function [duration] = calcDuration(yearsToMaturity, yieldToMaturity, couponInterest, paymentsPerYear, type)
% Calculates the duration for a given bond
% Note. The implementaion resembles the formulas presented in week 9.
% However, what was there refered to as 'Modified Duration' (at least
% in the exercise solution) is here equivalent to 'Macaulay Duration'.

if (nargin < 4)
    paymentsPerYear = 2;
end

if (paymentsPerYear < 0)
    msg = sprintf('Illegal argument exception. Number of payments per year cannot be negative');
    baseException = MException('Domo:calcDuration', msg);
    throw(baseException);
end

if nargin < 5
    type = 'Modified';
end

if ~any(ismember({'Macaulay', 'Modified'}, type))
    msg = sprintf('Illegal argument exception. Duration type %s not supported', type);
    baseException = MException('Domo:calcDuration', msg);
    throw(baseException);
end

if paymentsPerYear == 0 % Semi-hack to deal with zero coupons
    duration = calcDuration(yearsToMaturity, yieldToMaturity, 0, 2, type);
else
    % Again, in week 9 this would be the Modified Duration. Going with the below
    % anyway as I keep mixing them up when comparing results with online examples
    % that demoenstrates bonds duration calculation with non-annual payments and
    % various interest rates.
    if strcmp('Macaulay', type)
        couponAmount = 100 * (couponInterest/paymentsPerYear);
        numberOfCashFlows = yearsToMaturity * paymentsPerYear;
        
        macaulay = 0;
        for t = 1:numberOfCashFlows
            macaulay = macaulay + (t * couponAmount) / (1 + yieldToMaturity/paymentsPerYear)^t;
        end
        macaulay = macaulay + (numberOfCashFlows * 100) / (1 + yieldToMaturity/paymentsPerYear)^numberOfCashFlows;
        macaulay = macaulay / (paymentsPerYear * calcBondPrice(yearsToMaturity, yieldToMaturity, couponInterest, paymentsPerYear, 100));
        
        duration = macaulay;
    end
    
    if strcmp('Modified', type)
        macaulay = calcDuration(yearsToMaturity, yieldToMaturity, couponInterest, paymentsPerYear, 'Macaulay');
        modified = macaulay / (1 + yieldToMaturity/paymentsPerYear);
        
        duration = modified;
    end
end

end
