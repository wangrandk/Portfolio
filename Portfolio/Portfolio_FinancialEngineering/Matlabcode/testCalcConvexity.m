function tests = testCalcConvexity
tests = functiontests(localfunctions);
end

% % Currently assuming that Equation (22.4) does not annualized for bonds with coupon
% % payments, i.e. it is specific for their zero-coupon example. This test (assignment 9)
% % will fail if asserting against the result from the exercise solution.
% function testCalcConvexity_assignment9(testCase)
% import matlab.unittest.constraints.IsEqualTo
% import matlab.unittest.constraints.RelativeTolerance
%
% actual = calcConvexity(5, 0.10, 0.10, 1);
% expected = 11.7178; % See assignment 9.
% testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.001)));
% end

function testCalcConvexity_assignment9OnWolframAlpha(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actual = calcConvexity(5, 0.10, 0.10, 1);
expected = 19.37; % Using Wolfram Alpha see http://tinyurl.com/pnfjzzf
testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.001)));
end

% http://faculty.darden.virginia.edu/conroyb/valuation/val2002/f-1238.pdf
function testCalcConvexity_DardenUniversity(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actual = calcConvexity(6, 0.10, 0.061, 2);
expected = 27.72;
testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.001)));
end

% Wait, Matlab has all of this stuff built-in...
function testCompareWithMatlab(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

ytm = 0.03696;
coupon = 0.04000;

for annualPayments = [0, 1, 2, 3, 4, 6, 12]
    actual = calcConvexity(10, ytm, coupon, annualPayments);
    expected = bndconvy(ytm, coupon, '01-Jan-2000', '31-Dec-2009', annualPayments);
    testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.015)));
end
end