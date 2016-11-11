A = load('iris.data');
A(:, end) = [];
[n, m] = size(A);
k = 3;

for i = 1 : 100
	Cinit = A(randsample(n, k), :);
	idx = kmeans(A, k, 'Start', Cinit);
	idx3 = kmeans3(A, k, 'Start', Cinit);
	if any(idx ~= idx3)
		fprintf('Test failed!\n');
		return;
	end
end

fprintf('Test passed!\n')
