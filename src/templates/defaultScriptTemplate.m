function [] = defaultScriptTemplate(data,out_abs,out_rel)
    %@brief{}
    %@detailed{}
   
    out_abs = sprintf('%s.md',out_abs);
    out_rel = sprintf('%s.md',out_rel);
    [~,file_name] = fileparts(out_rel);

    % Format each of the major sections:
    sub_function_table = createSubFunctionTable(data.Name,data.InputNames,...
                                                data.OutputNames,data.BriefDescription);
    sub_function_descr = createSubFunctionDescriptions(data.Name,data.InputNames,...
                                                       data.OutputNames,data.Description);

    % Format the final markdown:
    markdown = sprintf(['# script: %s\n\n',...
                        '%s\n\n',...
                        '## Sub-Functions\n\n',...
                        '%s\n\n ***\n\n',...
                        '## Detailed Description\n\n',...
                        '%s\n\n ***\n\n',...
                        '## Sub-Function Descriptions\n\n',...
                        '%s\n\n'],...
                        file_name,...
                        data.scriptBriefDescription,...
                        sub_function_table,...
                        data.scriptDescription,...
                        sub_function_descr);
            
                    
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


function [sub_function_table] = createSubFunctionTable(names,input_names,output_names,brief_description)
    if isempty(names)
        sub_function_table = '*No Sub-Functions*';
    else
        sub_function_table = sprintf('%s\n\n%s\n%s\n','<div class="table-wrapper" markdown="block">',...
                                     '| Function | Inputs | Outputs | Brief Description |',...
                                     '| -------- | ------ | ------- | ----------------- |');
        for ii = 1:length(names)
            name = sprintf('[%s](#%s)',names{ii},lower(names{ii}));
            inputs = sprintf([repmat('%s, ',1,length(input_names{ii})-1),'%s'],input_names{ii}{:});
            outputs = sprintf([repmat('%s, ',1,length(output_names{ii})-1),'%s'],output_names{ii}{:});
            sub_function_table = sprintf([sub_function_table,'| %s | %s | %s | %s |\n'],...
                                      name,inputs,outputs,brief_description{ii});
        end
        
        sub_function_table = sprintf('%s\n\n%s\n',sub_function_table,'</div>');
    end
end

function [sub_function_descr] = createSubFunctionDescriptions(name,input_names,...
                                                              output_names,description)
 
    if isempty(name)
        sub_function_descr = '*No Sub-Functions*';
    else
        sub_function_descr = '';
        for ii = 1:length(name)
            inputs = sprintf([repmat('%s, ',1,length(input_names{ii})-1),'%s'],input_names{ii}{:});
            outputs = sprintf([repmat('%s, ',1,length(output_names{ii})-1),'%s'],output_names{ii}{:});
            sub_function_descr = sprintf('%s### %s\n\n```matlab\nfunction [%s] = %s(%s)\n```\n\n %s\n',...
                                        sub_function_descr,...
                                        name{ii},...
                                        outputs,name{ii},inputs,...
                                        description{ii});
        end
    end
end