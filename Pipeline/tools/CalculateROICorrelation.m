function ROICorrelation = CalculateROICorrelation(Windows_data,Node_data)
% INPUT:
%     Windows_data:     -   4D data matrix (DimX*DimY*DimZ*DimTimePoints) or the directory of 3D image data file or the filename of one 4D data file
%     Node_data:        -   The Brain Mask matrix (DimX*DimY*DimZ) or the Brain Mask file name
% OUTPUT:
%     ROICorrelation:   -   data matrix(DimNodeNumber*DimNodeNumber),Correlation between Nodes

if ~isnumeric(Windows_data)
    Windows_nii = load_nii(Windows_data);
    Windows_data = Windows_nii.img;
end

Windows_data(find(isnan(Windows_data))) = 0; %Set the NaN voxels to 0.
[nDim1,nDim2,nDim3,nDimTimePoints]=size(Windows_data);

if ischar(Node_data)
    if ~isempty(Node_data)
        Node_nii = load_nii(Node_data);
        Node_data = Node_nii.img;
    else
        Node_data = ones(nDim1,nDim2,nDim3);
    end
end

Node_Numbzer = max(max(max(Node_data)));

% Convert into 2D
Windows_data = reshape(Windows_data,[],nDimTimePoints)';

NodeDataOneDim = reshape(Node_data,1,[]);
NodeIndex = find(NodeDataOneDim);

% Extract the Seed Time Courses
SeedSeries = [];
Windows_mask = zeros(nDimTimePoints,Node_Numbzer);

for iNode = 1:Node_Numbzer
    mask_list = [find(Node_data == iNode)];
    SeedSeries = Windows_data(:,mask_list);
    Windows_mask(:,iNode) = mean(SeedSeries,2);
end

% Calculate ROI Correlation
ROICorrelation = zeros(Node_Numbzer,Node_Numbzer);
for i = 1:Node_Numbzer
    SeedSeries1 = Windows_mask(:,i);
    for j = 1:Node_Numbzer
        SeedSeries2 = Windows_mask(:,j);
        ROICorrelation(i,j) = corr(SeedSeries1,SeedSeries2);
    end
end
ROICorrelation(find(isnan(ROICorrelation)==1)) = 0;

disp('ROICorrelation Finished!')