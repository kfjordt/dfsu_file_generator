function element_displacement = calculate_line_displacement(end_point, start_point, thickness, Elmts, Nodes)

line_vector = end_point - start_point;
normalized_vector = line_vector / norm(line_vector);

ortho_vector = [-normalized_vector(2); normalized_vector(1)];

v1 = start_point + ortho_vector * ( thickness / 2 );    % Lower right
v2 = start_point - ortho_vector * ( thickness / 2 );    % Lower left
v3 = end_point + ortho_vector * ( thickness / 2 );      % Upper right
v4 = end_point - ortho_vector * ( thickness / 2 );      % Upper left

coord_matrix = [v1, v3, v4, v2];
line_polygon = polyshape(coord_matrix(1,:), coord_matrix(2,:));

element_amount = length(Elmts);
temp_displacement = zeros(element_amount, 1);

for kk=1:size(Elmts,1)
    current_element = Elmts(kk,:);
    
    vertex_1 = Nodes(current_element(1),1:2);
    vertex_2 = Nodes(current_element(2),1:2);
    vertex_3 = Nodes(current_element(3),1:2);
    
    current_polygon = polyshape([vertex_1(1) vertex_2(1) vertex_3(1)],[vertex_1(2) vertex_2(2) vertex_3(2)]);
    
    [in, out] = intersect(current_polygon, line_polygon);
    
    if isempty(in.Vertices) == 0 
        temp_displacement(kk) = 1;
    end
    
    element_displacement = temp_displacement;
    
end
