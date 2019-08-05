<?php
namespace app\admin\controller;

use think\Controller;
use think\facade\Request;
use think\facade\Validate;
use think\facade\Session;
use app\facade\Auth;
use app\common\vo\ResultVo;
use app\common\enums\ErrorCode;
/**
 * 后台控制器基类
 */
class Backend extends Controller
{
    protected $middleware = ['CORS', 'Check','Auth'];

    /**
     * 是否开启Validate验证
     */
    protected $modelValidate = true;
    /**
     * 是否开启模型场景验证
     */
    protected $modelSceneValidate = false;
    /**
     * 无需登录的方法，同时也就不需要鉴权了
     * @var array
     */
    // protected $noNeedLogin = [];

    /**
     * 无需鉴权的方法，但需要登录
     * @var array
     */
    // protected $noNeedRight = [];

    public function initialize()
    {
        $controllerName = Request::controller();
        trace($controllerName, 'controllerName');
    // public $model = ';
        $this->model = 'app\admin\model\\' . $controllerName;

    }
    /**
     * 查看
     */
    public function index()
    {
        $where = Request::get();
        $order = 'id ASC';
        // $status = Request::get('status', '');
        // if ($status !== ''){
        //     $where[] = ['status','=',intval($status)];
        //     $order = '';
        // }
        // $name = Request::get('name', '');
        // if (!empty($name)){
        //     $where[] = ['name', 'like', $name . '%'];
        //     $order = '';
        // }
        $res = $this->model::getLists($where, $order);
       
        return ResultVo::success($res);
    }
    // /**
    //  * 添加
    //  */
    public function add()
    {
        if (Request::isPost()) {
            $params = Request::post();
            if ($params) {

                if ($this->modelValidate) {
                    $validate = str_replace("\\model\\", "\\validate\\", $this->model);
                    
                    $result = $this->validate($params, $validate);
            
                    if (true !== $result) {
                        // 验证失败 输出错误信息
                        return ResultVo::error(ErrorCode::DATA_NOT, $result);
                    }
                }
                $result = $this->model::create($params);

                if ($result !== false) {
                    // $this->success();
                    return ResultVo::success($result);
                } else {
                    // $this->error($this->model->getError());
                    return ResultVo::error(ErrorCode::DATA_NOT);

                }
            }
            return ResultVo::error(ErrorCode::DATA_NOT, 'Parameter can not be empty');
            // $this->error('Parameter %s can not be empty', '');
        }
    //     return $this->view->fetch();
    }

    // /**
    //  * 编辑
    //  */
    public function edit()
    {
        $params = Request::post();
        if (empty($params['id']) || empty($params['name'])){
            return ResultVo::error(ErrorCode::DATA_VALIDATE_FAIL);
        }
        // 从数据库中查询记录
        $row = $this->model::get($params['id']);
        if (!$row)
            return ResultVo::error(ErrorCode::DATA_NOT, "记录不存在");

        if ($this->modelValidate) {
            $validate = str_replace("\\model\\", "\\validate\\", $this->model);
            // $validate = is_bool($this->modelValidate) ? ($this->modelSceneValidate ? $name . '.add' : $name) : $this->modelValidate;
            // $this->model->validate($validate);
            $result = $this->validate($params, $validate);

            if (true !== $result) {
                // 验证失败 输出错误信息
                return ResultVo::error(ErrorCode::DATA_NOT, $result);
            }
        }
        $result = $row->save($params);
        if (!$result){
            return ResultVo::error(ErrorCode::DATA_CHANGE);
        }
    }

    // /**
    //  * 删除
    //  */
    public function delete()
    {

        $id = Request::post('id/d');
        if (empty($id)){
            return ResultVo::error(ErrorCode::DATA_VALIDATE_FAIL);
        }
        if (!$this->model::where('id',$id)->delete()){
            return ResultVo::error(ErrorCode::NOT_NETWORK);
        }
        return ResultVo::success();
    }
}
