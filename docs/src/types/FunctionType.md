[Home](../../index.md) > [docs](../../docs_index.md) > [src](../src_index.md) > [types](types_index.md)  


# classdef: FunctionType

**SuperClasses:** 



 ***

## Class Attributes

<div class="table-wrapper" markdown="block">

| Attribute         | Status   |
| ----------------- | -------- |
| Abstract | false | 
| ConstructOnLoad | false | 
| HandleCompatible | false | 
| Hidden | false | 
| Sealed | false | 


</div>


[*Default Class Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/class-attributes.html)

 ***

## Properties

<div class="table-wrapper" markdown="block">

| Property | Attributes  | Type | Default Value | Description |
| -------- | ----------- | ---- | ------------- | ----------- |
| Name |   | cell |  |  |
| InputNames |   | cell |  |  |
| OutputNames |   | cell |  |  |
| BriefDescription |   | cell |  |  |
| Description |   | cell |  |  |
| Include |   | logical |  |  |
| code |   | char |  |  |
| scriptBriefDescription |   | char |  |  |
| scriptDescription |   | char |  |  |


</div>

[*Default Property Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html)

 ***

## Methods

<div class="table-wrapper" markdown="block">

| Method | Attributes | Inputs | Outputs | Brief Description |
| ------ | ---------- | ------ | ------- | ----------------- |
| [FunctionType](#functiontype) |   |  | self |  |
| [inBlockComment](#inblockcomment) | Static = true | fid, tline | comment, fid |  |
| [getFuncComments](#getfunccomments) | Static = true | fid, tline | brief_description, description, fid, tline |  |
| [getFuncDeclare](#getfuncdeclare) | Static = true | fid, tline | input_names, output_names, name, fid |  |
| [parse](#parse) | Static = true | file_name | self |  |


</div>


[*Default Method Attributs*](https://www.mathworks.com/help/matlab/matlab_oop/method-attributes.html)

 ***

## Detailed Description



 ***

## Method Descriptions

### FunctionType

```matlab
function [self] = FunctionType()
```

### inBlockComment

```matlab
function [comment, fid] = inBlockComment(fid, tline)
```

### getFuncComments

```matlab
function [brief_description, description, fid, tline] = getFuncComments(fid, tline)
```

### getFuncDeclare

```matlab
function [input_names, output_names, name, fid] = getFuncDeclare(fid, tline)
```

### parse

```matlab
function [self] = parse(file_name)
```




***

*Generated on 04-Mar-2021 12:30:25 by [m2docs](https://github.com/crgnam-research/m2docs) © 2021*
