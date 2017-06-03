%Generates arbitrary triangles using the MATLAB PDE Toolbox
disp('Creating arbitrary triangle mesh with MATLAB PDE Toolbox...');
model = createpde;
disp('WARNING: Press any key to open the PDE Toolbox. Create arbitrary triangles by clicking the simple triangle symbol. Save data via Draw-->Export Geometry Description. Then exit.');
pause;
pderect([Omega(1, :), Omega(2, :)]);
disp('Press any key again after saving the data and closing the toolbox.');
pause;
dl = decsg(gd,sf,ns);
ag = geometryFromEdges(model, dl);
meshdata = generateMesh(model);
pdeplot(model);
clear model gd sf ns dl ag;

%alternatively load variables via dat = matfile('PDEMesh.mat');