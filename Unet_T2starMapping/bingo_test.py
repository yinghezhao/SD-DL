import os
import torch
import random
import numpy as np
import scipy.io as scio
import argparse

from network.Unet import Unet_t2s

from torch.utils import data
from torchvision import transforms as T


def Reshape2D(dir_src, dir_des, modality, Nx, Ny, Ns, delete_files=True):
    dir_search = dir_src + '/' + modality + '/'
    Nt = int(len(os.listdir(dir_search)) / Ns)
    if modality != 'Signals_Pred':
        outputdata = np.zeros((Nx, Ny, Ns, Nt))
    else:
        outputdata = np.zeros((Nx, Ny, Ns, Nt, 3))
    for i in os.listdir(dir_search):
        dir_data = dir_search + '/' + i
        slice = int(i.split('_s')[-1].split('.')[0])
        time = int(i.split('_t')[-1].split('_s')[0])

        data_t = scio.loadmat(dir_data)['output']
        if modality != 'Signals_Pred':
            outputdata[:, :, slice - 1, time - 1] = np.squeeze(data_t)
        else:
            outputdata[:, :, slice - 1, time - 1, :] = np.squeeze(data_t)
        save_name = i.split('_s')[0][:-5] + '.mat'

    if not os.path.exists((dir_des + '/Reshaped/')):
        os.mkdir((dir_des + '/Reshaped/'))
    if not os.path.exists((dir_des + '/Reshaped/' + modality + '/')):
        os.mkdir((dir_des + '/Reshaped/' + modality + '/'))
    save_dir = dir_des + '/Reshaped/' + modality + '/' + save_name

    label_var = {"output": outputdata}
    scio.savemat(save_dir, label_var)
    print(save_dir)

    if delete_files:
        for i in os.listdir(dir_search):
            dir_data = dir_search + '/' + i
            os.remove(dir_data)
    print('Temp files deleted')


def load_Normeddata_mat(image_path, config):
    data = scio.loadmat(image_path)
    data_in = data.get('Normed_data')  # 64 64 3
    label_sets = np.zeros(data_in.shape)  # useless

    return data_in, label_sets


class ImageFolder(data.Dataset):

    def __init__(self, root, config, crop_key, mode='train'):
        """Initialize image paths and preprocessing module."""
        self.config = config
        self.root = root
        self.mode = mode
        self.crop_key = crop_key
        self.crop_size = config.CROP_SIZE
        self.image_dir = os.path.join(root, mode)

        self.image_paths = list(map(lambda x: os.path.join(self.image_dir, x), os.listdir(self.image_dir)))
        print("image count in {} path :{}".format(self.mode, len(self.image_paths)))
        self.image_paths.sort(reverse=True)

    def __getitem__(self, index):
        """Read an image from a file and preprocesses it and returns."""
        image_path = self.image_paths[index]
        image, GT = load_Normeddata_mat(image_path, self.config)

        if self.crop_key:
            # -----RandomCrop-----
            (w, h, c) = image.shape
            th, tw = self.crop_size, self.crop_size
            i = random.randint(0, h - th)
            j = random.randint(0, w - tw)
            if w <= th and h <= th:
                print("Error! Your input size is too small: %d is smaller than crop size %d " % (w, self.crop_size))
                return
            image = image[i:i + th, j:j + th, :]
            GT = GT[i:i + th, j:j + th, :]

        # -----To Tensor-----
        Transform = T.ToTensor()
        image = Transform(image)
        GT = Transform(GT)

        return image, GT, image_path

    def __len__(self):
        """Return the total number of this dataset"""
        return len(self.image_paths)


def get_loader(image_path, config, crop_key, num_workers, shuffle=True, mode='train'):
    """Builds and returns Dataloader"""
    dataset = ImageFolder(root=image_path, config=config, crop_key=crop_key, mode=mode)
    data_loader = data.DataLoader(dataset=dataset,
                                  batch_size=config.BATCH_SIZE,
                                  shuffle=shuffle,
                                  num_workers=num_workers,
                                  pin_memory=True)
    return data_loader


def save_results2mat(variable, image_path, result_path, result_type):
    """save data to mat file """
    # get filename
    filename_var = image_path[0].split("/")[-1].split(".")[0] + '.mat'
    save_var = result_path + '/' + result_type + '/'
    if not os.path.exists(save_var):
        os.mkdir(save_var)
    save_var_dir = os.path.join(save_var, filename_var)
    label_var = {"output": variable}
    scio.savemat(save_var_dir, label_var)


def test(config):
    # -----GPU-----#
    os.environ['CUDA_VISIBLE_DEVICES'] = config.GPU_NUM

    # -----random seed-----#
    np.random.seed(1)
    torch.manual_seed(1)

    # -----path-----#
    model_dir = os.path.join(config.model_path, config.name + '/' + config.name + '_epoch_' + config.model_num + '.pth')
    if not os.path.exists(model_dir):
        print('Model not found, please check you path to model')
        os._exit(0)
    if not os.path.exists(config.result_path):
        os.makedirs(config.result_path)

    # -----dataloader-----#
    test_batch = get_loader(config.data_dir, config, crop_key=False, num_workers=1, shuffle=False, mode=config.test_dir)

    # -----model-----#
    net = Unet_t2s()

    if torch.cuda.is_available():
        net.cuda()

    # -----modelloader-----#
    torch.load(model_dir)
    net.load_state_dict(torch.load(model_dir))
    print('Model parameters loaded!')

    # Setup device
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    # ********************************************test*****************************************************#
    temap_test = torch.Tensor(config.tes).expand(config.INPUT_H, config.INPUT_W, 3).permute(2, 0,
                                                                                            1)  # tensor H W C -- C H W
    Normtemap_test = - temap_test
    Normtemap_test = Normtemap_test.to(device)

    with torch.no_grad():
        for i, (images, GT, image_path) in enumerate(test_batch):
            images = images.type(torch.FloatTensor)

            images = images.to(device)

            X_pred, t2s, M0 = net(images, Normtemap_test)  # B C H W

            OUT_test_t2s = t2s.permute(0, 2, 3, 1).cpu().detach().numpy()  # B C H W -- B H W C
            # save t2s data to mat file
            save_results2mat(OUT_test_t2s, image_path, config.result_path, config.result_type)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    # experiment name
    parser.add_argument('--name', type=str, default='experiment')
    parser.add_argument('--data_dir', type=str, default='./dataset_test/')
    parser.add_argument('--GPU_NUM', type=str, default='4')

    # model hyper-parametersps
    parser.add_argument('--INPUT_H', type=int, default=64)
    parser.add_argument('--INPUT_W', type=int, default=64)
    parser.add_argument('--INPUT_D', type=int, default=34)

    parser.add_argument('--CROP_KEY', type=bool, default=False)
    parser.add_argument('--CROP_SIZE', type=int, default=32)

    # test hyper-parameters
    parser.add_argument('--BATCH_SIZE', type=int, default=1)

    parser.add_argument('--model_path', type=str, default='./models/')
    parser.add_argument('--model_num', type=str, default='500')

    parser.add_argument('--test_dir', type=str, default='')

    parser.add_argument('--tes', type=list, default=[0.014, 0.028, 0.042])
    parser.add_argument('--result_path', type=str,
                        default='/DATA_Inter/zyh/trained_MEEPI/rest_run-1/Unet_echo2/sub-001/')
    parser.add_argument('--result_type', type=str, default='t2s')

    config = parser.parse_args()
    config.model_num = '300'
    config.name = 'Unet_t2s_rician_3p'
    config.result_type = 't2s'
    tasknames = ['fingerTapping', 'rest_run-1', 'rest_run-2']
    average = True

    for taskname in tasknames:
        if average:
            fn_all = os.path.join('/DATA2023', 'zyh', 'train_Normed_MEEPI_AR', 'average', taskname)
            res_root = os.path.join('/DATA2023', 'zyh', 'trained_AR', 'average',taskname, config.name)
        else:
            fn_all = os.path.join('/DATA2023', 'zyh', 'train_Normed_MEEPI_AR', taskname)
            res_root = os.path.join('/DATA2023', 'zyh', 'trained_AR', taskname, config.name)
        if not os.path.exists(res_root):
            os.mkdir(res_root)
        config.data_dir = fn_all

        fn_list = os.listdir(fn_all)
        print(fn_list)

        for fn_sub in fn_list:
            dir_sub = os.path.join(fn_all, fn_sub)
            result_sub = os.path.join(res_root, fn_sub)
            config.test_dir = dir_sub
            config.result_path = result_sub
            if not os.path.exists(result_sub):
                os.mkdir(result_sub)
            print(dir_sub)
            print(result_sub)
            test(config)
            Reshape2D(result_sub, res_root, config.result_type, config.INPUT_H, config.INPUT_W, config.INPUT_D)
        print('Finished all!')
