<?php
namespace app\admin\model;


class Plan extends Backend
{
    protected $table = 'plan';
    protected $append = ['type_text'];
    public static function getLists($where=[], $order=[])
    {
        
        $lists = self::withSearch(['type'], $where)
                    ->select()
                    ->toArray();

        $res['total'] = self::count();
        $res['list'] = $lists;
        return $res;
    }
    public function getTypeTextAttr($value,$data)
    {
        $status = [1=>'低频彩',2=>'高频彩'];
        return $status[$data['type']];
    }
}