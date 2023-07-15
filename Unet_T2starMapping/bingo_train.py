import os
import csv
import argparse
import numpy as np
import time

import torch
import torch.nn as nn
import torch.optim as optim

from tensorboardX import SummaryWriter
from tools.data_loader import get_loader
from tools.misc import mkexperiment
from tools.misc import save_torch_result
from network.Unet import Unet_t2s


def main(config):
    # -----GPU-----
    os.environ['CUDA_VISIBLE_DEVICES'] = config.GPU_NUM
    torch.backends.cudnn.benchmark = True

    # -----random seed-----
    np.random.seed(1)
    torch.manual_seed(1)
    time2 = 0

    # -----Experiment-----
    experiment_path = mkexperiment(config, cover=True)
    save_inter_result = os.path.join(experiment_path, 'inter_result')
    model_path = os.path.join(config.model_path, config.name)

    # -----dataloader-----
    data_dir = config.data_dir
    train_batch = get_loader(data_dir, config, crop_key=config.CROP_SIZE, num_workers=config.NUM_WORKERS, shuffle=True,
                             mode='train')
    val_batch = get_loader(data_dir, config, crop_key=False, num_workers=config.NUM_WORKERS, shuffle=True, mode='test')
    brain_batch = get_loader(data_dir, config, crop_key=False, num_workers=config.NUM_WORKERS, shuffle=False,
                             mode='brain')

    # -----Model-----
    net = Unet_t2s()

    # -----Loss Function-----
    criterion = nn.MSELoss()

    if torch.cuda.is_available():
        net.cuda()
        criterion.cuda()

    # -----Optimizer-----
    optimizer = optim.Adam(net.parameters(), lr=config.lr, betas=(config.beta1, config.beta2))

    # -----Setup device-----
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    # -----Tensorboard-----
    Writer_train = SummaryWriter(os.path.join(os.path.join(config.experiment_path, 'tensorboard'), 'train'))
    Writer_val = SummaryWriter(os.path.join(os.path.join(config.experiment_path, 'tensorboard'), 'val'))

    # -----csv-----
    f = open(os.path.join(config.experiment_path, 'result.csv'), 'a', encoding='utf-8', newline='')
    wr = csv.writer(f)
    wr.writerow(['train loss', 'val loss', 'val nmse', 'lr', 'total_iters', 'epochs'])

    temap = torch.Tensor(config.tes).expand(config.CROP_SIZE, config.CROP_SIZE, 3).permute(2, 0, 1)
    Normtemap = - temap
    temap_test = torch.Tensor(config.tes).expand(config.INPUT_H, config.INPUT_W, 3).permute(2, 0, 1)
    Normtemap_test = - temap_test
    if config.CROP_KEY == False:
        Normtemap = Normtemap_test
    Normtemap = Normtemap.to(device)
    Normtemap_test = Normtemap_test.to(device)

    if config.mode == 'train':
        total_iters = 0
        print("Start Training......")
        for epoch in range(1, config.num_epochs + 1):
            net = net.train()
            train_loss = 0
            train_length = 0
            val_loss = 0
            val_length = 0

            # ******************************train******************************
            for i, (image, GT) in enumerate(train_batch):

                images = image.type(torch.FloatTensor)
                images = images.to(device)
                GT = GT.type(torch.FloatTensor)
                GT = GT.to(device)

                optimizer.zero_grad()  # clear grad

                x_pred, t2s, M0 = net(images, Normtemap)

                loss_l2_t2s = criterion(GT[:, 0, :, :], torch.squeeze(t2s)) # GT[:, 0, :, :]-B HW
                loss_l2 = loss_l2_t2s # t2s loss
                loss = loss_l2
                train_loss += loss.item()

                loss.backward()  # backward
                optimizer.step()  # update

                train_length += image.size(0)
                total_iters += 1

                # learning rate decay
                if (total_iters % config.lr_update) == 0:
                    for param_group in optimizer.param_groups:
                        param_group['lr'] = param_group['lr'] * 0.8

                if total_iters % config.step == 0:
                    lr = optimizer.param_groups[0]['lr']
                    # ******************************val******************************
                    with torch.no_grad():
                        for i, (images_val, GT_val) in enumerate(val_batch):
                            images_val = images_val.type(torch.FloatTensor)
                            images_val = images_val.to(device)
                            GT_val = GT_val.type(torch.FloatTensor)
                            GT_val = GT_val.to(device)

                            x_pred_val, t2s_val, M0_val = net(images_val, Normtemap_test)

                            loss_l1_val_t2s = criterion(GT_val[:, 0, :, :], torch.squeeze(t2s_val))
                            loss_l1_val = loss_l1_val_t2s # t2s loss
                            loss_val = loss_l1_val

                            val_loss += loss_val.item()
                            val_length += images_val.size(0)

                        # Print the log info
                        time1 = time.clock()
                        temp_time = time1 - time2
                        print(
                            "Epoch [%d/%d], Total iters [%d], Train loss: %.9f, Val loss: %.9f, lr: %.5f, time: %.3f" % (
                                epoch, config.num_epochs, total_iters,
                                train_loss / train_length, val_loss / val_length, lr, temp_time
                            ))
                        time2 = time.clock()
                        Writer_train.add_scalar('data/loss', train_loss / train_length, total_iters)
                        Writer_val.add_scalar('data/loss', val_loss / val_length, total_iters)
                        wr.writerow([train_loss / train_length, val_loss / val_length, lr, total_iters, epoch])

                        train_loss = 0
                        train_length = 0
                        val_loss = 0
                        val_length = 0

                        # ******************************test brain******************************
                        for i, (brain_images, _) in enumerate(brain_batch):
                            brain_images = brain_images.type(torch.FloatTensor)
                            brain_images = brain_images.to(device)
                            x_pred_brain, t2s_brain, M0_brain = net(brain_images, Normtemap_test)

                            save_dir = os.path.join(save_inter_result, 'inter_t2s_' + str(total_iters) + '_brain')
                            save_torch_result(t2s_brain, save_dir, format='png', cmap='jet', norm=False,
                                              crange=[0, 0.2])
            # -----save model-----
            if (epoch) % config.model_save_step == 0 and epoch > config.model_save_start:
                if not os.path.exists(model_path):
                    os.mkdir(model_path)
                torch.save(net.state_dict(), model_path + '/' + config.name + '_epoch_' + str(epoch) + '.pth')

        f.close()
        Writer_train.close()
        Writer_val.close()


if __name__ == '__main__':
    parse = argparse.ArgumentParser()

    # experiment name
    parse.add_argument('--name', type=str, default='experiment')
    parse.add_argument('--experiment_path', type=str, default='')
    parse.add_argument('--data_dir', type=str, default='./dataset_norm')
    parse.add_argument('--GPU_NUM', type=str, default='3')

    # model hyper-parameters
    parse.add_argument('--INPUT_H', type=int, default=64)
    parse.add_argument('--INPUT_W', type=int, default=64)

    parse.add_argument('--CROP_KEY', type=bool, default=True)
    parse.add_argument('--CROP_SIZE', type=int, default=32)

    # training hyper-parameters
    parse.add_argument('--num_epochs', type=int, default=500)
    parse.add_argument('--BATCH_SIZE', type=int, default=256)
    parse.add_argument('--NUM_WORKERS', type=int, default=1)
    parse.add_argument('--lr', type=float, default=1e-4)
    parse.add_argument('--lr_update', type=float, default=40000)
    parse.add_argument('--beta1', type=float, default=0.9)
    parse.add_argument('--beta2', type=float, default=0.999)
    parse.add_argument('--regular', type=float, default=0.001)
    parse.add_argument('--step', type=int, default=500)
    parse.add_argument('--model_save_start', type=int, default=1)
    parse.add_argument('--model_save_step', type=int, default=100)

    # misc
    parse.add_argument('--mode', type=str, default='train')
    parse.add_argument('--model_path', type=str, default='./models')
    parse.add_argument('--result_path', type=str, default='./results')

    parse.add_argument('--tes', type=list, default=[0.014, 0.028, 0.042])

    config = parse.parse_args()

    config.name = 'Unet_t2s_rician_3p'
    print(config.name)
    main(config)
