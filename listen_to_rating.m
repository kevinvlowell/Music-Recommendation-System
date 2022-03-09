function [new_mat] = listen_to_rating(mat)
%Converts the normalized listening count for a user to a rating

%constructing the new "ratings" matrix
u = mat(:,1:end-1);
[l,w] = size(u);
new_mat = zeros(l,w);
for i = 1:w
    [n,e,bins] = histcounts(mat(:,i),5);
    new_mat(:,i) = bins;
end
new_mat = [new_mat mat(:,end)];
end

