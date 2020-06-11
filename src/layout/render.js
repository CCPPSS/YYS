import header from '../components/header/header.ejs';
import nav from '../components/nav/nav.ejs';
import index from './index.ejs';

import headerData from '../components/header/data.js'
const data = {
  header: headerData,
  content: ''
}


export default {
  pushData(inputData) {
    data.content = inputData;
    console.log(123)
    console.log(data.content)
    return this;
  },

  render(content) {
    return index({
      header: header(data.header),
      nav: nav(),
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
