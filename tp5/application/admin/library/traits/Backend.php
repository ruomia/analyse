<?php

namespace app\admin\library\traits;

trait Backend
{

    /**
     * 查看
     */
    public function index()
    {
        $where = $this->request->get();
        $order = 'id ASC';
        // $status = $this->request->get('status', '');
        // if ($status !== ''){
        //     $where[] = ['status','=',intval($status)];
        //     $order = '';
        // }
        // $name = $this->request->get('name', '');
        // if (!empty($name)){
        //     $where[] = ['name', 'like', $name . '%'];
        //     $order = '';
        // }
        $res = $this->model::getLists($where, $order);
       
        return ResultVo::success($res);
    }
    /**
     * 添加
     */
    public function add()
    {
        if ($this->request->isPost()) {
            $params = $this->request->post();
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
        $params = $this->request->post();
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

        $id = $this->request->post('id/d');
        if (empty($id)){
            return ResultVo::error(ErrorCode::DATA_VALIDATE_FAIL);
        }
        if (!$this->model::where('id',$id)->delete()){
            return ResultVo::error(ErrorCode::NOT_NETWORK);
        }
        return ResultVo::success();
    }
}
