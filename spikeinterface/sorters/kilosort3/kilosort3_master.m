function kilosort3_master(fpath, kilosortPath)
    try
        set(groot,'defaultFigureVisible', 'off');

        % prepare for kilosort execution
        addpath(genpath(kilosortPath));

        % add npy-matlab functions (copied in the output folder)
        addpath(genpath(fpath));

        % Load channel map file
        load(fullfile(fpath, 'chanMap.mat'));

        % Load the configuration file, it builds the structure of options (ops)
        load(fullfile(fpath, 'ops.mat'));

        % preprocess data to create temp_wh.dat
        rez = preprocessDataSub(ops);

        % run data registration
        rez = datashift2(rez, 1); % last input is for shifting data

        [rez, st3, tF] = extract_spikes(rez);

        rez = template_learning(rez, tF, st3);

        [rez, st3, tF] = trackAndSort(rez);

        rez = final_clustering(rez, tF, st3);

        % final merges
        rez = find_merges(rez, 1);

        % output to phy
        fprintf('Saving results to Phy\n')
        rezToPhy2(rez, fpath);

    catch
        fprintf('----------------------------------------');
        fprintf(lasterr());
        quit(1);
    end
    quit(0);
end