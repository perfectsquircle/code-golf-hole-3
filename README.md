Code Golf: Hole 2
===========================

## Introduction

Code Golf is a competition where given a programming prompt, the shortest source code (measured in bytes) to fully implement the prompt wins the challenge. Ties are broken by the first golfer to submit a solution of a given size.

## Challenge

Write a program that, given a short ASCII input string, outputs a copy where no two characters are repeating. Upper and lower case letters are considered equal. Your output does not have to match the following examples exactly, there are many correct answers.

```bash
$ echo 'Aaron, Gregg, Moos, and Laabs vacuum llamas in Mississippi.' | node my-solution.js
Araon, Greg,g Moso, and Labas vacumu lalmas in Misisispsip.
$ echo 'aaabbbxxxyyy' | python3 my-solution.py
yababxbxyxya
$ echo 'Everything   is    awesome!' | ruby my-solution.rb
Everything i s a w e s ome!
```

## Rules

* The languages are limited to JavaScript (Node.js 6.9), Python3 (3.5), and Ruby (2.3).
* Your submission is limited to a single file.
* The input string is provided through stdin.
* The output string must be printed to stdout.
* The output string must be the same length as the input string.
* The output string must contain every character in the input string in the same quantity.
* No two letters or characters in the output string may be repeating.
* Upper and lower case letters are considered equal.

## Scoring

Please submit a single file (.js, .py, or .rb). The included node script `code-golf.sh` will be used to score your file. To run this script, you must have Node.js installed.

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

Docker
```bash
$ docker build -t golf .
$ docker run -it -v "$PWD":/tmp/src golf bash
$ ./code-golf.sh my-solution.js
Your score is 456
```

![golf](https://media.giphy.com/media/t01OCfo66twSQ/giphy.gif)
