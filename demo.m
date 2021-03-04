clear; matlabrc; clc; close all;
addpath(genpath('src'))

% Generate the documentation:
data = GenerateDocumentation({'src/','demo/'});