import torch

# SR: Output Result
# GT: Ground Truth

def get_mse(SR, GT):
    """Compute Mean Squared Error(MSE)"""
    return (torch.mean(SR - GT) ** 2).item()


def get_nmse(SR, GT):
    """Compute Normalized Mean Squared Error(NMSE)"""
    return (torch.norm(GT - SR) ** 2 / torch.norm(GT) ** 2).item()


def get_psnr(SR, GT):
    SR = SR.type(torch.FloatTensor)
    GT = GT.type(torch.FloatTensor)
    mse = torch.mean((SR - GT) ** 2)
    if mse == 0:
        return float('inf')
    return (20 * torch.log10(255 / torch.sqrt(mse))).item()


def get_accuracy(SR, GT, threshold=0.5):
    SR = SR > threshold
    GT = GT == torch.max(GT)
    corr = torch.sum(SR == GT)
    tensor_size = SR.size(0) * SR.size(1) * SR.size(2) * SR.size(3)
    acc = float(corr) / float(tensor_size)

    return acc


def get_specificity(SR, GT, threshold=0.5):
    SR = SR > threshold
    GT = GT == torch.max(GT)

    # TN : True Negative
    # FP : False POsitive
    TN = ((SR == 0) + (GT == 0)) == 2
    FP = ((SR == 1) + (GT == 0)) == 2

    SP = float(torch.sum(TN)) / (float(torch.sum(TN + FP)) + 1e-6)

    return SP
