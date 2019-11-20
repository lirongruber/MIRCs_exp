
function [SavingPath]=CompStartUpMIRCs 
% looking for the experiment directory-
% deciding on which computer Im working.
% set the path
% run the defaults
% output=where to save the data.

%ADD FOR EACH COMPUTER!!!

if exist('C:\Users\aslab\Documents\Liron\MIRCs_exp\','dir')
    SavingPath='C:\Users\aslab\Documents\Liron\MIRCs_raw_data\';
    cd C:\Users\aslab\Documents\Liron\MIRCs_exp\
%     addpath (genpath('C:\toolbox\'))
    addpath (genpath('C:\Users\aslab\Documents\Liron\MIRCs_exp\'))
end

if exist('C:\Users\lirongr\Documents\MIRCs_exp\','dir')
    SavingPath='C:\Users\lirongr\Documents\MIRCs_exp\data\';
    cd C:\Users\lirongr\Documents\MIRCs_exp\codes_only_repo
    addpath (genpath('C:\Users\lirongr\Documents\MIRCs_exp\'))
    addpath (genpath('C:\Users\lirongr\Documents\MATLAB\UTIL\'))
end

set(0,'DefaultAxesFontName', 'Arial')
set(0,'defaultTextFontName', 'Arial')
set(0,'DefaultAxesFontSize',18)
set(0,'defaultlinelinewidth',2)
set(0,'DefaultLineMarkerSize',12)
set(0,'defaultfigurecolor',[1 1 1])
% LATEX TEXT is default:
set(0,'DefaultTextInterpreter','Latex')

end


