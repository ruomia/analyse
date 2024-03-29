<?php
namespace app\admin\model;

use think\Model;

/**
 * 规则表
 */
class AuthRule extends Model
{
    protected $table = 'auth_rule';

    public static function getLists($where = [], $order = 'id ASC',$type=1)
    {
        // $type = 1 : $field = 'id,pid,name,title,status,condition,path,ismenu'
        // $type = 2 : $filed = 'id,pid,title'
        $field = $type === 1 ? 'id,pid,name,title,status,condition,path,ismenu' : 'id,pid,title';
        $lists = self::where($where)
            ->field($field)
            ->order($order)
            ->select()
            ->toArray();
        $lists = generateTree($lists);
        return $lists;
    }
    public function getStatusTextAttr($value,$data)
    {
        $status = [0=>'禁用',1=>'正常'];
        return $status[$data['status']];
    }

    public static function getAuthRules($rules)
    {
        $data = AuthRule::field('id,name')
            ->where('id', 'in', $rules)
            ->select()
            ->toArray();

        $result = array_column($data, 'name');
        return $result;
    }
}