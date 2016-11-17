#!/usr/bin/env node
"use strict"
const fs = require("fs")
const spawn = require('child_process').spawn
const path = require("path")
const assert = require("assert")

let args = process.argv
let file = args[2]
if (!file) {
    console.log("Must provide file as first argument")
    process.exit(1)
}

let stat = fs.statSync(file)

let fileContents = fs.readFileSync(file, "utf-8")
checkFileContents(fileContents)

let extension = path.extname(file)

let runtime
switch (extension) {
    case ".js":
        runtime = "node"
        break
    case ".py":
        runtime = "python3"
        break
    case ".rb":
        runtime = "ruby"
        break
    default:
        console.log("Unrecognized file type")
        process.exit(1)
}

test(runtime, file).then(() => { 
    console.log(`Your score is ${stat.size}`)
    process.exit(0)
}).catch((e) => { 
    console.log("Failed tests")
    process.exit(1)
})

function test(runtime, file) {
    return Promise.all([
        runTest(runtime, file, "8 10", "18"),
        runTest(runtime, file, "200 42 1024", "1266"),
        runTest(runtime, file, "9 8 7 6 5 4 3 2 1", "45"),
        runTest(runtime, file, "128 256 512", "896")
    ])
}

function runTest(runtime, file, input, expectedOutput) {
    return new Promise((resolve, reject) => {
        let timeout = setTimeout(function () {
            reject("file failed tests")
        }, 1000)
        let node = spawn(runtime, [file])
        node.stdin.write(input)
        node.stdin.end();

        node.stdout.setEncoding('utf8')
        node.stdout.on("data", (data) => {
            clearTimeout(timeout)
            assert.equal(expectedOutput, data.trim())
            resolve("file passed tests")
        })
    })
}

function checkFileContents(fileContents) {
    assert(!fileContents.includes("+"), "file contains a + character")
}