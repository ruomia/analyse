/**
 * Created by lk on 17/6/4.
 */
import axios from "../utils/axios";

// 获取列表
export function ballList(query) {
    return axios({
        url: "/admin/ball/index",
        method: "get",
        params: query
    });
}

// 获取列表
export function ballRead(id) {
    return axios({
        url: "/admin/ball/read",
        method: "get",
        params: { id: id }
    });
}
// 保存
export function ballSave(data, formName, method = "post") {
    let url = formName === "add" ? "/admin/ball/add" : "/admin/ball/edit";
    return axios({
        url: url,
        method: method,
        data: data
    });
}

// 删除
export function ballDelete(data) {
    return axios({
        url: "/admin/ball/delete",
        method: "post",
        data: data
    });
}
