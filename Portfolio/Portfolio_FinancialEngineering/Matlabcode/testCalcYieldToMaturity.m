function tests = testCalcYieldToMaturity
% Unit tests covering yield to maturity calculations.
tests = functiontests(localfunctions);
end

function testYtm_assignment9AnnualPayment(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actual = calcYieldToMaturity(5, 960, 0.10, 1, 1000);
expected = 0.1108; % See assignment week 9
testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.001)));
end

function testYtm_assignment9SemiAnnualPayment(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actual = calcYieldToMaturity(5, 960, 0.10, 2, 1000);
expected = 0.1106; % See assignment week 9
testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.001)));
end

function testYtm_textbookZeroCoupon(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actual_sixMonths = calcYieldToMaturity(0.5, 970.87, 0.00, 0, 1000);
testCase.assertThat(actual_sixMonths, IsEqualTo(0.06, 'Within', RelativeTolerance(0.001)));

actual_oneYear = calcYieldToMaturity(1, 933.51, 0.00, 0, 1000);
testCase.assertThat(actual_oneYear, IsEqualTo(0.07, 'Within', RelativeTolerance(0.001)));

actual_threeYears = calcYieldToMaturity(3, 725.25, 0.00, 0, 1000);
testCase.assertThat(actual_threeYears, IsEqualTo(0.11, 'Within', RelativeTolerance(0.001)));
end

function testYtm_ZeroCouponInvestopediaExample(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actual = calcYieldToMaturity(5, 744.09, 0.00, 2, 1000);
expected = 0.06;
testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.001)));
end

% Price:	103.05
% Coupon (%):	2.450
% Maturity Date:	1-Nov-2020
% Yield to Maturity (%):	1.902
% Current Yield (%):	2.378
% Coupon Payment Frequency:	Semi-Annual
% Callable:	No
% Settlement Date:	4-Dec-2014
function testYtm_CocaColaCo(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actual = calcYieldToMaturity(6, 103.05, 0.0245);
expected = 0.01902;
testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.01)));
end

% Wait, Matlab has all of this stuff built-in...
function testCompareWithMatlab(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

coupon = 0.04000;
for price = [90, 100, 110]
    for annualPayments = [0, 1, 2, 4]
        actual = calcYieldToMaturity(10, price, coupon, annualPayments);
        expected = bndyield(price, coupon, '01-Jan-2000', '31-Dec-2009', annualPayments);
        testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.015)));
    end
end
end