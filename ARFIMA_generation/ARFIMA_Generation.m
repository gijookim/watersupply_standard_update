%% ARFIMA SERIES GENERATION FOR BORYEONG DAM

rng(42);

NN = 100000;      % number of samples
NY = 500;       % number of years
ARFIMA_generation_data = ones(NY,9,NN);

obs_csv = readtable('br_inflow_mcm.csv');
obs_mcm   = table2array(obs_csv(1:23,'obs_mcm'));
parma_mcm = table2array(obs_csv(1:499,'parma_mcm'));

mu_obs  = mean(obs_mcm); %134.1468
std_obs = std(obs_mcm);  %58.2442

min_obs = min(obs_mcm);
max_obs = max(obs_mcm);
phi_1 = 0.264784;

  d=[0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4];
% Corresponding Hurst Coefficient H=[0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.85,0.9];

for i=1:9
    k = 1;
    while k < NN+1
    temp_arfima = ARFIMA_generation(NY,[phi_1],[0],d(i),mu_obs,std_obs+10.2,0.9670,min_obs,max_obs);
        if mean(temp_arfima) <= mu_obs*1.05 && mean(temp_arfima) >= mu_obs*0.95 
            if std(temp_arfima) <= std_obs*1.5 && std(temp_arfima) >= std_obs*0.5
                h_temp = hurst_estimate(temp_arfima, 'aggvar', 0);
                if h_temp <= d(i)+0.55 && h_temp >= d(i)+0.45
                    ARFIMA_generation_data(:,i,k) = temp_arfima ;
                    k=k+1;
                end
            end
        end
    end
end


for i=1:NN    %NN=1000
    mean_table(i,:) = mean(ARFIMA_generation_data(:,:,i));
    std_table(i,:) = std(ARFIMA_generation_data(:,:,i));
    for j=1:9
       % lag1_corr_table(i,j) = corr(ARFIMA_generation_data(1:NY-1,j,i),ARFIMA_generation_data(2:NY,j,i));
        H_table(i,j) = hurst_estimate(ARFIMA_generation_data(:,j,i), 'aggvar', 0); 
    end
end

subplot(1,3,1);
boxplot(mean_table,'Labels',{'0.5','0.55','0.6','0.65','0.7','0.75','0.8','0.85','0.9'});
xlabel('Target H')
ylim([100,160]);
ylabel('Average Inflow (MCM)');
yline(mu_obs, '--r');

subplot(1,3,2);
boxplot(std_table,'Labels',{'0.5','0.55','0.6','0.65','0.7','0.75','0.8','0.85','0.9'});
xlabel('Target H')
ylim([48,65]);
ylabel('standard deviation of annual mean inflow');
yline(std_obs, '--r');

subplot(1,3,3);
boxplot(H_table,'Labels',{'0.5','0.55','0.6','0.65','0.7','0.75','0.8','0.85','0.9'});
xlabel('Target H')
ylim([0.4,1]);
ylabel('Generated H');
hold on;
plot([1,2,3,4,5,6,7,8,9], [0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.85,0.9], '--r')
hold off;

% subplot(2,2,4);
% boxplot(lag1_corr_table,'Labels',{'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9' });  
% xlabel('Target Hurst coefficient')
% ylim([0,1]);
% ylabel('Estimated Lag-1 correlation');    
