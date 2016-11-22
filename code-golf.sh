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

checkFileContents(file)
let runtime = getRuntime(file)

test(runtime, file).then(() => { 
    let stat = fs.statSync(file)    
    console.log(`Your score is ${stat.size}`)
    process.exit(0)
}).catch((e) => { 
    console.log("Failed tests")
    console.log(e)
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
        let errors = []
        let timeout = setTimeout(function () {
            reject("timeout\n" + errors.join("\n"))
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

        node.stderr.on("data", (data) => { 
            errors.push(data)
        })
    })
}

function checkFileContents(file) {
    let fileContents = fs.readFileSync(file, "utf-8")
    assert(!fileContents.includes("+"), "file contains a + character")
}

function getRuntime(file) {
    let extension = path.extname(file)    
    switch (extension) {
        case ".js":
            return "node"
        case ".py":
            return "python3"
        case ".rb":
            return "ruby"
        default:
            throw new Error("Unrecognized file type")
    }
}