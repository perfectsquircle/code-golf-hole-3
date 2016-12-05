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
        runTest(runtime, file, "Aaron, Gregg, Moos, and Laabs vacuum llamas in Mississippi."),
        runTest(runtime, file, "aaabbbxxxyyy"),
        runTest(runtime, file, "Everything   is    awesome!"),
        runTest(runtime, file, "And, as in uffish thought he stood, The Jabberwock, with eyes of flame, Came whiffling through the tulgey wood, And burbled as it came!"),
        runTest(runtime, file, "AaAaBbBbCcCcDdDd"),
        runTest(runtime, file, "aaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbb")
    ])
}

function runTest(runtime, file, input) {
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
            makeAssertions(input, data)
            resolve("file passed tests")
        })

        node.stderr.on("data", (data) => { 
            errors.push(data)
        })
    })
}

function makeAssertions(input, output) {
    // The output string must be the same length as the input string.
    assert.equal(input.length, output.length, "The output string is not the same length as the input string.")

    // The output string must contain every character in the input string in the same quantity.
    let inputSorted = input.split("").sort().join("")
    let outputSorted = output.split("").sort().join("")
    assert.equal(
        inputSorted,
        outputSorted,
        `Output string contains characters not found in the input string.\n${inputSorted}\n${outputSorted}\n`
    )

    // No two letters or characters in the output string may be repeating.
    // Upper and lower case letters are considered equal.    
    for (let i = 0; i < output.length - 1; i++) {
        let a = output[i]
        let b = output[i+1]
        if (a.toUpperCase() === b.toUpperCase()) {    
            assert.fail(a, b, `Repeating characters found at index ${i} \n${output} \n${" ".repeat(i)}^^\n`)
        }    
    }
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