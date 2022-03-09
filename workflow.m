%Final workflow
top_k_bands = 100;
ratings_per_user = 20;
rank = 4;
random_removals = 10;
iterations = 10;

% % Loading the Data for the music recommendation system
 Dataload;

% Reading in to our desired matrix size
mrs = tbu(userartists2,top_k_bands,ratings_per_user);

% Normalizing the data

 mrs2 = norm_data(mrs);

% Convert listen counds to ratings

mrs3 = listen_to_rating(mrs2);

%Getting the reconstructed matrix after nnmf
[w, h, info, pred,final_rmse,index] = rande2(mrs3,random_removals,rank,iterations);


%Getting the reconstructed matrix after svd
recommendation_sys_SVD;
predicted_listens_matrix = [predicted_listens_matrix' pred(:,end)];

% Getting the predictions for nnmf and svd
Double_predictions(pred,predicted_listens_matrix,artists1,index);