function dfsu_file = create_dfsu_file(export_path, start_time_str, time_step, proj, X, Y, Z, code, Elmts)

    % Load necessary .dll libraries
    NETaddAssembly('DHI.Generic.MikeZero.EUM.dll');
    NETaddAssembly('DHI.Generic.MikeZero.DFS.dll');
    import DHI.Generic.MikeZero.DFS.*;
    import DHI.Generic.MikeZero.DFS.dfsu.*;
    import DHI.Generic.MikeZero.*
  
    factory = DfsFactory();
    builder = DfsuBuilder.Create(DfsuFileType.Dfsu2D);

    % Create a temporal definition matching input file
    start_time = split(start_time_str, "-");
    
    year = str2double(start_time{1});
    month = str2double(start_time{2});
    day = str2double(start_time{3});
    hour = str2double(start_time{4});
    minute = str2double(start_time{5});
    second = str2double(start_time{6});
    
    start = System.DateTime(year, month, day, hour, minute, second);
    builder.SetTimeInfo(start, time_step);

    % Create a spatial defition based on mesh input file
    builder.SetNodes(NET.convertArray(X),NET.convertArray(Y),NET.convertArray(single(Z)),NET.convertArray(int32(code)));
    builder.SetElements(mzNetToElmtArray(Elmts));
    builder.SetProjection(factory.CreateProjection(proj))

    % Add bed level change
    builder.AddDynamicItem('Bed level change', eumQuantity(eumItem.eumIBedLevelChange,eumUnit.eumUmeter));

    % Create the file - make it ready for data
    dfsu_file = builder.CreateFile(export_path);
end
