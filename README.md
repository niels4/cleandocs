# cleandocs

Merge code and markdown files to create project documentation.

This project is in very early alpha stage. It does the bare minimum to allow me to start
writing literate coffee script in a way that doesn't clutter up the source code while
I'm working on it. Expect plenty of changes as I get some free time to make them.

## Getting Started

There are two ways to use cleandocs.

### Grunt Plugin
This is the easiest and recommended way to use cleandocs when documenting a project.
For examples and usage, see [grunt-cleandocs](https://github.com/niels4/grunt-cleandocs)

### Command Line
The app also exists as a simple command line app.

Install the module with: `npm install -g cleandocs`
Copy the example cleandocs.json file into the root directory of your project.
Edit the dirs list to point to your src files, doc files, and output directory for
each source directory you wish to document (Usually its just src and test).

Then from the same directory as the cleandocs.json file, type cleandocs.
The files should be merged and output into the directory specified in the json config file.

## Examples
For an example of using cleandocs from the grunt plugin, see [grunt-cleandocs](https://github.com/niels4/grunt-cleandocs).

This project is an example of cleandocs working from the command line.

First install cleandocs
    
    npm install -g cleandocs

Then clone this repository and clean out the existing docs folder

  git clone https://github.com/niels4/cleandocs
  cd cleandocs
  rm -rf out/docs

Then run clean docs and verify that the literate coffeescript files were generated

    cleandocs
    ls out/docs/src

## Future plans

*  Expand the documentation using cleandocs
*  Pass the litcoffe files through docco to create a static site of html files
*  Create a searchable table of contents page based off of the files created
*  Export documentation as static site at the end of the grunt build task

## License
Copyright (c) 2013 Niels Nielsen. Licensed under the MIT license.
