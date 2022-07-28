clear
clc

load e

e.addSerie('glm', 'glm', 1 );
e.getSerie('glm').addVolume('clean4D.nii','clean4D',1)

model_dir = e.getSerie('glm').getPath();
spm_file  = fullfile(model_dir,'SPM.mat');
mask_file = fullfile(model_dir,'mask.nii');

load aal3.mat

nRun = length(e);

nRegion = size(aal3,1);

for iRun = 1 : nRun
    
    fprintf('run %d/%d : %s \n', iRun, nRun, model_dir{iRun})
    
    matlabbatch = cell(nRegion,1);
    for iRegion = 1 : nRegion
        
        ROIabbr = aal3.ROIabbr(iRegion);
        ROIid   = aal3.ROIid  (iRegion);
        
        matlabbatch{iRegion}.spm.util.voi.spmmat = spm_file(iRun);
        matlabbatch{iRegion}.spm.util.voi.adjust = NaN; % NaN means "adjust with everythong" => in RS, all regressors are noise, so we want to regress them out
        matlabbatch{iRegion}.spm.util.voi.session = 1;
        matlabbatch{iRegion}.spm.util.voi.name = sprintf('region_%03d_%s', ROIid, ROIabbr);
        matlabbatch{iRegion}.spm.util.voi.roi{1}.label.image = {'./aal3.nii'};
        matlabbatch{iRegion}.spm.util.voi.roi{1}.label.list = ROIid;
        matlabbatch{iRegion}.spm.util.voi.roi{2}.mask.image = {mask_file{iRun}};
        matlabbatch{iRegion}.spm.util.voi.roi{2}.mask.threshold = 0.5;
        matlabbatch{iRegion}.spm.util.voi.expression = 'i1 & i2';
        
    end
    
    spm_jobman('run',matlabbatch)
    
end
