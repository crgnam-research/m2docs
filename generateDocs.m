% NAME>{Generate Documentation}
%
% BRIEF>{Script to call m2md and generate markdown documentation}
%
% DESCRIPTION>{
% A more detailed description can go here. 
%}
clear; matlabrc; clc; close all;
addpath(genpath('src'))

% First test:
output1 = m2md({'src/'},'docs','Template',@defaultTemplate,...
                'MakeIndex',true,'IndexTemplate',@defaultIndexTemplate);