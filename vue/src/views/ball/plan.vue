<template>
  <div>
    <el-header>
      <el-button-group>
        <el-button @click="goBack" type="text">返回列表页</el-button>
      </el-button-group>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      第
      <el-tag type="danger">{{issue}}</el-tag>期 &nbsp;&nbsp;
      开奖号:
      <el-tag v-for="(v,k) in ball_number" :key="k">{{v}}</el-tag>
    </el-header>
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
              <template v-for="(v1, k1) in v.split('-')">
                <el-tag v-if="ball_number.find( n => n == v1)" :key="k1" type="danger">{{v1}}</el-tag>
                <el-tag v-else :key="k1">{{v1}}</el-tag>
              </template>
            </el-form-item>
          </el-form>
          <el-alert v-else title="该计划暂时没有球号" type="warning" :closable="false"></el-alert>
        </template>
      </el-table-column>
      <el-table-column label="计划名称" prop="description"></el-table-column>
      <el-table-column label="类型" prop="type_text"></el-table-column>
      <el-table-column label="球数" prop="number"></el-table-column>
      <el-table-column label="计划号码" prop="sign_number"></el-table-column>
      <el-table-column label="计划状态">
        <template slot-scope="scope">
          <el-tag type="warning" v-if="scope.row.size > 0">中奖</el-tag>
          <el-tag v-else>未中</el-tag>
        </template>
      </el-table-column>

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
import { planList, planSave, planDelete, planOne } from "../../api/plan";
import { ballRead } from "../../api/ball";

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
      loading: false,
      index: null,
      formName: null,
      formLoading: false,
      formVisible: false,
      logFormVisible: false,
      deleteLoading: false,
      balls: [],
      addBtnIsDisplay: true,
      editBtnIsDisplay: true,
      delBtnIsDisplay: true,
      issue: "",
      ball_number: "",
      tst: []
    };
  },
  computed: {
    fullName: {
      // getter
      get: function() {
        return this.firstName + " " + this.lastName;
      },
      // setter
      set: function(newValue) {
        var names = newValue.split(" ");
        this.firstName = names[0];
        this.lastName = names[names.length - 1];
      }
    }
  },
  methods: {
    goBack() {
      this.$router.push("/ball/index");
    },
    // getPlanStatus(k) {
    //   let ball_number = this.list[k].ball_number;
    //   // let right_number = this.ball_number.split("-");
    //   let balls = ball_number.split(",");
    //   // 判断是否中奖
    //   // [1, 4, -5, 10].find(n => n < 0);
    //   let a = new Set(this.ball_number);

    //   for (let ball of balls) {
    //     let b = new Set(ball.split("-"));
    //     let intersect = new Set([...a].filter(x => b.has(x)));
    //     // console.log(ball, b, intersect);
    //     if (intersect.size > 0) {
    //       return "中奖了";
    //     }
    //   }
    //   return "没有中奖";
    // },
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
      this.query = {
        type: "",
        page: 1,
        limit: 20
      };

      this.selectedOptions = [];
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
          console.log(response);
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
    let data = this.$route.query;
    if (!data.id) {
      this.$router.push("/ball/index");
    }
     planOne({ id: data.id }).then(res => {
       console.log(res);
      if (res.code == 0) {
        let ball = res.data.ball;
        // 开奖球
        this.issue = ball.issue;
        this.ball_number = ball.ball_number.split("-");
        // 计划列表
        this.list = res.data.list || [];
        this.total = res.data.total || 0;
      } else {
        this.$router.push("/ball/index");
      }
    });
   

  }
};
</script>

<style>
.box-card {
  margin-top: 4px;
}
</style>
