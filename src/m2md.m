% NAME>{Matlab 2 Markdown}
%
% BRIEF>{Utility for Creating Markdown Documentation for MATLAB Projects}
%
% DESCRIPTION>{
% This class will automatically generate documentation in a markdown
% format, ready to be uploaded to GitHub pages or any other static site
% generator system that allows for markdown files.
% 
% Simply provide the m files, or a directory/directories to your m files,
% along with the desired output directory.
%}
classdef m2md < handle
    properties (Access = public)
        % Inputs (set by user):
        InputMfiles_rel % Input m files relative path
        InputMfiles_full % Input m files absolute path
        OutputMDdir_rel % Output directory relative path
        OutputMDdir_full % Output directory full path
        OutputMD_name % Output names
        Template % Function handle of markdown template
        
        % Index Generation:
        MakeIndex % Boolean for whether or not to make the index files
        IndexTemplate % Function handle to the markdown template
        
        % Generic Data:
        TYPE % Current type of m file that was loaded
        FILENAME % Current file name
        BCOMMENTS_INDS % Current indices of block comment sections
        leading_comments % Current leading comments
        NAME % Current specified name
        BRIEF % Current specified brief description
        DESCRIPTION % Current specified detailed description
        
        % TYPE==FUNCTION: Data extracted from the m file:
        FUNCTION % Current function data
        SUBFUNCTIONS % Current sub-functions data
        
        % TYPE==CLASS: Data extracted from the m file:
        CLASS_ATTR % Current class attributes
        SUPERCLASS % Current class' super class
        PROPERTIES % Current class properties
        PROP_ATTR % Current class' property attributes
        CONSTRUCTOR % Current class' constructor
        METHODS % Current class' methods
        METHOD_ATTR % Current class' method attributes
    end
    
    methods (Access = public)
        function [self] = m2md(InputMfiles,OutputMDdir,varargin)
            tic
            % NAME>{Matlab to Markdown}
            % BRIEF>{The constructor for the m2md class}
            % DESCRIPTION>{When called this will instantiate an object and
            % then begin processing all of the input m files into markdown}
            
            % Define defaults:
            validInputPath = @(x) ischar(x) || iscell(x);
            validOutputPath = @(x) ischar(x);
            validTemp = @(x) isa(x,'function_handle');
            validBool = @(x) isa(x,'logical');
            defaultTemplate = '@defaultTemplate';
            defaultIndex = true;
            defaultIndexTemplate = @defaultIndexTemplate;
            
            % Parse the inputs:
            p = inputParser;
                addRequired(p,'InputMfiles',validInputPath);
                addRequired(p,'OutputMDdir',validOutputPath)
                addOptional(p,'Template',defaultTemplate,validTemp);
                addOptional(p,'MakeIndex',defaultIndex,validBool);
                addOptional(p,'IndexTemplate',defaultIndexTemplate,validTemp);
            parse(p,InputMfiles,OutputMDdir,varargin{:});
            
            % Process the index settings
            self.MakeIndex = p.Results.MakeIndex;
            if self.MakeIndex
                self.IndexTemplate = p.Results.IndexTemplate;
            end
            
            % Get a list of all input .m files:
            [mfiles_rel,mfiles_full] = self.getMfiles(p.Results.InputMfiles);
            
            outputmd_dir_rel = p.Results.OutputMDdir;
            outputmd_dir_full = fullfile(pwd,outputmd_dir_rel);
            
            % Store the results:
            self.InputMfiles_rel = mfiles_rel;
            self.InputMfiles_full = mfiles_full;
            self.OutputMDdir_rel  = outputmd_dir_rel;
            self.OutputMDdir_full = outputmd_dir_full;
            self.Template    = p.Results.Template;            
            
            % Define the regular expressions used in parsing:
            def_exp  = @(KEYWORD) ['(\r\n|\r|\n)(?<!%)\s*',KEYWORD,'.*?(\r\n|\r|\n)'];
            cdef_exp = @(TYPE,NAME) ['(\r\n|\r|\n)*(?<!%)\s*',TYPE,'.*?',NAME,'.*?(\r\n|\r|\n)'];
            block_comments_exp = '%{.*?%}';
            
            % Run the actual documentation process
            for ii = 1:length(self.InputMfiles_rel)
                % RESET:
                self.FUNCTION = struct();
                self.SUBFUNCTIONS = {};
                self.CLASS_ATTR = {};
                self.SUPERCLASS = {};
                self.PROPERTIES = {};
                self.PROP_ATTR = {};
                self.CONSTRUCTOR = {};
                self.METHODS = {};
                self.METHOD_ATTR = {};
                self.SUBFUNCTIONS = {};
                
                % Set the default values of supported Class Attributes:
                self.CLASS_ATTR.Abstract.DEFAULT = 'false';
                self.CLASS_ATTR.ConstructOnLoad.DEFAULT = 'false';
                self.CLASS_ATTR.HandleCompatible.DEFAULT = 'false';
                self.CLASS_ATTR.Hidden.DEFAULT = 'false';
                self.CLASS_ATTR.Sealed.DEFAULT = 'false';

                % Set the default values of supported Property Attributes:
                self.PROP_ATTR.Constant.DEFAULT = 'false';
                self.PROP_ATTR.Hidden.DEFAULT   = 'false';
                self.PROP_ATTR.Access.DEFAULT   = 'public';

                % Set the default values of supporter Method Attributes:
                self.METHOD_ATTR.Abstract.DEFAULT = 'false';
                self.METHOD_ATTR.Access.DEFAULT   = 'public';
                self.METHOD_ATTR.Hidden.DEFAULT   = 'false';
                self.METHOD_ATTR.Sealed.DEFAULT   = 'false';
        
                % Get the filename:
                [PATH,self.FILENAME] = fileparts(self.InputMfiles_full{ii});
                PATH = erase(PATH,pwd);
                self.OutputMD_name = [PATH,'/',self.FILENAME,'.md'];
                
                % Identify all block comments:
                msource = fileread(self.InputMfiles_full{ii});
                [i1,i2] = regexp(msource,block_comments_exp,'matchcase');
                self.BCOMMENTS_INDS = [i1',i2'];
                
                % Determine the type and get def line:
                [i1,i2] = regexp(msource,cdef_exp('classdef',self.FILENAME),'matchcase');
                [i1,i2] = self.removeComments(i1,i2);
                if isempty(i1)
                    % It is not a class, check if it is a function:
                    [i1,i2] = regexp(msource,cdef_exp('function',self.FILENAME),'matchcase');
                    [i1,i2] = self.removeComments(i1,i2);
                    if isempty(i1)
                       % It is not a class or a function, so it is a script
                        self.TYPE = 'SCRIPT';
                    else
                        self.TYPE = 'FUNCTION';
                    end
                else
                    self.TYPE = 'CLASS';
                end
                
                % Read the leading comment data:
                if ~isempty(i1)
                    lead_comments = erase(msource(1:i1-1),'%');
                else
                    lead_comments = msource;
                end
                self.NAME  = extractBetween(lead_comments,'NAME>{','}');
                if ~isempty(self.NAME)
                    self.NAME = self.NAME{1};
                    self.NAME = erase(self.NAME,'%');
                else
                    self.NAME = '';
                end
                self.BRIEF = extractBetween(lead_comments,'BRIEF>{','}');
                if ~isempty(self.BRIEF)
                    self.BRIEF = self.BRIEF{1};
                    self.BRIEF = erase(self.BRIEF,'%');
                else
                    self.BRIEF = '';
                end
                self.DESCRIPTION = extractBetween(lead_comments,'DESCRIPTION>{','}');
                if ~isempty(self.DESCRIPTION)
                    self.DESCRIPTION = self.DESCRIPTION{1};
                    self.DESCRIPTION = erase(self.DESCRIPTION,'%');
                else
                    self.DESCRIPTION = '';
                end
                
                % Parse each depending on its type:
                if strcmp(self.TYPE,'CLASS')                   
                    % Get the class settings
                    cdef_line = strtrim(msource(i1(1):i2(1)));
                    
                    % Get the SuperClass
                    idx = strfind(cdef_line,'<');
                    self.SUPERCLASS = strtrim(cdef_line(idx+1:end));
                    
                    % Get the attributes:
                    self.getCLASS_ATTR(cdef_line);
                    
                    % Get the properties lines:
                    [p1,p2] = regexp(msource,def_exp('properties'),'matchcase');
                    [p1,p2] = self.removeComments(p1,p2);
                    
                    % Get the methods lines:
                    [m1,m2] = regexp(msource,def_exp('methods'),'matchcase');
                    [m1,m2] = self.removeComments(m1,m2);
                    
                    % Parse the property lines:
                    if isempty(p1)
                        % TODO: What to do if no properties are given?
                    else
                        num_props = 1;
                        for jj = 1:length(p1)
                            prop_line = strtrim(msource(p1(jj):p2(jj)));
                            
                            % Get the property attributes:
                            custom = self.getPROP_ATTR(prop_line);
                            
                            % Read in all properties for this group:
                            if jj == length(p1)
                                if ~isempty(m1)
                                    m_temp = msource(p1(jj):m1(1));
                                else
                                    m_temp = msource(p1(jj):end);
                                end
                            else
                                m_temp = msource(p1(jj):p1(jj+1));
                            end
                            
                            % Extract just the properties
                            if custom
                                m_temp = extractBetween(m_temp,')','end');
                            else
                                m_temp = extractBetween(m_temp,'properties','end');
                            end
                            m_temp = [strtrim(m_temp{1}),newline];
                            
                            % Check for properties:
                            [c1,c2] = regexp(m_temp,'\s*(?<!%).*?(\r\n|\r|\n)','matchcase');
                            for kk = 1:length(c1)
                                line = strtrim(m_temp(c1(kk):c2(kk)));
                                % TODO: Fix regex above to ignore
                                % standalone comments.  This works for now.
                                if ~strcmp(line(1),'%')
                                    if contains(line,'%')
                                        idx = strfind(line,'%');
                                        prop_name = strtrim(line(1:idx-1));
                                        comment = strtrim(line(idx+1:end));
                                    else
                                        prop_name = strtrim(line);
                                        comment = '';
                                    end
                                    % Store the results:
                                    self.PROPERTIES{num_props} = {prop_name,self.PROP_ATTR,comment};
                                    num_props = num_props+1;
                                end
                            end
                        end
                    end
                    
                    % Get the method lines:
                    if isempty(m1)
                        % TODO: What to do if no methods given?
                    else
                        num_funcs = 1;
                        for jj = 1:length(m1)
                            method_line = strtrim(msource(m1(jj):m2(jj)));
                            % Get the method attributes:
                            self.getMETHOD_ATTR(method_line);
                            if jj == length(m1)
                                m_temp = msource(m2(jj):end);
                                [f1,f2] = regexp(m_temp,def_exp('function'),'matchcase');
                                for kk = 1:length(f1)
                                    func_line = strtrim(m_temp(f1(kk):f2(kk)));
                                    if kk == length(f1)
                                        m_temp2 = m_temp(f1(kk):end);
                                    else
                                        m_temp2 = m_temp(f1(kk):f1(kk+1));
                                    end
                                    method = self.parseFunction(func_line,m_temp2);
                                    if strcmp(method.FUNCTION,self.FILENAME)
                                        self.CONSTRUCTOR = method;
                                        self.CONSTRUCTOR.ATTRIBUTES = self.METHOD_ATTR;
                                    else
                                        self.METHODS{num_funcs} = method;
                                        self.METHODS{num_funcs}.ATTRIBUTES = self.METHOD_ATTR;
                                        num_funcs = num_funcs+1;
                                    end
                                end
                            else
                                m_temp = msource(m2(jj):m2(jj+1));
                                [f1,f2] = regexp(m_temp,def_exp('function'),'matchcase');
                                for kk = 1:length(f1)
                                    func_line = strtrim(m_temp(f1(kk):f2(kk)));
                                    if kk == length(f1)
                                        m_temp2 = m_temp(f1(kk):end);
                                    else
                                        m_temp2 = m_temp(f1(kk):f1(kk+1));
                                    end
                                    method = self.parseFunction(func_line,m_temp2);
                                    if strcmp(method.FUNCTION,self.FILENAME)
                                        self.CONSTRUCTOR = method;
                                        self.CONSTRUCTOR.ATTRIBUTES = self.METHOD_ATTR;
                                    else
                                        self.METHODS{num_funcs} = method;
                                        self.METHODS{num_funcs}.ATTRIBUTES = self.METHOD_ATTR;
                                        num_funcs = num_funcs+1;
                                    end
                                end
                            end
                        end
                    end
                    
                elseif strcmp(self.TYPE,'FUNCTION')
                    [f1,f2] = regexp(msource,def_exp('function'),'matchcase');
                    func_line = extractBetween(msource,'function',newline);
                    func_line = ['function',func_line{1},newline];
                    f12 = strfind(msource,func_line);
                    f22 = length(func_line);
                    if isempty(f1)
                       f1 = f12;
                       f2 = f22;
                    else
                        if ~ismember(f12,f1)
                            f1 = [f12,f1];
                            f2 = [f22,f2];
                        end
                    end
                    num_subf = 1;
                    for jj = 1:length(f1)
                        func_line = msource(f1(jj):f2(jj));
                        if ~isempty(func_line)
                            if jj == length(f1)
                                m_temp2 = msource(f1(jj):end);
                            else
                                m_temp2 = msource(f1(jj):f1(jj+1));
                            end
                            func = self.parseFunction(func_line,m_temp2);

                            if strcmp(func.FUNCTION,self.FILENAME)
                                self.FUNCTION = func;
                                self.FUNCTION.NAME = self.NAME;
                                self.FUNCTION.BRIEF = self.BRIEF;
                                self.FUNCTION.DESCRIPTION = self.DESCRIPTION;
                            else
                                self.SUBFUNCTIONS{num_subf} = func;
                                num_subf = num_subf+1;
                            end
                        end
                    end
                    
                elseif strcmp(self.TYPE,'SCRIPT')
                    [f1,f2] = regexp(msource,def_exp('function'),'matchcase');
                    num_subf = 1;
                    for jj = 1:length(f1)
                        func_line = msource(f1(jj):f2(jj));
                        if jj == length(f1)
                            m_temp2 = msource(f1(jj):end);
                        else
                            m_temp2 = msource(f1(jj):f1(jj+1));
                        end
                        self.SUBFUNCTIONS{num_subf} = self.parseFunction(func_line,m_temp2);
                        num_subf = num_subf+1;
                    end
                end
                
                % Write the markdown file based on the provided template:
                self.Template(self);
            end
            
            % Generate Index Files if asked for
            if self.MakeIndex
                % Get list of all directories:
                subdirs = dir([self.OutputMDdir_rel,'/**/*']);
                subdirs = subdirs([subdirs.isdir]);
                subdirs = subdirs(~ismember({subdirs.name},{'.','..'}));
                
                % Make the document home index file:
                self.IndexTemplate(self.OutputMDdir_rel,self.OutputMDdir_rel)
                
                % Make all the sub-index files:
                for ii = 1:length(subdirs)
                    rel_path = [erase(subdirs(ii).folder,pwd),'/',subdirs(ii).name];
                    self.IndexTemplate(rel_path(2:end),subdirs(ii).name)
                end
            end
            x = toc;
            fprintf('Documented %i files in %f seconds\n',length(self.InputMfiles_rel),x)
        end
    end
    
    methods (Access = private)
        function [] = getCLASS_ATTR(self,cdef_line)
            % NAME>{Get Class Attributes}
            % BRIEF>{Reads the current class attributes}
            fn = fieldnames(self.CLASS_ATTR);
            for jj = 1:length(fn)
                self.CLASS_ATTR.(fn{jj}).SET = self.CLASS_ATTR.(fn{jj}).DEFAULT;
            end
            if contains(cdef_line,'(')
                if contains(cdef_line,',')
                    for jj = 1:length(fn)
                        bounds = strtrim(erase(extractBetween(cdef_line,fn{jj},','),'='));
                        if ~isempty(bounds)
                            self.CLASS_ATTR.(fn{jj}).SET = bounds{1};
                        end
                    end
                else
                    % Only a single attribute definition was given:
                    for jj = 1:length(fn)
                        bounds = strtrim(erase(extractBetween(cdef_line,fn{jj},')'),'='));
                        if ~isempty(bounds)
                            self.CLASS_ATTR.(fn{jj}).SET = bounds{1};
                            break
                        end
                    end
                end
            end
        end
        
        
        function [custom] = getPROP_ATTR(self,prop_line)
            % NAME>{Get Property Attributes}
            % BRIEF>{Reads the current class' property attributes}
            custom = false;
            fn = fieldnames(self.PROP_ATTR);
            for jj = 1:length(fn)
                self.PROP_ATTR.(fn{jj}).SET = self.PROP_ATTR.(fn{jj}).DEFAULT;
            end
            if contains(prop_line,'(')
                custom = true;
                if contains(prop_line,',')
                    for jj = 1:length(fn)
                        bounds = strtrim(erase(extractBetween(prop_line,fn{jj},','),'='));
                        if ~isempty(bounds)
                            self.PROP_ATTR.(fn{jj}).SET = bounds{1};
                        end
                    end
                else
                    % Only a single attribute definition was given:
                    for jj = 1:length(fn)
                        bounds = strtrim(erase(extractBetween(prop_line,fn{jj},')'),'='));
                        if ~isempty(bounds)
                            self.PROP_ATTR.(fn{jj}).SET = bounds{1};
                            break
                        end
                    end
                end
            end
        end
        
        function [] = getMETHOD_ATTR(self,method_line)
            % NAME>{Get Method Attributes}
            % BRIEF>{Gets the current class' method attributes}
            fn = fieldnames(self.METHOD_ATTR);
            for jj = 1:length(fn)
                self.METHOD_ATTR.(fn{jj}).SET = self.METHOD_ATTR.(fn{jj}).DEFAULT;
            end
            if contains(method_line,'(')
                if contains(method_line,',')
                    for jj = 1:length(fn)
                        bounds = strtrim(erase(extractBetween(method_line,fn{jj},','),'='));
                        if ~isempty(bounds)
                            self.METHOD_ATTR.(fn{jj}).SET = bounds{1};
                        end
                    end
                else
                    % Only a single attribute definition was given:
                    for jj = 1:length(fn)
                        bounds = strtrim(erase(extractBetween(method_line,fn{jj},')'),'='));
                        if ~isempty(bounds)
                            self.METHOD_ATTR.(fn{jj}).SET = bounds{1};
                            break
                        end
                    end
                end
            end
        end
    
        function [i1,i2] = removeComments(self,i1,i2)
            % NAME>{Remove Comments}
            % BRIEF>{Removes matches that are comments}
            if ~isempty(self.BCOMMENTS_INDS)
                remove = false(size(i1));
                for ii = 1:length(i1)
                    remove(ii) = any(i1(ii)>self.BCOMMENTS_INDS(:,1) & i1(ii)<self.BCOMMENTS_INDS(:,2));
                end
                i1(remove) = [];
                i2(remove) = []; 
            end
        end
    end
    
    methods (Access = private, Static = true)        
        function [outstruct] = parseFunction(func_line,msource)   
            % NAME>{Parse Function}
            % BRIEF>{Gets the inputs/outputs of the current function}
            % Remove comments (if any on line):
            idx = strfind(func_line,'%');
            func_line(idx:end)=[];
            if contains(func_line,'...')
                idx = strfind(func_line,'...');
                func_line(idx+3:end) = [];
                if contains(func_line,'[')
                    if ~contains(func_line,']')
                        func_line2 = extractBetween(msource,func_line,'=');
                        func_line = [func_line,func_line2{1},'='];
                        func_line2 = extractBetween(msource,func_line,newline);
                        func_line = [func_line,func_line2{1},newline];
                        if contains(func_line,'...')
                            if contains(func_line,'(')
                                func_line2 = extractBetween(msource,func_line,')');
                                func_line = [func_line,func_line2{1},')'];
                            else
                                func_line2 = extractBetween(msource,func_line,'(');
                                func_line = [func_line,func_line2{1},'('];
                                func_line2 = extractBetween(msource,func_line,newline);
                                func_line = [func_line,func_line2{1},newline];
                                func_line2 = extractBetween(msource,func_line,')');
                                func_line = [func_line,func_line2{1},')'];
                            end
                        end
                    else
                        if contains(func_line,'(')
                            if ~contains(func_line,')')
                                func_line2 = extractBetween(msource,func_line,')');
                                func_line = [func_line,func_line2{1},')'];
                            end
                        end
                    end
                end
                % Cleanup:
                id_elip = strfind(func_line,'...');
                id_nl   = strfind(func_line,newline);
                remove = [];
                for ii = 1:length(id_elip)
                    remove = [remove,id_elip(ii):id_nl(ii)];
                end
                func_line(remove) = [];
                func_line = func_line(~isspace(func_line));
            end
            
            if contains(func_line,'=')
                outputs_raw = extractBetween(func_line,'function','=');
                outputs_raw = strtrim(outputs_raw{1});
                % Remove brackets if they exist
                if contains(outputs_raw,'[')
                    outputs_raw = outputs_raw(2:end-1);
                end
                if contains(outputs_raw,',')
                    outputs = split(outputs_raw,',');
                else
                    outputs = split(outputs_raw);
                end
                
                idx = strfind(func_line,'=');
                temp = func_line(idx+1:end);
            else
                temp = func_line(9:end);
                outputs = {''};
            end
            
            if contains(temp,'(')
                inputs_raw = extractBetween(temp,'(',')');
                inputs_raw = strtrim(inputs_raw{1});
                if contains(inputs_raw,',')
                    inputs = split(inputs_raw,',');
                else
                    inputs = split(inputs_raw);
                end
                idx = strfind(temp,'(');
                func = strtrim(temp(1:idx-1));
            else
                inputs = {''};
                func = strtrim(temp);
            end
            
            % Store the results:
            outstruct.FUNCTION = func;
            outstruct.OUTPUTS = outputs;
            outstruct.INPUTS = inputs;
            
            % Extract the annotations from the function source code:
            outstruct.NAME = extractBetween(msource,'NAME>{','}');
            if ~isempty(outstruct.NAME)
                outstruct.NAME = outstruct.NAME{1};
            else
                outstruct.NAME = '';
            end
            outstruct.BRIEF = extractBetween(msource,'BRIEF>{','}');
            if ~isempty(outstruct.BRIEF)
                outstruct.BRIEF = outstruct.BRIEF{1};
            else
                outstruct.BRIEF = '';
            end
            outstruct.DESCRIPTION = extractBetween(msource,'DESCRIPTION>{','}');
            if ~isempty(outstruct.DESCRIPTION)
                outstruct.DESCRIPTION = outstruct.DESCRIPTION{1};
            else
                outstruct.DESCRIPTION = '';
            end
        end
        
        function [mfiles_rel,mfiles_full] = getMfiles(InputMfiles)
            % NAME>{getMfiles}
            % BRIEF>{Gets the relative and absolute paths to all specified m files}
            if iscell(InputMfiles)
                assert(numel(InputMfiles) == size(InputMfiles,1)*size(InputMfiles,2),...
                       'Batch input must be with a 1xN or Nx1 cell array');
                mfiles_rel = cell(size(InputMfiles));
                mfiles_full = cell(size(InputMfiles));
                file_num = 1;
                for ii = 1:length(InputMfiles)
                    if isfolder(InputMfiles{ii})
                        mfiles_indir = dir([InputMfiles{ii},'/**/*.m']);
                        for jj = 1:length(mfiles_indir)
                            rel_folder = erase(mfiles_indir(jj).folder,pwd);
                            mfiles_rel{file_num} = fullfile(rel_folder,mfiles_indir(jj).name);
                            mfiles_full{file_num} = fullfile(pwd,mfiles_rel{file_num});
                            file_num = file_num+1;
                        end
                    else
                        mfiles_rel{file_num} = InputMfiles{ii};
                        mfiles_full{file_num} = fullfile(pwd,mfiles_rel{file_num});
                        file_num = file_num+1;
                    end
                end
            else
                if isfolder(InputMfiles)
                    
                else
                    mfiles_rel{1} = InputMfiles;
                    mfiles_full{1} = fullfile(pwd,mfiles_rel{1});
                end
            end
        end
        
        function [string] = bool2str(bool)
            % NAME>{bool2str}
            % BRIEF>{Converts a boolean to a string}
            if bool
                string = 'True';
            else
                string = 'False';
            end
        end
    end
end