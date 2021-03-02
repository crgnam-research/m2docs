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
    body = sprintf('## Contents of %s/\n\n',rel_path);
    
    % Create the body of the markdown file:
    if isempty(mdfiles) && isempty(subdirs)
        body = sprintf([body,'*Directory is Empty*']);
    else
        if ~isempty(mdfiles)
            for ii = 1:length(mdfiles)
                if strcmp(mdfiles(ii).name,'index.md')
                    body = sprintf([body,'- [%s](%s) (Home Page)\n'],mdfiles(ii).name,mdfiles(ii).name);
                else
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

