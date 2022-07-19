clear
clc

load e

model_dir = e.mkdir('glm');
input_file = e.getSerie('run_RS').getVolume('s5w').getPath();
noisereg_file = e.getSerie('run_RS').getRP('multiple_regressors').getPath();

nRun = length(model_dir);

for iRun = 1 : nRun
    
    if spm_existfile(fullfile(model_dir{iRun},'SPM.mat'))
        fprintf('skip %d/%d : %s \n', iRun, nRun, model_dir{iRun})
        continue
    else
        fprintf('run %d/%d : %s \n', iRun, nRun, model_dir{iRun})
    end
    
    matlabbatch = [];
    
    %%%
    matlabbatch{1}.spm.stats.fmri_spec.dir = model_dir(iRun);
    %%%
    
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1.66;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    
    %%%
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = spm_select('expand', input_file(iRun));
    %%%
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    
    %%%
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = noisereg_file(iRun);
    %%%
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.1;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 1;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.util.cat.vols(1) = cfg_dep('Model estimation: Residual Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','res'));
    matlabbatch{3}.spm.util.cat.name = 'clean4D.nii';
    matlabbatch{3}.spm.util.cat.dtype = 0;
    matlabbatch{3}.spm.util.cat.RT = 1.66;
    
    spm_jobman('run',matlabbatch)
    
end
