function element_displacement = calculate_circle_displacement(Xe, Ye, circle_center, radius)
    c_x = circle_center(1);
    c_y = circle_center(2);
    
    element_amount = length(Xe);
    
    temp_displacement = zeros(element_amount, 1);
    
    for k = 1:element_amount
        pt_x = Xe(k);
        pt_y = Ye(k);
        
        if (pt_x-c_x)^2 + (pt_y-c_y)^2 < radius^2
            temp_displacement(k) = 1;
        else
            temp_displacement(k) = 0;
        end
    end
    
    element_displacement = temp_displacement;
    
end
