%% import the data as a user-artist matrix, where elements represent listen-counts
% clear; clc;

% run Dataload.m script to retrieve datasets
% Dataload;

% same x as used in the nnmf
 X = mrs3(:,1:end-1);


%% testing

[PC_matrix, W, sorted_lambda_vec] = svd_deconstruction(X,0,0,0);
k_principled = k_plotter(sorted_lambda_vec, .90);
predicted_listens_matrix = low_rank_matrix_approximator(mean(X),W,PC_matrix,k_principled);

%% svd-based low-rank deconstruction functions

function [PC_matrix, W, sorted_lambda_vec] = svd_deconstruction(X, default_vals, is_col_means, is_row_means)
% input values are the data matrix X (dxn) and the value OR vector that will be
% used to populate the empty cells in the sparse data set. If the empty
% cells in the matrix are to be populated using the relevant column means
% or row means, pass a VECTOR of the means to default_vals and indicate 1
% for is_col_means or is_row_means as appropriate. Otherwise, indicate 0
% for both parameter flags and pass a singular value to default_vals

% output values are the matrix of principal components (PC_matrix), W
% derived via PCA using SVD, and a vector of eigenvalues from largest to
% smallest

%% populate "empty" cells of matrix with desired default values

% 0 is the default value for empty cells

% using matrix average value to fill empty cells
if (is_col_means == 0 && is_row_means == 0)
    X(X==0) = default_vals;

% using column means to fill empty cells
elseif (is_col_means == 1 && is_row_means == 0)
    for i = 1:length(default_vals)
        logical_index = X(:,i) == 0;
        X(logical_index) = default_vals(i);
    end
% using row means to fill empty cells
elseif (is_col_means == 0 && is_row_means == 1)
    for i = 1:length(default_vals)
        logical_index = X(i,:) == 0;
        X(logical_index) = default_vals(i);
    end
else
    error("Invalid input arguments for SVD deconstruction. Please check flags and default values");
end

%% solve for orthonormal eigenvectors of empirical covariance matrix using SVD
[~, user_count] = size(X);

% calculate X_tilde
mean_vec = mean(X);
X_tilde = X-mean_vec;

% scale X_tilde
X_tilde_scaled = (1/sqrt(user_count))*X_tilde;

%% perform reduced SVD to solve for W (left singular vectors of X_tilde_scaled)

[W,S,~] = svd(X_tilde_scaled,"econ");

% compute all principal components
PC_matrix = W'*X_tilde;

% compute eigenvalues of empirical covariance matrix
lambdas = S.^2;
sorted_lambda_vec = diag(lambdas);

end

function k_principled = k_plotter(eigenvalue_vector, principled_threshold)
% produces a scree plot (heuristic method) and plots returns the values of k
% determined via the principled method and a given threshold. Returns best
% k from principled method

%% use heuristic method to visualize best value of k

% create scree plot
component_nums = [1:length(eigenvalue_vector)];

figure
plot(component_nums, eigenvalue_vector, 'b')
xlabel("Component Index")
ylabel("Eigenvalues")
title("Scree Plot")

%% use the principled method to solve for best value of k
frac_of_var = zeros(1,length(eigenvalue_vector));

for k = 1:length(eigenvalue_vector)

    top_k_sum = sum(eigenvalue_vector(1:k));
    frac_of_var(k) = round(top_k_sum/sum(eigenvalue_vector),2);

end

k_principled = find(frac_of_var >= principled_threshold, 1);

k = [1:length(eigenvalue_vector)];
figure
plot(k,frac_of_var,'b')
xlabel("k")
ylabel("Fraction of Variance (\rho)")
title("Principled Method Results: k vs. Fraction of Variance")
hold on;

% plot chosen threshold value
yline(principled_threshold,'--r', sprintf('threshold = %.2f',principled_threshold))
xl = xline(k_principled,'g', sprintf("k = %d",k_principled));
xl.LabelVerticalAlignment = "middle";
hold off;

end

%% reconstruction function

function predicted_listens_matrix = low_rank_matrix_approximator(mu_x,W,PC_matrix,k)
% reconstructs the rating matrix using the top k principal components. mu_x
% should be dx1, W should be dxk, and PC_matrix kxn

predicted_listens_matrix = (mu_x + W(:,1:k)*PC_matrix(1:k,:))';

% convert negative listen counts to 0, since negative listens aren't
% meaningful
predicted_listens_matrix = max(predicted_listens_matrix, 0);

end
