<?php

namespace app\admin\validate;

use think\Validate;

class Module extends Validate
{
    protected $rule =   [
        'name' => 'require|min:4'
    ];
    
    protected $message  =   [
        'name.require' => '名称必须',
        'name.min' => '名称不能少于4个字符'  
    ];
    
}