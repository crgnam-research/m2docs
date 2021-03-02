% NAME>{Default Footer}
%
% BRIEF>{Defines the footer text for each markdown file}
function [footer] = defaultFooter()
    footer = sprintf('***\n\n*Generated on %s by [m2md](https://github.com/crgnam-research/m2md) © 2021*',datetime);
end