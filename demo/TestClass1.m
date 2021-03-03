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

