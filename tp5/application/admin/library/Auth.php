<?php
namespace app\admin\library;

use app\admin\model\Admin;
use think\facade\Session;
use think\facade\Config;
use \Tree;
use \Firebase\JWT\JWT;
use think\facade\Env;
use app\admin\model\AuthRoleAdmin;
use app\admin\model\AuthRule;
use app\admin\model\AuthRuleRole;
class Auth
{
    protected $_error = '';
    protected $logined = false; // 登录状态

    /**
     * 管理员登录
     * 
     * @param  string $useranme 用户名
     * @param  string $password 密码
     * @param  int    $keeptime 有效时长
     * @return boolean
     */
    public function login($username, $password, $keeptime=0)
    {
        $admin = Admin::get(['username' => $username]);
        if (!$admin) {
            $this->setError('账号不正确');
            return false;
        }
        // if ($admin['s'])
        if ($admin->password != md5($password))
        {
            $this->setError('密码不正确');
            return false;
        }
        // Session::set("admin", $admin->toArray());
        
        // 获取权限
        $roles = $admin->getRoleId();
        // 判断是否有超级管理员权限
        if(!in_array( 1, $roles)) {
            // 根据角色id，获取权限id
            $rules = AuthRuleRole::getRuleIds($roles);

            $authRules = AuthRule::getAuthRules($rules);
        } else {
            $authRules = ['admin'];
        }
        trace($authRules, 'role ids');
        
        $now = time();
        // 定义令牌中的数据
        $data = [
            'iat' => $now,
            'exp' => $now + Env::get('jwt.expire'),
            'id' => $admin->id,
            'authRules' => $authRules,
            'nickname' =>  $admin->nickname,
        ];
        // 生成令牌
        $jwt = JWT::encode($data, Env::get('jwt.key'));
        return $jwt;


    }
    /**
     * 注销登录
     */
    public function logout()
    {
        $admin = Admin::get(intval($this->id));
        if (!$admin) {
            return true;
        }
        Session::delete("admin");
        return true;
    }
    /**
     * 设置错误信息
     *
     * @param string $error 错误信息
     * @return Auth
     */
    public function setError($error)
    {
        $this->_error = $error;
        return $this;
    }

    /**
     * 获取错误信息
     * @return string
     */
    public function getError()
    {
        return $this->_error ? ($this->_error) : '';
    }
}