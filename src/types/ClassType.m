classdef ClassType < handle
    
    properties (GetAccess = public, SetAccess = private)  
        Name char
        BriefDescription char
        Description char
        Attributes struct % class attributes
        SuperclassList cell % Superclass list
        PropertyList struct % property list
        MethodList struct % method list
        Include logical % if true, include the source code in the output
        code char % the source code
    end
    
    methods (Access = public)
        function [self] = ClassType()
            % Set the default class attributes:
            self.Attributes(1).Abstract.default         = false;
            self.Attributes(1).ConstructOnLoad.default  = false;
            self.Attributes(1).HandleCompatible.default = false;
            self.Attributes(1).Hidden.default           = false;
            self.Attributes(1).Sealed.default           = false;
            self.Attributes(1).InferiorClasses.default  = cell(0,1);
            
            % Set the default property attributes:
            self.PropertyList(1).Attributes.AbortSet.default      = false;
            self.PropertyList(1).Attributes.Abstract.default      = false;
            self.PropertyList(1).Attributes.Access.default        = 'public';
            self.PropertyList(1).Attributes.Constant.default      = false;
            self.PropertyList(1).Attributes.Dependent.default     = false;
            self.PropertyList(1).Attributes.GetAccess.default     = 'public';
            self.PropertyList(1).Attributes.GetObservable.default = false;
            self.PropertyList(1).Attributes.Hidden.default        = false;
            self.PropertyList(1).Attributes.NonCopyable.default   = false;
            self.PropertyList(1).Attributes.SetAccess.default     = 'public';
            self.PropertyList(1).Attributes.SetObservable.default = false;
            self.PropertyList(1).Attributes.Transient.default     = false;
            self.PropertyList(1).Attributes.PartialMatchPriority.default = true;
            
            % Set the default method attributes:
            self.MethodList(1).Attributes.Abstract.default = false;
            self.MethodList(1).Attributes.Access.default   = 'public';
            self.MethodList(1).Attributes.Hidden.default   = false;
            self.MethodList(1).Attributes.Sealed.default   = false;
            self.MethodList(1).Attributes.Static.default   = false;
            
            % Currently Unsupported:
            % - Class Attribute: AllowedSubclasses
            % - Class Attribute: Framework specific attributes
            % - Property Attribute: Framework specific attributes
            % - Method Attributes: Framework specific attributes
        end
    end
    
    methods (Static)
        function [self] = parse(file_name)
            % Create the ClassType object:
            self = ClassType();
            self.code = strtrim(fileread(file_name));
            
            % Get the meta data from the class object:
            [folder,name,ext] = fileparts(file_name);
            name = erase(name,ext);
            self.Name = name;
            
            % Check if on path:
            path_cell = regexp(path, pathsep, 'split');
            if ispc
                on_path = any(strcmpi(folder,path_cell));
            else
                on_path = any(strcmp(folder,path_cell));
            end
            
            % Read the meta data from the class file:
            if ~on_path
                addpath(folder)
            end
            
            % Attempt to extract the metadata from the file:
            try
                metadata = eval(['?',name]);
            catch
                warning('The data from the %s class could not be read.  Check file for errors',name)
            end
            
            % Store the class Superclass List:
            for ii = 1:length(metadata.SuperclassList)
                self.SuperclassList{ii} = metadata.SuperclassList(ii).Name;
            end

            % Process the class attributes:
            fn = fieldnames(self.Attributes);
            for ii = 1:length(fn)
                self.Attributes.(fn{ii}).set = metadata.(fn{ii});
            end

            % Process the property list:
            if ~isempty(metadata.PropertyList)
                fn = fieldnames(self.PropertyList.Attributes);
                for ii = 1:length(metadata.PropertyList)
                    self.PropertyList(ii).Name = metadata.PropertyList(ii).Name;
                    if ~isempty(metadata.PropertyList(ii).Validation)
                        if ~isempty(metadata.PropertyList(ii).Validation.Class)
                            self.PropertyList(ii).Type = metadata.PropertyList(ii).Validation.Class.Name;
                        end
                    end
                    if metadata.PropertyList(ii).HasDefault
                        self.PropertyList(ii).DefaultValue = metadata.PropertyList(ii).DefaultValue;
                    else
                        self.PropertyList(ii).DefaultValue = '';
                    end
                    for jj = 1:length(fn)
                        if ~strcmp(fn{jj},'Access')
                            self.PropertyList(ii).Attributes.(fn{jj}).set = metadata.PropertyList(ii).(fn{jj});
                        end
                    end
                end
            end

            % Process the method list:
            if ~isempty(metadata.MethodList)
                fn = fieldnames(self.MethodList.Attributes);
                for ii = 1:length(metadata.MethodList)
                    if strcmp(metadata.MethodList(ii).DefiningClass.Name,name)
                        if ~strcmp(metadata.MethodList(ii).Name,'empty')
                            self.MethodList(ii).Name = metadata.MethodList(ii).Name;
                            self.MethodList(ii).InputNames = metadata.MethodList(ii).InputNames;
                            self.MethodList(ii).OutputNames = metadata.MethodList(ii).OutputNames;
                            for jj = 1:length(fn)
                                self.MethodList(ii).Attributes.(fn{jj}).set = metadata.MethodList(ii).(fn{jj});
                            end
                        end
                    end
                end
            end

            % Get the specific comments:
            fid = fopen(file_name);
            tline = fgetl(fid);
            in_func = false;
            in_methods = false;
            in_classdef = false;
            in_properties = false;
            in_block_comment = false;
            classdef_comments = '';
            func_comments = '';
            prop_idx_matched = false(1,length(self.PropertyList));
            meth_idx_matched = false(1,length(self.MethodList));
            while ischar(tline)
                tline = strtrim(tline);
                % Check current line for comments:
                if in_block_comment
                    if length(tline) >= 2
                        if strcmp(tline(1:2),'%}')
                            in_block_comment = false;
                            tline = fgetl(fid); 
                            continue
                        end
                    end
                else
                    if length(tline) >= 2
                        if strcmp(tline(1:2),'%{')
                            in_block_comment = true;
                            tline = fgetl(fid); 
                            continue
                        end
                    end
                end              
                
                if ~in_block_comment
                    % Determine which type of section you are in:
                    if length(tline) >= 7 && ~in_methods && ~in_properties
                        if contains(tline(1:7),'methods')
                            in_methods = true;
                            in_classdef = false;
                            tline = fgetl(fid); 
                            continue
                        end
                    end
                    if length(tline) >= 8 && ~in_classdef
                        if contains(tline(1:8),'classdef')
                            in_classdef = true;
                            tline = fgetl(fid); 
                            continue
                        end
                    end
                    if length(tline) >= 10 && ~in_properties && ~in_methods
                        if contains(tline(1:10),'properties')
                            in_properties = true;
                            in_classdef = false;
                            tline = fgetl(fid); 
                            continue
                        end
                    end
                    if length(tline) >= 3 && (in_methods || in_classdef || in_properties) && ~in_func
                        if contains(tline(1:3),'end')
                            in_methods = false;
                            in_classdef = false;
                            in_properties = false;
                            tline = fgetl(fid); 
                            continue
                        end
                    end
                    
                    % If in a section, obtain the appropraite information:
                    if in_classdef
                        tline_insert = strtrim(erase(tline,'%'));
                        classdef_comments = sprintf('%s\n%s',classdef_comments,tline_insert);
                    elseif in_properties
                        for ii = 1:length(self.PropertyList)
                            if length(tline)>=length(self.PropertyList(ii).Name) && ~prop_idx_matched(ii)
                                if strcmp(tline(1:length(self.PropertyList(ii).Name)),self.PropertyList(ii).Name)
                                    idx = strfind(tline,'%');
                                    if ~isempty(idx)
                                        self.PropertyList(ii).Description = strtrim(tline(idx+1:end));
                                    else
                                        self.PropertyList(ii).Description = '';
                                    end
                                    prop_idx_matched(ii) = true;
                                    break
                                end
                            end
                        end
                    elseif in_methods
                        if in_func
                            if length(tline) >= 3
                                if contains(tline(1:3),'end')
                                    in_func = false;
                                    bdescr = extractBetween(func_comments,'@brief{','}');
                                    descr  = extractBetween(func_comments,'@detailed{','}');
                                    if isempty(bdescr)
                                        bdescr = '';
                                    else
                                        bdescr = bdescr{1};
                                    end
                                    if isempty(descr)
                                        descr = '';
                                    else
                                        descr = descr{1};
                                    end
                                    self.MethodList(meth_idx).BriefDescription = bdescr;
                                    self.MethodList(meth_idx).Description = descr;
                                    func_comments = '';
                                    tline = fgetl(fid);
                                    continue
                                end
                                tline_insert = strtrim(erase(tline,'%'));
                                func_comments = sprintf('%s\n%s',func_comments,tline_insert);
                                tline = fgetl(fid);
                                continue
                            end
                        end
                        temp = tline(~isspace(tline));
                        temp = erase(temp,{'[',']',',','(',')'});
                        for ii = 1:length(self.MethodList)
                            temp2 = self.func_declaration_nospace(self.MethodList(ii));
                            if length(temp)>=length(temp2) && ~meth_idx_matched(ii)
                                if strcmp(temp(1:length(temp2)),temp2)
                                    in_func = true;
                                    meth_idx = ii;
                                    meth_idx_matched(ii) = true;
                                    break
                                end
                            end
                        end
                    end
                end               
                % Get new line:
                tline = fgetl(fid); 
            end
            
            % Parse the classdef comments and store appropriately:
            bdescr = strtrim(extractBetween(classdef_comments,'@brief{','}'));
            descr  = strtrim(extractBetween(classdef_comments,'@detailed{','}'));
            include = strtrim(extractBetween(classdef_comments,'@code{','}'));
            if isempty(bdescr)
                bdescr = '';
            end
            if isempty(descr)
                descr = '';
            end
            if isempty(include)
                include = false;
            else
                if strcmp(include,'true')
                    include = true;
                end
            end
            self.BriefDescription = bdescr;
            self.Description = descr;
            self.Include = include;
            
            % Cleanup
            if ~on_path
                rmpath(folder)
            end
            fclose(fid);
        end
        
        function [temp] = func_declaration_nospace(method_list)
            temp = 'function';
            for ii = 1:length(method_list.OutputNames)
                temp = sprintf('%s%s',temp,method_list.OutputNames{ii});
            end
            temp = sprintf('%s=%s',temp,method_list.Name);
            for ii = 1:length(method_list.InputNames)
                temp = sprintf('%s%s',temp,method_list.InputNames{ii});
            end
        end
    end
end

