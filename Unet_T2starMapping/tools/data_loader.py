import os
import random
import scipy.io as scio

from torch.utils import data
from torchvision import transforms as T
import torch

def load_data_mat(image_path, config):
    data = scio.loadmat(image_path)
    data_in = data.get('NormedSignal')
    input_sets = data_in[:, :, :3] # echo1,echo2,echo3
    label_sets = data_in[:, :, 3:5] # t2*, M0


    return input_sets, label_sets

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
        if len(self.image_paths) != 0:
            x, gt = self.getdata(0)
            self.x_data = torch.zeros(len(self.image_paths), x.shape[0], x.shape[1], x.shape[2])
            self.y_data = torch.zeros(len(self.image_paths), gt.shape[0], gt.shape[1], gt.shape[2])
            for i in range(len(self.image_paths)):
                x, y = self.getdata(i)
                self.x_data[i] = x
                self.y_data[i] = y

    def __getitem__(self, item):
        return self.x_data[item], self.y_data[item]

    def getdata(self, index):
        """Read an image from a file and preprocesses it and returns."""
        image_path = self.image_paths[index]
        image, GT = load_data_mat(image_path, self.config)

        if self.crop_key:
            # -----RandomCrop-----
            dims = image.shape
            w = dims[0]
            h = dims[1]
            # (w, h, c) = image.shape
            th, tw = self.crop_size, self.crop_size
            i = random.randint(0, h - th)
            j = random.randint(0, w - tw)
            if w <= th and h <= th:
                print("Error! Your input size is too small: %d is smaller than crop size %d " % (w, self.crop_size))
                return
            image = image[i:i + th, j:j + th, :]
            GT = GT[i:i + th, j:j + th]

        # -----To Tensor-----
        Transform = T.ToTensor() # (H,W,C) --> (C,H,W)
        image = Transform(image)
        GT = Transform(GT)

        return image, GT

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

