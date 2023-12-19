% Main file for the project
%% ME254_Project_Main, Cady Brunecz, Junyi Lin, Dec11 2023

%% Housekeeping
clear all;
close all;

%% Inputting File
directory = 'Project-files/input_coarse_mesh/'; % Input files directory
data = read_input(directory); % Input Reading

for i = 1:size(data.elemconn,1)
    stiff{i} = stiffness_cal([data.coord(data.elemconn(i,1:4),1),data.coord(data.elemconn(i,1:4),2)], ...
        data.matprop);
end