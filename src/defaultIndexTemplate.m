% NAME>{Default Template}
%
% BRIEF>{Template for use with m2md}
%
% DESCRIPTION>{
% A more detailed description can go here two.
%}
function [] = defaultIndexTemplate(rel_path,name)
    % Get a list of everything in the directoy we care about:
    rel_path = strrep(rel_path,'\','/');
    subdirs = dir([rel_path,'/*']);
    subdirs = subdirs([subdirs.isdir]);
    subdirs = subdirs(~ismember({subdirs.name},{'.','..'}));
    mdfiles = dir([rel_path,'/*.md']);
    
    % Create the header and footer:
    header = defaultHeader(rel_path);
    footer = defaultFooter();
    
    % Create the title:
    rel_path_split = strsplit(rel_path,'/');
    L = length(rel_path_split);
    if L <= 2
        body = sprintf('## Contents of %s/\n\n',rel_path);
    elseif L == 3
        body = sprintf('## %s Module\n\n',uppperFirst(rel_path_split{3}));
    elseif L > 3
        body = sprintf('## %s Sub-Module (Part of the %s Module)\n\n',uppperFirst(rel_path_split{end}),uppperFirst(rel_path_split{3}));
    end
    
    
    % Create the body of the markdown file:
    if isempty(mdfiles) && isempty(subdirs)
        body = sprintf([body,'*Directory is Empty*']);
    else
        if ~isempty(mdfiles)
            for ii = 1:length(mdfiles)
                if ~contains(mdfiles(ii).name,'index.md')
                    body = sprintf([body,'- [%s](%s)\n'],mdfiles(ii).name,mdfiles(ii).name);
                end
            end
        end
        
        if ~isempty(subdirs)
            for ii = 1:length(subdirs)
                body = sprintf([body,'- [%s/](%s)\n'],subdirs(ii).name,[subdirs(ii).name,'/',subdirs(ii).name,'_index.md']);
            end
        end
    end
    
    % Format the markdown:
    markdown = sprintf([header,body,'\n',footer]);
    
    % Save the markdown file:
    path = [rel_path,'/',name,'_index.md'];
    fid = fopen(path,'w');
    fprintf(fid,'%s',markdown);
    fclose(fid);
end

function [string] = uppperFirst(string)
    string = [upper(string(1)),string(2:end)];
end

