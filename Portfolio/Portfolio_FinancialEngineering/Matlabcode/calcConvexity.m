function [ convexity ] = calcConvexity(yearsToMaturity, yieldToMaturity, couponInterest, paymentsPerYear)
%CALCCONVEXITY Calculates the annualized convexity of a vanilla bond.

if nargin < 4
    paymentsPerYear = 2;
end

if paymentsPerYear == 0 % Again, this is to handle zero-coupon bounds.
    convexity = calcConvexity(yearsToMaturity, yieldToMaturity, 0, 2);
else
    % Compared to the formula in the book, this implementation has an
    % additional component and is also annualized. See
    % http://faculty.darden.virginia.edu/conroyb/valuation/val2002/f-1238.pdf
    % (The specific example in the textbook deals with a zero-coupon bond
    % and might also be a sligthy less accrurate approximation.)
    couponAmount = 100 * (couponInterest/paymentsPerYear);
    numberOfCashFlows = yearsToMaturity * paymentsPerYear;
    multiplier = 1 / (1+yieldToMaturity/paymentsPerYear)^2; % The extra component!
    
    convexity = 0;
    for t = 1:numberOfCashFlows
        convexity = convexity + multiplier * (t * (t + 1) * couponAmount) / (1 + yieldToMaturity/paymentsPerYear)^t;
    end
    convexity = convexity + multiplier * (numberOfCashFlows * (numberOfCashFlows + 1) * 100) / (1 + yieldToMaturity/paymentsPerYear)^numberOfCashFlows;
    convexity = convexity / calcBondPrice(yearsToMaturity, yieldToMaturity, couponInterest, paymentsPerYear, 100);
    convexity = convexity / paymentsPerYear^2; % Annualize convexity!
end

end
