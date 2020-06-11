import header from '@src/components/header/header.ejs';
import nav from '@src/components/nav/nav.ejs';
import index from './index.ejs';

import headerData from '@src/components/header/data.js'

const data = {
  header: headerData,
  nav: '',
  content: '',
}


export default {

  // 将数据更新到内部
  pushData(inputData) {
    //更新模板数据，
    //自定义页面的meta等信息
    let newData = Object.assign(data, inputData)
    data.content = inputData;
    return this;
  },

  // 根据数据生成content
  render(content) {
    return index({
      header: header(data.header),
      nav: nav(data.nav),
      content: content(data.content),
    })
  }
}


// export default (content) => {
//   return index({
//     header: header(data.header),
//     nav: nav(),
//     content: content(),
//   })
// }
