 clear; close all; clc;
%%
% Run this script for an experiment.
tic
[time, someData, someData2, someData3, someData4, someData5, someData6] = ni_daq;
toc
% After running this, all you have to do is enter in the command line:
%
% save('place_name_of_file_here.mat');
%
% That will save all the workspace variables into a .mat file with the
% name 'place_name_of_file_here'.
%
% If the experiment does not run for the entire duration, then you will
% have to save the data into a .mat file another way. There will be .csv files that are
% saved in the current folder. In the ni_daq.m, evaluate the code:
%
% time = csvread('time.csv');
% data_1 = csvread('data_1.csv');
% data_2 = csvread('data_2.csv');
% data_3 = csvread('data_3.csv');
% data_4 = csvread('data_4.csv');
% data_5 = csvread('data_5.csv');
% data_6 = csvread('data_6.csv');
%
% These will appear as workspace variables. Then, enter in the command
% line:
%
% save('place_name_of_file_here.mat');
%

