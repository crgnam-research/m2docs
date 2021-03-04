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