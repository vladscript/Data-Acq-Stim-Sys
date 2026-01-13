% Place name of file inside variable
function [time, data_1, data_2, data_3, data_4, data_5, data_6] = ni_daq

% Plotting analog data from NI USB-6008 and saving to .mat file
clear; close all; clc;
acquireData;
time = csvread('time.csv');
data_1 = csvread('data_1.csv');
data_2 = csvread('data_2.csv');
data_3 = csvread('data_3.csv');
data_4 = csvread('data_4.csv');
data_5 = csvread('data_5.csv');
data_6 = csvread('data_6.csv');
