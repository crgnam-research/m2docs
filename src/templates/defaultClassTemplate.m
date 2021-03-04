function [] = defaultClassTemplate(data,out_abs,out_rel)
    %@brief{}
    %@detailed{}
   
    out_abs = sprintf('%s.md',out_abs);
    out_rel = sprintf('%s.md',out_rel);

    % Format each of the major sections:
    class_table    = createClassAttributeTtable(data.Attributes);
    property_table = createPropertyTable(data.PropertyList);
    method_table   = createMethodTable(data.MethodList);
    method_descriptions = createMethodDescriptions(data.MethodList);
    
    % Create the supeclasses list:
    if isempty(data.SuperclassList)
        superclasses = '';
    else
        superclasses = data.SuperclassList{1};
        for ii = 2:length(data.SuperclassList)
            superclasses = sprintf('%s, %s',superclasses,data.SuperclassList{ii});
        end
    end

    % Format the final markdown:
    markdown = sprintf(['# classdef: %s\n\n',...
                        '**SuperClasses:** %s\n\n',...
                        '%s\n\n ***\n\n',...
                        '## Class Attributes\n\n',...
                        '%s\n\n ***\n\n',...
                        '## Properties\n\n',...
                        '%s\n\n ***\n\n',...
                        '## Methods\n\n',...
                        '%s\n\n ***\n\n',...
                        '## Detailed Description\n\n',...
                        '%s\n\n ***\n\n',...
                        '## Method Descriptions\n\n',...
                        '%s\n\n'],...
                        data.Name,...
                        superclasses,...
                        data.BriefDescription,...
                        class_table,...
                        property_table,...
                        method_table,...
                        data.Description,...
                        method_descriptions);
                    
    % Add in header and footer:
    rel_path = fileparts(out_rel);
    header = defaultHeader(rel_path);
    footer = defaultFooter();
    
    % Get the code if asked for:
    if data.Include
        code = sprintf('```matlab \n %s \n```',data.code);
        markdown = sprintf('%s \n *** \n\n# Source Code:\n\n %s \n ',markdown,code);
    end
    
    % Format the final output markdown:
    markdown = sprintf('%s\n%s\n%s\n',header,markdown,footer);
    
    % Save the markdown file:
    output_path = fileparts(out_abs);
    if ~exist(output_path, 'dir')
       mkdir(output_path)
    end
    fid = fopen(out_abs,'w');
    fprintf(fid,'%s',markdown);
    fclose(fid);
end


%% Subformating Functions
function [class_table] = createClassAttributeTtable(attributes)
    fn = fieldnames(attributes);
    class_attributes_diff = struct;
    for ii = 1:length(fn)
        if ~strcmp(attributes.(fn{ii}).set,attributes.(fn{ii}).default)
            if attributes.(fn{ii}).set
                set = 'true';
            else
                set = 'false';
            end
            class_attributes_diff.(fn{ii}) = set;
        end
    end
    
    % Format the table or return basic message:
    fn = fieldnames(class_attributes_diff);
    if isempty(fn)
        class_table = 'default';
    else
        class_table = sprintf(['| Attribute         | Status   | \n',...
                               '| ----------------- | -------- | \n']);
        for ii = 1:length(fn)
            class_table = sprintf([class_table,...
                                   '| %s | %s | \n'],...
                                   fn{ii},class_attributes_diff.(fn{ii}));
        end
    end
    
    % Add link:
    matlab_ca_link = ['[*Default Class Attributes*]',...
                      '(https://www.mathworks.com/help/matlab/matlab_oop/class-attributes.html)'];
    class_table = [class_table,newline,newline,matlab_ca_link];
end

function [property_table] = createPropertyTable(PropertyList)
    % NAME>{Create P Table}
    % BRIEF>{Creates a table of the class properties}
    if ~isfield(PropertyList(1).Attributes.AbortSet,'set')
        property_table = '*No Properties*';
    else       
        % Setup the table:
        property_table = sprintf(['| Property | Attributes  | Type | Default Value | Description |\n',...
                                  '| -------- | ----------- | ---- | ------------- | ----------- |\n']);
        for ii = 1:length(PropertyList)     
            % Calculate any non-default attributes:
            fn = fieldnames(PropertyList(ii).Attributes);
            count = 1;
            attributes_diff = ' ';
            for jj = 1:length(fn)
                if ~strcmp(fn{jj},'Access')
                    if ischar(PropertyList(ii).Attributes.(fn{jj}).set)
                        if ~strcmp(PropertyList(ii).Attributes.(fn{jj}).set,PropertyList(1).Attributes.(fn{jj}).default)
                            set = sprintf('%s = %s',fn{jj},PropertyList(ii).Attributes.(fn{jj}).set);
                            if count == 1
                                attributes_diff = set;
                            else
                                attributes_diff = sprintf('%s, %s',attributes_diff,set);
                            end
                            count = count+1;
                        end
                    else
                        if PropertyList(ii).Attributes.(fn{jj}).set ~= PropertyList(1).Attributes.(fn{jj}).default
                            if PropertyList(ii).Attributes.(fn{jj}).set
                                set = sprintf('%s = true',fn{jj});
                            else
                                set = sprintf('%s = false',fn{jj});
                            end
                            if count == 1
                                attributes_diff = set;
                            else
                                attributes_diff = sprintf('%s, %s',attributes_diff,set);
                            end
                            count = count+1;
                        end
                    end
                end
            end
            
            % Store values into table:
            property_table = sprintf([property_table,...
                                      '| %s | %s | %s | %s | %s |\n'],...
                                      PropertyList(ii).Name,attributes_diff,...
                                      PropertyList(ii).Type,...
                                      char(string(PropertyList(ii).DefaultValue)),...
                                      PropertyList(ii).Description);
        end
    end
    
    matlab_pa_link = ['[*Default Property Attributes*]',...
                      '(https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html)'];
    property_table = [property_table,newline,matlab_pa_link];
end

function [methods_table] = createMethodTable(MethodList)
    % NAME>{Create M Table}
    % BRIEF>{Creates a table of the class methods}
    if isempty(MethodList)
        methods_table = '*No Methods*';
    else
        methods_table = ['| Method | Attributes | Inputs | Outputs | Brief Description |\n',...
                         '| ------ | ---------- | ------ | ------- | ----------------- |\n'];
        for ii = 1:length(MethodList)
            fn = fieldnames(MethodList(ii).Attributes);
            count = 1;
            attributes_diff = ' ';
            for jj = 1:length(fn)
                if ischar(MethodList(ii).Attributes.(fn{jj}).set)
                    if ~strcmp(MethodList(ii).Attributes.(fn{jj}).set,MethodList(1).Attributes.(fn{jj}).default)
                        set = sprintf('%s = %s',fn{jj},MethodList(ii).Attributes.(fn{jj}).set);
                        if count == 1
                            attributes_diff = set;
                        else
                            attributes_diff = sprintf('%s, %s',attributes_diff,set);
                        end
                        count = count+1;
                    end
                else
                    if MethodList(ii).Attributes.(fn{jj}).set ~= MethodList(1).Attributes.(fn{jj}).default
                        if MethodList(ii).Attributes.(fn{jj}).set
                            set = sprintf('%s = true',fn{jj});
                        else
                            set = sprintf('%s = false',fn{jj});
                        end
                        if count == 1
                            attributes_diff = set;
                        else
                            attributes_diff = sprintf('%s, %s',attributes_diff,set);
                        end
                        count = count+1;
                    end
                end
            end

            % Construct the table insert:
            name = sprintf('[%s](#%s)',MethodList(ii).Name,lower(MethodList(ii).Name));
            inputs = sprintf([repmat('%s, ',1,length(MethodList(ii).InputNames)-1),'%s'],MethodList(ii).InputNames{:});
            outputs = sprintf([repmat('%s, ',1,length(MethodList(ii).OutputNames)-1),'%s'],MethodList(ii).OutputNames{:});
            methods_table = sprintf([methods_table,'| %s | %s | %s | %s | %s |\n'],...
                                     name,attributes_diff,inputs,outputs,MethodList(ii).BriefDescription);
        end
    end
    
    matlab_ma_link = ['[*Default Method Attributs*]',...
                      '(https://www.mathworks.com/help/matlab/matlab_oop/method-attributes.html)'];
    methods_table = [methods_table,newline,newline,matlab_ma_link];
end

function [method_descriptions] = createMethodDescriptions(MethodList)
    % NAME>{Create M Description}
    % BRIEF>{Formats each method's description}
    if isempty(MethodList)
        method_descriptions = '*No Methods*';
    else
        method_descriptions = '';
        for ii = 1:length(MethodList)
            inputs = sprintf([repmat('%s, ',1,length(MethodList(ii).InputNames)-1),'%s'],MethodList(ii).InputNames{:});
            outputs = sprintf([repmat('%s, ',1,length(MethodList(ii).OutputNames)-1),'%s'],MethodList(ii).OutputNames{:});
            method_descriptions = sprintf('%s ### %s\n\n```matlab\nfunction [%s] = %s(%s)\n```\n%s\n',...
                                           method_descriptions,...
                                           MethodList(ii).Name,...
                                           outputs,MethodList(ii).Name,inputs,...
                                           MethodList(ii).Description);
        end
    end
end