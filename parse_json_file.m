function [mesh_file, export_path, start_time, step_size, amount_of_timesteps, displacement_factor, tsunamis] = parse_json_file(raw_json_string)
    json_object = jsondecode(raw_json_string);
    
    mesh_file = json_object.meshfile;
    export_path = json_object.exportpath;
    start_time = json_object.starttime;
    step_size = json_object.stepsize;
    amount_of_timesteps = json_object.amount_of_timesteps;
    displacement_factor = json_object.displacement_factor;
    tsunamis = struct2cell(json_object.tsunamis);
end
