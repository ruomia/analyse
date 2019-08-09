<?php

namespace app\admin\validate;

use think\Validate;

class Ball extends Validate
{
    protected $rule =   [
        'issue' => 'require|unique:ball,issue'
    ];
    
    protected $message  =   [
        'issue.require' => '期号必须',
        'issue.unique' => '期号不能重复'  
    ];
}