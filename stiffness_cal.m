function K = stiffness_cal(coordinates, matprop, flag)
%% Connectivity matrix
elements = [1, 2, 3, 4];

t = matprop(1);
v = matprop(2);
E = matprop(3);

%% Define Gauss quadrature points and weights for full integration
% Flag: 1 for reduced integration, 2 for full integration
[gauss_points,weights] = ReducedFull(flag);

%% Initialize global stiffness matrix
K = zeros(8, 8);

%% Assemble stiffness matrix
for i = 1:size(elements, 1)
    % Extract nodal coordinates for the current element
    % Extract nodal coordinates for the current element
    element_nodes = elements(i, :);
    node_coords = coordinates(element_nodes, :);

    % Perform numerical integration using Gauss quadrature
    for gp = 1:length(weights)
        xi = gauss_points(gp, 1);
        eta = gauss_points(gp, 2);
        w = weights(gp);

        % Compute shape functions and their derivatives
        [N, dNdxi] = Q4_shape_functions(xi, eta);

        % Compute Jacobian matrix and its determinant
        % Here, dNdxi is a 2x4 matrix, and node_coords is a 4x2 matrix
        J = dNdxi * node_coords;  % Transpose dNdxi to get a 4x2 matrix
        detJ = det(J);

        % Construct B matrix (strain-displacement matrix)
        alpha = [1,0,0,0;
                0,0,0,1;
                0,1,1,0];
        beta = [J^-1,zeros(2,2);zeros(2,2),J^-1];
        gamma = [dNdxi(1,1),0,dNdxi(1,2),0,dNdxi(1,3),0,dNdxi(1,4),0;
                dNdxi(2,1),0,dNdxi(2,2),0,dNdxi(2,3),0,dNdxi(2,4),0;
                0,dNdxi(1,1),0,dNdxi(1,2),0,dNdxi(1,3),0,dNdxi(1,4);
                0,dNdxi(2,1),0,dNdxi(2,2),0,dNdxi(2,3),0,dNdxi(2,4);];
        B = alpha*beta*gamma;

        % Material matrix
        D = (E/(1-v^2)) * [1, v, 0;
            v, 1, 0;
            0, 0, (1-v)/2];

        % Compute element stiffness matrix
        I = B' * D * B * w * detJ * t;
        K = K + I;
    end
end
end