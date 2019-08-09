<template>
  <div>
    <el-table v-loading="loading" :data="lists" style="width: 100%;">
      <el-table-column label="编号" prop="id"></el-table-column>
      <el-table-column label="类型" prop="type_text"></el-table-column>
      <el-table-column label="球数" prop="number"></el-table-column>
      <el-table-column label="描述" prop="description"></el-table-column>
      <el-table-column label="错误次数" prop="error" sortable></el-table-column>

      <el-table-column label="操作" fixed="right" align="center">
        <template slot-scope="scope">
          <el-button
            type="text"
            @click.native="handleForm(scope.$index, scope.row)"
            :loading="formLoading"
          >
            <i class="el-icon-search"></i>
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
      title="数据分析"
      :visible.sync="formVisible"
      :before-close="hideForm"
      @click="drawer = true"
      width="85%"
      top="5vh"
    >
      <el-collapse accordion>
        <el-collapse-item v-for="(v,k) in balls" :key="k">
          <template slot="title">
            {{v.id}}期 {{v.ball_number}}
            <span style="color: #F56C6C;padding-left:10px">{{error}}</span>
          </template>
          <p>开奖期号: {{v.id}}期</p>
          <p>开奖球号: {{v.ball_number}}</p>
          <p>计划号: {{v.write_number}}</p>
          <p>
            中奖数:
            <span style="color: #F56C6C;">{{v.size}}</span>
          </p>
        </el-collapse-item>
      </el-collapse>
      <div slot="footer" class="dialog-footer">
        <el-button @click="drawer = true" type="info" style="margin-left: 16px;">查看明细</el-button>
        <el-button @click.native="hideForm">取消</el-button>
        <el-button type="primary" @click.native="formSubmit()" :loading="formLoading">提交</el-button>
      </div>
    </el-dialog>
   

    <el-drawer
      title="10期明细"
      :visible.sync="drawer"
      :direction="direction"
      :before-close="handleClose"
      :modal="false"
    >
      <el-timeline :reverse="false" style="margin-left:20px;">
        <el-timeline-item
          v-for="(v, k) in ball_list"
          :key="k"
          :timestamp="'第'+(k+1)+'期'">
          {{v}}
        </el-timeline-item>
      </el-timeline>
    </el-drawer>
  </div>
</template>

<script>
import { planLow } from "../../api/plan";

export default {
  data() {
    return {
      query: {
        type: 1,
        page: 1,
        limit: 20
      },
      list: [],
      total: 0,
      loading: true,
      index: null,
      formLoading: false,
      formVisible: false,
      balls: [],
      plans: [],
      lists: [],
      error: "",
      drawer: false,
      direction: "rtl",
      ball_list: []

    };
  },
  methods: {
    handleCurrentChange(val) {
      this.query.page = val;
      this.getList();
    },
    getLists() {
      this.loading = true;
      planLow(this.query)
        .then(response => {
          console.log(response);
          this.loading = false;
          this.lists = response.data.list || [];
          this.total = response.data.total || 0;
        })
        .catch(() => {
          this.loading = false;
          this.lists = [];
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
      return true;
    },
    // 显示表单
    handleForm(index, row) {
      this.formVisible = true;
      this.balls = Object.assign({}, row.balls);
      this.error = row.error;
      this.ball_list = row.ball_number.split(",");
      // for (let my_number of ball_numbers){
      //   let a = new Set(my_number.split('-'));
      //   let data = [];
      //   for (let ball of this.balls) {
      //     let ball_number = ball.ball_number.split('-');
      //     // let intersect = new Set([...ball_number]).filter(x => ball.ball_number.has(x));
      //     let b = new Set(ball_number);
      //     // 交集
      //     let intersect = new Set([...a].filter(x => b.has(x)));
      //     // 追加
      //     data.push(Object.assign({size: intersect.size}, ball));
      //   }
      //   this.lists.push({ball_number: my_number, balls: data})
      // }
    },
    handleClose(done) {
      done();
      // this.$confirm("确认关闭？")
        // .then(_ => {
          // done();
        // })
        // .catch(_ => {});
    }
  },
  mounted() {},
  created() {
    // 加载表格数据
    this.getLists();
  }
};
</script>

