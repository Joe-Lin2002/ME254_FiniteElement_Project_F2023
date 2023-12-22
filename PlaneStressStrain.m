% Determine which conditions using
function D = PlaneStessStrain(matprop, plane_flag)
%Plane Stress or Strain
    nu = matprop(2);
    E = matprop(3);
    
    if flag == 1  % Reduced integration
        nu_r = 2/3 * nu;
    else
        nu_r = nu;
    end

    if plane_flag == 1  % Plane stress
        D = E / (1 - nu_r^2) * [1, nu_r, 0;
                                nu_r, 1, 0;
                                0, 0, (1 - nu_r) / 2];
    else  % Plane strain
        D = E / ((1 + nu_r) * (1 - 2 * nu_r)) * [1 - nu_r, nu_r, 0;
                                                  nu_r, 1 - nu_r, 0;
                                                  0, 0, (1 - 2 * nu_r) / 2];
    end
end


