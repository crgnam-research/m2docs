% NAME>{Generate Documentation}
%
% BRIEF>{Script to call m2md and generate markdown documentation}
%
% DESCRIPTION>{
% A more detailed description can go here. 
%}
clear; matlabrc; clc; close all;

% First test:
output1 = m2md({'m2md.m','defaultTemplate.m','generateDocs.m'},'docs','Template',@defaultTemplate,...
                'MakeMainIndex',true,'MainIndexName','docs.md','MakeSubIndices',true,'SubIndexName','DIRNAME',...
                'MainIndexTemplate',@defaultIndexTemplate,'SubIndexTemplate',@defaultIndexTemplate);