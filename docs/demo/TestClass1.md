[Home](../index.md) > [docs](../docs_index.md) > [demo](demo_index.md)  


# classdef: TestClass1

**SuperClasses:** handle

class brief description

 ***

## Class Attributes

| Attribute         | Status   | 
| ----------------- | -------- | 
| Abstract | false | 
| ConstructOnLoad | false | 
| HandleCompatible | true | 
| Hidden | false | 
| Sealed | true | 


[*Default Class Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/class-attributes.html)

 ***

## Properties

| Property | Attributes  | Type | Default Value | Description |
| -------- | ----------- | ---- | ------------- | ----------- |
| prop1 |   |  |  | description of prop1 |
| prop2 |   |  |  | description of prop2 |
| prop3 |   | double |  | description of prop3 |
| prop4 |   | double |  | description of prop4 |
| prop5 |   | double | 0000000000000000000000000000 | description of prop5 |
| prop6 |   | double | 3 |  |
| prop7 |   | double | 8 | description of prop7 |
| prop8 |   |  | string | description of prop8 |
| prop9 | AbortSet = true | double |  |  |
| prop10 | GetAccess = private, SetAccess = private |  |  |  |
| prop11 | Constant = true, GetAccess = private, NonCopyable = true, SetAccess = none | int32 | 32 | description of prop11 |
| prop12 | Constant = true, GetAccess = private, NonCopyable = true, SetAccess = none | char | prop11 values | description of prop12 |

[*Default Property Attributes*](https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html)

 ***

## Methods

| Method | Attributes | Inputs | Outputs | Brief Description |
| ------ | ---------- | ------ | ------- | ----------------- |
| [TestClass1](#testclass1) |   | inputArg1, inputArg2 | self | Brief description |
| [method1](#method1) | Access = private | self, inputArg |  |  |
| [method4](#method4) | Static = true | inputArg, varargin | val | Brief description 4 |
| [method3](#method3) | Static = true | inputArg | val |  |


[*Default Method Attributs*](https://www.mathworks.com/help/matlab/matlab_oop/method-attributes.html)

 ***

## Detailed Description

Class detailed description goes here

 ***

## Method Descriptions

 ### TestClass1

```matlab
function [self] = TestClass1(inputArg1, inputArg2)
```
Detailed description goes here.  And we can even use
markdown syntax!  I'm not going to do that though, because this
is just a test...
 ### method1

```matlab
function [] = method1(self, inputArg)
```

 ### method4

```matlab
function [val] = method4(inputArg, varargin)
```
Detailed description goes here.  And we can even use
markdown syntax!  I'm not going to do that though, because this
is just a test... 4
 ### method3

```matlab
function [val] = method3(inputArg)
```



 
 *** 

# Source Code:

 ```matlab 
 classdef (Sealed = true) TestClass1 < handle
    %@brief{class brief description}
    %@detailed{Class detailed description goes here}
    %@code{true}
    properties 
        prop1 % description of prop1
        prop2 (3,1) % description of prop2
        prop3 (3,1,3) double % description of prop3
        prop4 (1,1) double {mustBeReal, mustBeFinite} % description of prop4
        prop5 (7,2,2) double {mustBeReal} = 0; % description of prop5
        prop6 double = 3;
        prop7 double = 8; % description of prop7
        prop8 = 'string'; % description of prop8
    end
    
    properties (AbortSet = true)
        prop9 (2,1) double
    end
    
    properties (Access = private)
        prop10
    end
    
    properties (Access = private, Constant = true)
        prop11 int32 = 32; % description of prop11
        prop12 char = 'prop11 values'; % description of prop12
    end
    
    methods (Access = public)
        function [self] = TestClass1(inputArg1,inputArg2)
            %@brief{Brief description}
            %@detailed{Detailed description goes here.  And we can even use
            % markdown syntax!  I'm not going to do that though, because this
            % is just a test...}
            self.property1 = inputArg1 + inputArg2;
        end
    end
    
    methods (Access = private)
        function [] = method1(self,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            self.property2 = self.property1 + inputArg;
        end
    end
    
    methods (Static)
        function [val] = method3(inputArg)
            val = inputArg^2;
        end
        
        function [val] = method4(inputArg,varargin)
            %@brief{Brief description 4}
            %@detailed{Detailed description goes here.  And we can even use
            % markdown syntax!  I'm not going to do that though, because this
            % is just a test... 4}
            p = inputParser;
            addRequired('inputArg');
            val = inputArg^2;
        end
    end
end 
``` 
 
***

*Generated on 03-Mar-2021 00:05:55 by [m2docs](https://github.com/crgnam-research/m2docs) © 2021*
