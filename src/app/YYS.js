'use strict'
const lw = require('clw')
let l1 = lw('./src/dll/test11.dll')

const worker = require('worker_threads')
console.dir(worker)

if (worker.isMainThread) {
    const mworker = new worker.Worker('./test.js')
    mworker.on('start', (message) => {
        console.log(message); // Prints 'Hello, world!'.
    });

    mworker.postMessage('Hello, world!');
}