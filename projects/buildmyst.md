# About BuildMyst [![Build Status](https://travis-ci.org/CodeMyst/BuildMyst.svg?branch=master)](https://travis-ci.org/CodeMyst/BuildMyst)

A very simple and customizable build system. You can find an example in the `example` folder.

You can define actions which execute simple shell scripts or even complex custom D scripts (meaning you can do anything).

Each build executes defined actions in an order one by one. You can specify multiple build configurations (like debug and release). There are also prebuilt build event `before_build` and `after_build` which get executed before and after the build.

There's also a watch mode where you can specify which directories to watch, when something changes inside of them the actions get called. You can specify different actions for different directories, so if you have a html and css directories for example, when something changes inside the html folder you don't necessarily also need to build the css folder (but you can if you want!).

## Getting BuildMyst

You can download the Linux binary on the [releases page](https://github.com/CodeMyst/BuildMyst/releases) or you can build it very easily using dmd and dub.

Download dmd on the [D website](https://dlang.org/download.html) and simply run `dub build` in the project directory.

## Running BuildMyst

```sh
buildmyst
```

```sh
buildmyst --targetDirectory test/ --configuration release
```

Here's a sample config file:

```yaml
---
actions:
    build_pug:
        - pug source/views/index.pug -o dist -P
    build_scss:
        - sass source/styles/style.scss dist/style.css
    build_pug_minified:
        - pug source/views/index.pug -o dist
    build_scss_minified:
        - sass source/styles/style.scss dist/style.css -s compressed --no-source-map
    file_renamer:
        - ${files/renamer dist/}
    clean_dist:
        - ${files/rmdir dist/} # Calls the scripts/files/rmdir.d script
        - ${files/mkdir dist/}

configurations:
    - debug
    - release

before_build:
    - ${clean_dist}

build_debug:
    - ${build_pug}
    - ${build_scss}

build_release:
    - ${build_pug_minified}
    - ${build_scss_minified}
    - ${file_renamer}

watch:
    source/views/:
        - ${build_pug}
    source/styles/:
        - ${build_scss}
...
```
