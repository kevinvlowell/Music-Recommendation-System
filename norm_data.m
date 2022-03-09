function [new_mat] = norm_data(mat)
%function takes in a matrix and modifies outliers, then normalizes 
u = mat(:,1:end-1);
u(u == 0) = NaN;
[l,w] = size(u);
new_mat = zeros(l,w);

for i = 1:w
    %adjusting the outliers
    new_mat(:,i) = filloutliers(u(:,i),'center','mean');
end
%normalizing by user
new_mat = normalize(new_mat,'range');
new_mat = [new_mat mat(:,end)];
end

