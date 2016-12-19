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
    console.error(e.message || e)
    process.exit(1)
})

function test(runtime, file) {
    const bigVersionString = "0.14.0 0.14.1 1.0.0-beta 1.0.0-beta2 1.0.0-rc 1.0.0-rc2 1.0.0-rc3 1.0.0-rc4 1.0.0 1.0.1 1.0.2 1.0.3 1.0.4 1.0.5 1.0.6 1.0.7 2.0.0-pre 1.0.8 2.0.0-beta 2.0.0-beta2 2.0.0-beta3 2.0.0-rc 2.0.0-rc2 2.0.0-rc3 2.0.0 2.1.0 2.1.1 2.2.0 2.2.1 2.2.2 2.3.0 2.3.1 2.3.2 2.3.3 2.3.4 2.3.5 2.3.6 2.3.7 2.3.8 2.3.9 2.3.10 2.3.11 2.3.12 2.4.0 2.4.1 2.4.2 2.4.3 2.4.4 2.4.5 2.4.6 2.4.7 2.5.0 2.5.1 2.5.2 2.5.3 2.5.4 2.5.5 2.5.6 2.5.7 2.5.8 2.5.9 3.0.0-alpha1 3.0.0-alpha2 3.0.0-alpha3 3.0.0-alpha4 3.0.0-alpha5 3.0.0-beta1 3.0.0-beta2 3.0.0-beta3 2.5.10 3.0.0-beta4 2.5.11 3.0.0-beta5 3.0.0-beta6 3.0.0-beta7 3.0.0-rc1 3.0.0-rc2 3.0.0-rc3 3.0.0-rc4 3.0.0-rc5 3.0.0 3.0.1 3.0.2 3.0.3 3.0.4 3.0.5 3.0.6 3.1.0 3.1.1 3.1.2 3.2.0 3.2.1 3.2.2 3.2.3 3.2.4 3.2.5 3.2.6 3.3.0 3.3.1 3.3.2 3.3.3 3.3.4 3.3.5 3.3.6 3.3.7 3.3.8 3.4.0 3.4.1 3.4.2 3.4.3 3.4.4 3.4.5 3.4.6 3.4.7 3.4.8 4.0.0-rc1 4.0.0-rc2 3.5.0 4.0.0-rc3 4.0.0-rc4 3.5.1 4.0.0 3.5.2 4.1.0 4.1.1 3.5.3 4.1.2 3.6.0 4.2.0 3.7.0 3.8.0 4.3.0 4.3.1 3.8.1 4.3.2 3.9.0 4.4.0 4.4.1 3.10.0 3.10.1 3.10.2 3.10.3 3.10.4 4.4.2 3.10.5 4.4.3 3.11.0 4.4.4 3.12.0 3.12.1 4.4.5 3.13.0 4.5.0 4.5.1 3.14.0 4.6.0 4.6.1 3.15.0 4.7.0 3.15.1 4.7.1 3.15.2 4.7.2 4.7.3 3.15.3 4.7.4 3.16.0 4.8.0 3.16.1 4.8.1 3.16.2 4.8.2 3.16.3 3.16.4 4.8.3 3.16.5 3.16.6 4.8.4 3.16.7 4.8.5 3.16.8 4.8.6 3.16.9 4.8.7 3.16.10 4.8.8 3.17.0 3.17.1 4.9.0 3.17.2 4.9.1 4.9.2 3.17.3 4.9.3 3.17.4 4.9.4 3.17.5 4.9.5 3.17.6 3.17.7 4.9.6 4.9.7 3.17.8 4.9.8 3.18.0 3.18.1 4.10.0 3.18.2 4.10.1 5.0.0-alpha.1 3.18.3 4.10.2 3.18.4 4.10.3 4.10.4 4.10.5 3.18.5 3.18.6 4.10.6 4.10.7 3.19.0 4.10.8 4.11.0 3.19.1 4.11.1 3.19.2 4.11.2 3.20.0 4.12.0 3.20.1 4.12.1 4.12.2 3.20.2 4.12.3 3.20.3 4.12.4 3.21.0 4.13.0 3.21.1 4.13.1 5.0.0-alpha.2 3.21.2 4.13.2 4.13.3 4.13.4 4.14.0";

    return runTest(runtime, file, "9.0.0 10.0.0 10.1.0 10.1.1 10.1.2 10.1.3 11.0.0", "10.*", "10.1.3")
        .then(() => runTest(runtime, file, "0.1.0 0.1.1 0.1.2 1.0.0-rc1 0.1.3 0.1.4 1.0.0-rc2 1.0.0 1.0.1 1.1.0 1.2.0", "1.0.0-*", "1.0.0"))
        .then(() => runTest(runtime, file, "1.0.0-alpha.1 1.0.0-alpha 1.0.0-alpha.beta 1.0.0-beta.11 1.0.0-beta 1.0.0-beta.2", "1.0.0-*", "1.0.0-beta.11"))
        .then(() => runTest(runtime, file, bigVersionString, "2.0.0-rc3", "2.0.0-rc3"))
        .then(() => runTest(runtime, file, bigVersionString, "1.0.1-*", "1.0.1"))
        .then(() => runTest(runtime, file, bigVersionString, "3.0.0-*", "3.0.0"))
        .then(() => runTest(runtime, file, bigVersionString, "4.10.*", "4.10.8"))
        .then(() => runTest(runtime, file, bigVersionString, "0.*", "0.14.1"))
        .then(() => runTest(runtime, file, bigVersionString, "1.*", "1.0.8"))
        .then(() => runTest(runtime, file, bigVersionString, "2.*", "2.5.9"))
        .then(() => runTest(runtime, file, bigVersionString, "3.*", "3.21.2"))
        .then(() => runTest(runtime, file, bigVersionString, "*", "4.14.0"))
}

function runTest(runtime, file, input, range, expectedOutput) {
    return new Promise((resolve, reject) => {
        let errors = []
        let timeout = setTimeout(function () {
            reject("Timeout\n" + errors.join("\n"))
        }, 7000)
        let node
        if (runtime === "dotnet") {
            node = spawn("dotnet", ["script", file, "--", range])
        } else {
            node = spawn(runtime, [file, range])
        }
        node.stdout.setEncoding('utf8')
        node.stdout.on("data", (data) => {
            try {
                clearTimeout(timeout)
                makeAssertions(input, range, expectedOutput, data)
                resolve("file passed tests")
            } catch (e) {
                reject(e);
            }
        })

        node.stderr.on("data", (data) => {
            errors.push(data)
        })

        node.stdin.write(input)
        node.stdin.end()
    })
}

function makeAssertions(input, range, expectedOutput, output) {
    // Trim trailing newline
    output = output.replace(/\r?\n?$/, "")
    assert.equal(expectedOutput, output, `The incorrect version was selected.
    Input:    ${input}
    Range:    ${range}
    Expected: ${expectedOutput}
    Actual:   ${output}
    `)
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
        case ".csx":
            return "dotnet"
        default:
            throw new Error("Unrecognized file type")
    }
}