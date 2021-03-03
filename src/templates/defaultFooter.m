% NAME>{Default Footer}
%
% BRIEF>{Defines the footer text for each markdown file}
function [footer] = defaultFooter()
    footer = sprintf('***\n\n*Generated on %s by [m2docs](https://github.com/crgnam-research/m2docs) © 2021*',datetime);
end