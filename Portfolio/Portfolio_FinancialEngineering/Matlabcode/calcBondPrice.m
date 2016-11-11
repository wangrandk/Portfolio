function [ price ] = calcBondPrice(yearsToMaturity, requiredYield, couponInterest, paymentsPerYear, faceValue)
%CALCBONDPRICE Calculates the price for given bond. Currently only the clean price
%for a fixed-income security is supported.

if nargin < 4
    paymentsPerYear = 2;
end

if nargin < 5
    faceValue = 100;
end

if paymentsPerYear == 0
    price = calcBondPrice(yearsToMaturity, requiredYield, 0, 2, faceValue);
else
    couponAmount = faceValue * (couponInterest/paymentsPerYear);
    remainingCoupons = yearsToMaturity * paymentsPerYear;
    
    price = 0;
    for i = 1:remainingCoupons
        price = price + couponAmount / (1 + requiredYield/paymentsPerYear)^i;
    end
    price = price + faceValue/(1 + requiredYield/paymentsPerYear)^remainingCoupons; % Principal is paid along with last coupon
end

end
