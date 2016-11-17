Code Golf: Round 1
===========================

## Introduction

Code Golf is a competition where given a programming prompt, the shortest source code (measured in bytes) to fully implement the prompt wins the challenge.

## Challenge

Write a program that adds together several small positive integers. **Your program may not use the `+` character.**

The integers are provided through `stdin`. They are seperated by a single space

```bash
$ echo 42 13 | node my-solution.js
55
$ echo 128 256 512 | python3 my-solution.py
896
$ echo 9 8 7 6 5 4 3 2 1 | ruby my-solution.rb
45
```

## Rules

* The languages are limited to JavaScript (Node.js), Python3, and Ruby.
* You may not use libraries.
* Your submission is limited to a single file.
* That file cannot contain the `+` character.

## Scoring

Please submit a single file (.js, .py, or .rb). The included node script `code-golf.sh` will be used to score your file. To run this script, you must have Node.js installed.

Docker Host (any OS running docker - so you don't have to install node/ruby/python)
```bash
$ docker build -t golf .
$ docker run -it -v "$PWD":/tmp/src golf bash
$ ./code-golf.sh my-solution.js
Your score is 456
```

macOS
```bash
$ ./code-golf.sh my-solution.js
Your score is 456
```

Windows
```
C:\> node code-golf.sh my-solution.js
Your score is 456
```


![golf](https://media.giphy.com/media/l2SqdN3BeFQzEG9Dq/giphy.gif)
