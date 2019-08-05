<?php
require_once(__DIR__ . '/vendor/autoload.php');
use Beanbun\Beanbun;
use Beanbun\Lib\Db;
use Beanbun\Middleware\Parser;
use Beanbun\Lib\Helper;

$beanbun = new Beanbun;
$beanbun->seed = 'http://ycsx.top/zl/bm.php?sid=Null-2-0';
$beanbun->middleware(new Parser);
// $beanbun->middleware(new Decode);

$beanbun->fields = [
    [
        'name' => 'content',
        'selector' => ['p', 'text']
    ]
];
Db::$config = [
    'analyse' => [
        'server' => '127.0.0.1',
        'port' => '3306',
        'username' => 'root',
        'password' => '123456',
        'database_name' => 'analyse',
        'database_type' => 'mysql',
        'charset' => 'utf8',
    ]
];

$beanbun->afterDownloadPage = function($beanbun) {
    // print_r($beanbun->data);
    // $content = $beanbun->page;
    // $contents = mb_convert_encoding($beanbun->page, 'UTF-8' ,'GBK');
    preg_match('/-(\d+)期.*开奖结果.*(\d.*)特码.*(\d+)\(/U', $beanbun->data['content'], $content);
    $data = [
        'id' => (int)$content[1],
        'ball_number' => $content[2],
        'special_code' => $content[3]
    ];
    if (!Db::instance('analyse')->has("ball", [
        "id" => $data['id']
    ])) {
        Db::instance('analyse')->insert("ball", $data);
        print('插入成功');

    } else {
        print('数据重复');

    }

};
$beanbun->start();