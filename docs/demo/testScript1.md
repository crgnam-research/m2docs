[Home](../index.md) > [docs](../docs_index.md) > [demo](demo_index.md)  


# script: testScript1

a brief description

## Sub-Functions

| Function | Inputs | Outputs | Brief Description |
| -------- | ------ | ------- | ----------------- |
| [multiply](#multiply) | a, b | val |  |
| [myFunc2](#myfunc2) |  | a | a brief description for myFunc2 |


 ***

## Detailed Description



 ***

## Sub-Function Descriptions

### multiply

```matlab
function [val] = multiply(a, b)
```

 
### myFunc2

```matlab
function [a] = myFunc2()
```

 


 
 *** 

# Source Code:

 ```matlab 
 %@brief{a brief description}
%@code{true}
clear; matlabrc; clc; close all;
a = eye(3);
b = randn(5);
c = multiply(a,b);

function [val] = multiply(a,b)
    val = 0;
    for ii = 1:numel(a)
        for jj = 1:numel(b)
            val = val + a(ii)*b(jj);
        end
    end
end

function [a] = myFunc2()
%@brief{a brief description for myFunc2}
    a = 0;
end 
``` 
 
***

*Generated on 04-Mar-2021 00:17:21 by [m2docs](https://github.com/crgnam-research/m2docs) © 2021*
