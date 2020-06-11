'use strict'
const data = {
  header: {
    title: 'ccvb',
    meta: [

    ]
  },
  content: '',
  footer: '',
}

const newData = {
  content: {
    title: 'content'
  }
}



console.log(data);

let n = Object.assign(data, { content: { title: 'content' } })

console.log(data);
