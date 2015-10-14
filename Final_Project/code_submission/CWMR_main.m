%=======================================================================
% 2014-11-22: Sihui Han: CWMR-Stdev, basic version, no transcation cost
% S is the cumulative wealth and to see the result
% t= 1:T
% plot (t,log(S))
%=======================================================================
%data = importdata('text.txt');
clear all;
load nyse_o.mat;

[T,n] = size(data);

%input parameters
epsilon = -0.5;
phi = 2;

%varaibles and ininitalization
mu = ones(n, 1)/n;
sigma = eye(n)/(n^2);
lambda = 0;

S = ones(T,1); %cumulative wealth
b = zeros (n,1); % portfolio vector
run_ret = 1;% Final return

%update
for t = 1:T
    % 1. draw a portfolio bt from N~(mu,sigma)
    b = mu./sum(mu);
    % 2. recieve stock prices relatives xt
    
    % 3. calculate daily return and cumulative return
    daily_return = data(t,:) * b;
    run_ret = run_ret * daily_return;
    S(t) = run_ret;
    
    % 4.1 calculate the following variables
    x_bar = (ones(n, 1)'*sigma*data(t, :)')/(ones(n, 1)'*sigma*ones(n, 1));
    M = data(t, :) * mu; 
    V = data(t, :) * sigma * data(t, :)'; 
    %W = data(t, :) * sigma * ones(n, 1);
    
    % 5. update lambda
    a=((V-x_bar*data(t,:)*sigma*ones(n,1))/M^2 + V*phi^2/2)^2-V^2*phi^4/4;
    b = 2*(epsilon-log(M))*((V-x_bar*data(t,:)*sigma*ones(n,1))/M^2+ V*phi^2/2);
    c = epsilon-M-phi^2*V;
    
    t1 = b; t2 = sqrt(b^2-4*a*c); t3 = 2*a;
    gamma1 = (-t1+t2)/(t3);  gamma2 = (-t1-t2)/(t3);
    lambda = max([gamma1 gamma2 0]);
    
    % 5. update mu, sigma
    mu = mu - lambda * sigma*((data(t, :)'-x_bar*ones(n, 1)));
    sqrtu = (-lambda*phi*V+sqrt((lambda^2)*(V^2)*(phi^2)+4*V))/2;
    if (sqrtu ~= 0)
        sigma = (sigma^(-1) + lambda * phi / sqrtu * diag(data(t, :)).^2)^(-1);
    end
    
    % 6. Normalize mu, sigma 
    %mu1 = simplex_projection(mu, 1);
   
    mu_nor = zeros(n,1);
    [tmp, idx] = sort(mu, 'descend');
 
    for j = 1:n,
       if (tmp(j, 1) - (sum(tmp(1:j, 1))-1) / j <= 0)
           rho = j - 1;
           break;
       end
    end
   
    theta = (sum(tmp(1:rho, 1))-1)/rho;
    mu_nor(idx(1:rho, 1), 1) = mu(idx(1:rho, 1), 1) - theta;
    mu= mu_nor;

    sigma=sigma./sum(sigma(:))/n^2;
end



