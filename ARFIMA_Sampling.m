load('ARFIMA_Statistics.mat');

% Selection based on Deviation from Target
Target_H = [0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.85,0.9];
Target_mu = 134.1468; 
Target_std = 58.2442;

% For ALL CASES (Cases 1-9)
for i=1:9
    H_dev(:,i) = sqrt(((H_table(:,i)-Target_H(i)).^2)/Target_H(i));
    mu_dev(:,i) = sqrt(((mean_table(:,i)-Target_mu).^2)/Target_mu);
    std_dev(:,i) = sqrt(((std_table(:,i)-Target_std).^2)/Target_std);

    dev_sum(:,i) = H_dev(:,i) + mu_dev(:,i) + std_dev(:,i);
end

for i=1:9
    [~,p] = sort(dev_sum(:,i),'ascend');
    r = 1:length(dev_sum(:,i));
    r(p) = r;

    sorted_rank(:,i) = p(1:100);
end