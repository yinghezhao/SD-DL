# Synthetic Data-driven Deep Learning(SD-DL)

Example codes for multi-echo fMRI $T_{2}^{*}$ mapping using SD-DL.

**Author**: Yinghe Zhao (33320211150273@stu.xmu.edu.cn)

**Table of Conents**

- [Synthetic Data-driven Deep Learning(SD-DL)](#synthetic-data-driven-deep-learningsd-dl)
  - [Dependencies](#dependencies)
  - [Pipeline](#pipeline)
  - [Unet\_T2starMapping](#unet_t2starmapping)

## Dependencies

The deep learning codes have been tested in [Anaconda 3.6](https://repo.anaconda.com/archive/) with [Pytorch 1.6.0-cuda](https://pytorch.org/get-started/previous-versions/). 

The pre-processing codes have been tested in MATLAB R2018a.

- [tedana](https://tedana.readthedocs.io/en/stable/index.html) v0.0.12
- spm12
- DPABI
- TAPAS
- [ROCKETSHIP](https://github.com/petmri/ROEKETSHIP)

## Pipeline
`ParameterCongif.py`: This is the parameter configuration file, you can set the parameters in this file.

`CompareResults.py`: This is the code for comparing the results of different methods.

`main1.py`: This is the code for per-processing and GLM analyse for the multi-echo fMRI data. Remember Run `RunTedana.py` file after `CatData` function in `main1.py`.

`main2.py`: This is the code for per-processing and GLM analyse for the multi-echo fMRI data. Remember run `RunTedana.py` file after `CatData` function in `main2.py`. Remember run  `bingo_test.py` before run `main2.py`.

## Unet_T2starMapping

The codes in this directory were used to deep learning $T_{2}^{*}$  mapping.

`bingo_train.py`: This is the training code, you'd better run it in PyCharm IDE.

`bingo_test.py`: This is the testing code, make sure the trained model has been included in the `./models/` directory.

`network/UNet.py`: Network architecture of Unet.

