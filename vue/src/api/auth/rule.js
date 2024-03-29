/**
 * Created by lk on 17/6/4.
 */
import axios from "../../utils/axios";

// 权限管理

// 获取列表
export function authPermissionRuleList(query) {
    return axios({
        url: "/admin/auth/rule/index",
        method: "get",
        params: query
    });
}
// 获取树形列表
export function authPermissionRuleTree(query) {
    return axios({
        url: "/admin/auth/rule/index",
        method: "get",
        params: query
    });
}

// 保存
export function authPermissionRuleSave(data, formName, method = "post") {
    let url =
        formName !== "edit" ? "/admin/auth/rule/add" : "/admin/auth/rule/edit";
    return axios({
        url: url,
        method: method,
        data: data
    });
}

// 删除
export function authPermissionRuleDelete(data) {
    return axios({
        url: "/admin/auth/rule/delete",
        method: "post",
        data: data
    });
}
