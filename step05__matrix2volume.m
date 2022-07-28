clear
clc
close all

load e

e.addSerie('glm', 'glm', 1 );

model_dir = e.getSerie('glm').getPath();
mx_file  = fullfile(model_dir,'correlation_matrix.mat');

load aal3_voxel_list.mat
nRegion = size(aal3,1);
nRun = length(e);

Vaal = spm_vol('aal3.nii');
Yaal = spm_read_vols(Vaal);

for iRun = 1 : nRun
    
    fprintf('run %d/%d : %s \n', iRun, nRun, model_dir{iRun})
    
    load(mx_file{iRun})
    
    
    for iRegionSRC = 1 : nRegion
        ROIabbrSRC = aal3.ROIabbr(iRegionSRC);
        ROIidSRC   = aal3.ROIid  (iRegionSRC);
        
        Vroi       = Vaal;
        Vroi.dt(1) = spm_type('float32');
        Vroi.fname = fullfile(model_dir{iRun}, sprintf('correlation_region_%03d_%s.nii', ROIidSRC, char(ROIabbrSRC)));
        
        Yroi       = nan(size(Yaal));
        
        for iRegionDST = 1 : nRegion
            
            Yroi(aal3.voxel_list{iRegionDST}) = mx(iRegionSRC, iRegionDST);
            
        end % DST
        
        
        % for the viewer: it should scale the intensity range from -1 to 1
        Yroi(:,  1,:) = -1;
        Yroi(:,end,:) = +1;
        
        spm_write_vol(Vroi, Yroi);
        
    end % SRC
    
end % RUN
