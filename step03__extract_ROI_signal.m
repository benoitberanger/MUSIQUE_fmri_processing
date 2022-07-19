clear
clc

load e

e.addSerie('glm', 'glm', 1 );
e.getSerie('glm').addVolume('clean4D.nii','clean4D',1)

model_dir = e.getSerie('glm').getPath();
spm_file = fullfile(model_dir,'SPM.mat');

load aal3.mat

nRun = length(e);

nRegion = size(aal3,1);

for iRun = 1 : nRun
    
    fprintf('run %d/%d : %s \n', iRun, nRun, model_dir{iRun})
    
    matlabbatch = cell(nRegion,1);
    for iRegion = 1 : nRegion
        
        matlabbatch{iRegion}.spm.util.voi.spmmat = spm_file(iRun);
        matlabbatch{iRegion}.spm.util.voi.adjust = NaN;
        matlabbatch{iRegion}.spm.util.voi.session = 1;
        matlabbatch{iRegion}.spm.util.voi.name = sprintf('region_%03d_%s', iRegion, aal3.ROIabbr(iRegion));
        matlabbatch{iRegion}.spm.util.voi.roi{1}.label.image = {'./aal3.nii'};
        matlabbatch{iRegion}.spm.util.voi.roi{1}.label.list = iRegion;
        matlabbatch{iRegion}.spm.util.voi.expression = 'i1';
        
    end
    
    spm_jobman('run',matlabbatch)
    
end
                                                                                                                                                                                                                                                                                 