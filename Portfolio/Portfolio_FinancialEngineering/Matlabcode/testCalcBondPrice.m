function tests = testCalcBondPrice
tests = functiontests(localfunctions);
end

function testCalcBondPrice_assignment9AnnualPayment(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

yearsToMaturity = 10;
requiredYield = 0.10;
couponRate = 0.10;
paymentsPerYear = 1;
faceValue = 1000;

actual = calcBondPrice(yearsToMaturity, requiredYield, couponRate, paymentsPerYear, faceValue);
expected = 1000;
testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.001)));
end

% http://www.investopedia.com/university/advancedbond/advancedbond2.asp
function testYtm_zeroCoupon(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actual = calcBondPrice(5, 0.06, 0.00, 0, 1000);
expected = 744.09;
testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.001)));
end

% http://www.investopedia.com/university/advancedbond/advancedbond2.asp
function testCalcBondPrice_semiannualPayments(testCase)
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.RelativeTolerance

actual = calcBondPrice(10, 0.12, 0.10, 2, 1000);
expected = 885.32;
testCase.assertThat(actual, IsEqualTo(expected, 'Within', RelativeTolerance(0.001)));
end
