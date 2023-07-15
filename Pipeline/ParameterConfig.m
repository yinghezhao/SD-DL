function Parameter = ParameterConfig()
Parameter.dir_source = 'F:\dataset\rt-me-fMRI\';
Parameter.dir_root = 'D:\MyData\rt-me-fMRI-retry\';
Parameter.dir_model_source = '/DATA2023/zyh/trained_AR/';
Parameter.dir_result = 'D:\1-积累\My Github\SDM-DL\Pipeline\results';
Parameter.dir_Normed = 'D:\MyData\train_Normed_t2s_AR';
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