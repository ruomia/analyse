<template>
  <div>
    <el-form :inline="true" :model="query" class="query-form" size="mini">
      <el-form-item class="query-form-item">
        <el-select v-model="query.type" placeholder="状态">
          <el-option label="全部" value></el-option>
          <el-option label="低频彩" value="1"></el-option>
          <el-option label="高频彩" value="2"></el-option>
        </el-select>
      </el-form-item>

      <el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-refresh" @click="onReset"></el-button>
          <el-button type="primary" icon="search" @click="onSubmit">查询</el-button>
          <el-button type="primary" @click.native="handleForm(null, null)">新增</el-button>
        </el-button-group>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="list" style="width: 100%;">
      <el-table-column label="编号" prop="id"></el-table-column>
      <el-table-column label="期号" prop="issue"></el-table-column>
      <el-table-column label="开奖号" prop="ball_number"></el-table-column>

      <el-table-column label="操作" fixed="right" align="center">
        <template slot-scope="scope">
          <el-button
            type="text"
            @click.native="handleForm(scope.$index, scope.row)"
            :loading="deleteLoading"
          >
            <i class="el-icon-edit"></i>
          </el-button>
          <el-button
            type="text"
            @click.native="handleDel(scope.$index, scope.row)"
            :loading="deleteLoading"
          >
            <i class="el-icon-delete"></i>
          </el-button>
          <el-button type="text">
            <router-link class="el-icon-more" :to="{path:'/ball/plan', query: {id: scope.row.id}}"></router-link>
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      :page-size="query.limit"
      @current-change="handleCurrentChange"
      layout="prev, pager, next"
      :total="total"
    ></el-pagination>

    <!--表单-->
    <el-dialog
      :title="formMap[formName]"
      :visible.sync="formVisible"
      :before-close="hideForm"
      width="85%"
      top="5vh"
    >
      <el-form :model="formData" :rules="formRules" ref="dataForm">
        <el-form-item label="期号" prop="issue">
          <el-input type="number" v-model="formData.issue" placeholder="请输入期号"></el-input>
        </el-form-item>
        <el-card class="box-card">
          <div slot="header">
            开奖号
          </div>
          <el-input
            v-for="(v,k) in 7"
            :key="k"
            v-model="formData.ball_number[k]"
            auto-complete="off"
            style="width:14%"
            :placeholder="v"
            maxlength="2"
          ></el-input>
        
        </el-card>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click.native="hideForm">取消</el-button>
        <el-button type="primary" @click.native="formSubmit()" :loading="formLoading">提交</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<style>
.demo-table-expand {
  font-size: 0;
}
.demo-table-expand label {
  width: 90px;
  color: #99a9bf;
}
.demo-table-expand .el-form-item {
  margin-right: 0;
  margin-bottom: 0;
  width: 75%;
}
</style>

<script>
import { ballList, ballSave, ballDelete } from "../../api/ball";
const formJson = {
  id: "",
  ball_number: [],
  issue: ""
};
export default {
  data() {
    return {
      query: {
        type: "",
        page: 1,
        limit: 20
      },
      list: [],
      total: 0,
      loading: true,
      index: null,
      formName: null,
      formMap: {
        add: "新增",
        edit: "编辑"
      },
      formLoading: false,
      formVisible: false,
      logFormVisible: false,
      formData: formJson,
      formRules: {
        name: [{ required: true, message: "请输入名称", trigger: "blur" }],
        status: [{ required: true, message: "请选择状态", trigger: "change" }]
      },
      deleteLoading: false,
      balls: [],
      addBtnIsDisplay: true,
      editBtnIsDisplay: true,
      delBtnIsDisplay: true
    };
  },
  methods: {
    onReset() {
      this.$router.push({
        path: ""
      });
      this.query = {
        type: "",
        page: 1,
        limit: 20
      };

      this.selectedOptions = [];
      this.getList();
    },
    onSubmit() {
      this.getList();
    },
    handleCurrentChange(val) {
      this.query.page = val;
      this.getList();
    },
    getList() {
      this.loading = true;
      ballList(this.query)
        .then(response => {
          this.loading = false;
          this.list = response.data.list || [];
          this.total = response.data.total || 0;
        })
        .catch(() => {
          this.loading = false;
          this.list = [];
          this.total = 0;
        });
    },
    // 刷新表单
    resetForm() {
      if (this.$refs["dataForm"]) {
        // 清空验证信息表单
        this.$refs["dataForm"].clearValidate();
        // 刷新表单
        this.$refs["dataForm"].resetFields();
      }
    },
    // 隐藏表单
    hideForm() {
      // 更改值
      this.formVisible = !this.formVisible;
      // 清空文件列表
      this.fileList = [];
      return true;
    },
    // 显示表单
    handleForm(index, row) {
      this.formVisible = true;
      this.formData = JSON.parse(JSON.stringify(formJson));
      if (row !== null) {
        this.formData = Object.assign({}, row);
      }
      this.formName = "add";

      if (index !== null) {
        this.index = index;
        this.formName = "edit";
        this.formData.ball_number = row.ball_number.split('-');
      }
    },
    formSubmit() {
      this.$refs["dataForm"].validate(valid => {
        if (valid) {
          this.formLoading = true;
          let data = Object.assign({}, this.formData);
          let str = data.ball_number.join('-');
          data.ball_number = str;
          // return false;
          console.log(data);
          ballSave(data, this.formName)
            .then(response => {
              this.formLoading = false;
              if (response.code) {
                this.$message.error(response.message);
                return false;
              }
              this.$message.success("操作成功");
              this.formVisible = false;
              if (this.formName === "add") {
                // 向头部添加数据
                if (response.data && response.data.id) {
                  data.id = response.data.id;
                  // this.list.unshift(data);
                  this.list.push(response.data);
                  this.total++;
                }
              } else {
                this.list.splice(this.index, 1, data);
              }
              // 刷新表单
              this.resetForm();
            })
            .catch(() => {
              this.formLoading = false;
            });
        }
      });
    },
    // 删除
    handleDel(index, row) {
      if (row.id) {
        this.$confirm("确认删除该记录吗?", "提示", {
          type: "warning"
        })
          .then(() => {
            this.deleteLoading = true;
            let para = { id: row.id };
            ballDelete(para)
              .then(response => {
                this.deleteLoading = false;
                if (response.code) {
                  this.$message.error(response.message);
                  return false;
                }
                this.$message.success("删除成功");
                // 刷新数据
                this.list.splice(index, 1);
                this.total--;
              })
              .catch(() => {
                this.deleteLoading = false;
              });
          })
          .catch(() => {
            this.$message.info("取消删除");
          });
      }
    },
    addBallCard() {
      this.formData.ball_number.push([]);
    },
    delBallCard(k) {
      this.formData.ball_number.splice(k, 1);
    }
  },
  filters: {
    statusFilterType(status) {
      const statusMap = {
        0: "gray",
        1: "success"
      };
      return statusMap[status];
    },
    statusFilterName(status) {
      const statusMap = {
        0: "待处理",
        1: "已解决",
        2: "未解决"
      };
      return statusMap[status];
    }
  },
  mounted() {},
  created() {
    // 加载表格数据
    this.getList();
  }
};
</script>

<style>
.box-card {
  margin-top: 4px;
}
</style>
