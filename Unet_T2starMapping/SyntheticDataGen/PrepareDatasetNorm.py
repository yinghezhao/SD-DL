import os
import shutil
import os

dir_DatasetNorm = '/data2/zyh/CODE/t2star_fitting_sup/dataset_norm'
dir_template = '/data2/zyh/template/MESignal_t2s_Norm_Rayleigh_sup_3p'

dir_DN_train = dir_DatasetNorm + '/train'
dir_DN_test = dir_DatasetNorm + '/test'
dir_DN_brain = dir_DatasetNorm + '/brain'

delete = 1
if not os.path.exists(dir_DatasetNorm):
    os.mkdir(dir_DatasetNorm)
if delete:
    shutil.rmtree(dir_DatasetNorm)
    os.mkdir(dir_DatasetNorm)
    os.mkdir(dir_DN_train)
    os.mkdir(dir_DN_test)
    os.mkdir(dir_DN_brain)

NumTrain = 4500
NumTest = 895
NumBrain = 5

count = len(os.listdir(dir_template)) # totally 5400 files
if count == (NumTrain + NumTest + NumBrain):
    # copy datasets
    print('Preparing Datasets......')
    for num_i in range(count):
        file_name = dir_template + '/NormedMESignal_' + str(num_i + 1) + '.mat'

        if num_i + 1 <= NumTrain:
            shutil.copy(file_name, dir_DN_train)
        elif NumTrain < num_i + 1 and num_i + 1 <= NumTrain + NumTest:
            shutil.copy(file_name, dir_DN_test)
        elif NumTrain + NumTest < num_i + 1 and num_i + 1 <= NumTrain + NumTest + NumBrain:
            shutil.copy(file_name, dir_DN_brain)
else:
    print(
        'Total number of templates is {} \n Please check number of train({})/test({})/brain({})/Total({}) data'.format(
            count, NumTrain, NumTest, NumBrain, (NumTrain + NumTest + NumBrain)))

print('Finished all!')
