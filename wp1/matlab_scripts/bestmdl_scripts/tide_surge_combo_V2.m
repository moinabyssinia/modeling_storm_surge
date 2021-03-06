% This script puts together observed surge and tide together to
% re-construct the total still water level
% created @ 08/23/2019

%load Model A .mat files
file_path = 'F:\OneDrive - Knights - University of Central Florida\Daten\MLR\best_model\BestMdl_v2'; 
tide_path = 'F:\OneDrive - Knights - University of Central Florida\Daten\Tide_data\Surge_after_T_Tide';
tidesurge_combo = 'F:\OneDrive - Knights - University of Central Florida\Daten\MLR\best_model\tidesurge_combo';
cd (file_path)
tg_lst = dir('*.mat');

for i = 507:length(tg_lst)
    fprintf('%d tide gauges left . . .', length(tg_lst) - i);
    load(tg_lst(i).name);
    %load corresponding tide .mat file
    tide_name1 = strsplit(tg_lst(i).name, '_17yrs');
    tide_name2 = strcat(tide_name1{1}, '.mat.mat');
    cd (tide_path);
    load(tide_name2);
    
    %search and find overlapping time for tide and surge
    %make two matrices from Thour and y_rec to compare 
    [ava tide_ind] = ismember(y_rec(:,1), Thour); 
    
    %when tide_ind == 0; surge 
    
    %concatenate |Time| tide | observed surge | modeled surge | observed total waterlevel | 
    %modeled total waterlevel  
    total_waterlevel = [Thour(tide_ind), Tide(tide_ind), ...
        y_surge(:,2), y_rec(:,2), Whour_detr(tide_ind),...
        Tide(tide_ind)+y_rec(:,2)];
    
    %Statistics
    %correlation
    corr_waterlevel = corr(total_waterlevel(:,5), total_waterlevel(:,6));
    %rmse
    zz = total_waterlevel(:,5) - total_waterlevel(:,6); zsqr = zz.*zz; 
    zmean = mean(zsqr); 
    rmse_waterlevel = sqrt(zmean);
    %nse
    x1 = total_waterlevel(:,5) - mean(total_waterlevel(:,5)); x1sqr = x1.*x1;
    nse_waterlevel = 1- (sum(zsqr)/sum(x1sqr));
    cd (tidesurge_combo);
    save(strcat(tide_name1{1}, '_tide_surge.mat'));
    cd (file_path)
end
