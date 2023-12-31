import os
import numpy as np
import scipy.io as scio
import random

def GenerateNormedTemplate_t2s(dir_root, dir_destination, TE_value, sigma=0.01, noise_type='rician', rand = False):
    for filepath, dirnames, filenames in os.walk(dir_root):
        for filename in filenames:
            dir_mat = os.path.join(filepath, filename)
            data = scio.loadmat(dir_mat)
            Templatedata = data.get('Template')
            M0 = Templatedata[:, :, 0]
            t2s = Templatedata[:, :, 1]
            max_M0 = M0.max()

            echos = len(TE_value)
            [Nx, Ny] = t2s.shape
            Template = np.zeros((Nx, Ny, echos))
            save_data = np.zeros((Nx, Ny, echos + 2))
            for echo in range(echos):
                Template[:, :, echo] = np.multiply(M0, np.exp(- np.array(TE_value[echo]) / t2s))
            Template[np.isinf(Template)] = 0
            Template[Template > max_M0] = 0
            Template[Template < 0] = 0

            # Normalise Template
            max_S1 = Template[:, :, 0].max()
            Template_Norm = Template / max_S1

            # add Noise to Normed Template
            if rand == True:
                sigma = random.uniform(0, sigma)
            if noise_type == 'rayleigh':
                if sigma != 0:
                    # add noise to Template
                    noise = np.random.rayleigh(sigma, size=Template_Norm.shape)
                else:
                    noise = np.zeros(Template_Norm.shape)
                Template_withNoise = Template_Norm + noise
            elif noise_type == 'rician':
                x = sigma * np.random.randn(*Template_Norm.shape) + Template_Norm
                y = sigma * np.random.randn(*Template_Norm.shape)
                Template_withNoise = np.sqrt(x ** 2 + y ** 2)

            # create simulation samples
            save_data[:, :, 0:echos] = Template_withNoise
            save_data[:, :, echos:echos + 1] = t2s.reshape(64, 64, 1)
            save_data[:, :, echos + 1:echos + 2] = M0.reshape(64, 64, 1) / max_S1

            filenum = filename.split("_")[-1].split(".")[0]
            template_name = 'NormedMESignal_' + str(filenum) + '.mat'
            save_template_name = os.path.join(dir_destination, template_name)

            # save Template as mat file
            label = {"NormedSignal": save_data}
            scio.savemat(save_template_name, label)

if __name__ == '__main__':
    dir_root = '/data2/zyh/Templates/Template_SMRI_realbrain_new_64' # totally 5400 files exists
    dir_destination = '/data2/zyh/template/MESignal_t2s_Norm_Rayleigh_sup_3p'
    if not os.path.exists(dir_destination):
        os.mkdir(dir_destination)
    TE_value = [0.014, 0.028, 0.042]
    GenerateNormedTemplate_t2s(dir_root, dir_destination, TE_value, sigma=0.03, noise_type='rician')

