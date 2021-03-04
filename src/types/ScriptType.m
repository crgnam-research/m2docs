classdef ScriptType
    %FUNCTIONTYPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name cell
        InputNames cell
        OutputNames cell
        BriefDescription cell
        Description cell
        Include logical
        code char
    end
    
    methods
        function [self] = ScriptType()

        end
    end
    
    methods (Static)
        function [self] = parse(file_name)
            % Create an instance of this type:
            self = ScriptType();
            
            % Begin scanning line by line:
            fid = fopen(file_name);
            tline = fgetl(fid);
            ii = 1;
            while ischar(tline)                
                % Get the function declaration:
                [self.InputNames{ii},self.OutputNames{ii},self.Name{ii},fid] = self.getFuncDeclare(fid,tline);
                
                % Get the function comments:
                tline = fgetl(fid);
                if ~ischar(tline)
                    self.InputNames = self.InputNames(1:end-1);
                    self.OutputNames = self.OutputNames(1:end-1);
                    self.Name = self.Name(1:end-1);
                    break
                end
                [self.BriefDescription{ii},self.Description{ii},fid,tline] = self.getFuncComments(fid,tline);
                
                ii = ii+1;
            end
            fclose(fid);
            
            % Read the source code:
            self.code = strtrim(fileread(file_name));
            include = strtrim(extractBetween(self.code,'@code{','}'));
            if isempty(include)
                include = false;
            else
                if strcmp(include,'true')
                    include = true;
                end
            end
            self.Include = include;
        end
        
        function [input_names,output_names,name,fid] = getFuncDeclare(fid,tline)
            func_declare = '';
            in_func_declare = false;
            while ischar(tline)
                tline = strtrim(tline);
                if length(tline) >= 8
                    if strcmp(tline(1:8),'function')
                        if strcmp(tline(9),' ')
                            in_func_declare = true;
                        end
                    end
                end
                
                if in_func_declare
                    idx = strfind(tline,'%');
                    if ~isempty(idx)
                        temp = tline(1:idx-1);
                    else
                        temp = tline;
                    end
                    if contains(temp,'...')
                        func_declare = sprintf('%s%s',func_declare,temp);
                        tline = fgetl(fid);
                        continue
                    else
                        func_declare = sprintf('%s%s',func_declare,temp);
                        in_func_declare = false;
                    end
                end
                
                if ~in_func_declare && ~isempty(func_declare)
                    break
                end
                tline = fgetl(fid);
            end
            
            % Parse the function declaration:
            func_declare = erase(func_declare,'...');
            
            % Get the function name:
            if contains(func_declare,'=')
                if contains(func_declare,'(')
                    name = extractBetween(func_declare,'=','(');
                    name = strtrim(name{1});
                else
                    idx = strfind(func_declare,'=');
                    name = strtrim(func_declare(idx+1:end));
                end
            else
                if contains(func_declare,'(')
                    name = extractBetween(func_declare,'function','(');
                    name = strtrim(name{1});
                else
                    name = strtrim(func_declare(9:end));
                end
            end
            
            % Get the output names:
            if contains(func_declare,'[')
                outputs = extractBetween(func_declare,'[',']');
                outputs = strtrim(outputs{1});
                output_names = strsplit(outputs,{' ',','});
            elseif contains(func_declare,'=')
                outputs = extractBetween(func_declare,'function','=');
                output_names = {strtrim(outputs{1})};
            else
                output_names = {''};
            end
            
            % Get the input names:
            if contains(func_declare,'(')
                inputs = extractBetween(func_declare,'(',')');
                inputs = strtrim(inputs{1});
                input_names = strsplit(inputs,{' ',','});
            else
                input_names = {''};
            end
        end
        
        function [brief_description,description,fid,tline] = getFuncComments(fid,tline)
            tline = strtrim(tline);
            in_comment = false;
            comment = '';
            if ~isempty(tline)
                if strcmp(tline(1),'%')
                    in_comment = true;
                    comment = tline;
                end
            end
            if length(tline)>=2
                if strcmp(tline(1:2),'%{')
                    in_block_comment = true;
                else
                    in_block_comment = false;
                end
            end
            tline = fgetl(fid);
            
            while ischar(tline) && in_comment
                tline = strtrim(tline);
                if ~isempty(tline)
                    if strcmp(tline(1),'%') || in_block_comment
                        comment = sprintf('%s%s',comment,tline);
                    else
                        break
                    end
                    if strcmp(tline(1:2),'%{') && ~in_block_comment
                        in_block_comment = true;
                    elseif in_block_comment && strcmp(tline(1:2),'%}')
                        in_block_comment = false;
                    end
                end
                tline = fgetl(fid);
            end
            
            % Parse the comment:
            brief_description = extractBetween(comment,'@brief{','}');
            if ~isempty(brief_description)
                brief_description = brief_description{1};
            else
                brief_description = '';
            end
            description = extractBetween(comment,'@detailed{','}');
            if ~isempty(description)
                description = description{1};
            else
                description = '';
            end
        end
        
        function [comment,fid] = inBlockComment(fid,tline)
            comment = '';
            while ischar(tline)
                tline = strtrim(tline); 
                if length(tline) >= 2
                    if in_block_comment
                        if strcmp(tline(1:2),'%}')
                            in_block_comment = false;
                            continue
                        end
                    else
                        if strcmp(tline(1:2),'%{')
                            in_block_comment = true;
                            continue
                        end
                    end
                    comment = sprintf('%s\n%s',comment,strtrim(tline));
                end
                tline = fgetl(fid);
            end
            comment = strtrim(comment);
        end
    end
end