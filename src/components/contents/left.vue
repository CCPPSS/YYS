<template>
  <div id="left">
    <el-tabs
      v-model="activeName"
      type="card"
      @tab-click="handleClick"
    >
      <el-tab-pane
        label="用户管理"
        name="first"
      >

        <!-- 用户帐号列表界面 -->
        <el-table
          header-row-class-name="ss"
          :row-class-name="tableRowClassName"
          stripe
          @selection-change="handleSelectionChange"
          height="300px"
          highlight-current-row
          :data="tableData"
          style="width: 100%"
        >

          <!-- 选择按钮列 -->
          <el-table-column
            type="selection"
            width="30"
          ></el-table-column>

          <!-- 数据列1 -->
          <el-table-column
            label="账号列表"
            width="150"
            show-overflow-tooltip
          >
            <template slot-scope="scope">
              {{scope.row.hwnd+"-["+scope.row.angent+"]"}}
            </template>
          </el-table-column>

          <!-- 数据列2 -->
          <el-table-column
            label="启停状态"
            width="70"
            align="left"
          >
            <template slot-scope="scope">
              <el-switch
                v-model="scope.row.stats"
                active-color="#0FD2F0"
                inactive-color="#ff4949"
              >
              </el-switch>
            </template>
          </el-table-column>

        </el-table>

        <!-- 控制台按钮控件 -->
        <div id="left">
          <el-button-group>
            <el-button
              @click="run"
              size="medium"
              type="success"
              icon="el-icon-caret-right"
            >&nbsp;&nbsp;启&nbsp;&nbsp;&nbsp;&nbsp;动&nbsp;&nbsp;</el-button>
            <el-button
              size="medium"
              type="warning"
            >刷新窗口 <i class="el-icon-refresh"></i></el-button>
          </el-button-group>
        </div>
      </el-tab-pane>

      <!-- 高级配置管理界面 -->
      <el-tab-pane
        label="高级管理"
        name="second"
      >

        配置管理
      </el-tab-pane>

    </el-tabs>
  </div>
</template>

<script>
/*
 * @Author: cps-thinkpad
 * @Date: 2020-01-03 14:15:39
 * @Last Modified by: home-holy
 * @Last Modified time: 2020-01-07 13:28:13
 */
export default {
  name: 'left',
  data() {
    return {
      activeName: 'first',
      tableData: [{
        hwnd: 251423,
        angent: '桌面版',
        name: '251423-桌面版',
        stats: false
      }, {
        hwnd: 251423,
        angent: '逍遥模拟器',
        name: '251423-逍遥模拟器',
        stats: false
      }],
      multipleSelection: []
    };
  },
  methods: {
    run() {
      console.log(this.$refs.multipleTable)
    },

    handleClick(tab, event) {
      console.log(tab, event);
    },
    handleEdit(index, row) {
      console.log(index, row);
    },
    handleDelete(index, row) {
      console.log(index, row);
    },


    /**
     * 每次点击表格都会执行,有多少行就执行多少次
     * @param      {Object}  arg1           对象
     * @param      {object}  arg1.row       行数据
     * @param      {<type>}  arg1.rowIndex  行对应的索引
     */
    tableRowClassName({ row, rowIndex }) {},



    /**
     * Gets the name.
     *
     * @param      {<type>}  index   The index
     * @return     {<type>}  The name.
     */
    getName(index) {
      console.log(index);
      return this.tableData[index].angent
    },


    /**
     * 处理每次点击时的函数
     *
     * @param      {<type>}  val     The value
     */
    handleSelectionChange(val) {
      if (val.length > 0) {
        val[0].hwnd
      }
      this.multipleSelection = val
    }
  }
};

</script>

<style scoped>
#console {
  padding: 5%;
}

#left {
  background-color: #FfF;
  padding: 5px;
  font-size: 15px;
}

.miniheight {
  width: 100%;
  min-height: 250px;
  max-height: 300px;
}

#checkHwnds {
  width: 60%;
  display: inline-block;
}

#countlist {
  background-color: #820707;
  width: 60%;
  display: inline-block;
  padding: 0;
  margin: 0;
}

#countlistset {
  background-color: #08F584;
  width: 38%;
  display: inline-block;
}

.el-switch__label--right {
  z-index: 1;
  right: -3px;
  margin: 0;
}

.el-switch__label--left {
  z-index: 1;
  right: 19px;
  margin: 0;
}

.ss {
  background: #6AEB23;
}

</style>
