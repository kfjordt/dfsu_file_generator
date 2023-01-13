clear 
CONFIG_FOLDER = "simulation_configs";

[y, Fs] = audioread('resources\TSUNAMI.mp3');
sound(y, Fs);

all_config_files = dir(fullfile(CONFIG_FOLDER));
all_config_files([all_config_files.isdir]) = [];    

for i = 1 :  length(all_config_files)
  current_filename = fullfile(CONFIG_FOLDER, all_config_files(i).name);
  current_file = fopen(current_filename, 'r');
  
  file_content = fread(current_file);
  json_string = char(file_content');
  
  [mesh_file, export_path, start_time, step_size, amount_of_timesteps, displacement_factor, tsunamis] = parse_json_file(json_string);
  
  [Elmts, Nodes, proj, X, Y, Z, code] = read_mesh(mesh_file);
  element_amount = length(Elmts);

  [Xe,Ye,Ze] = mzCalcElmtCenterCoords(Elmts, X, Y, Z);
  
  element_displacement = zeros(element_amount, 1);
  
  for j = 1:length(tsunamis)
      current_tsunami = tsunamis(j);
      tsunami_type = current_tsunami{1}.type;
      
      if tsunami_type == "circle"
          circle_center = current_tsunami{1}.center;
          circle_radius = current_tsunami{1}.radius;
          
          current_element_displacement = calculate_circle_displacement(Xe,Ye, circle_center, circle_radius);

          element_displacement = element_displacement + current_element_displacement;
          
      elseif tsunami_type =="line"
          start_point = current_tsunami{1}.startpoint;
          end_point = current_tsunami{1}.endpoint;
          thickness = current_tsunami{1}.thickness;
          
          current_element_displacement = calculate_line_displacement(start_point, end_point, thickness, Elmts, Nodes);
          
          element_displacement = element_displacement + current_element_displacement;
      end
      
  end
  
  element_displacement = element_displacement * displacement_factor;
    
  dfsu_file = create_dfsu_file(export_path, start_time, step_size, proj, X, Y, Z, code, Elmts);
  
  error_flag = 0;
  
  for ii=0:amount_of_timesteps
    try 
        if ii == 0
            dfsu_file.WriteItemTimeStepNext(0, NET.convertArray(single(zeros(element_amount,1))))
        else
            dfsu_file.WriteItemTimeStepNext(0, NET.convertArray(single(element_displacement)))
        end
    catch 
        error_flag = 1;
    end
    
  end
  
  if error_flag == 1
      disp("An error occured")
  end
  
    dfsu_file.Close()
  
end
