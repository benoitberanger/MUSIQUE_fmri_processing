clear
clc

load e

e.addSerie('glm', 'glm', 1 );

model_dir = e.getSerie('glm').getPath();
spm_file  = fullfile(model_dir,'SPM.mat');

load aal3.mat

nRun = length(e);

nRegion = size(aal3,1);

for iRun = 1 : nRun
    
    fprintf('run %d/%d : %s \n', iRun, nRun, model_dir{iRun})
    
    % load all timeseries
    
    load(spm_file{iRun})
    nscan = SPM.nscan;
    
    ts = zeros(nscan,nRegion);
    
    for iRegion = 1 : nRegion
        
        ROIabbr = aal3.ROIabbr(iRegion);
        ROIid   = aal3.ROIid  (iRegion);
        
        roi_file = sprintf('VOI_region_%03d_%s_1.mat', ROIid, ROIabbr);
        roi_struct = load( fullfile( model_dir{iRun}, roi_file ) );
        
        ts(:,iRegion) = roi_struct.Y;
        
    end
        
    % perform correlation
    
    mx = corrcoef(ts);
    
    save(fullfile(model_dir{iRun},'correlation_matrix.mat'), 'mx')
    
end
