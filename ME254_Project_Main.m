% Main file for the project
%% ME254_Project_Main, Cady Brunecz, Junyi Lin, Dec11 2023

%% Housekeeping
clear all;
close all;

%% Inputting File
directory = 'Project-files/input_fine_mesh/'; % Input files directory
data = read_input(directory); % Input Reading

%% Finding Stiffness Matrix
% Flag: 1 for reduced integration, 2 for full integration
flag = 1;
% plane_flag: 1 for plane stress, 2 for plane strain
plane_flag = 1;

for i = 1:size(data.elemconn,1)
    [stiff_local{i}, B{i}] = stiffness_cal([data.coord(data.elemconn(i,1:4),1),data.coord(data.elemconn(i,1:4),2)], ...
        data.matprop, flag, plane_flag);
end

%% Global Stiffness Matrix Assemble
stiff_global = zeros(2*length(data.nodeid)); % Preallocate the global stiffness matrix

% Create a mapping array from local to global node numbers
node_mapping = zeros(max(data.elemconn(:)), 1);
node_mapping(data.nodeid) = 1:length(data.nodeid);

% Assemble the global stiffness matrix using the mapping
for i = 1:length(stiff_local)
    K_local = stiff_local{i};
    element_nodes = data.elemconn(i,:);
    global_nodes = node_mapping(element_nodes);
    
    % Identify global degrees of freedom for the element
    global_dofs = [2 * global_nodes - 1, 2 * global_nodes];
    
    % Check the ordering of nodes and DOFs
   disp(['Element ' num2str(i) ': Local Nodes ' num2str(element_nodes) ', Global Nodes ' num2str(global_nodes') ', Global DOFs ' num2str(global_dofs(1)) ' ' num2str(global_dofs(2))]);

    
    % Assemble the local stiffness matrix into the global stiffness matrix
    stiff_global(global_dofs(:), global_dofs(:)) = ...
        stiff_global(global_dofs(:), global_dofs(:)) + K_local(:,:);
end

%% Apply boundary conditions
for i = 1:length(data.nodeid)
    if data.bc_code(i,1) == 1
        dof_x = 2*i - 1;
        stiff_global(:, dof_x) = 0;
        stiff_global(dof_x, :) = 0;
        stiff_global(dof_x, dof_x) = 1e6; % Large number
    end
    if data.bc_code(i,2) == 1
        dof_y = 2*i;
        stiff_global(:, dof_y) = 0;
        stiff_global(dof_y, :) = 0;
        stiff_global(dof_y, dof_y) = 1e6; % Large number
    end
end


force = reshape([data.loads],size(stiff_global,1),1);
stiff_global = stiff_global + 1e-6 * eye(size(stiff_global));
displacement = gmres(stiff_global, force, [], 1e-6);

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