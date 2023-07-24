import os

dir_root = '/DATA2023/zyh/rs-me-fMRI-test/'

tasks = ['fingerTapping', 'rest_run-1', 'rest_run-2']
# tasks = ['fingerTapping']

subs = ['001', '002', '003', '004', '005', '006', '007', '010', '011', '013', '015', '016', '017', '018', '019', '020',
        '021', '022', '023', '024', '025', '026', '027', '029', '030', '031', '032']
# subs = ['001']

# model_name = ['MEICA'];replace = 0;
model_name = ['MEICA_Unet_t2s_9_rician_3p'];replace = 1;

for task in tasks:
    dir_task = os.path.join(dir_root, task)
    for sub in subs:
        dir_sub = os.path.join(dir_task, 'sub-' + sub)
        for meica in model_name:
            dir_file = os.path.join(dir_sub, meica, 'cat_echo123.nii.gz')
            print(dir_file)
            dir_output = os.path.join(dir_sub, meica, 'tedana_output')
            print(dir_output)
            dir_t2s = os.path.join(dir_output, 't2s.nii')
            print(dir_t2s)
            if replace == 0:
                command = 'tedana -e 14 28 42 -d ' + dir_file + ' --out-dir ' + dir_output
            elif replace == 1:
                command = 'tedana -e 14 28 42 -d ' + dir_file + ' --out-dir ' + dir_output + ' --t2smap ' + dir_t2s

            os.system(command)
            print('Finished sub-' + sub + ' ' + task)
