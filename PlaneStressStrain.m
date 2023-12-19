% Determine which conditions using
function [E,t] = PlaneStessStrain(matprop)
%Plane Stress or Strain
planechoice = input('Enter 1 for plane stress, 2 for plane strain: ');
if planechoice==1
t=matprop(1);
nu = matprop(2);
E = matprop(3)/(1-nu^2).*[1 nu 0
                          nu 1 0
                          0 0 (1-nu)/2];
else
t=1;
nu = matprop(2);
E = matprop(3)/((1+nu)*(1-2*nu)).*[1-nu nu 0
                                   nu 1-nu 0
                                   0 0 1-2*nu];
end

end