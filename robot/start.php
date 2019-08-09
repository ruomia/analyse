<?php
require_once(__DIR__ . '/vendor/autoload.php');
use Beanbun\Beanbun;
use Beanbun\Lib\Db;
use Beanbun\Middleware\Parser;
use Beanbun\Lib\Helper;

$beanbun = new Beanbun;
$beanbun->count = 3;
$beanbun->seed = 'http://ycsx.top/zl/bm.php?sid=Null-2-0';
$beanbun->logFile = __DIR__ . '/fangmama_access.log';
$beanbun->max = 1000;
$beanbun->interval = 10;
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
    // $content = $beanbun->page;
    // $contents = mb_convert_encoding($beanbun->page, 'UTF-8' ,'GBK');
    preg_match('/-(\d.*)特码.*(\d+)\(.*(\d+)期/U', $beanbun->data['content'], $content);
    $data = [
        'id' => ($content[3] - 1),
        'ball_number' => $content[1] . '-' . $content[2]
    ];
    $id = $data['id'];
    if($id){
        if (!Db::instance('analyse')->has("ball", [
            "id" => $id
        ])) {
            Db::instance('analyse')->insert("ball", $data);
            // print('插入成功');
            mylog(date('Y-m-d H:i:s') . ": 插入成功\n");
    
        } else {
            // print('数据重复');
            mylog(date('Y-m-d H:i:s') . ": 数据重复\n");
            
        }
    } else {
        mylog(date('Y-m-d H:i:s') . ": 数据错误\n");
    }

};
$beanbun->start();



function mylog($string = '', $APPEND = true, $file = 'test') {
    return file_put_contents(__DIR__ . '/log/' . $file . '.log', $string . PHP_EOL, $APPEND ? FILE_APPEND : false);
}