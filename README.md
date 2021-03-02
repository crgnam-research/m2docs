# m2md: MATLAB 2 Markdown

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/crgnam-research/m2md/blob/main/LICENSE)
[![Release](https://img.shields.io/github/v/release/crgnam-research/m2md?include_prereleases)](https://github.com/crgnam-research/m2md/releases/tag/0.9.3)
[![Issues](https://img.shields.io/github/issues/crgnam-research/m2md)](https://github.com/crgnam-research/m2md/issues)
[![View m2md on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/88046-m2md)

A Utility for Generating Markdown Documentation for MATLAB

## Features
- Supported .m file types:
  - Class
  - Function
  - Script
- Customizable output via template files
- Easy integration with github pages

***

## How to Use:

1. Add `m2md/src/` to your MATLAB path.  (e.g. `addpath(your/path/to/m2md/src/)`)
2. Navigate to a directory above all of your .m files, and where your output docs directory will be/is
3. Run as: `m2md({INPUT_DIRS},OUTPUT_DIR,OPTIONS)`

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
## Contact
If you come across any issues or bugs with this tool, please [submit a new issue](https://github.com/crgnam-research/m2md/issues)

For questions or suggestions on this tool (or anything else!) please feel free to reach out to my email: [crgnam@buffalo.edu](mailto:crgnam@buffalo.edu)

For more information about my research, feel free to checkout my website: [chrisgnam.space](chrisgnam.space)
