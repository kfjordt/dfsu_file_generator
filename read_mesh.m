function [Elmts,Nodes, proj, X, Y, Z, code] = read_mesh(mesh_file)

    full_path = fullfile("mesh/" + mesh_file + ".mesh");
    
    [Elmts,Nodes,proj] = mzReadMesh(full_path);
    X = Nodes(:,1);
    Y = Nodes(:,2);
    Z = Nodes(:,3);
    code = Nodes(:,4);
end
