function tests = testCalcDuration
tests = functiontests(localfunctions);
end

function testCalcDuration_assignment9Duration(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actualMacaulay = calcDuration(5, 0.10, 0.10, 1, 'Macaulay');
expectedMacaulay = 4.1699; % See assignment week 9
testCase.assertThat(actualMacaulay, IsEqualTo(expectedMacaulay, 'Within', RelativeTolerance(0.001)));

actualModified = calcDuration(5, 0.10, 0.10, 1, 'Modified');
expectedModified = 3.791;
testCase.assertThat(actualModified, IsEqualTo(expectedModified, 'Within', RelativeTolerance(0.001)));
end

function testCalcDuration_semiAnnualPayment(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actualMacaulay = calcDuration(5, 0.10, 0.10, 2, 'Macaulay');
expectedMacaulay = 4.051;
testCase.assertThat(actualMacaulay, IsEqualTo(expectedMacaulay, 'Within', RelativeTolerance(0.001)));

actualMod = calcDuration(5, 0.10, 0.10, 2, 'Modified');
expectedMod = 3.858;
testCase.assertThat(actualMod, IsEqualTo(expectedMod, 'Within', RelativeTolerance(0.01)));
end

function testCalcDuration_quarterlyPayment(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actualMacaulay = calcDuration(5, 0.10, 0.10, 4, 'Macaulay');
expectedMacaulay = 3.995;
testCase.assertThat(actualMacaulay, IsEqualTo(expectedMacaulay, 'Within', RelativeTolerance(0.001)));

actualMod = calcDuration(5, 0.10, 0.10, 4, 'Modified');
expectedMod = 3.897;
testCase.assertThat(actualMod, IsEqualTo(expectedMod, 'Within', RelativeTolerance(0.01)));
end

% http://financialexamhelp123.com/macaulay-duration-modified-duration-and-effective-duration/
function testCalcDuration_interestRateCouponRateDiffer(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actualMac = calcDuration(5, 0.04, 0.06, 1, 'Macaulay');
expectedMac = 4.49;
testCase.assertThat(actualMac, IsEqualTo(expectedMac, 'Within', RelativeTolerance(0.01)));

actualMod = calcDuration(5, 0.04, 0.06, 1, 'Modified');
expectedMod = 4.32;
testCase.assertThat(actualMod, IsEqualTo(expectedMod, 'Within', RelativeTolerance(0.01)));
end

% Wait, Matlab has all of this stuff built-in...
function testCompareWithMatlab(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

ytm = 0.03696;
coupon = 0.04000;

for annualPayments = [0, 1, 2, 3, 4, 6, 12]
    actualModified = calcDuration(10, ytm, coupon, annualPayments, 'Modified');
    actualMacaulay = calcDuration(10, ytm, coupon, annualPayments, 'Macaulay');
    [modified, macaulay] = bnddury(ytm, coupon, '01-Jan-2000', '31-Dec-2009', annualPayments);
    testCase.assertThat(actualModified, IsEqualTo(modified, 'Within', RelativeTolerance(0.02)));
    testCase.assertThat(actualMacaulay, IsEqualTo(macaulay, 'Within', RelativeTolerance(0.02)));
end
end