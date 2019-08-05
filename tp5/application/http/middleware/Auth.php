<?php

namespace app\http\middleware;

class Auth
{
    public function handle($request, \Closure $next)
    {
        if($request->authRules[0] !== 'admin') {
            $controllerName = strtolower($request->controller());
            $actionName = strtolower($request->action());
            
            $path = str_replace('.', '/', $controllerName) . '/' . $actionName;
            // trace($path, 'core path');
            // trace($jwt->authRules, 'jwt_authRules');
            // $rules = array_merge($request->authRules, ['index/userinfo']);
            if(!in_array($path, $request->authRules)){
                return json([
                    'code'=> 2,
                    // 'message'=>'HTTP/1.1 403 Forbidden'
                    'message' => ''
                ]);
            }
        }
        return $next($request);

    }
}
