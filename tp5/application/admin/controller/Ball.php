<?php
namespace app\admin\controller;

use think\Controller;
use app\admin\model\Ball as BallModel;
use app\common\vo\ResultVo;

class Ball extends Controller 
{

    protected $middleware = [
        'CORS',
        'Check'
    ];

    public function index()
    {
        $lists = BallModel::select();
        $res['total'] =count($lists);
        $res['list'] = $lists;
        return ResultVo::success($res);
    }

}