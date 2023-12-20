% Determine which conditions using
function D = PlaneStessStrain(matprop, plane_flag)
%Plane Stress or Strain
planechoice = plane_flag;
if planechoice==1
    nu = matprop(2);
    D = matprop(3)/(1-nu^2).*[1 nu 0
        nu 1 0
        0 0 (1-nu)/2];
else
    nu = matprop(2);
    D = matprop(3)/((1+nu)*(1-2*nu)).*[1-nu nu 0
        nu 1-nu 0
        0 0 1-2*nu];
end

end