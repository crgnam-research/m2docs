[Home](../../index.md) > [docs](../../docs_index.md) > [src](../src_index.md) > [types](types_index.md)  


# classdef: ClassType

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
| Name | SetAccess = private | char |  |  |
| BriefDescription | SetAccess = private | char |  |  |
| Description | SetAccess = private | char |  |  |
| Attributes | SetAccess = private | struct |  | class attributes |
| SuperclassList | SetAccess = private | cell |  | Superclass list |
| PropertyList | SetAccess = private | struct |  | property list |
| MethodList | SetAccess = private | struct |  | method list |
| Include | SetAccess = private | logical |  | if true, include the source code in the output |
| code | SetAccess = private | char |  | the source code |

[*Default Property Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html)

 ***

## Methods

| Method | Attributes | Inputs | Outputs | Brief Description |
| ------ | ---------- | ------ | ------- | ----------------- |
| [ClassType](#classtype) |   |  | self |  |
| [func_declaration_nospace](#func_declaration_nospace) | Static = true | method_list | temp |  |
| [parse](#parse) | Static = true | file_name | self |  |


[*Default Method Attributs*](https://www.mathworks.com/help/matlab/matlab_oop/method-attributes.html)

 ***

## Detailed Description



 ***

## Method Descriptions

### ClassType

```matlab
function [self] = ClassType()
```

### func_declaration_nospace

```matlab
function [temp] = func_declaration_nospace(method_list)
```

### parse

```matlab
function [self] = parse(file_name)
```




***

*Generated on 04-Mar-2021 00:17:21 by [m2docs](https://github.com/crgnam-research/m2docs) © 2021*
