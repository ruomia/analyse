/**
 * Created by lk on 17/6/4.
 */
import axios from "../utils/axios";

// 获取列表
export function planList(query) {
    return axios({
        url: "/admin/plan/index",
        method: "get",
        params: query
    });
}

// 保存
export function planSave(data, formName, method = "post") {
    let url = formName === "add" ? "/admin/plan/add" : "/admin/plan/edit";
    return axios({
        url: url,
        method: method,
        data: data
    });
}

// 删除
export function planDelete(data) {
    return axios({
        url: "/admin/plan/delete",
        method: "post",
        data: data
    });
}

// 低频彩分析
export function planLow(query) {
    return axios({
        url: "/admin/plan/low",
        method: "get",
        params: query
    })
}

// 低频彩分析
export function planOne(query) {
    return axios({
        url: "/admin/plan/one",
        method: "get",
        params: query
    })
}
