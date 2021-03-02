# m2md: MATLAB 2 Markdown

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/crgnam-research/m2md/blob/main/LICENSE)
[![Release](https://img.shields.io/github/v/release/crgnam-research/m2md?include_prereleases)](https://github.com/crgnam-research/m2md/releases/tag/0.9.3)
[![Issues](https://img.shields.io/github/issues/crgnam-research/m2md)](https://github.com/crgnam-research/m2md/issues)
[![View m2md on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/88046-m2md)

A Utility for Generating Markdown Documentation for MATLAB

## Features
- Supported .m file types:
  - Classes
  - Functions (with all sub-functions)
  - Scripts (with all sub-functions)
- Customizable output via template files
- Easy integration with github pages

***

## How to Use:

1. Simply write a MATLAB file as you normally would, making comments abiding by the [Comment Style Guide](#comment-style-guide)
4. Add `m2md/src/` to your MATLAB path.  (e.g. `addpath(your/path/to/m2md/src/)`)
5. Navigate to a directory above all of your .m files, and where your output docs directory will be/is
6. Run as: `m2md({INPUT_DIRS},OUTPUT_DIR,OPTIONS)`

This will process all of the directories and .m files specified in `{INPUT_DIRS}`, and produce a set of markdown files in `OUTPUT_DIR` along with a set of index files for navigating them.

For an example, refer to `generateDocs.m` in the root directory of this project.  This is the script which auto generates the documentation for this project.

### Hosting on GitHub Pages:
Simply turn on [GitHub Pages](https://guides.github.com/features/pages/), select a theme, create an `index.md` file, and create a link to whatever the base markdown file thats been generated is named (typically `docs.md`).  Thats it!  Your MATLAB documentation will be hosted in an easy to navigate website!

### Tips when hosting on GitHub Pages:

- The tables generated for classes can be quite wide, which is not typically an issue when viewed a normal desktop computer, but can cause things to look quite ugly on mobile devices.  To fix this we'll want to make the tables scrollable if they are bigger than the container they're in.  To this on your site:
  - In your github pages source directory (either `root` or `docs`), create a new file: `assets/css/style.scss`
  - Add the following lines to this new file (*NOTE: replace "jekyll-theme-slate" with whatever theme you are using*):
```
---
---
@import "jekyll-theme-slate";

table {
    overflow-x: scroll;
}
```
- Because the annotated comments in your .m files are extracted inserted into a markdown file verbatim, you can embed equations using [MathJax](https://www.mathjax.org/).  To get them to render properly though, we'll need to add MathJax support to our theme if it doesn't have it already.  To do this on your site:
  - Find your theme's github repository (for example, for the slate theme used on this site, we'd go to https://github.com/pages-themes/slate)
  - Navigate to `_layouts/default.html` and copy the contents of that file
  - Navigate back to your repository, and go to your github pages source directory (either `root` or `docs`) and create a new file: `_layouts/default.html`
  - Paste the contents of the file you copied from the themes directory into this new file
  - In the header section (after `<head>` and before `</head>`, paste the following code:
```
    <!-- MathJax -->
    <script type="text/javascript"
      src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.3/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
    </script>
```

***
## Comment Style Guide
In order to get the most out of your documentation, there are several things you need to keep in mind while commenting.  All of these comments are totally optional, but without them the only things that will be documented are the file's meta data (file name, type, etc.) along with:

- class properties and their attributes
- class methods, their attributes, their inputs and their outputs
- function inputs and outputs
- sub-function inputs and outputs

To add descriptions/information for your properties/methods/functions/scripts, etc. You'll need to format your comments properly.  But don't worry!  Its easy!

- To assign a **Name** to your file make a comment starting with `NAME>{Your Name Here}` at the top of the file (somewhere before any function/classdef declaration)
- To assign a **Brief Description** to your file, make a comment `BRIEF>{Your Brief Description Here}` at the top of the file (somewhere before any function/classdef declaration)
- To assign a **Detailed Description** to your file, make a comment `DESCRIPTION>{Your Detailed Description Here}` at the top of the file (somewhere any function/classdef/declaration)

All of three of these special comments outlined above can span multiple lines.  Simply make sure to keep the keyword and bracket together (e.g. `NAME>{` cannot be broken between lines).  Whatever text placed inside the the brackets will be assigned to that particular parameter.

Beyond assigning a name and description to your file, you can also add additional information about certain components of your file These are outlined below.

### Classes
- For each class method, you can use `NAME>{}`, `BRIEF>{}`, and `DESCRIPTION>{}`. Simply place them immediately following the function delcaration
- You can add brief descriptions to each property, simply write a normal comment on the same line as the property you wish to describe

### Functions
- You can use `NAME>{}`, `BRIEF>{}`, and `DESCRIPTION>{}`.  Simply place them immediately following the function delcaration

### Sub-Functions
- You can use `NAME>{}`, `BRIEF>{}`, and `DESCRIPTION>{}`.  Simply place them immediately following the sub-function delcaration

***
## Contact
If you come across any issues or bugs with this tool, please [submit a new issue](https://github.com/crgnam-research/m2md/issues)

For questions or suggestions on this tool (or anything else!) please feel free to reach out to my email: [crgnam@buffalo.edu](mailto:crgnam@buffalo.edu)

For more information about my research, feel free to checkout my website: [chrisgnam.space](chrisgnam.space)
