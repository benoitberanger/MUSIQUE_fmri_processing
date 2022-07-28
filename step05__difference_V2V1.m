clear
clc
close all

load e

load aal3.mat
nRegion = size(aal3,1);

e.addSerie('glm', 'glm', 1 );

model_dir = e.getSerie('glm').getPath();


correlation = struct;
for visite_idx = [1 2]

glm = e.getExam(sprintf('MUSIQUE_850_V%d',visite_idx)).getSerie('glm');
file_mx = fullfile( glm.path, 'correlation_matrix.mat');
tmp = load(file_mx);
correlation(visite_idx).mx   = tmp.mx;
correlation(visite_idx).name = sprintf('V%d',visite_idx);

end

correlation(3).mx = correlation(2).mx - correlation(1).mx;
correlation(3).name = 'V2 - V1';

f = figure('Name','MUSIQUE_850','NumberTitle','off');
tg = uitabgroup(f);

for i = 1 : 3
    
    t = uitab('Title', correlation(i).name);
    a(i) = axes(t);
    
    imagesc(a(i), correlation(i).mx )
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
