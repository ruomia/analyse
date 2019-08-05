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
          <el-button v-if="addBtnIsDisplay" type="primary" @click.native="handleForm(null, null)">新增</el-button>
        </el-button-group>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="list" style="width: 100%;">
      <el-table-column type="expand">
        <template slot-scope="props">
          <el-form
            label-position="left"
            inline
            class="demo-table-expand"
            v-if="props.row.ball_number"
          >
            <el-form-item
              :label="'第' + (k+1) + '期'"
              v-for="(v,k) in props.row.ball_number.split(',')"
              :key="k"
            >
              <span style="width:100%;">{{ v }}</span>
            </el-form-item>
          </el-form>
          <el-alert v-else title="该计划暂时没有球号" type="warning" :closable="false"></el-alert>
        </template>
      </el-table-column>
      <el-table-column label="编号" prop="id"></el-table-column>
      <el-table-column label="类型" prop="type_text"></el-table-column>
      <el-table-column label="球数" prop="number"></el-table-column>
      <el-table-column label="描述" prop="description"></el-table-column>

      <el-table-column label="操作" fixed="right" align="center">
        <template slot-scope="scope">
          <el-button
            v-if="delBtnIsDisplay"
            type="text"
            @click.native="handleDel(scope.$index, scope.row)"
            :loading="deleteLoading"
          >
            <i class="el-icon-delete"></i>
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
        <el-form-item label="计划彩种" prop="type">
          <el-radio-group v-model="formData.type">
            <el-radio-button :label="1">低频彩</el-radio-button>
            <el-radio-button :label="2">高频彩</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="计划球数" prop="number">
          <el-radio-group v-model="formData.number">
            <el-radio-button :label="3">3个球</el-radio-button>
            <el-radio-button :label="4">4个球</el-radio-button>
            <el-radio-button :label="5">5个球</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="计划描述" prop="description">
          <el-input v-model="formData.description" auto-complete="off"></el-input>
        </el-form-item>

        <!-- <el-form-item label="问题链接" prop="link">
              <el-input v-model="formData.link" auto-complete="off"
               v-for="v in formData.number" :key="v"
               style="width:15%;margin:0 auto">
               </el-input>
            
        </el-form-item>-->
        <h3 style="text-align:center">
          计划号码
          <el-button @click="addBallCard" style="float: right; padding: 3px 0" type="text">
            <i class="el-icon-plus"></i>
          </el-button>
        </h3>
        <el-card class="box-card" v-for="(v,k) in formData.ball_number" :key="k">
          <div slot="header" style="text-align:center">
            <span>第{{k+1}}期</span>
            <el-button @click="delBallCard(k)" style="float: right; padding: 3px 0" type="text">
              <i class="el-icon-minus"></i>
            </el-button>
          </div>
          <el-input
            v-for="(v1,k1) in formData.number"
            v-model="v[k1]"
            auto-complete="off"
            :key="k1"
            style="width:20%;"
            :placeholder="k1+1"
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
import { planList, planSave, planDelete } from "../../api/plan";
const formJson = {
  id: "",
  type: 1,
  number: 3,
  description: "",
  ball_number: []
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
    btnIsDisplay() {
      let authRules = this.$store.getters.authRules;
      let result = authRules.findIndex(value => value === "admin");
      if (result === 0) {
        return;
      }
      result = authRules.findIndex(value => value === "module/add");
      if (result < 0) {
        this.addBtnIsDisplay = false;
      }
      result = authRules.findIndex(value => value === "module/edit");
      if (result < 0) {
        this.editBtnIsDisplay = false;
      }
      result = authRules.findIndex(value => value === "module/del");
      if (result < 0) {
        this.delBtnIsDisplay = false;
      }
    },
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
      planList(this.query)
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
      }
    },
    formSubmit() {
      this.$refs["dataForm"].validate(valid => {
        if (valid) {
          this.formLoading = true;
          let data = Object.assign({}, this.formData);
          let str = "";
          for (let i of data.ball_number) {
            if (str) {
              str += "," + i.join("-");
            } else {
              str += i.join("-");
            }
          }
          data.ball_number = str;
          // return false;
          planSave(data, this.formName)
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
            planDelete(para)
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
    // 判断权限
    this.btnIsDisplay();
  }
};
</script>

<style>
.box-card {
  margin-top: 4px;
}
</style>
