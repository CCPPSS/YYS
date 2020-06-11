'use strict'

const path = requrie('path')

module.exports = {
  target: 'node',
  mode: 'none',
  entry: path.resolve(__dirname, '../src/index.js'),
  output: {
    filename: '[name].binder.js',
    path: path.resolve(__dirname, '../build')
  }
}
