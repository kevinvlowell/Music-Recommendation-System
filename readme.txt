To run all of the code, simply run the workflow.m file with the pwd containing all other files included in this folder.

At the top of the workflow file, you can change the parameters for:

Number of most popular bands you want to include
Number of ratings a user must have 
Rank of the factorization
Number of random elements to remove from the matrix 
Number of times to perform the random removal 

***Processing and Cleaning***
Dataload reads in the files which can be found at https://grouplens.org/datasets/hetrec-2011/ (files from hetrec2011-lastfm-2k.zip only)
Place them in the same directory as all included files in this folder

The tbu function is used to segmet the data by selecting n top bands, and users who have rated atleast m bands.
    - Depends on spartisty, which is a function which determines how many points of the matrix are empty

The norm_data function adjusts outliers and then normalizs the data by column

The listen_to_rating function takes in the normalized data and converts it to ratings

***Perfoming Calculations***
The rande2 function calculates the rmse for the randomly removed points and the overall input matrix using nnmf

The recommendations_sys_SVD computes the SVD decomposition and associated best rank

The Double_predictions functions takes in the best reconstruction matrices produced in the previous two steps and outputs the predictions for any user in the dataset