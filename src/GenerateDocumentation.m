classdef GenerateDocumentation < handle 
    properties
        in_rel  cell % Nx1 relative paths to all N input files
        in_abs  cell % Nx1 absolute paths to all N input files
        out_rel cell % Nx1 relative paths to all N output files
        out_abs cell % Nx1 absolute paths to all N output files
        root    char % The root directory this was run from
        
        class_template function_handle % The template used to format outputs for class files
        function_template function_handle % The template used to format outputs for function files
        script_template function_handle % The template used to format outputs for script files
        
        ind (1,1) double % Current itertaion for looping through all files
        
        type cell % Nx1 array containing the types for each of the N input files
        data cell % Nx1 array containing the extracted data from each N input files
        code cell % Nx1 array containing the source code for each of the N input files
    end
    
    methods
        function [self] = GenerateDocumentation(input_files,varargin)
            % Process the inputs:
            p = inputParser;
                validPath = @(x) isa(x,'cell') || isa(x,'char');
                default_out_dir = 'docs/';
                validTemplate = @(x) isa(x,'function_handle');
                addRequired(p,'input_files',validPath);
                addOptional(p,'output_dir',default_out_dir,validPath);
                addParameter(p,'ClassTemplate',@defaultClassTemplate,validTemplate);
                addParameter(p,'FunctionTemplate',@defaultFunctionTemplate,validTemplate);
                addParameter(p,'ScriptTemplate',@defaultScriptTemplate,validTemplate);
            parse(p,input_files,varargin{:});
            
            % Get paths:
            self.class_template = p.Results.ClassTemplate;
            self.function_template = p.Results.FunctionTemplate;
            self.script_template = p.Results.ScriptTemplate;
            self.root = pwd;
            self.getPaths(p.Results.input_files, p.Results.output_dir)
            
            % Pre-allocate:
            self.type = cell(size(self.in_rel));
            self.code = cell(size(self.in_rel));
            self.data = cell(size(self.in_rel));
            
            % Parse each file:
            for ii = 1:length(self.in_abs)
                self.ind = ii;
                msource = fileread(self.in_abs{ii});
                self.code{ii} = strtrim(msource);
                
                % Get the type of the file:
                self.getType(self.in_abs{ii});
                
                % Parse the file:
                switch self.type{ii}
                    case 'class'
                        self.data{ii} = ClassType.parse(self.in_abs{ii});
                    case 'function'
                        self.data{ii} = FunctionType.parse(self.in_abs{ii});
                    case 'script'
                        self.data{ii} = ScriptType.parse(self.in_abs{ii});
                end
            end
            
            % This is kept separate for future versions where
            % cross-references may be computed first, once all of the data
            % for all files has been read in
            for ii = 1:length(self.data)
                % Send data to the proper template file:
                switch self.type{ii}
                    case 'class'
                        self.class_template(self.data{ii},self.out_abs{ii},self.out_rel{ii});
                    case 'function'
                        self.function_template(self.data{ii},self.out_abs{ii},self.out_rel{ii});
                    case 'script'
                        self.script_template(self.data{ii},self.out_abs{ii},self.out_rel{ii});
                end
            end
            
            % Create the index files:
        end
    end
    
    % Utility methods:
    methods (Access = private)
        function [] = getPaths(self,input_files, output_dir)
            N = 1;
            out_path = fullfile(self.root,output_dir);
            for ii = 1:length(input_files)
                if contains(input_files{ii},'.m')
                    in_file = dir(input_files{ii});
                    self.in_abs{N}  = fullfile(in_file.folder,in_file.name);
                    self.in_rel{N}  = erase(self.in_abs{N},self.root); 
                    self.out_abs{N} = fullfile(out_path,[self.in_rel{N}(1:end-2)]);
                    self.out_rel{N} = erase(self.out_abs{N},self.root);
                    N = N+1;
                else
                    in_files = dir(fullfile(input_files{ii},'**/*.m'));
                    for jj = 1:length(in_files)
                        self.in_abs{N}  = fullfile(in_files(jj).folder,in_files(jj).name);
                        self.in_rel{N}  = erase(self.in_abs{N},self.root); 
                        self.out_abs{N} = fullfile(out_path,[self.in_rel{N}(1:end-2)]);
                        self.out_rel{N} = erase(self.out_abs{N},self.root);
                        N = N+1;
                    end
                end
            end
        end
        
        function [] = getType(self,input_file)
            % Begin scanning line by line:
            fid = fopen(input_file);
            tline = fgetl(fid);
            in_block_comment = false;
            while ischar(tline)
                tline = strtrim(tline);
                % Check current line for comments:
                if in_block_comment
                    if strcmp(tline(1:2),'%}')
                        in_block_comment = false;
                    end
                else
                    if strcmp(tline(1:2),'%{')
                        in_block_comment = true;
                    end
                end              
                
                if ~in_block_comment
                    if length(tline) >= 8
                        if contains(tline(1:8),'classdef')
                            self.type{self.ind} = 'class';
                            break
                        elseif contains(tline(1:8),'function')
                            self.type{self.ind} = 'function';
                            break
                        else
                            self.type{self.ind} = 'script';
                            break
                        end
                    end
                end
                tline = fgetl(fid);
            end
            fclose(fid);
        end
    end
end

