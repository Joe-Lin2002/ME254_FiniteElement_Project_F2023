% Main file for the project
%% ME254_Project_Main, Cady Brunecz, Junyi Lin, Dec11 2023

% Constants

E = 1e9; % Pa
nu = 0.3; % Poisson ratio
P = 1; % KN

% Read data in
readmatrix('bc_code.txt') % Replace with boundary conditions
readmatrix('coord.txt') % Replace with nodal coords
