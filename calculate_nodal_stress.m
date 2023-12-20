function nodal_stress = calculate_nodal_stress(data, displacement, B, plane_flag)
    % Initialize nodal stress array
    nodal_stress = zeros(length(data.nodeid), 3);  % For 2D: sigma_x, sigma_y, tau_xy
    nodal_stress_count = zeros(length(data.nodeid), 1);  % To count the contributions for averaging

    % Material properties
    E = data.matprop(3);   % Young's modulus
    nu = data.matprop(2);  % Poisson's ratio

    % Plane stress constitutive matrix
    D = PlaneStressStrain(data.matprop, plane_flag);

    % Iterate over each element to calculate stress
    for i = 1:size(data.elemconn, 1)
        % Get the global node indices for the current element
        element_nodes = data.elemconn(i, :);

        % Get the displacement vector for the current element
        element_displacement_indices = [2*element_nodes-1; 2*element_nodes];
        element_displacement_indices = element_displacement_indices(:);
        element_displacements = displacement(element_displacement_indices);

        % Calculate the strain for the element using B matrix
        element_strain = B * element_displacements;

        % Calculate the stress for the element
        element_stress = D * element_strain;

        % Distribute the element stress to the nodes and count for averaging
        for j = 1:length(element_nodes)
            node = element_nodes(j);
            nodal_stress(node, :) = nodal_stress(node, :) + element_stress';
            nodal_stress_count(node) = nodal_stress_count(node) + 1;
        end
    end

    % Average the stress at each node
    for i = 1:length(data.nodeid)
        if nodal_stress_count(i) > 0
            nodal_stress(i, :) = nodal_stress(i, :) / nodal_stress_count(i);
        end
    end
end
