function Parameter = ParameterConfig()
Parameter.dir_source = '/DATA_Simu/zyh/rt-me-fMRI/'; % direction of rs-me-fMRI dataset
Parameter.dir_root = '/DATA2023/zyh/rs-me-fMRI-test/';  % direction where you want to save data files
Parameter.dir_model_source = '/DATA2023/zyh/trained_AR/'; % direction where you save Unet t2star mapping results
Parameter.dir_result = '/data2/zyh/Results/rs-me-fMRI-results/'; % direction where you want save comparison matrix results.
Parameter.dir_Normed = '/DATA2023/zyh/train_Normed_AR_test/'; % direction where you save the file transferred to the Unet t2star mapping model.
Parameter.dir_DPABI = '/DATA2023/zyh/rs-me-fMRI-DPABI/'; % direction where you save dpabi processing data and results.
Parameter.dir_Template = '/data2/zyh/CODE/SDM-DL/dependences/Template/';
Parameter.subs = {'001','002','003','004','005','006','007','010','011','013','015','016','017','018','019','020','021','022','023','024','025','026','027','029','030','031','032'};

Parameter.TR = 2;
Parameter.TE = [14 28 42];
Parameter.use_phy = 1;
Parameter.VoxelNumber = [64, 64, 34];
Parameter.TotalTimepoints = 210;
Parameter.minimum = 0;
Parameter.maxT2 = 0.6;
Parameter.level = 0.1;
Parameter.MaskTimepoint = 1; 
Parameter.VoxelSize = [3.5, 3.5, 3.5];
Parameter.datatype = 16;
Parameter.TaskOnsets = [11; 31; 51; 71; 91; 111; 131; 151; 171; 191];
Parameter.TaskDurations = [10;10;10;10;10;10;10;10;10;10];
Parameter.AutoSave = 1;
Parameter.DelTempFiles = 1;
Parameter.CalTSNRTimePeriod = [10,100];
end