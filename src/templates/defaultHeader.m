function [header] = defaultHeader(path)
    path = strrep(path,'\','/');
    if strcmp(path(1),'/')
        path = path(2:end);
    end
    path_split = strsplit(path,'/');
    path = '';
    L = length(path_split);
    for ii = 1:L
        path = sprintf([path,'[%s](',repmat('../',1,L-ii),'%s) > '],path_split{ii},[path_split{ii},'_index.md']);
    end
    home_path = [repmat('../',1,L-1),'index.md'];
    path = path(1:end-2);
    header = sprintf(['[Home](%s) > %s \n\n'],home_path,path);
end