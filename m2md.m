%% NAME>{Matlab 2 Markdown}
%
% BRIEF>{Utility for creating markdown documentation from a Matlab M-file}
%
% DESCRIPTION>{
% A more detailed description can go here. 
% ### Section 1
% You can use limited markdown syntax exactly in here.  Just make sure that
% you recognize that:
% - You can only use level 3 sections or higher
% - This section is entire entered into the "Detailed Description" section
% exactly as it appears here (it is copied verbatim)
% - You must remember to add a closing bracket.
% 
% ### Section 2
% You can use [links](google.com) as well
% }
%{
More block comments
because I enjoy the challenge 
%}

%{
going
to
test
this
 classdef m2md
beacuse
it
is
annoying
%}
    
classdef (Abstract = false) m2md < handle
    properties (Access = public)
        % Inputs (set by user):
        InputMfiles_rel
        InputMfiles_full
        OutputMDdir_rel
        OutputMDdir_full
        OutputMD_name
        Template
        
        % Generic Data:
        TYPE % Type of m-file that was loaded
        FILENAME
        BCOMMENTS_INDS % Indices of block comment sections
        
        % OTHER:
        leading_comments
        
        % TYPE==SCRIPT: Data extracted from the m file:
        
        % TYPE==FUNCTION: Data extracted from the m file:
        
        % TYPE==CLASS: Data extracted from the m file:
        NAME
        BRIEF
        DESCRIPTION
        CLASS_ATTR
        SUPERCLASS
        PROPERTIES
        PROP_ATTR
        CONSTRUCTOR
        METHODS
        METHOD_ATTR
    end
    
    properties (Access = private,Constant = true)
        seven = 2
        six = 5
    end
    
    methods (Access = public)
        function [self] = m2md(InputMfiles,OutputMDdir,varargin)
            % Define defaults:
            validInputPath = @(x) ischar(x) || iscell(x);
            validOutputPath = @(x) ischar(x);
            validTemp = @(x) isa(x,'function_handle');
            defaultTemplate = 'defaultTemplate.m';
            
            % Parse the inputs:
            p = inputParser;
                addRequired(p,'InputMfiles',validInputPath);
                addRequired(p,'OutputMDdir',validOutputPath)
                addOptional(p,'Template',defaultTemplate,validTemp);
            parse(p,InputMfiles,OutputMDdir,varargin{:});
            
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
            self.METHOD_ATTR.Access.DEFAULT = 'false';
            self.METHOD_ATTR.Hidden.DEFAULT = 'false';
            self.METHOD_ATTR.Sealed.DEFAULT = 'false';
            
            
            % Define the regular expressions used in parsing:
            def_exp  = @(KEYWORD) ['(\r\n|\r|\n)(?<!%)\s*',KEYWORD,'.*?(\r\n|\r|\n)'];
            cdef_exp = @(TYPE,NAME) ['(\r\n|\r|\n)(?<!%)\s*',TYPE,'.*?',NAME,'.*?(\r\n|\r|\n)'];
            block_comments_exp = '%{.*?%}';
            
            % Run the actual documentation process
            for ii = 1:length(self.InputMfiles_rel)
                % Get the filename:
                [~,self.FILENAME] = fileparts(self.InputMfiles_full{ii});
                self.OutputMD_name = [self.FILENAME,'.md'];
                
                % Identify all block comments:
                msource = fileread(self.InputMfiles_rel{ii});
                [i1,i2] = regexp(msource,block_comments_exp,'matchcase');
                self.BCOMMENTS_INDS = [i1',i2'];
                
                % Determine the type and get def line:
                [i1,i2] = regexp(msource,cdef_exp('classdef','m2md'),'matchcase');
                [i1,i2] = self.removeComments(i1,i2);
                if isempty(i1)
                    % It is not a class, check if it is a function:
                    [i1,i2] = regexp(msource,cdef_exp('function','m2md'),'matchcase');
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
                
                % Parse each depending on its type:
                if strcmp(self.TYPE,'CLASS')
                    % Get the leading comment data:
                    lead_comments = erase(msource(1:i1-1),'%');
                    self.NAME  = extractBetween(lead_comments,'NAME>{','}');
                    self.NAME  = self.NAME{1};
                    self.BRIEF = extractBetween(lead_comments,'BRIEF>{','}');
                    self.BRIEF = self.BRIEF{1};
                    self.DESCRIPTION = extractBetween(lead_comments,'DESCRIPTION>{','}');
                    self.DESCRIPTION = self.DESCRIPTION{1};
                    
                    % Get the class settings
                    cdef_line = strtrim(msource(i1(1):i2(1)));
                    
                    % Get the attributes:
                    self.getCLASS_ATTR(cdef_line);
                    
                    % Get the properties lines:
                    [p1,p2] = regexp(msource,def_exp('properties'),'matchcase');
                    [p1,p2] = self.removeComments(p1,p2);
                    
                    % Get the methods lines:
                    [m1,m2] = regexp(msource,def_exp('methods'),'matchcase');
                    [m1,m2] = self.removeComments(m1,m2);
                    
                    % Parse the property lines:
                    num_props = 1;
                    if isempty(p1)
                        % TODO: What to do if no properties are given?
                    else
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
                    for jj = 1:length(m1)
                        disp(strtrim(msource(m1(jj):m2(jj))))
                        if jj == length(m1)
                            msource_range = msource(m2(jj):end);
                            [f1,f2] = regexp(msource_range,def_exp('function'),'matchcase');
                            for kk = 1:length(f1)
                                disp(strtrim(msource_range(f1(kk):f2(kk))));
                            end
                        else
                            msource_range = msource(m2(jj):m2(jj+1));
                            [f1,f2] = regexp(msource_range,def_exp('function'),'matchcase');
                            for kk = 1:length(f1)
                                disp(strtrim(msource_range(f1(kk):f2(kk))));
                            end
                        end
                    end
                    
                elseif strcmp(self.TYPE,'FUNCTION')
                    
                    
                elseif strcmp(self.TYPE,'SCRIPT')
                    
                end
                
                % Write the markdown file based on the provided template:
                self.Template(self);
            end
        end
    end
    
    methods (Access = private)
        function [] = getCLASS_ATTR(self,cdef_line)
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
    end
    
    methods (Access = private)
        function [i1,i2] = removeComments(self,i1,i2)
           remove = false(size(i1));
            for ii = 1:length(i1)
                remove(ii) = any(i1(ii)>self.BCOMMENTS_INDS(:,1) & i1(ii)<self.BCOMMENTS_INDS(:,2));
            end
            i1(remove) = [];
            i2(remove) = []; 
        end
        
        function [TYPE] = getType(self,msource)
            
        end
    end
    
    methods (Access = private, Static = true)
        function [mfiles_rel,mfiles_full] = getMfiles(InputMfiles)
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
            if bool
                string = 'True';
            else
                string = 'False';
            end
        end
    end
end