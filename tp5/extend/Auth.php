<?php
// +----------------------------------------------------------------------
// | ThinkPHP 5.1 auth
// +----------------------------------------------------------------------
// | Copyright (c) 2018 http://www.wyxgn.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 ;)
// +----------------------------------------------------------------------
// | Author: lqsong <957698457@qq.com>
// +----------------------------------------------------------------------
// namespace ;
use think\Db;
use think\facade\Config;
use think\facade\Session;
use think\facade\Request;
/**
 * 权限认证类
 * 功能特性：
 * 1，是对规则进行认证，不是对节点进行认证。用户可以把节点当作规则名称实现对节点进行认证。
 *      $auth=new Auth();  $auth->check('规则名称','用户id')
 * 2，可以同时对多条规则进行认证，并设置多条规则的关系（or或者and）
 *      $auth=new Auth();  $auth->check('规则1,规则2','用户id','and')
 *      第三个参数为and时表示，用户需要同时具有规则1和规则2的权限。 当第三个参数为or时，表示用户值需要具备其中一个条件即可。默认为or
 * 3，一个用户可以属于多个用户组(think_auth_group_access表 定义了用户所属用户组)。我们需要设置每个用户组拥有哪些规则(think_auth_group 定义了用户组权限)
 *
 * 4，支持规则表达式。
 *      在think_auth_rule 表中定义一条规则时，如果type为1， condition字段就可以定义规则表达式。 如定义{score}>5  and {score}<100  表示用户的分数在5-100之间时这条规则才会通过。
 */
class Auth
{
    /**
     * var object 对象实例
     */
    protected static $instance;
    //默认配置
    protected $config = [
        'auth_on' => 1, // 权限开关
        'auth_type' => 1, // 认证方式，1为实时认证；2为登录认证。
        'auth_group' => 'auth_group', // 用户组数据表名
        'auth_group_access' => 'auth_group_access', // 用户-用户组关系表
        'auth_rule' => 'auth_rule', // 权限规则表
        'auth_user' => 'admin', // 用户信息表
    ];
    // 是否是超级管理员
    protected $admin = false;
    /**
     * 类架构函数
     * Auth constructor.
     */
    public function __construct()
    {
        //可设置配置项 auth, 此配置项为数组。
        if ($auth = Config::get('auth')) {
            $this->config = array_merge($this->config, $auth);
        }
    }
    /**
     * 初始化
     * access public
     * @param array $options 参数
     * return \think\Request
     */
    public static function instance($options = [])
    {
        if (is_null(self::$instance)) {
            self::$instance = new static($options);
        }
        return self::$instance;
    }
    /**
     * 检查权限
     * @param $name string|array  需要验证的规则列表,支持逗号分隔的权限规则或索引数组
     * @param $uid  int           认证用户的id
     * @param int $type 认证类型
     * @param string $mode 执行check的模式
     * @param string $relation 如果为 'or' 表示满足任一条规则即通过验证;如果为 'and'则表示需满足所有规则才能通过验证
     * return bool               通过验证返回true;失败返回false
     */
    public function check($name, $uid, $type = 1, $mode = 'url', $relation = 'or')
    {
        if (!$this->config['auth_on']) {
            return true;
        }
        // 获取角色列表
        // 获取规则列表
        // 获取用户需要验证的所有有效规则列表
        $authList = $this->getRuleList($uid, $type);
        // 判断是否是超级管理员
        if ($this->admin)
            return true;

        if (is_string($name)) {
            $name = strtolower($name);
            if (strpos($name, ',') !== false) {
                $name = explode(',', $name);
            } else {
                $name = [$name];
            }
        }
        $list = []; //保存验证通过的规则名
        if ('url' == $mode) {
            $REQUEST = unserialize(strtolower(serialize(Request::param())));
            trace($REQUEST, 'auth request');
        }
        foreach ($authList as $auth) {
            $query = preg_replace('/^.+\?/U', '', $auth);
            trace($query, 'query');
            if ('url' == $mode && $query != $auth) {
                parse_str($query, $param); //解析规则中的param
                $intersect = array_intersect_assoc($REQUEST, $param);
                $auth = preg_replace('/\?.*$/U', '', $auth);
                trace($auth, 'auth');

                if (in_array($auth, $name) && $intersect == $param) {
                    //如果节点相符且url参数满足
                    $list[] = $auth;
                }
            } else {
                if (in_array($auth, $name)) {
                    $list[] = $auth;
                }
            }
        }
        trace($list, 'list');
        if ('or' == $relation && !empty($list)) {
            return true;
        }
        $diff = array_diff($name, $list);
        trace($diff, 'diff');
        if ('and' == $relation && empty($diff)) {
            return true;
        }
        return false;
    }
    /**
     * 根据用户id获取用户组,返回值为数组
     * @param  $uid int     用户id
     * return array       用户所属的用户组 array(
     *     array('uid'=>'用户id','group_id'=>'用户组id','title'=>'用户组名称','rules'=>'用户组拥有的规则id,多个,号隔开'),
     *     ...)
     */
    public function getGroups($uid)
    {
        static $groups = [];
        if (isset($groups[$uid])) {
            return $groups[$uid];
        }  
        // 执行查询
        $user_groups = Db::view('auth_role_admin', 'role_id,admin_id')
            ->view('auth_role', 'name', "auth_role_admin.role_id=auth_role.id", 'LEFT')
            ->where("auth_role_admin.admin_id='{$uid}' and auth_role.status='1'")
            ->select();
        $groups[$uid] = $user_groups ?: [];

        return $groups[$uid];
    }
    /**
     * 获得权限规则列表
     * @param integer $uid 用户id

     * return array
     */
    protected function getRuleList($uid)
    {
        static $_rulelist = []; //保存用户验证通过的权限列表
        // $t = implode(',', (array)$type);
        // if (isset($_rulelist[$uid . $t])) {
            // return $_rulelist[$uid . $t];
        // }
        if (isset($_rulelist[$uid])) {
            return $_rulelist[$uid];
        }
        if (2 == $this->config['auth_type'] && Session::has('_rule_list' . $uid)) {
            return Session::get('_rule_list' . $uid);
        }
        // 读取用户规则节点
        $ids = $this->getRuleIds($uid);

        if (empty($ids)) {
            $_rulelist[$uid] = [];
            return [];
        }
        //读取用户组所有权限规则
        $rules = Db::name('auth_rule')->where('status',1)
                    ->where('id','in',$ids)
                    ->field('condition,name')
                    ->select();

        //循环规则，判断结果。
        $rulelist = []; //
        foreach ($rules as $rule) {
            if (!empty($rule['condition'])) {
                //根据condition进行验证
                $user = $this->getUserInfo($uid); //获取用户信息,一维数组
                $command = preg_replace('/\{(\w*?)\}/', '$user[\'\\1\']', $rule['condition']);
                //dump($command); //debug
                @(eval('$condition=(' . $command . ');'));
                if ($condition) {
                    $rulelist[] = strtolower($rule['name']);
                }
            } else {
                //只要存在就记录
                $rulelist[] = strtolower($rule['name']);
            }
        }
        $_rulelist[$uid] = $rulelist;
        if (2 == $this->config['auth_type']) {
            //规则列表结果保存到session
            Session::set('_rule_list_' . $uid, $rulelist);
        }
        return array_unique($rulelist);
    }

    public function getRuleIds($uid)
    {
        // 读取用户所属角色
        $roles = $this->getGroups($uid);
        $roleIds = array_column($roles, 'role_id');
        // 判断角色id中是否含有1的，即超级管理员
        if(in_array(1, $roleIds)) {
            $this->admin = true;
        }
        $ids = []; // 保存用户所属角色设置的所有权限规则id
       
        $ids = Db::view('auth_rule_role', 'rule_id')
        ->where('role_id', 'in', $roleIds)
        ->select();
        $ids = array_unique(array_column($ids, 'rule_id'));
        return $ids;

    }
    /**
     * 获得用户资料
     * @param $uid
     * @return mixed
     */
    protected function getUserInfo($uid)
    {
        static $userinfo = [];
        $user = Db::name($this->config['auth_user']);
        // 获取用户表主键
        $_pk = is_string($user->getPk()) ? $user->getPk() : 'uid';
        if (!isset($userinfo[$uid])) {
            $userinfo[$uid] = $user->where($_pk, $uid)->find();
        }
        return $userinfo[$uid];
    }
}