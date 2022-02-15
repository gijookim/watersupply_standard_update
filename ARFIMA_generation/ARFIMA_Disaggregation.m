%% Sorting & Disaggregation into 10-day Series

% Load Data
load('ARFIMA_10^5_Trials.mat');
load('sorted_rank.mat');

%% Sorting FOR ALL CASES
ARFIMA_Case1 = ARFIMA_generation_data(:,1,:);
ARFIMA_Case2 = ARFIMA_generation_data(:,2,:);
ARFIMA_Case3 = ARFIMA_generation_data(:,3,:);
ARFIMA_Case4 = ARFIMA_generation_data(:,4,:);
ARFIMA_Case5 = ARFIMA_generation_data(:,5,:);
ARFIMA_Case6 = ARFIMA_generation_data(:,6,:);
ARFIMA_Case7 = ARFIMA_generation_data(:,7,:);
ARFIMA_Case8 = ARFIMA_generation_data(:,8,:);
ARFIMA_Case9 = ARFIMA_generation_data(:,9,:);

for i=1:100
    Case1_100_samples(:,:,i) = ARFIMA_Case1(:,:,sorted_rank(i,1));
    Case2_100_samples(:,:,i) = ARFIMA_Case2(:,:,sorted_rank(i,2));
    Case3_100_samples(:,:,i) = ARFIMA_Case3(:,:,sorted_rank(i,3));
    Case4_100_samples(:,:,i) = ARFIMA_Case4(:,:,sorted_rank(i,4));
    Case5_100_samples(:,:,i) = ARFIMA_Case5(:,:,sorted_rank(i,5));
    Case6_100_samples(:,:,i) = ARFIMA_Case6(:,:,sorted_rank(i,6));
    Case7_100_samples(:,:,i) = ARFIMA_Case7(:,:,sorted_rank(i,7));
    Case8_100_samples(:,:,i) = ARFIMA_Case8(:,:,sorted_rank(i,8));
    Case9_100_samples(:,:,i) = ARFIMA_Case9(:,:,sorted_rank(i,9));
end

%
reshape(Case1_100_samples,[],500)
reshape(Case9_100_samples,[],500)


mean_est = ones(100,7);
std_est  = ones(100,7);
H_est    = ones(100,7);

for i=1:100 
    mean_est(i,1) = mean(Case3_100_samples(:,:,i));
    std_est(i,1) = std(Case3_100_samples(:,:,i));
    H_est(i,1) = hurst_estimate(Case3_100_samples(:,:,i), 'aggvar', 0); 
end
for i=1:100 
    mean_est(i,2) = mean(Case4_100_samples(:,:,i));
    std_est(i,2) = std(Case4_100_samples(:,:,i));
    H_est(i,2) = hurst_estimate(Case4_100_samples(:,:,i), 'aggvar', 0); 
end
for i=1:100 
    mean_est(i,3) = mean(Case5_100_samples(:,:,i));
    std_est(i,3) = std(Case5_100_samples(:,:,i));
    H_est(i,3) = hurst_estimate(Case5_100_samples(:,:,i), 'aggvar', 0); 
end
for i=1:100 
    mean_est(i,4) = mean(Case6_100_samples(:,:,i));
    std_est(i,4) = std(Case6_100_samples(:,:,i));
    H_est(i,4) = hurst_estimate(Case6_100_samples(:,:,i), 'aggvar', 0); 
end
for i=1:100 
    mean_est(i,5) = mean(Case7_100_samples(:,:,i));
    std_est(i,5) = std(Case7_100_samples(:,:,i));
    H_est(i,5) = hurst_estimate(Case7_100_samples(:,:,i), 'aggvar', 0); 
end
for i=1:100 
    mean_est(i,6) = mean(Case8_100_samples(:,:,i));
    std_est(i,6) = std(Case8_100_samples(:,:,i));
    H_est(i,6) = hurst_estimate(Case8_100_samples(:,:,i), 'aggvar', 0); 
end
for i=1:100 
    mean_est(i,7) = mean(Case9_100_samples(:,:,i));
    std_est(i,7) = std(Case9_100_samples(:,:,i));
    H_est(i,7) = hurst_estimate(Case9_100_samples(:,:,i), 'aggvar', 0); 
end

subplot(1,3,1);
boxplot(mean_est,'Labels',{'0.6','0.65','0.7','0.75','0.8','0.85','0.9'});
xlabel('Target H')
ylim([133,135]);
ylabel('Average Inflow (MCM)');
yline(134.1468, '--r');

subplot(1,3,2);
boxplot(std_est,'Labels',{'0.6','0.65','0.7','0.75','0.8','0.85','0.9'});
xlabel('Target H')
ylim([57.5,59]);
ylabel('Standard Deviation of Annual Average Inflow');
yline(58.2442, '--r');

subplot(1,3,3);
boxplot(H_est,'Labels',{'0.6','0.65','0.7','0.75','0.8','0.85','0.9'});
xlabel('Target H')
ylim([0.55,1]);
ylabel('Generated H');
hold on;
plot([1,2,3,4,5,6,7], [0.6,0.65,0.7,0.75,0.8,0.85,0.9], '--r')
hold off;

set(gcf,'color','white');

%% Disaggregation into 10-Day Series (Nowak et al. 2010)
p_boryeong = table2array(readtable('p_boryeong.csv'));
Z_obs_boryeong = table2array(readtable('Z_boryeong.csv'));
W = [0.437956204; 0.218978102;0.145985401;0.109489051;0.087591241];
d_boryeong = NaN(500*36,100);
C = 1;
Annual_inflow_input = Case9_100_samples; % Should be


for A=1:100 % Number of Samples
    C=1;
    for B=1:500 % Number of Years

        targetZ = Annual_inflow_input(B,1,A);

        distance = NaN(23,1);
        index = NaN(5,1);
        agg_ratio = NaN(5,36);
        disaggregated_Z = NaN(36,1);

        synthetic_d = NaN(500*36,1);

        for i=1:23
            distance(i) = sqrt((targetZ - Z_obs_boryeong(i))^2);
            [~,p] = sort(distance,'ascend');
           r = 1:length(distance);
           r(p) = r;

            for j=1:5
                index(j) = find(r==j);
                agg_ratio(j,:) = W(j) * p_boryeong(index(j),:);
            end

            p_y = sum(agg_ratio);
        end

        for i=1:36
            disaggregated_Z(i) = p_y(i)*targetZ;
        end

    d_boryeong(C:(C+35),A) = disaggregated_Z;
    C = C+36;

    end
end
 % Save d_boryeong as output file

csvwrite('Case9_Q.csv',d_boryeong);
