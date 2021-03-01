[Home](../index.md) > [docs](../docs_index.md) > [src](src_index.md)  


# classdef: m2md

**SuperClass:** handle

**Matlab 2 Markdown**: Utility for creating markdown documentation from a Matlab M-file

 ***

## Class Attributes

default

[*Default Class Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/class-attributes.html)

 ***

## Properties

| Property | Attributes  | Comment |
| -------- | ----------- | ------- |
| InputMfiles_rel | default |  |
| InputMfiles_full | default |  |
| OutputMDdir_rel | default |  |
| OutputMDdir_full | default |  |
| OutputMD_name | default |  |
| Template | default |  |
| MakeIndex | default |  |
| IndexTemplate | default |  |
| TYPE | default | Type of m-file that was loaded |
| FILENAME | default |  |
| BCOMMENTS_INDS | default | Indices of block comment sections |
| leading_comments | default |  |
| NAME | default |  |
| BRIEF | default |  |
| DESCRIPTION | default |  |
| FUNCTION | default |  |
| SUBFUNCTIONS | default |  |
| CLASS_ATTR | default |  |
| SUPERCLASS | default |  |
| PROPERTIES | default |  |
| PROP_ATTR | default |  |
| CONSTRUCTOR | default |  |
| METHODS | default |  |
| METHOD_ATTR | default |  |

[*Default Property Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html)

 ***

## Constructor

| Constructor | Attributes | Inputs | Outputs | Brief Description |
| ----------- | ---------- | ------ | ------- | ----------------- |
| [m2md](#m2md) | default | InputMfiles, OutputMDdir, varargin | self | Brief Description Goes Here |


 ***

## Methods

| Method | Attributes | Inputs | Outputs | Brief Description |
| ------ | ---------- | ------ | ------- | ----------------- |
| [getCLASS_ATTR](#getclass_attr) | (Access = *private*) | self, cdef_line |  | Brief Description Goes Here |
| [getPROP_ATTR](#getprop_attr) | (Access = *private*) | self, prop_line | custom | Brief Description Goes Here |
| [getMETHOD_ATTR](#getmethod_attr) | (Access = *private*) | self, method_line |  | Brief Description Goes Here |
| [removeComments](#removecomments) | (Access = *private*) | self, i1, i2 | i1, i2 | Brief Description Goes Here |
| [parseFunction](#parsefunction) | (Access = *private*) | func_line, msource | outstruct | Brief Description Goes Here |
| [getMfiles](#getmfiles) | (Access = *private*) | InputMfiles | mfiles_rel, mfiles_full | Brief Description Goes Here |
| [bool2str](#bool2str) | (Access = *private*) | bool | string | Brief Description Goes Here |


[*Default Method Attributs*](https://www.mathworks.com/help/matlab/matlab_oop/method-attributes.html)

 ***

## Detailed Description


 A more detailed description can go here. 


 ***

## Constructor Description

### m2md

**[self] = m2md(InputMfiles, OutputMDdir, varargin)**

DESCRIPTION: Detailed Description Goes Here

 ***

## Method Descriptions

### getCLASS_ATTR

**[] = getCLASS_ATTR(self, cdef_line)**

DESCRIPTION: Detailed Description Goes Here
### getPROP_ATTR

**[custom] = getPROP_ATTR(self, prop_line)**

DESCRIPTION: Detailed Description Goes Here
### getMETHOD_ATTR

**[] = getMETHOD_ATTR(self, method_line)**

DESCRIPTION: Detailed Description Goes Here
### removeComments

**[i1, i2] = removeComments(self, i1, i2)**

DESCRIPTION: Detailed Description Goes Here
### parseFunction

**[outstruct] = parseFunction(func_line, msource)**

DESCRIPTION: Detailed Description Goes Here
### getMfiles

**[mfiles_rel, mfiles_full] = getMfiles(InputMfiles)**

DESCRIPTION: Detailed Description Goes Here
### bool2str

**[string] = bool2str(bool)**

DESCRIPTION: Detailed Description Goes Here

***

*Generated on 01-Mar-2021 16:29:26 by [m2md](https://github.com/crgnam-research/m2md) © 2021*