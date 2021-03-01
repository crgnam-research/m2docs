function [] = defaultTemplate(data)

    switch data.TYPE
        case 'CLASS'
            % Format each of the major sections:
            CLASS_ATTR   = createCAtable(data.CLASS_ATTR);
            PROPERTIES   = createPtable(data.PROPERTIES);
%             METHOD_LIST  = createMtable(data.METHODS);
%             METHOD_DESCR = createMdescr(data.METHODS);
            METHOD_LIST = '';
            METHOD_DESCR = '';

            % Format the final markdown:
            markdown = sprintf(['# classdef: %s\n\n',...
                                '**SuperClass:** %s\n\n',...
                                '**%s**: %s\n\n ***\n\n',...
                                '## Class Attributes\n\n',...
                                '%s\n\n ***\n\n',...
                                '## Properties\n\n',...
                                '%s\n\n ***\n\n',...
                                '## Methods\n\n',...
                                '%s\n\n ***\n\n',...
                                '## Detailed Description\n\n',...
                                '%s\n\n ***\n\n',...
                                '## Constructor\n\n',...
                                '%s\n\n ***\n\n',...
                                '# Method Descriptions\n\n',...
                                '%s'],...
                                data.FILENAME,...
                                data.SUPERCLASS,...
                                data.NAME, data.BRIEF,...
                                CLASS_ATTR,...
                                PROPERTIES,...
                                METHOD_LIST,...
                                data.DESCRIPTION,...
                                data.CONSTRUCTOR,...
                                METHOD_DESCR);
        case 'FUNCTION'
            markdown = '';
        case 'SCRIPT'
            markdown = '';
    end
                            
    % Save the markdown file:
    full_path = fullfile(data.OutputMDdir_full,data.OutputMD_name);
    output_path = fileparts(full_path);
    if ~exist(output_path, 'dir')
       mkdir(output_path)
    end
    fid = fopen(full_path,'w');
    fprintf(fid,'%s',markdown);
    fclose(fid);
end

%% Subformating Functions
function [CLASS_ATTR_FORMAT] = createCAtable(CLASS_ATTR)
    % Check if any set values were non-default:
    fn = fieldnames(CLASS_ATTR);
    CLASS_ATTR_DIFF = struct;
    for ii = 1:length(fn)
        if ~strcmp(CLASS_ATTR.(fn{ii}).SET,CLASS_ATTR.(fn{ii}).DEFAULT)
            CLASS_ATTR_DIFF.(fn{ii}) = CLASS_ATTR.(fn{ii}).SET;
        end
    end
    
    % Format the table or return basic message:
    fn = fieldnames(CLASS_ATTR_DIFF);
    if isempty(fn)
        CLASS_ATTR_FORMAT = '*No Non-Default Class Attributes*';
    else
        CLASS_ATTR_FORMAT = sprintf(['| Attribute         | Status   | \n',...
                                     '| ----------------- | -------- | \n']);
        for ii = 1:length(fn)
            CLASS_ATTR_FORMAT = sprintf([CLASS_ATTR_FORMAT,...
                                         '| %s | %s | \n'],...
                                         fn{ii},CLASS_ATTR_DIFF.(fn{ii}));
        end
    end
    
    % Add link:
    matlab_ca_link = ['[*Default Class Attributes*]',...
                      '(https://www.mathworks.com/help/matlab/matlab_oop/class-attributes.html)'];
    CLASS_ATTR_FORMAT = [CLASS_ATTR_FORMAT,newline,newline,matlab_ca_link];
end

function [PROPERTIES_FORMAT] = createPtable(PROPERTIES)
    if isempty(PROPERTIES)
        PROPERTIES_FORMAT = '*No Properties*';
    else       
        % Setup the table:
        PROPERTIES_FORMAT = sprintf(['| Property | Attributes  | Comment |\n',...
                                     '| -------- | ----------- | ------- |\n']);
        for ii = 1:length(PROPERTIES)
            fn = fieldnames(PROPERTIES{ii}{2});
            PROP_ATTR_DIFF = struct;
            for jj = 1:length(fn)
                if ~strcmp(PROPERTIES{ii}{2}.(fn{jj}).SET,PROPERTIES{ii}{2}.(fn{jj}).DEFAULT)
                    PROP_ATTR_DIFF.(fn{jj}) = PROPERTIES{ii}{2}.(fn{jj}).SET;
                end
            end
            fn = fieldnames(PROP_ATTR_DIFF);
            if isempty(fn)
                attr = 'default';
            else
                attr = '(';
                for jj = 1:length(fn)
                    if jj == length(fn)
                        attr = [attr, sprintf('%s = *%s*',fn{jj},PROP_ATTR_DIFF.(fn{jj}))];
                    else
                        attr = [attr, sprintf('%s = *%s*,',fn{jj},PROP_ATTR_DIFF.(fn{jj}))];
                    end
                end
                attr = [attr,')'];
            end
        
            PROPERTIES_FORMAT = sprintf([PROPERTIES_FORMAT,...
                                         '| %s | %s | %s |\n'],...
                                         PROPERTIES{ii}{1},attr,PROPERTIES{ii}{3});
        end
    end
    
    matlab_pa_link = ['[*Default Property Attributes*]',...
                      '(https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html)'];
    PROPERTIES_FORMAT = [PROPERTIES_FORMAT,newline,matlab_pa_link];
end

function [METHOD_LIST] = createMtable(METHODS)
    METHOD_LIST = '*Incomplete*';
end

function [METHOD_DESCR] = createMdescr(METHODS)
    METHOD_DESCR = '*Incomplete*';
end