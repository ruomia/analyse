<?php

namespace app\admin\validate;

use think\Validate;

class Type extends Validate
{
    protected $rule =   [
        'name' => 'require|unique:type,name'
    ];
    
    protected $message  =   [
        'name.require' => '名称必须',
        'name.unique' => '名称不能重复'  
    ];
}