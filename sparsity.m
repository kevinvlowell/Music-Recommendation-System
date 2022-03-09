function [sparsity] = sparsity(matrix)
[a,b] = size(matrix);
sparsity = 100*sum(sum(matrix==0))/(a*b);
end

