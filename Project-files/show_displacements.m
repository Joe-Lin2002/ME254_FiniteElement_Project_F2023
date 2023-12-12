function show_displacements(elemconn,coord,ut,ux,uy,NumNodes)

figure(1)


% Show mesh
mesh=zeros(NumNodes,1);
subplot(2,1,1)
  p=trisurf ( elemconn, coord(:,1), coord(:,2),mesh' );
  title('FEA Mesh');
  axis equal tight; 
  view(2);
  set(p,'edgecolor','k'); 
  set(p,'LineWidth',1); 
  set(p,'Marker','d');
  

% Show displacements  


subplot(2,1,2)

scale=1.;
displ=zeros(NumNodes,2);
displ(:,1)=ux*scale;
displ(:,2)=uy*scale;
distorted=coord+displ;
  %p=trisurf ( elemconn, distorted(:,1), distorted(:,2)+ut(:,2), ut' );
  p=trisurf ( elemconn, distorted(:,1), distorted(:,2), ut' );
  title('Displacement Values  Scale=1x')
  axis equal tight;
  view(2); 
  shading interp;
  colorbar;
  set(p,'edgecolor','k'); 
  set(p,'LineWidth',1); 
  set(gcf, 'color', 'white');
 
  