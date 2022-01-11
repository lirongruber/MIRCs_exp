
function [SavingPath]=CompStartUpMIRCs 
% looking for the experiment directory-
% deciding on which computer Im working.
% set the path
% run the defaults
% output=where to save the data.

%ADD FOR EACH COMPUTER!!!

if exist('C:\Users\aslab\Documents\Liron\MIRCs_exp\','dir')
    SavingPath='C:\Users\aslab\Documents\Liron\MIRCs_exp';
    cd C:\Users\aslab\Documents\Liron\MIRCs_exp\
%     addpath (genpath('C:\toolbox\'))
    addpath (genpath('C:\Users\aslab\Documents\Liron\MIRCs_exp\'))
end

if exist('C:\Users\KOKO\Documents\GitHub\MIRCs_exp\','dir')
    SavingPath='C:\Users\KOKO\Documents\GitHub\MIRCs_exp\';
    cd C:\Users\KOKO\Documents\GitHub\MIRCs_exp
    addpath (genpath('C:\Users\KOKO\Documents\GitHub\MIRCs_exp\'))
    addpath (genpath('C:\Users\KOKO\Documents\MATLAB\'))
    addpath (genpath('D:\LIRON_MIRCs_exp\data\modelData\'))
end

if exist('/Users/lirongruber/Documents/GitHub/MIRCs_exp','dir')
%     SavingPath='C:\Users\lirongr\Documents\MIRCs_exp\data\';
    cd /Users/lirongruber/Documents/GitHub/MIRCs_exp
    addpath (genpath('/Users/lirongruber/Documents/GitHub/MIRCs_exp'))
    addpath (genpath('/Users/lirongruber/Documents/GitHub/UTILS_lirongr/'))
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


