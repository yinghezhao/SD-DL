import torch
import torch.nn as nn


class conv_block(nn.Module):
    def __init__(self, ch_in, ch_out):
        super(conv_block, self).__init__()
        self.conv = nn.Sequential(
            nn.Conv2d(ch_in, ch_out, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.Conv2d(ch_out, ch_out, kernel_size=3, padding=1),
            nn.ReLU()
        )

    def forward(self, x):
        x = self.conv(x)
        return x


class up_conv(nn.Module):
    def __init__(self, ch_in, ch_out):
        super(up_conv, self).__init__()
        self.up = nn.Sequential(
            nn.Upsample(scale_factor=2),
            nn.Conv2d(ch_in, ch_out, kernel_size=3, padding=1),
            nn.ReLU()
        )

    def forward(self, x):
        x = self.up(x)
        return x


class outconv(nn.Module):
    def __init__(self, ch_in, ch_out):
        super(outconv, self).__init__()
        self.conv = nn.Sequential(
            nn.Conv2d(ch_in, ch_out, kernel_size=3, padding=1)
        )

    def forward(self, x):
        x = self.conv(x)
        return x


class Unet(nn.Module):
    def __init__(self, ch_in, ch_out):
        super(Unet, self).__init__()
        self.Conv1 = conv_block(ch_in=ch_in, ch_out=64)
        self.Conv2 = conv_block(ch_in=64, ch_out=128)
        self.Conv3 = conv_block(ch_in=128, ch_out=256)
        self.Conv4 = conv_block(ch_in=256, ch_out=512)

        self.Maxpool = nn.MaxPool2d(kernel_size=2, stride=2)

        self.up4 = up_conv(ch_in=512, ch_out=256)
        self.up_Conv4 = conv_block(ch_in=512, ch_out=256)

        self.up3 = up_conv(ch_in=256, ch_out=128)
        self.up_Conv3 = conv_block(ch_in=256, ch_out=128)

        self.up2 = up_conv(ch_in=128, ch_out=64)
        self.up_Conv2 = conv_block(ch_in=128, ch_out=64)

        self.Conv11 = outconv(64, ch_out)

    def forward(self, x):
        x1 = self.Conv1(x)

        x2 = self.Maxpool(x1)
        x2 = self.Conv2(x2)

        x3 = self.Maxpool(x2)
        x3 = self.Conv3(x3)

        x4 = self.Maxpool(x3)
        x4 = self.Conv4(x4)

        d4 = self.up4(x4)
        d4 = torch.cat((x3, d4), dim=1)
        d4 = self.up_Conv4(d4)

        # d3 = self.up3(x3)
        d3 = self.up3(d4)
        d3 = torch.cat((x2, d3), dim=1)
        d3 = self.up_Conv3(d3)

        d2 = self.up2(d3)
        d2 = torch.cat((x1, d2), dim=1)
        d2 = self.up_Conv2(d2)

        out = self.Conv11(d2)
        return out


class Unet_t2s(nn.Module):
    def __init__(self):
        super(Unet_t2s, self).__init__()
        self.Unet_M0 = Unet(ch_in=3, ch_out=1)
        self.Unet_t2s = Unet(ch_in=3, ch_out=1)

    def forward(self, x, Normtemap):
        M0 = self.Unet_M0(x)
        t2s = self.Unet_t2s(x)
        x_pred = M0 * torch.exp(Normtemap / t2s)

        return x_pred, t2s, M0
