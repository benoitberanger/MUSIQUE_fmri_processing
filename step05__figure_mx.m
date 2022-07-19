clear
clc
close all

load e

e.addSerie('glm', 'glm', 1 );

model_dir = e.getSerie('glm').getPath();
mx_file  = fullfile(model_dir,'correlation_matrix.mat');

load aal3.mat

nRun = length(e);

nRegion = size(aal3,1);

f = figure('Name','Measured Data','NumberTitle','off');
tg = uitabgroup(f);

for iRun = 1 : nRun
    
    fprintf('run %d/%d : %s \n', iRun, nRun, model_dir{iRun})
        
    load(mx_file{iRun})
    
    t = uitab('Title', e(iRun).name);
    a(iRun) = axes(t);
    
    % mx( eye(size(mx))==1 ) = NaN;
    
    imagesc(a(iRun), mx)
    caxis([-1 +1])
    colormap(jet)
    colorbar
    axis equal
    
    xticks(1:nRegion)
    xticklabels(aal3.ROIabbr)
    xtickangle(90)
    yticks(1:nRegion)
    yticklabels(aal3.ROIname)
    
    
end

linkaxes(a, 'xy')