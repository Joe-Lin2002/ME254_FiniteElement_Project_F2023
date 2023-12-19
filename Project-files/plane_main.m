
% read the data files
load coord.txt
load elemconn.txt
load bc_code.txt
load loads.txt
load matprop.txt

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

%Full or reduced integration
intchoice = input('Enter 1 for reduced integration, 2 for full integration: ');

% determine work size
NumNodes=size(coord,1);
NumElements=size(elemconn,1);
ID=zeros(NumNodes, 2);
E=zeros(3,3);
u=zeros(2*NumNodes,1);
ux=zeros(NumNodes,1);
uy=zeros(NumNodes,1);
ut=zeros(NumNodes,1);
SE=zeros(8,8);
%J=zeros(2,2);

X=zeros(NumNodes);
Y=zeros(NumNodes);
X=coord(:,1);
Y=coord(:,2);

% Intergration order
%int_points=2;


% Get nodal DOF Equations
%ID=equations(NumNodes, bc_code);

% Generate the elasticity matrix
%E=elasticity(matprop, planechoice);

%Generate Global Stiffness Matrix
%N=nsize(NumNodes,ID);
%K=zeros(N);

% Generate the force vector

% Solve for the displacements

% Recover the displacements for all nodes

% Calculate the Elemental Stresses at Centroid
% Along with Elemantal VonMises and Principal Stresses

% See the results

show_displacements(elemconn, coord,ut,ux,uy,NumNodes);
