clear all
clc
close all
%% 2.a) Yield to maturity, (Modified) duration, and convexity of each bond.
% U S TREAS BD STRIPPED PRIN PMT15-Aug-2025
% Price:	78.11
% Maturity Date:	15-Aug-2025
% Yield to Maturity (%):	2.322
% Type:	Treasury Zero
% Settlement Date:	2-Dec-2014
% URL: http://tinyurl.com/zknwaka
treas_ytm = calcYieldToMaturity(2025.71-2014.92, 78.11, 0, 0);
treas_dur = calcDuration(2025.71-2014.92, treas_ytm, 0.00);
treas_con = calcConvexity(2025.71-2014.92, treas_ytm, 0.00);

% GENERAL ELECTRIC CAPITAL CORP     As of 30-Nov-2015
% Price:	99.94
% Coupon (%):	3.000
% Maturity Date:	15-Nov-2025
% Yield to Maturity (%):	3.007
% Current Yield (%):	3.002
% Fitch Ratings:	AA
% Coupon Payment Frequency:	Semi-Annual
% First Coupon Date:	15-May-2013
% Type:	Corporate
% Callable:	No
% Settlement Date:	4-Dec-2014
% URL:  http://tinyurl.com/nwpesjo
ge_ytm = calcYieldToMaturity(2026-2015, 99.94, 0.03000);
ge_dur = calcDuration(2026-2015, ge_ytm, 0.03000);
ge_con = calcConvexity(2026-2015, ge_ytm, 0.03000);

% MORGAN STANLEY
% Price:	102.50
% Coupon (%):	4.000
% Maturity Date:	1-Nov-2024
% Yield to Maturity (%):	3.696
% Current Yield (%):	3.902
% Fitch Ratings:	A
% Coupon Payment Frequency:	Semi-Annual
% First Coupon Date:	1-May-2013
% Type:	Corporate
% Callable:	No
% Settlement Date:	4-Dec-2014
% URL: http://tinyurl.com/h329qpj
ms_ytm = calcYieldToMaturity(2025-2015, 102.50, 0.04000);
ms_dur = calcDuration(2025-2015, ms_ytm, 0.04000);
ms_con = calcConvexity(2025-2015, ms_ytm, 0.04000);

% VERIZON COMMUNICATIONS INC	As of 30-Nov-2015
% Price:	100.87
% Coupon (%):	3.500
% Maturity Date:	1-Nov-2024
% Yield to Maturity (%):	3.396
% Current Yield (%):	3.470
% Fitch Ratings:	BBB
% Coupon Payment Frequency:	Semi-Annual
% First Coupon Date:	1-May-2015
% Type:	Corporate
% Callable:	No
% Settlement Date:	4-Dec-2014
% URL: http://tinyurl.com/o3ls2pu
vc_ytm = calcYieldToMaturity(2025-2015, 100.87, 0.03500);
vc_dur = calcDuration(2025-2015, vc_ytm, 0.03500);
vc_con = calcConvexity(2025-2015, vc_ytm, 0.03500);

% NORTH LAS VEGAS NEV GO LTD TAX WTR WASTEWTR IMPT B	As of 30-Nov-2015
% Price:	94.10
% Coupon (%):	6.122
% Maturity Date:	1-Jun-2025
% Yield to Maturity (%):	6.922
% Current Yield (%):	6.506
% Fitch Ratings:	BB
% Coupon Payment Frequency:	Semi-Annual
% First Coupon Date:	1-Dec-2010
% Callable:	No
% Type:	Municipal
% Settlement Date:	4-Dec-2014
% URL: http://tinyurl.com/glh6w63
muni_ytm = calcYieldToMaturity(2025.5-2015, 94.10, 0.06122);
muni_dur = calcDuration(2025.5-2015, muni_ytm, 0.06122);
muni_con = calcConvexity(2025.5-2015, muni_ytm, 0.06122);

% WENDYS INTL INC	As of 30-Nov-2015
% Price:	108.75
% Coupon (%):	7.000
% Maturity Date:	15-Dec-2025
% Yield to Maturity (%):	5.909
% Current Yield (%):	6.437
% Fitch Ratings:	B
% Coupon Payment Frequency:	Semi-Annual
% First Coupon Date:	15-Jun-1996
% Type:	Corporate
% Callable:	No
% Settlement Date:	4-Dec-2014
% URL: http://tinyurl.com/zjsa7tm
wen_ytm = calcYieldToMaturity(2026-2015, 108.75, 0.07000);
wen_dur = calcDuration(2026-2015, wen_ytm, 0.07000);
wen_con = calcConvexity(2026-2015, wen_ytm, 0.07000);

% PENNEY J C INC	As of 30-Nov-2015
% Price:	90.00
% Coupon (%):	6.900
% Maturity Date:	15-Aug-2026
% Yield to Maturity (%):	8.246
% Current Yield (%):	7.667
% Fitch Ratings:	CCC
% Coupon Payment Frequency:	Semi-Annual
% First Coupon Date:	15-Feb-1997
% Type:	Corporate
% Callable:	No
% Settlement Date:	4-Dec-2014
% URL: http://tinyurl.com/ptcnh6
jcp_ytm = calcYieldToMaturity(2026.5-2015, 90.00, 0.06900);
jcp_dur = calcDuration(2026.5-2015, jcp_ytm, 0.06900);
jcp_con = calcConvexity(2026.5-2015, jcp_ytm, 0.06900);

ytms = [treas_ytm, ge_ytm, ms_ytm, vc_ytm, muni_ytm, wen_ytm, jcp_ytm];

%% 2.b) Duration and convexity of a bond portfolio
EUR_USD_EXCHANGE_RATE = 1.0578976;

prices = [148.10, 99.94, 102.50, 100.87, 94.10, 108.75, 90.00] ./ EUR_USD_EXCHANGE_RATE;
durations = [treas_dur, ge_dur, ms_dur, vc_dur, muni_dur, wen_dur, jcp_dur];
convexities = [treas_con, ge_con, ms_con, vc_con, muni_con, wen_con jcp_con];

% This is a bit silly as in our case terms will cancel out. Oh well...
investments = ones(1, length(prices)) * 100000;
bondQuantities = investments ./ prices;
totalInvestment = sum(prices .* bondQuantities);
portfolioDuration = sum(((bondQuantities .* prices) ./ totalInvestment) .* durations);
portfolioConvexity = sum(((bondQuantities .* prices) ./ totalInvestment) .* convexities);

%% 2.c) Portfolio market value if yield increses 150 basis points.
yieldIncrease = 0.015;
weights = (bondQuantities .* prices) ./ totalInvestment;
return_unexpected = sum(weights .* (-durations .* yieldIncrease + 0.5 * convexities*yieldIncrease^2));
valueOfPortfolio_yieldIncrease = totalInvestment + totalInvestment * return_unexpected;