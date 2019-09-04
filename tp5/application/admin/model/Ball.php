<?php
namespace app\admin\model;


class Ball extends Backend
{
    protected $table = 'ball';
    // public function getBallNumberAttr($value)
    // {
    //     // $status = [-1=>'删除',0=>'禁用',1=>'正常',2=>'待审核'];
    //     return explode('-', $value);
    //     // return $status[$value];
    // }

    public static function getLists($where=[], $order=[])
    {
        
        $lists = self::withSearch(['issue'], $where)
                    ->select()
                    ->toArray();

        $res['total'] = self::count();
        $res['list'] = $lists;
        return $res;
    }
}