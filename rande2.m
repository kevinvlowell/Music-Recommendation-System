function [w,h,info,pred,final_rmse,index_already_rated] = rande2(mat,rand_removals,rank,iterations)
%normalizes the data and removes a selected number and random values,
%returns all the predicted information as well as the rmse of the predicted
%removals

%input are the matrix of interest, the number of items to be removed, the
%rank of the factorized matrix, and the number of iterations to calculate
%average rmse
%Output is the w,h, and info associated, final predicted matrix, the final
%average rmse and the index of already rated points 
u = mat(:,1:end-1);
[l,w] = size(u);
if rank>l || rank>w
    if l<=w
        rank = l;
    else
        rank = w;
    end
    fprintf('Rank is larger than input matrix allows, result will be full rank\n');
end
index_already_rated = u == 0;

index_already_rated =~index_already_rated;

t = u;
t(isnan(t)) = 0;

[w,h,info] = nnmf(t,rank,'replicates',100);

%randomly remove some elements and check how close the prediction is
rem_vec = zeros(rand_removals,2);
[l,girth] = size(u);
t2 = t;
avg_rmse = zeros(1,iterations);

j2 = w*h;
pred = [j2 mat(:,end)];
for j = 1:iterations
    count = 1;
pass = false;

while count<(rand_removals+1)
rand_x = randi(l,1);
rand_y = randi(girth,1);
if t2(rand_x,rand_y)~= 0
    rem_vec(count,:) = [rand_x, rand_y];
    t2(rem_vec(count,1),rem_vec(count,2)) = 0;
    pass = true;
end
if pass
count = count+1;
pass = false;
end
end

[w2,h2,info2] = nnmf(t2,rank,'replicates',100);
j2 = w2*h2;

%Finding the values of rmse for the randomly removed points
close = 0;
for i = 1:rand_removals
    close = close + norm(t(rem_vec(i,1),rem_vec(i,2))-j2(rem_vec(i,1),rem_vec(i,2)));
end
avg_rmse(j) = sqrt(close/rand_removals);
end

%Plot of the RMSE as we move through each iteration randomly removing some
%values
plot(avg_rmse);
title('RMSE Calcualted for Each Iteration');
ylabel('RMSE');
xlabel('Iteration');
final_rmse = mean(avg_rmse);
fprintf('After %d random removals executed %d times, the NNMF reconstructed the values with a average RMSE of %.2f\n',rand_removals,iterations,final_rmse);
    
%How close are the predicted ratings to the correct ratings
orig = t(index_already_rated);
new = pred(index_already_rated);

total_rmse = sqrt(mean((orig-new).^2));
fprintf('The reconstruction error for the already observed points was %.2f\n',total_rmse);

end

