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
| TYPE | default | Type of m-file that was loaded |
| FILENAME | default |  |
| BCOMMENTS_INDS | default | Indices of block comment sections |
| leading_comments | default |  |
| NAME | default |  |
| BRIEF | default |  |
| DESCRIPTION | default |  |
| CLASS_ATTR | default |  |
| SUPERCLASS | default |  |
| PROPERTIES | default |  |
| PROP_ATTR | default |  |
| CONSTRUCTOR | default |  |
| METHODS | default |  |
| METHOD_ATTR | default |  |
| seven = 2 | (Access = *private*) |  |
| six = 5 | (Access = *private*) |  |

[*Default Property Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html)

 ***

## Constructor

| Constructor | Attributes | Inputs | Outputs | Brief Description |
| ----------- | ---------- | ------ | ------- | ----------------- |
| [m2md](###m2md) | default | InputMfiles, OutputMDdir, varargin | self | ',' |


 ***

## Methods

| Method | Attributes | Inputs | Outputs | Brief Description |
| ------ | ---------- | ------ | ------- | ----------------- |
| [getCLASS_ATTR](###getCLASS_ATTR) | (Access = *private*) | self, cdef_line |  |  |
| [getPROP_ATTR](###getPROP_ATTR) | (Access = *private*) | self, prop_line | custom |  |
| [getMETHOD_ATTR](###getMETHOD_ATTR) | (Access = *private*) | self, method_line |  |  |
| [removeComments](###removeComments) | (Access = *private*) | self, i1, i2 | i1, i2 |  |
| [square](###square) | (Access = *private*) |  |  | Brief Description Goes Here |
| [circle](###circle) | (Access = *private*) |  | a, b | Brief Description Goes Here |
| [triangle](###triangle) | (Access = *private*) | a,  b | a, b | Brief Description Goes Here |
| [parseFunction](###parseFunction) | (Access = *private*) | func_line, msource | outstruct | Brief Description Goes Here |
| [getMfiles](###getMfiles) | (Access = *private*) | InputMfiles | mfiles_rel, mfiles_full |  |
| [bool2str](###bool2str) | (Access = *private*) | bool | string |  |
| [str2bool](###str2bool) | (Access = *private*) | string | bool |  |


[*Default Method Attributs*](https://www.mathworks.com/help/matlab/matlab_oop/method-attributes.html)

 ***

## Detailed Description


 A more detailed description can go here. 
 ### Section 1
 You can use limited markdown syntax exactly in here.  Just make sure that
 you recognize that:
 - You can only use level 3 sections or higher
 - This section is entire entered into the "Detailed Description" section
 exactly as it appears here (it is copied verbatim)
 - You must remember to add a closing bracket.
 
 ### Section 2
 You can use [links](google.com) as well
 

 ***

## Constructor Description

### m2md

**[self] = m2md(InputMfiles, OutputMDdir, varargin)**

DESCRIPTION: ','

 ***

## Method Descriptions

### getCLASS_ATTR

**[] = getCLASS_ATTR(self, cdef_line)**

DESCRIPTION: 
### getPROP_ATTR

**[custom] = getPROP_ATTR(self, prop_line)**

DESCRIPTION: 
### getMETHOD_ATTR

**[] = getMETHOD_ATTR(self, method_line)**

DESCRIPTION: 
### removeComments

**[i1, i2] = removeComments(self, i1, i2)**

DESCRIPTION: 
### square

**[] = square()**

DESCRIPTION: Detailed Description Goes Here
### circle

**[a, b] = circle()**

DESCRIPTION: Detailed Description Goes Here
### triangle

**[a, b] = triangle(a,  b)**

DESCRIPTION: Detailed Description Goes Here
### parseFunction

**[outstruct] = parseFunction(func_line, msource)**

DESCRIPTION: Detailed Description Goes Here
### getMfiles

**[mfiles_rel, mfiles_full] = getMfiles(InputMfiles)**

DESCRIPTION: 
### bool2str

**[string] = bool2str(bool)**

DESCRIPTION: 
### str2bool

**[bool] = str2bool(string)**

DESCRIPTION: 
