[Home](../../index.md) > [docs](../../docs_index.md) > [src](../src_index.md) > [types](types_index.md)  


# classdef: ClassType

**SuperClasses:** handle



 ***

## Class Attributes

<div class="table-wrapper" markdown="block">

| Attribute         | Status   |
| ----------------- | -------- |
| Abstract | false | 
| ConstructOnLoad | false | 
| HandleCompatible | true | 
| Hidden | false | 
| Sealed | false | 


</div>


[*Default Class Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/class-attributes.html)

 ***

## Properties

<div class="table-wrapper" markdown="block">

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


</div>

[*Default Property Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html)

 ***

## Methods

<div class="table-wrapper" markdown="block">

| Method | Attributes | Inputs | Outputs | Brief Description |
| ------ | ---------- | ------ | ------- | ----------------- |
| [ClassType](#classtype) |   |  | self |  |
| [func_declaration_nospace](#func_declaration_nospace) | Static = true | method_list | temp |  |
| [parse](#parse) | Static = true | file_name | self |  |


</div>


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

*Generated on 04-Mar-2021 12:30:25 by [m2docs](https://github.com/crgnam-research/m2docs) © 2021*
