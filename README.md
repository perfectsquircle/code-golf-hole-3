Code Golf: Hole 3
===========================

## Introduction

Code Golf is a competition where given a programming prompt, the shortest source code (measured in bytes) to fully implement the prompt wins the challenge. Ties are broken by the first golfer to submit a solution of a given size.

## Challenge

Your friend Irene is writing a package manager. The package manager is almost complete, but she needs your help with dependency resolution. She wants you to write the algorithm that picks the correct version given a version range.

She gives you all the versions of a single published package through stdin, seperated by a single space. She also provides you with a version range as the first parameter. She wants your program to print the correct version that satisfies that range.

```bash
$ echo '9.0.0 10.0.0 10.1.0 10.1.1 10.1.2 10.1.3 11.0.0' | node my-solution.js '10.*'
10.1.3
$ echo '0.1.0 0.1.1 0.1.2 1.0.0-rc1 0.1.3 0.1.4 1.0.0-rc2 1.0.0 1.0.1 1.1.0 1.2.0' | python3 my-solution.py '1.0.0-*'
1.0.0
$ echo '1.0.0-alpha.1 1.0.0-alpha 1.0.0-alpha.beta 1.0.0-beta.11 1.0.0-beta 1.0.0-beta.2' | ruby my-solution.rb '1.0.0-*'
1.0.0-beta.11
$ echo '1.0.0 2.0.0 3.0.0-alpha' | dotnet script my-solution.csx -- '*'
2.0.0
```

## Rules

* The languages are limited to JavaScript (Node.js 6.9), Python3 (3.5), Ruby (2.3), and C# ([.NET Core 1.1](https://github.com/filipw/dotnet-script)).
* Your submission is limited to a single file.
* The series of versions are is provided through stdin, each seperated by a single space.
* Versions provided aren't necessarily chronological or in order of precedence.
* Each version conforms to [semver](http://semver.org)
  * The versions will be of the form MAJOR.MINOR.PATCH or MAJOR.MINOR.PATCH-PRERELEASE.
  * MAJOR, MINOR, and PATCH are always whole, positive numbers.
  * PRERELEASE can contain alphanumeric characters. Precedence is determined by [semver rules](http://semver.org/#spec-item-11).
* A single version range is given as the first argument.
* The version range:
  * Can be an exact version: `1.0.0`, `1.0.0-alpha1`
  * Can use one `*` wildcard in any position: `1.0.0-*`, `1.0.*`, `1.*`, `*`
    * A wildcard in the MAJOR, MINOR, or PATCH position indicate that the highest non-prerelease version within that position should be chosen.
    * A wildcard in the PRERELEASE position indicates that the highest prerelease version should be chosen, unless a matching release version is found.
* A single version must be printed to stdout, and it must be chosen from one of the input versions.

## Scoring

Please submit a single file (.js, .py, .rb, or .csx). The included node script `code-golf.sh` will be used to score your file. To run this script, you must have Node.js installed.

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

![golf](https://media.giphy.com/media/dOdfxZkkKFgOc/giphy.gif)
