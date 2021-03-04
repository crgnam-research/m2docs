[Home](../index.md) > [docs](../docs_index.md) > [src](src_index.md)  


# classdef: GenerateDocumentation

**SuperClasses:** handle



 ***

## Class Attributes

| Attribute         | Status   | 
| ----------------- | -------- | 
| Abstract | false | 
| ConstructOnLoad | false | 
| HandleCompatible | true | 
| Hidden | false | 
| Sealed | false | 


[*Default Class Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/class-attributes.html)

 ***

## Properties

| Property | Attributes  | Type | Default Value | Description |
| -------- | ----------- | ---- | ------------- | ----------- |
| in_rel |   | cell |  | Nx1 relative paths to all N input files |
| in_abs |   | cell |  | Nx1 absolute paths to all N input files |
| out_rel |   | cell |  | Nx1 relative paths to all N output files |
| out_abs |   | cell |  | Nx1 absolute paths to all N output files |
| out_dir |   | char |  |  |
| root |   | char |  | The root directory this was run from |
| class_template |   | function_handle |  | The template used to format outputs for class files |
| function_template |   | function_handle |  | The template used to format outputs for function files |
| script_template |   | function_handle |  | The template used to format outputs for script files |
| index_template |   | function_handle |  |  |
| ind |   | double |  | Current itertaion for looping through all files |
| type |   | cell |  | Nx1 array containing the types for each of the N input files |
| data |   | cell |  | Nx1 array containing the extracted data from each N input files |
| code |   | cell |  | Nx1 array containing the source code for each of the N input files |
| scriptBriefDescription |   | cell |  |  |
| scriptDescription |   | cell |  |  |

[*Default Property Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html)

 ***

## Methods

| Method | Attributes | Inputs | Outputs | Brief Description |
| ------ | ---------- | ------ | ------- | ----------------- |
| [GenerateDocumentation](#generatedocumentation) |   | input_files, varargin | self |  |
| [getType](#gettype) | Access = private | self, input_file |  |  |
| [getPaths](#getpaths) | Access = private | self, input_files, output_dir |  |  |


[*Default Method Attributs*](https://www.mathworks.com/help/matlab/matlab_oop/method-attributes.html)

 ***

## Detailed Description



 ***

## Method Descriptions

### GenerateDocumentation

```matlab
function [self] = GenerateDocumentation(input_files, varargin)
```

### getType

```matlab
function [] = getType(self, input_file)
```

### getPaths

```matlab
function [] = getPaths(self, input_files, output_dir)
```




***

*Generated on 04-Mar-2021 00:17:21 by [m2docs](https://github.com/crgnam-research/m2docs) © 2021*
