function [yieldToMaturity] = calcYieldToMaturity(yearsToMaturity, price, couponInterest, paymentsPerYear, faceValue)
% Calculates the yield to maturity for a given fixed-income bond.
% 

if nargin < 3
    msg = sprintf('Illegal argument exception. Expected (at least) 3 arguments - got %d', nargin);
    baseException = MException('Domo:calcBondCharacteristics', msg);
    throw(baseException);
end

if nargin == 3
    paymentsPerYear = 2; % Semiannual payouts is said to be the most common
end

if nargin < 5
    faceValue = 100;
end

if (paymentsPerYear < 0)
    msg = sprintf('Illegal argument exception. Number of payouts per year cannot be negative');
    baseException = MException('Domo:calcBondCharacteristics', msg);
    throw(baseException);
end

if (paymentsPerYear ~= 0)
    couponAmount = faceValue * (couponInterest/paymentsPerYear);
    remainingCoupons = yearsToMaturity * paymentsPerYear;

    % Create symbolic variable and build up equation
    syms ytm;
    eqn = 0;
    for i = 1:remainingCoupons
        eqn = eqn + couponAmount / (1 + ytm/paymentsPerYear)^i;
    end
    eqn = eqn + faceValue/(1 + ytm/paymentsPerYear)^remainingCoupons; % Principal is paid along with last coupon
    eqn = eqn == price;
else
    syms ytm;
    eqn = faceValue/(1 + ytm/2)^(2*yearsToMaturity) == price; % ytm is essential the spot rate
end

ytm = vpasolve(eqn);

% It's silly, but this is an attempt to single out the "correct" value among those returned by the solver...
yieldToMaturity = NaN;
for i = 1 : length(ytm)
    ytmAsDouble = double(ytm(i));
    if isreal(ytmAsDouble)
        if isnan(yieldToMaturity) || yieldToMaturity < ytmAsDouble
            yieldToMaturity = ytmAsDouble;
        end
    end
end

end
