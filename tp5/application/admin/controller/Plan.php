<?php
namespace app\admin\controller;

use think\facade\Request;
use think\facade\Validate;
use think\facade\Session;
use app\facade\Auth;
use app\common\vo\ResultVo;
use app\common\enums\ErrorCode;
use app\admin\model\Ball;
use app\admin\model\Plan as PlanModel;

class Plan extends Backend
{
    protected $modelValidate = false;
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

    // 低频彩分析
    public function low()
    {
        $balls = Ball::order('issue', 'desc')->select()->toArray();
        $plans = PlanModel::select()->toArray();
        foreach($plans as $k => $v) {
            $my_number = explode(',', $v['ball_number']);
            $data = [];
            $plans[$k]['error'] = 0;
            foreach($balls as $k1 => $ball) {
                // array_key_exists("$key", $array)
                // $key = substr(($k1+1), -1);

                $key = substr(($ball['issue']-1), -1);
                if(array_key_exists($key, $my_number)) {
                    $ball_number = explode('-', $ball['ball_number']);
                    $write_number = explode('-', $my_number[$key]);
                    $result = array_intersect($ball_number, $write_number);
                    // dump($v['ball_number']);
                    $ball['size'] = count($result);
                    $ball['write_number'] = $my_number[$key];
                    if(count($result)) {
                        $plans[$k]['error'] = 0;
                    } else {
                        $plans[$k]['error']++;
                    }
                    // $balls[$k1]['size'] = $v['ball_number'];
                    // $data[$key][] = array_merge(['size'=>$v['ball_number'], array($ball)]); 
                    $data[] = $ball;

                }
                
            }
            $plans[$k]['balls'] = $data;

        }
        $res['list'] = $plans;
        $res['total'] = PlanModel::count();
        return ResultVo::success($res);
    }
    public function one(){
        $ball_id = Request::get('id', 1);
        $ball = Ball::get($ball_id);
        if(!$ball) {
            return ResultVo::error(ErrorCode::DATA_NOT, "记录不存在");
        }
        // 将开奖球号转换为数组
        $ball_number = explode('-', $ball['ball_number']);

        $plans = PlanModel::select()->toArray();
        foreach($plans as $k => $v) {
            $my_number = explode(',', $v['ball_number']);
        
            $key = substr(($ball['issue']-1), -1);
            if(array_key_exists($key, $my_number)) {
                $write_number = explode('-', $my_number[$key]);
                $result = array_intersect($ball_number, $write_number);
                // dump($v['ball_number']);
                $plans[$k]['size'] = count($result);
                $plans[$k]['sign_number'] = $my_number[$key];
                // $balls[$k1]['size'] = $v['ball_number'];
                // $data[$key][] = array_merge(['size'=>$v['ball_number'], array($ball)]); 

            } else {
                $plans[$k]['sign_number'] = "";
            }
        }
        $res['list'] = $plans;
        $res['ball'] = $ball;
        $res['total'] = PlanModel::count();
        return ResultVo::success($res);
    }
}
