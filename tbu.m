function [matrix] = tbu(mat,top_bands,number_rated)
%returns matrix with most rated bands, with specified number of bands rated
%per person
%Takes in a matrix in the format users on columns, items on rows

%converting Nan to 0
mat(isnan(mat(:,1:end-1)))=0;
% mat = normalize(mat,2);

%Top n arstists
[B, I] = maxk(sum(mat~=0,2),top_bands);
ua = mat(I,1:end-1);
bands = mat(I,end);
%If we want to select only people who have rated n bands
max_bands_rated =  max(sum(ua ~=0));
if number_rated>=max_bands_rated
    fprintf('Max items rated is %i, using this value\n',max_bands_rated);
    number_rated = max_bands_rated;
end

index = sum(ua~=0)>=number_rated;
ua_adjusted =  ua(:,index);

% Having it with users as columns makes some of the interpretation stuff
% easier
matrix = ua_adjusted;

sp = sparsity(matrix);
fprintf('This matrix is %.2f percent sparse\n',sp);
matrix(matrix == 0) = NaN;
matrix = [matrix bands];
end

