% Main file for the project
%% ME254_Project_Main, Cady Brunecz, Junyi Lin, Dec11 2023

%% Housekeeping
clear all;
close all;

%% Inputting File
directory = 'Project-files/input_coarse_mesh/'; % Input files directory
data = read_input(directory); % Input Reading

%% Finding Stiffness Matrix
% Flag: 1 for reduced integration, 2 for full integration
flag = 2;
% plane_flag: 1 for plane stress, 2 for plane strain
plane_flag = 1;

for i = 1:size(data.elemconn,1)
    [stiff_local{i}, B{i}] = stiffness_cal([data.coord(data.elemconn(i,1:4),1),data.coord(data.elemconn(i,1:4),2)], ...
        data.matprop, flag, plane_flag);
end

%% Global Stiffness Matrix Assemble
stiff_global = zeros(2*length(data.nodeid)); % Preallocate the global stiffness matrix

for i = 1:length(stiff_local)
    % Get the local stiffness matrix for the current element
    K_local = stiff_local{i};
    
    % Get the global node numbers for the current element
    element_nodes = data.elemconn(i,:);
    
    % Get the global DOFs for the current element
    global_dofs = [2*element_nodes(1)-1, 2*element_nodes(1), ...
                   2*element_nodes(2)-1, 2*element_nodes(2), ...
                   2*element_nodes(3)-1, 2*element_nodes(3), ...
                   2*element_nodes(4)-1, 2*element_nodes(4)];
    
    % Map the local stiffness matrix to the global stiffness matrix
    for ii = 1:length(global_dofs)
        for jj = 1:length(global_dofs)
            stiff_global(global_dofs(ii), global_dofs(jj)) = ...
                stiff_global(global_dofs(ii), global_dofs(jj)) + K_local(ii, jj);
        end
    end
end

%% Apply boundary conditions
for i = 1:length(data.nodeid)
    if data.bc_code(i,1) == 1
        dof_x = 2*i - 1;
        stiff_global(:, dof_x) = 0;
        stiff_global(dof_x, :) = 0;
        stiff_global(dof_x, dof_x) = 1e10; % Large number
    end
    if data.bc_code(i,2) == 1
        dof_y = 2*i;
        stiff_global(:, dof_y) = 0;
        stiff_global(dof_y, :) = 0;
        stiff_global(dof_y, dof_y) = 1e10; % Large number
    end
end


force = reshape([data.loads],size(stiff_global,1),1);
displacement = stiff_global\force;

for i = 1:length(displacement)
    if isnan(displacement(i))
        displacement(i)=0;
    end
end

nodal_stress = 0;
for i = 1:length(B)
    nodal_stress = nodal_stress + calculate_nodal_stress(data, displacement, B{i}, plane_flag);
end

show_displacements(data.elemconn, data.coord, sqrt(displacement(1:2:end).^2 + displacement(2:2:end).^2), displacement(1:2:end), displacement(2:2:end), length(data.nodeid));
plot_stress_contour_map(data, nodal_stress);