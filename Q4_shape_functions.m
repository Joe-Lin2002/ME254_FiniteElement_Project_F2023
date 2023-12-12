function [N, dNdxi] = Q4_shape_functions(xi, eta)
    % Shape functions
    N = 1/4 * [(1-xi)*(1-eta);  % N1
                (1+xi)*(1-eta);  % N2
                (1+xi)*(1+eta);  % N3
                (1-xi)*(1+eta)]; % N4
    
    % Derivatives of the shape functions with respect to xi and eta
    % Shape functions derivatives with respect to xi and eta
    dNdxi = 1/4 * [-1+eta, 1-eta, 1+eta, -1-eta;  % dN/dxi
                   -1+xi, -1-xi,  1+xi, 1-xi];    % dN/deta

end
