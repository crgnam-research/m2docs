[Home](../index.md) > [docs](../docs_index.md) > [src](src_index.md)  


# classdef: m2md

**SuperClass:** handle

**Matlab 2 Markdown**: Utility for Creating Markdown Documentation for MATLAB Projects

 ***

## Class Attributes

default

[*Default Class Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/class-attributes.html)

 ***

## Properties

| Property | Attributes  | Comment |
| -------- | ----------- | ------- |
| InputMfiles_rel | default | Input m files relative path |
| InputMfiles_full | default | Input m files absolute path |
| OutputMDdir_rel | default | Output directory relative path |
| OutputMDdir_full | default | Output directory full path |
| OutputMD_name | default | Output names |
| Template | default | Function handle of markdown template |
| MakeIndex | default | Boolean for whether or not to make the index files |
| IndexTemplate | default | Function handle to the markdown template |
| TYPE | default | Current type of m file that was loaded |
| FILENAME | default | Current file name |
| BCOMMENTS_INDS | default | Current indices of block comment sections |
| leading_comments | default | Current leading comments |
| NAME | default | Current specified name |
| BRIEF | default | Current specified brief description |
| DESCRIPTION | default | Current specified detailed description |
| FUNCTION | default | Current function data |
| SUBFUNCTIONS | default | Current sub-functions data |
| CLASS_ATTR | default | Current class attributes |
| SUPERCLASS | default | Current class' super class |
| PROPERTIES | default | Current class properties |
| PROP_ATTR | default | Current class' property attributes |
| CONSTRUCTOR | default | Current class' constructor |
| METHODS | default | Current class' methods |
| METHOD_ATTR | default | Current class' method attributes |

[*Default Property Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html)

 ***

## Constructor

| Constructor | Attributes | Inputs | Outputs | Brief Description |
| ----------- | ---------- | ------ | ------- | ----------------- |
| [m2md](#m2md) | default | InputMfiles, OutputMDdir, varargin | self | The constructor for the m2md class |


 ***

## Methods

| Method | Attributes | Inputs | Outputs | Brief Description |
| ------ | ---------- | ------ | ------- | ----------------- |
| [getCLASS_ATTR](#getclass_attr) | (Access = *private*) | self, cdef_line |  | Reads the current class attributes |
| [getPROP_ATTR](#getprop_attr) | (Access = *private*) | self, prop_line | custom | Reads the current class' property attributes |
| [getMETHOD_ATTR](#getmethod_attr) | (Access = *private*) | self, method_line |  | Gets the current class' method attributes |
| [removeComments](#removecomments) | (Access = *private*) | self, i1, i2 | i1, i2 | Removes matches that are comments |
| [parseFunction](#parsefunction) | (Access = *private*) | func_line, msource | outstruct | Gets the inputs/outputs of the current function |
| [getMfiles](#getmfiles) | (Access = *private*) | InputMfiles | mfiles_rel, mfiles_full | Gets the relative and absolute paths to all specified m files |
| [bool2str](#bool2str) | (Access = *private*) | bool | string | Converts a boolean to a string |


[*Default Method Attributs*](https://www.mathworks.com/help/matlab/matlab_oop/method-attributes.html)

 ***

## Detailed Description


 This class will automatically generate documentation in a markdown
 format, ready to be uploaded to GitHub pages or any other static site
 generator system that allows for markdown files.
 
 Simply provide the m files, or a directory/directories to your m files,
 along with the desired output directory.


 ***

## Constructor Description

### m2md

**[self] = m2md(InputMfiles, OutputMDdir, varargin)**

DESCRIPTION: When called this will instantiate an object and
            