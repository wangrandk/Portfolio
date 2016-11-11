%% Final Assignment: Portfolio Optimization
% Course: 42104 Introduction to Financial Engineering
% Authors:
clear all
clc
close all

%% A) Diversification

% Set the start and end dates to retrieve 20 years of index data.
startdate = '01011995';
enddate   = '01022015';

% Set some constants.
numInd = 7;
numYrs = 20;
numRW  = 11;

% Set the risk-free rates.
RF  = 0.03;
RF2 = 0.1;
% Set a constant required return.
R_req = 0.1;

% Collect monthly data for chosen sector indices.
% Note that the data goes new->old.
if ~exist('stocks', 'var')
    stocks=hist_stock_data(startdate,enddate,'^DJI','^DJT', '^DJU', '^NBI', '^XMI', '^SOX', '^BKX', '^GSPC', 'frequency','m');
    DJI  = stocks(1).AdjClose; % Dow Jones Industrial Average
    DJT  = stocks(2).AdjClose; % Dow Jones Transportation Average
    DJU  = stocks(3).AdjClose; % Dow Jones Utility Average
    NBI  = stocks(4).AdjClose; % NASDAQ Biotechnology
    XMI  = stocks(5).AdjClose; % NYSE ARCA MAJOR MARKET INDEX
    SOX  = stocks(6).AdjClose; % PHLX Semiconductor
    BKX  = stocks(7).AdjClose; % KBW Nasdaq Bank Index
    SP   = stocks(8).AdjClose; % S&P (used as market portfolio later)
    
    % Caclualte the monthly log returns.
    DJILR  = log(DJI(1:end-1) ./ DJI(2:end));
    DJTLR  = log(DJT(1:end-1) ./ DJT(2:end));
    DJULR  = log(DJU(1:end-1) ./ DJU(2:end));
    NBILR = log(NBI(1:end-1)  ./ NBI(2:end));
    XMILR  = log(XMI(1:end-1) ./ XMI(2:end));
    SOXLR  = log(SOX(1:end-1) ./ SOX(2:end));
    BKXLR  = log(BKX(1:end-1) ./ BKX(2:end));
    LR = [DJILR, DJTLR, DJULR, NBILR, XMILR, SOXLR, BKXLR];
    
    SPLR  = log(SP(1:end-1)   ./ SP(2:end));
end

% Structures to store statistical information.
ymean   = cell(numYrs,1);
ystd    = cell(numYrs,1);
ycov    = cell(numYrs,1);
j=1;
for i=1:12:size(LR,1)-11
    ymean{j} = 12 * mean(LR(i:i+11,:));       % Yearly index means
    ystd{j}  = sqrt(12) * std(LR(i:i+11,:));  % Yearly index standard deviations
    ycov{j}  = 12 * cov(LR(i:i+11,:));        % Yearly covariance
    j=j+1;
end

% Structures to store statistical information.
SPymeanRW = zeros(numRW,1);
ymeanRW   = cell(numRW,1);
ystdRW    = cell(numRW,1);
ycovRW    = cell(numRW,1);
ycorrRW   = cell(numRW,1);
CRW       = cell(numRW,1);
% Structures to store optimal portfolios.
opt_port     = cell(numRW,1);
opt_port_mu  = zeros(numRW,1);
opt_port_sig = zeros(numRW,1);
% Structures to store optimal asset allocations.
optx_rf   = zeros(numRW,1);
optx_port = zeros(numRW,1);

% Get the optimal portfolios and efficient frontiers for each of the
% 10-year rolling windows.
%% B) Estimate

j=1;
% Calculate statistics on each rolling window.
for i=1:12:size(LR,1)-119
    SPymeanRW(j) = 12 * mean(SPLR(i:i+119,:))';    % RW SP means
    ymeanRW{j} = 12 * mean(LR(i:i+119,:))';        % RW means
    ystdRW{j}  = sqrt(12) * std(LR(i:i+119,:))';   % RW std deviations
    ycovRW{j}  = 12 * cov(LR(i:i+119,:))';         % RW covariance matrices
    ycorrRW{j} = corr(LR(i:i+119,:))';             % RW correlation matrices
    CRW{j} = diag(ystdRW{j})*ycorrRW{j}*diag(ystdRW{j}); % RW correlation matrices
    j=j+1;
end

% Plot the expected returns and covariance matricies for each rolling window.
figure;
plot(1:numRW, cell2mat(ymeanRW'));
xlabel('Rolling windows');
ylabel('Expected yearly returns');
legend('\^DJI','\^DJT', '\^DJU', '\^NBI', '\^XMI', '\^SOX', '\^BKX', 'Location', 'Southeast');
ax = gca;
ax.XTickLabelRotation = 45;
ax.XTickLabel = {'2005-2014', '2004-2013', '2003-2012', '2002-2011', '2001-2010', '2000-2009', '1999-2008', '1998-2007', '1997-2006', '1996-2005', '1995-2004'};

figure;
for i=1:numRW
    subplot(3,4,i);
    imagesc(ycovRW{i});
    xlabel([num2str(2006-i) '-' num2str(2015-i)]);
    set(gca,'xtick',[],'ytick',[]);
end
colorbar('Position', get(subplot(3,4,12),'Position'), 'AxisLocation', 'in');
set(gca,'xtick',[],'ytick',[]);

% Hacky drawing options for efficient frontier
asSubPlots = false;
isIncludeTobinSeperation = true;

figure;
subplotAxes = zeros(numRW,1);
colors = hsv(numRW);
frontiers = zeros(numRW,1);
for j=1:numRW
    %% C) Efficient Frontier?
    xopt = cell(2,1);
    % Calculate the highest slope protfolio with the given RF.
    [xopt{1}, muopt(1), sigopt(1)] = highest_slope_portfolio(ycorrRW{j}, RF, ymeanRW{j}, ystdRW{j});
    
    % Store information on the optimal portfolio.
    opt_port{j}     = xopt{1};
    opt_port_mu(j)  = muopt(1);
    opt_port_sig(j) = sigopt(1);
    
    % Calculate another portfolio on the efficient frontier with a new RF.
    [xopt{2}, muopt(2), sigopt(2)] = highest_slope_portfolio(ycorrRW{j}, RF2, ymeanRW{j}, ystdRW{j});
    
    large_n = 100;
    k = 1;
    mu_tmp  = zeros(1, 8*k*large_n);
    std_tmp = zeros(1, 8*k*large_n);
    
    % Run through different combinations to find the efficient frontier.
    for i = -4*k* large_n:1:4*k*large_n
        curr_port = i / large_n * xopt{1} + (1 - i / large_n) * xopt{2};
        mu_tmp (i + 4*k*large_n + 1) = curr_port' * ymeanRW{j};
        std_tmp(i + 4*k*large_n + 1) = sqrt(curr_port' * CRW{j} * curr_port);
    end
    
    % Put all graph elements for one moving window in a single subplot.
    if asSubPlots
        subplotAxes(j) = subplot(3,4,j);
    end
    
    % Plot the efficient frontier.
    hold on;
    frontiers(j) = plot(std_tmp, mu_tmp, 'color', colors(j, :));
    
    %% D) Tobin Separation
    if isIncludeTobinSeperation
        % Plot the optimal portfolio and the intercept.
        hold on;
        plot(sigopt(1), muopt(1), 'rx');
        hold on;
        plot(0, RF, 'rx');
        
        % Plot the tangent line with slope = mu-RF/sig and intercept = RF.
        % Points on the line include (0, RF), (sig, mu), (2*sig, 2*mu-RF)...
        hold on;
        sigRF = [0   sigopt(1) 2*sigopt(1)    3*sigopt(1)      4*sigopt(1)];
        muRF  = [RF; muopt(1); 2*muopt(1)-RF; 3*muopt(1)-2*RF; 4*muopt(1)-3*RF];
        line(sigRF, muRF, 'color', colors(j, :));
        
        % Plot the new optimal portfolio and the new intercept.
        hold on;
        plot(sigopt(2), muopt(2), 'go');
        hold on;
        plot(0, RF2, 'go');
        
        % Plot the new tangent line.
        hold on;
        sigRF2 = [0    sigopt(2) 2*sigopt(2)     3*sigopt(2)       4*sigopt(2)];
        muRF2  = [RF2; muopt(2); 2*muopt(2)-RF2; 3*muopt(2)-2*RF2; 4*muopt(2)-3*RF2];
        %line(sigRF2, muRF2, 'color', 'green');
    end
    
    %% E) Asset Allocation
    
    % Determine the optimal asset allocation given RF and the expected
    % return of the optimal portfolio.
    % Two equations and two unknowns:
    %   x1*RF + x2*R_p = R_req
    %   x1 + x2 = 1
    
    syms x_rf x_port;
    eqn1 = x_rf*RF + x_port*muopt(1) == R_req;
    eqn2 = x_rf + x_port == 1;
    sol = solve([eqn1,eqn2],[x_rf,x_port]);
    optx_rf(j)   = sol.x_rf;
    optx_port(j) = sol.x_port;
end
if ~asSubPlots
    legend( frontiers, {'2005-2014', '2004-2013', '2003-2012', '2002-2011', '2001-2010', '2000-2009', '1999-2008', '1998-2007', '1997-2006', '1996-2005', '1995-2004'});
    xlabel('Volatility');
    ylabel('Expected Return');
end
% linkaxes(subplotAxes, 'xy'); % Makes the axes across plots the same

turnover    = zeros(numRW-1,1);
muBT        = zeros(numRW-1,1);
sigBT       = zeros(numRW-1,1);
mu_rel_err  = zeros(numRW-1,1);
sig_rel_err = zeros(numRW-1,1);
for i=1:numRW-1
    % Calculate the portfolio turnover as a perentage.
    % Note that we're storing them as new->old.
    turnover(i) = sum(abs(optx_port(i) - optx_port(i+1)));
    
    %% F) Backtest
    
    % Conduct a back-test on each optimal portfolio.
    % Note that we do not have the data to back-test the latest portfolio.
    % Get the average return and standard deviation out of sample.
    % Note that we're storing them as old->new.
    % ymeanRW/ycovRW{numRW-i} = ymeanRW/ycovRW{10}('05) => ymeanRW/ycovRW{1}('14)
    % opt_port{numRW-i+1}     = opt_port{11}('95-'04)   => opt_port{2}('04-'13)
    muBT(i)     = ymean{numRW-i} * opt_port{numRW-i+1} * optx_port(numRW-i+1);
    muBT(i)     = muBT(i) + RF * optx_rf(numRW-i+1);
    
    % We take the absolute value in case the covariance is negative.
    [sigBT(i),] = cov2corr(abs(opt_port{numRW-i+1}' * ycov{numRW-i} * opt_port{numRW-i+1}));
    
    % Calculate the relative error between the predicted values and the
    % actual values.
    % Note that we're storing them as old->new.
    equity = optx_port(numRW-i) * mean(ymean{numRW-i});
    mu_rel_err(i)  = abs(muBT(i)/(equity + optx_rf(numRW-i) * RF)) - 1;
    sig_rel_err(i) = abs(sigBT(i) - mean(ystd{numRW-i})) / (mean(ystd{numRW-i}));
    
end

%% G) Beta
% Structures to store performance measure.
%b_J     = cell(numRW, 1);  % coefficientEstimates
%bint_J  = cell(numRW, 1);  % [lowerConfidenceBounds, upperConfidenceBounds]
%r_J     = cell(numRW, 1);  % residuals
%rint_J  = cell(numRW, 1);  % something with outliers
%stats_J = cell(numRW, 1);  % [r*r_statistic, fStatistic, pValue, errorVariance]
%alpha  = zeros(numRW, 1); % alpha coefficient

% Get Jensen's alpha to check against CAPM prediction.
% Use the S&P as the market index
marketExcessReturn = SPymeanRW(1:numRW) - RF; % Our single prediction
X = [ones(length(marketExcessReturn), 1), marketExcessReturn];
portExcessReturn = opt_port_mu(1:numRW) - RF;
% (Rit - RFt) = ai + bi (Rmt - RFt) + eit
[b_J, bint_J, r_J, rint_J, stats_J] = regress(portExcessReturn, X);
alpha = b_J(1);

%% Black Litterman
figure('Name','Black-Litterman');
muopt_BL = zeros(11,1);
for i=1:numRW
    w = opt_port{i};
    gamma = 1.1;
    tau = 0.8;
    Pi{i} = gamma * ycovRW{i} * w;
    
    hold on;
    subplot(2,11,i);
    title('Orig. weights');
    hold on;
    bar(w);
    hold on;
    
    % firstly we do it by certian view:
    
    P = [ 0	 0  0  1 -1  0  0
          0  0  0  -1  0  1  0
          0  0 -1  0  0  0  1];
    V = [0.02; 0.02;0.03];
    
    ER{i} = Pi{i} + ( tau * ycovRW{i}) * P' * inv((P * tau * ycovRW{i} * P')) * ( V - P * Pi{i});
    
    %return;
    w2{i} = inv(gamma * ycovRW{i}) * ER{i}; % The change!!!
    subplot(2,11,i+11)
    hold on;
    title('BL with views');
    bar(w2{i}, 'g');
    hold on;
    
    
    muopt_BL(i) = sum(ER{i}' * w2{i});
end



% Back test using BL approach
sigBT_BL   = zeros(numRW-1,1);
mu_err_BL  = zeros(numRW-1,1);
sig_err_BL = zeros(numRW-1,1);
for i = 1:numRW-1
   
    [sigBT_BL(i),] = (abs(w2{numRW-i+1}' * ycovRW{numRW-i} * w2{numRW-i}));
    mu_err_BL(i)  = abs(muopt_BL(i) - mean(ymean{numRW-i})) / muopt_BL(i);
    sig_err_BL(i) = abs(sigBT_BL(i) - mean(ystd{numRW-i})) / sigBT_BL(i);
%     mu_rel_err  sig_rel_err
end 

figure
x=(1:10);
subplot(2,1,1)
plot(x,sig_rel_err,x,sig_err_BL)
title('Sigma error comparision')
xlabel('windows')
ylabel('Sigma error')
legend('sigma rel error','sigma rel error BL')
subplot(2,1,2)
plot(x,mu_rel_err,x,mu_err_BL)
title('Mean return error comparision')
xlabel('windows')
ylabel('Mean return error')
legend('Mean return rel error','Mean return rel error BL')



%% change of Asset Allocation using expected return from BL approach
optx_rf_BL=zeros(11,1);
optx_port_BL=zeros(11,1);
% sol_BL = zeros(11,1);
figure('Name','Before/after BL allocation');
for i=1:numRW
    subplot(2,11,i);
    hold on;
    title('Before');
    bar([optx_port(i),optx_rf(i)],'g');
    
    syms x_rf_BL x_port_BL;
    eqn3 = x_rf_BL*RF + x_port_BL*muopt_BL(i) == R_req;
    eqn4 = x_rf_BL    + x_port_BL == 1;
    sol_BL = vpasolve([eqn3,eqn4],[x_rf_BL,x_port_BL]);
    optx_rf_BL(i)   = double(sol_BL.x_rf_BL);
    optx_port_BL(i) = double(sol_BL.x_port_BL);
    hold on;
    subplot(2,11, i+11);
    hold on;
    title('After');
    bar([optx_port_BL(i),optx_rf_BL(i)]);
end
%%

%% I) Timing
% Structures to store performance measure.
%b_T     = cell(numRW, 1);  % coefficientEstimates
%bint_T  = cell(numRW, 1);  % [lowerConfidenceBounds, upperConfidenceBounds]
%r_T     = cell(numRW, 1);  % residuals
%rint_T  = cell(numRW, 1);  % something with outliers
%stats_T = cell(numRW, 1);  % [r*r_statistic, fStatistic, pValue, errorVariance]
% b_T= cell(numRW,1);
% timming= cell(numRW,1);
% Timing Treynor-Mazuy
% Use the S&P as the market index
marketExcessReturn = SPymeanRW(1:numRW) - RF; % Our single prediction
X = [ones(length(marketExcessReturn), 1), marketExcessReturn, marketExcessReturn.^2];

portExcessReturn = opt_port_mu(1:numRW) - RF;
% (Rit - RFt) = ai + bi (Rmt - RFt) + ci (Rmt - RFt)^2 + eit
[b_T, bint_T, r_T, rint_T, stats_T] = regress(portExcessReturn, X);
timing = b_T(3);

