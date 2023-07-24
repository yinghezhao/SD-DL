import os
import math
import shutil
import numpy as np
import matplotlib.pyplot as plt

irange = range

def mkexperiment(config, cover=False):

    # Create directories if not exist
    if not os.path.exists(config.model_path):
        os.makedirs(config.model_path)
    if not os.path.exists(config.result_path):
        os.makedirs(config.result_path)

    experiment_path = os.path.join(config.result_path, config.name)
    if os.path.exists(experiment_path):
        if cover:
            shutil.rmtree(experiment_path)
            os.makedirs(experiment_path)
            os.makedirs(os.path.join(experiment_path, 'tensorboard'))
            os.makedirs(os.path.join(experiment_path, 'inter_result'))
        else:
            raise ValueError("Experiment '{}' already exists. Please modify the experiment name!"
                             .format(config.name))
    else:
        os.makedirs(experiment_path)
        os.makedirs(os.path.join(experiment_path, 'tensorboard'))
        os.makedirs(os.path.join(experiment_path, 'inter_result'))
    return experiment_path

def save_torch_result(tensor, save_dir, nrow = 4, padding = 0, pad_value = 0,format = 'jpg', cmap = 'gray',norm = False, crange = [0,1]):
    """
    save a given Tessor into an image file.
    tensor shape: [N, C, H, W] N:BatchSize, C:Channels, H:Height, W:Width
    """
    nmaps = tensor.size(0)

    xmaps = min(nrow,nmaps)
    ymaps = int(math.ceil(float(nmaps) / xmaps))
    height, width = int(tensor.size(2) + padding), int(tensor.size(3) + padding)
    grid = tensor.new(tensor.size(1), height * ymaps + padding, width * xmaps + padding).fill_(pad_value)
    k = 0
    for y in irange(ymaps):
        for x in irange(xmaps):
            if k >= nmaps:
                break
            grid.narrow(1, y * height + padding, height - padding) \
                .narrow(2, x * width + padding, width - padding) \
                .copy_(tensor[k])
            k = k + 1
    merge_img = np.squeeze(grid.permute(1, 2, 0).cpu().detach().numpy())
    # print(merge_img.shape)

    if norm:
        plt.imsave(save_dir + '.' + format, merge_img, cmap = cmap)
    else:
        plt.imsave(save_dir + '.' + format, merge_img, cmap=cmap, vmin=crange[0], vmax = crange[1])
