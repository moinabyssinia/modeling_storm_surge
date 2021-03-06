% To do PCA on time-lagged predictors for model 2.4 
b1 = 'F:\OneDrive - Knights - University of Central Florida\Daten\MLR\Model_2\Extracted'
%b2 = 'F:\OneDrive - Knights - University of Central Florida\Daten\MLR\Model_2\4Xdaily_10X10_217_TGs'

a = dir(b1); b = [a.isdir]; lst1 = a(b); lst1(1:2) = [];
%c = dir(b2); d = [c.isdir]; lst2 = c(d); lst2(1:2) = []; 
clearvars -except b1 b2 lst1 lst2 
% PCA for Model # 2; time-lagged predictors - 10X10 dXdaily

%Load predictors and predictand
for jj = 1:length(lst1)
    cd(fullfile(b1, lst1(jj).name))
    %Load uwnd
    load('uwnd_lagged.mat')
    clear base_dir fid tg_lst ii
    %Load vwnd
    load('vwnd_lagged.mat')
    clear base_dir fid tg_lst ii
    %Load slp
    load('slp_lagged.mat')
    clear base_dir fid tg_lst ii
    %Load daily max surge
    load('surge_dmax.mat')
    clearvars -except b1 jj lst1 s6 s0 s12 s18 s24 s30...
        u0 u12 u18 u24 u30 u6 v0 v12 v18 v24 v30 v6 lat_t lon_t surge_sub
    
    %Permuting and reshaping predictors
    a = size(u0);
    u0_per = permute(u0, [3 2 1]); u0_rsh = reshape(u0_per, a(3), a(1)*a(2));
    a = size(u6);
    u6_per = permute(u6, [3 2 1]); u6_rsh = reshape(u6_per, a(3), a(1)*a(2));
    a = size(u12);
    u12_per = permute(u12, [3 2 1]); u12_rsh = reshape(u12_per, a(3), a(1)*a(2));
    a = size(u18);
    u18_per = permute(u18, [3 2 1]); u18_rsh = reshape(u18_per, a(3), a(1)*a(2));
    a = size(u24);
    u24_per = permute(u24, [3 2 1]); u24_rsh = reshape(u24_per, a(3), a(1)*a(2));
    a = size(u30);
    u30_per = permute(u30, [3 2 1]); u30_rsh = reshape(u30_per, a(3), a(1)*a(2));

    a = size(v0);
    v0_per = permute(v0, [3 2 1]); v0_rsh = reshape(v0_per, a(3), a(1)*a(2));
    a = size(v6);
    v6_per = permute(v6, [3 2 1]); v6_rsh = reshape(v6_per, a(3), a(1)*a(2));
    a = size(v12);
    v12_per = permute(v12, [3 2 1]); v12_rsh = reshape(v12_per, a(3), a(1)*a(2));
    a = size(u18);
    v18_per = permute(v18, [3 2 1]); v18_rsh = reshape(v18_per, a(3), a(1)*a(2));
    a = size(v24);
    v24_per = permute(v24, [3 2 1]); v24_rsh = reshape(v24_per, a(3), a(1)*a(2));
    a = size(v30);
    v30_per = permute(v30, [3 2 1]); v30_rsh = reshape(v30_per, a(3), a(1)*a(2));
    
    a = size(s0);
    s0_per = permute(s0, [3 2 1]); s0_rsh = reshape(s0_per, a(3), a(1)*a(2));
    a = size(s6);
    s6_per = permute(s6, [3 2 1]); s6_rsh = reshape(s6_per, a(3), a(1)*a(2));
    a = size(s12);
    s12_per = permute(s12, [3 2 1]); s12_rsh = reshape(s12_per, a(3), a(1)*a(2));
    a = size(s18);
    s18_per = permute(s18, [3 2 1]); s18_rsh = reshape(s18_per, a(3), a(1)*a(2));
    a = size(s24);
    s24_per = permute(s24, [3 2 1]); s24_rsh = reshape(s24_per, a(3), a(1)*a(2));
    a = size(s30);
    s30_per = permute(s30, [3 2 1]); s30_rsh = reshape(s30_per, a(3), a(1)*a(2));
    
    
    %compute zscores for model 2.4 
    
    zu0 = zscore(u0_rsh);
    zu6 = zscore(u6_rsh);
    zu12 = zscore(u12_rsh);
    zu18 = zscore(u18_rsh);
    zu24 = zscore(u24_rsh);
    zu30 = zscore(u30_rsh);
    
    
    zv0 = zscore(v0_rsh);
    zv6 = zscore(v6_rsh);
    zv12 = zscore(v12_rsh);
    zv18 = zscore(v18_rsh);
    zv24 = zscore(v24_rsh);
    zv30 = zscore(v30_rsh);    
    
    zu0s = zscore(u0_rsh.*u0_rsh);
    zu6s = zscore(u6_rsh.*u6_rsh);
    zu12s = zscore(u12_rsh.*u12_rsh);
    zu18s = zscore(u18_rsh.*u18_rsh);
    zu24s = zscore(u24_rsh.*u24_rsh);
    zu30s = zscore(u30_rsh.*u30_rsh);
    
    
    zv0s = zscore(v0_rsh.*v0_rsh);
    zv6s = zscore(v6_rsh.*v6_rsh);
    zv12s = zscore(v12_rsh.*v12_rsh);
    zv18s = zscore(v18_rsh.*v18_rsh);
    zv24s = zscore(v24_rsh.*v24_rsh);
    zv30s = zscore(v30_rsh.*v30_rsh);
    
    
    zs0 = zscore(s0_rsh);
    zs6 = zscore(s6_rsh);
    zs12 = zscore(s12_rsh);
    zs18 = zscore(s18_rsh);
    zs24 = zscore(s24_rsh);
    zs30 = zscore(s30_rsh);
    
    
    %PCA
    [cof_u0,score_u0,latent_u0,tsquared_u0,explained_u0] = pca(zu0);
    [cof_u6,score_u6,latent_u6,tsquared_u6,explained_u6] = pca(zu6);
    [cof_u12,score_u12,latent_u12,tsquared_u12,explained_u12] = pca(zu12);
    [cof_u18,score_u18,latent_u18,tsquared_u18,explained_u18] = pca(zu18);
    [cof_u24,score_u24,latent_u24,tsquared_u24,explained_u24] = pca(zu24);
    [cof_u30,score_u30,latent_u30,tsquared_u30,explained_u30] = pca(zu30);
    
    [cof_v0,score_v0,latent_v0,tsquared_v0,explained_v0] = pca(zv0);
    [cof_v6,score_v6,latent_v6,tsquared_v6,explained_v6] = pca(zv6);
    [cof_v12,score_v12,latent_v12,tsquared_v12,explained_v12] = pca(zv12);
    [cof_v18,score_v18,latent_v18,tsquared_v18,explained_v18] = pca(zv18);
    [cof_v24,score_v24,latent_v24,tsquared_v24,explained_v24] = pca(zv24);
    [cof_v30,score_v30,latent_v30,tsquared_v30,explained_v30] = pca(zv30);
    
    [cof_s0,score_s0,latent_s0,tsquared_s0,explained_s0] = pca(zs0);
    [cof_s6,score_s6,latent_s6,tsquared_s6,explained_s6] = pca(zs6);
    [cof_s12,score_s12,latent_s12,tsquared_s12,explained_s12] = pca(zs12);
    [cof_s18,score_s18,latent_s18,tsquared_s18,explained_s18] = pca(zs18);
    [cof_s24,score_s24,latent_s24,tsquared_s24,explained_s24] = pca(zs24);
    [cof_s30,score_s30,latent_s30,tsquared_s30,explained_s30] = pca(zs30);
    
    
    %Squared terms
    [cof_u0s,score_u0s,latent_u0s,tsquared_u0s,explained_u0s] = pca(zu0s);
    [cof_u6s,score_u6s,latent_u6s,tsquared_u6s,explained_u6s] = pca(zu6s);
    [cof_u12s,score_u12s,latent_u12s,tsquared_u12s,explained_u12s] = pca(zu12s);
    [cof_u18s,score_u18s,latent_u18s,tsquared_u18s,explained_u18s] = pca(zu18s);
    [cof_u24s,score_u24s,latent_u24s,tsquared_u24s,explained_u24s] = pca(zu24s);
    [cof_u30s,score_u30s,latent_u30s,tsquared_u30s,explained_u30s] = pca(zu30s);
    
    [cof_v0s,score_v0s,latent_v0s,tsquared_v0s,explained_v0s] = pca(zv0s);
    [cof_v6s,score_v6s,latent_v6s,tsquared_v6s,explained_v6s] = pca(zv6s);
    [cof_v12s,score_v12s,latent_v12s,tsquared_v12s,explained_v12s] = pca(zv12s);
    [cof_v18s,score_v18s,latent_v18s,tsquared_v18s,explained_v18s] = pca(zv18s);
    [cof_v24s,score_v24s,latent_v24s,tsquared_v24s,explained_v24s] = pca(zv24s);
    [cof_v30s,score_v30s,latent_v30s,tsquared_v30s,explained_v30s] = pca(zv30s); 
    
    
    

    %Subsetting PCs that explain >= 90% of variance
    
    %uwnd
    ee = 1;
    while sum(explained_u0(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; % number of PCs chosen for u0
    pc_u0 = score_u0(:,1:numb);
    
    ee = 1;
    while sum(explained_u6(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_u6 = score_u6(:,1:numb);
    
    ee = 1;
    while sum(explained_u12(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_u12 = score_u12(:,1:numb);

    ee = 1;
    while sum(explained_u18(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_u18 = score_u18(:,1:numb);
            
    ee = 1;
    while sum(explained_u24(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_u24 = score_u24(:,1:numb);

    ee = 1;
    while sum(explained_u30(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_u30 = score_u30(:,1:numb);
    
   %uwnd squared
    ee = 1;
    while sum(explained_u0s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; % number of PCs chosen for u0s
    pc_u0s = score_u0s(:,1:numb);
    
    ee = 1;
    while sum(explained_u6s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_u6s = score_u6s(:,1:numb);
    
    ee = 1;
    while sum(explained_u12s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_u12s = score_u12s(:,1:numb);

    ee = 1;
    while sum(explained_u18s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_u18s = score_u18s(:,1:numb);
            
    ee = 1;
    while sum(explained_u24s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_u24s = score_u24s(:,1:numb);

    ee = 1;
    while sum(explained_u30s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_u30s = score_u30s(:,1:numb);
    
    
    %vwnd
    ee = 1;
    while sum(explained_v0(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v0 = score_v0(:,1:numb);
    
    ee = 1;
    while sum(explained_v6(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v6 = score_v6(:,1:numb);
    
    ee = 1;
    while sum(explained_v12(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v12 = score_v12(:,1:numb);
    
    ee = 1;
    while sum(explained_v18(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v18 = score_v18(:,1:numb); 
    
    ee = 1;
    while sum(explained_v24(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v24 = score_v24(:,1:numb); 
    
    ee = 1;
    while sum(explained_v30(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v30 = score_v30(:,1:numb); 
    
    
    %vwnd squared
    ee = 1;
    while sum(explained_v0s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v0s = score_v0s(:,1:numb);
    
    ee = 1;
    while sum(explained_v6s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v6s = score_v6s(:,1:numb);
    
    ee = 1;
    while sum(explained_v12s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v12s = score_v12s(:,1:numb);
    
    ee = 1;
    while sum(explained_v18s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v18s = score_v18s(:,1:numb); 
    
    ee = 1;
    while sum(explained_v24s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v24s = score_v24s(:,1:numb); 
    
    ee = 1;
    while sum(explained_v30s(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_v30s = score_v30s(:,1:numb); 
    
    
   %slp
    ee = 1;
    while sum(explained_s0(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_s0 = score_s0(:,1:numb);
    
    ee = 1;
    while sum(explained_s6(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_s6 = score_s6(:,1:numb);
    
    ee = 1;
    while sum(explained_s12(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_s12 = score_s12(:,1:numb);
    
    ee = 1;
    while sum(explained_s18(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_s18 = score_s18(:,1:numb); 
    
    ee = 1;
    while sum(explained_s24(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_s24 = score_s24(:,1:numb); 
    
    ee = 1;
    while sum(explained_s30(1:ee)) < 90
        ee = ee + 1;
    end
    numb = ee; 
    pc_s30 = score_s30(:,1:numb);  
    
    
    %Prepare matrix of predictors & predictand
    
    vars = [pc_u0 pc_u6 pc_u12 pc_u18 pc_u24 pc_u30...
        pc_u0s pc_u6s pc_u12s pc_u18s pc_u24s pc_u30s...
        pc_v0 pc_v6 pc_v12 pc_v18 pc_v24 pc_v30...
        pc_v0s pc_v6s pc_v12s pc_v18s pc_v24s pc_v30s...
        pc_s0 pc_s6 pc_s12 pc_s18 pc_s24 pc_s30];
    
    y_surge = surge_sub(:,2);
    

    %Saving .mat files
    clearvars -except vars y_surge lat_t lon_t b1 lst1 jj
    folder = 'F:\OneDrive - Knights - University of Central Florida\Daten\MLR\Model_2\M2.3\mdl2p3_PCA_4Xdaily10X10_17yrs'
    baseFileName = sprintf('%s_pca_10x10_17yrs.mat', lst1(jj).name);
    fullMatFileName = fullfile(folder, baseFileName);
    save(fullMatFileName);
    clearvars -except b1 lst1 jj
    
    

    
end




























    