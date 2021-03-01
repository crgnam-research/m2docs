function [] = defaultTemplate(data)

    switch data.TYPE
        case 'CLASS'
            % Format each of the major sections:
            CLASS_ATTR   = createCAtable(data.CLASS_ATTR);
            PROPERTIES   = createPtable(data.PROPERTIES);
            CONSTRUCTOR = createCtable(data.CONSTRUCTOR);
            METHOD_TABLE  = createMtable(data.METHODS);
            CONSTRUCTOR_DESCR = createCdescr(data.CONSTRUCTOR);
            METHOD_DESCR = createMdescr(data.METHODS);

            % Format the final markdown:
            markdown = sprintf(['# classdef: %s\n\n',...
                                '**SuperClass:** %s\n\n',...
                                '**%s**: %s\n\n ***\n\n',...
                                '## Class Attributes\n\n',...
                                '%s\n\n ***\n\n',...
                                '## Properties\n\n',...
                                '%s\n\n ***\n\n',...
                                '## Constructor\n\n',...
                                '%s\n\n ***\n\n',...
                                '## Methods\n\n',...
                                '%s\n\n ***\n\n',...
                                '## Detailed Description\n\n',...
                                '%s\n\n ***\n\n',...
                                '## Constructor Description\n\n',...
                                '%s\n\n ***\n\n',...
                                '## Method Descriptions\n\n',...
                                '%s'],...
                                data.FILENAME,...
                                data.SUPERCLASS,...
                                data.NAME, data.BRIEF,...
                                CLASS_ATTR,...
                                PROPERTIES,...
                                CONSTRUCTOR,...
                                METHOD_TABLE,...
                                data.DESCRIPTION,...
                                CONSTRUCTOR_DESCR,...
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
        CLASS_ATTR_FORMAT = 'default';
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

function [CONSTRUCTOR_FORMAT] = createCtable(CONSTRUCTOR)
    if isempty(CONSTRUCTOR)
        CONSTRUCTOR_FORMAT = '*No Constructor*';
    else
        fn = fieldnames(CONSTRUCTOR.ATTRIBUTES);
        CONSTR_ATTR_DIFF = struct;
        for jj = 1:length(fn)
            if ~strcmp(CONSTRUCTOR.ATTRIBUTES.(fn{jj}).SET,CONSTRUCTOR.ATTRIBUTES.(fn{jj}).DEFAULT)
                CONSTR_ATTR_DIFF.(fn{jj}) = CONSTRUCTOR.ATTRIBUTES.(fn{jj}).SET;
            end
        end
        fn = fieldnames(CONSTR_ATTR_DIFF);
        if isempty(fn)
            attr = 'default';
        else
            attr = '(';
            for jj = 1:length(fn)
                if jj == length(fn)
                    attr = [attr, sprintf('%s = *%s*',fn{jj},CONSTR_ATTR_DIFF.(fn{jj}))];
                else
                    attr = [attr, sprintf('%s = *%s*,',fn{jj},CONSTR_ATTR_DIFF.(fn{jj}))];
                end
            end
            attr = [attr,')'];
        end
        name = sprintf('[%s](###%s)',CONSTRUCTOR.FUNCTION,CONSTRUCTOR.FUNCTION);
        inputs = sprintf([repmat('%s, ',1,length(CONSTRUCTOR.INPUTS)-1),'%s'],CONSTRUCTOR.INPUTS{:});
        outputs = sprintf([repmat('%s, ',1,length(CONSTRUCTOR.OUTPUTS)-1),'%s'],CONSTRUCTOR.OUTPUTS{:});
        CONSTRUCTOR_FORMAT = sprintf(['| Constructor | Attributes | Inputs | Outputs | Brief Description |\n',...
                                      '| ----------- | ---------- | ------ | ------- | ----------------- |\n',...
                                      '| %s | %s | %s | %s | %s |\n'],...
                                      name,attr,inputs,outputs,CONSTRUCTOR.BRIEF);
        
    end
end

function [METHODS_FORMAT] = createMtable(METHODS)
    if isempty(METHODS)
        METHODS_FORMAT = '*No Methods*';
    else
        METHODS_FORMAT = ['| Method | Attributes | Inputs | Outputs | Brief Description |\n',...
                          '| ------ | ---------- | ------ | ------- | ----------------- |\n'];
        for ii = 1:length(METHODS)
            fn = fieldnames(METHODS{ii}.ATTRIBUTES);
            METHOD_ATTR_DIFF = struct;
            for jj = 1:length(fn)
                if ~strcmp(METHODS{ii}.ATTRIBUTES.(fn{jj}).SET,METHODS{ii}.ATTRIBUTES.(fn{jj}).DEFAULT)
                    METHOD_ATTR_DIFF.(fn{jj}) = METHODS{ii}.ATTRIBUTES.(fn{jj}).SET;
                end
            end
            fn = fieldnames(METHOD_ATTR_DIFF);
            if isempty(fn)
                attr = 'default';
            else
                attr = '(';
                for jj = 1:length(fn)
                    if jj == length(fn)
                        attr = [attr, sprintf('%s = *%s*',fn{jj},METHOD_ATTR_DIFF.(fn{jj}))];
                    else
                        attr = [attr, sprintf('%s = *%s*,',fn{jj},METHOD_ATTR_DIFF.(fn{jj}))];
                    end
                end
                attr = [attr,')'];
            end
            name = sprintf('[%s](###%s)',METHODS{ii}.FUNCTION,METHODS{ii}.FUNCTION);
            inputs = sprintf([repmat('%s, ',1,length(METHODS{ii}.INPUTS)-1),'%s'],METHODS{ii}.INPUTS{:});
            outputs = sprintf([repmat('%s, ',1,length(METHODS{ii}.OUTPUTS)-1),'%s'],METHODS{ii}.OUTPUTS{:});
            METHODS_FORMAT = sprintf([METHODS_FORMAT,'| %s | %s | %s | %s | %s |\n'],...
                                      name,attr,inputs,outputs,METHODS{ii}.BRIEF);
        end
    end
    
    matlab_ma_link = ['[*Default Method Attributs*]',...
                      '(https://www.mathworks.com/help/matlab/matlab_oop/method-attributes.html)'];
    METHODS_FORMAT = [METHODS_FORMAT,newline,newline,matlab_ma_link];
end

function [CONSTRUCTOR_DESCR] = createCdescr(CONSTRUCTOR)
    if isempty(CONSTRUCTOR)
        CONSTRUCTOR_DESCR = '*No Methods*';
    else
        CONSTRUCTOR_DESCR = '';
        inputs = sprintf([repmat('%s, ',1,length(CONSTRUCTOR.INPUTS)-1),'%s'],CONSTRUCTOR.INPUTS{:});
        outputs = sprintf([repmat('%s, ',1,length(CONSTRUCTOR.OUTPUTS)-1),'%s'],CONSTRUCTOR.OUTPUTS{:});
        CONSTRUCTOR_DESCR = sprintf([CONSTRUCTOR_DESCR,...
                                    '### %s\n\n',...
                                    '**[%s] = %s(%s)**\n\n',...
                                    'DESCRIPTION: %s'],...
                                    CONSTRUCTOR.FUNCTION,...
                                    outputs,CONSTRUCTOR.FUNCTION,inputs,...
                                    CONSTRUCTOR.DESCRIPTION);
    end
end

function [METHODS_DESCR] = createMdescr(METHODS)
    if isempty(METHODS)
        METHODS_DESCR = '*No Methods*';
    else
        METHODS_DESCR = '';
        for ii = 1:length(METHODS)
            inputs = sprintf([repmat('%s, ',1,length(METHODS{ii}.INPUTS)-1),'%s'],METHODS{ii}.INPUTS{:});
            outputs = sprintf([repmat('%s, ',1,length(METHODS{ii}.OUTPUTS)-1),'%s'],METHODS{ii}.OUTPUTS{:});
            METHODS_DESCR = sprintf([METHODS_DESCR,...
                                    '### %s\n\n',...
                                    '**[%s] = %s(%s)**\n\n',...
                                    'DESCRIPTION: %s\n'],...
                                    METHODS{ii}.FUNCTION,...
                                    outputs,METHODS{ii}.FUNCTION,inputs,...
                                    METHODS{ii}.DESCRIPTION);
        end
    end
end