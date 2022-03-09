%% Import data from text file
%% Import User Listening Data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["userID", "artistID", "weight"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
userartists = readtable("user_artists.dat", opts);
%Pivot wider for user rows
userartists = unstack(userartists,'weight','artistID');
%remove first row (id number not important for now)
userartists = userartists(:,2:end);
% %% Convert to output type
userartists = table2array(userartists);
userartists = userartists';

%% Clear temporary variables
clear opts

%% Import Friend Information
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["userID", "friendID"];
opts.VariableTypes = ["double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
userfriends1 = readtable("user_friends.dat", opts);

%% Convert to output type
userfriends1 = table2array(userfriends1);

%% Clear temporary variables
clear opts

%% Import Tag Information
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["tagID", "tagValue"];
opts.VariableTypes = ["double", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "tagValue", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "tagValue", "EmptyFieldRule", "auto");

% Import the data
tags = readtable("tags.dat", opts);


%% Clear temporary variables
clear opts


%% Import Artist Information
opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["id", "name", "Var3", "Var4"];
opts.SelectedVariableNames = ["id", "name"];
opts.VariableTypes = ["double", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["name", "Var3", "Var4"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["name", "Var3", "Var4"], "EmptyFieldRule", "auto");

% Import the data
artists1 = readtable("artists.dat", opts);

artists1 = artists1(2:end,:);
%% Clear temporary variables
clear opts


%% Import User Tags
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["userID", "artistID", "tagID", "day", "month", "year"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
usertaggedartists1 = readtable("user_taggedartists.dat", opts);

%% Convert to output type
usertaggedartists1 = table2array(usertaggedartists1);

%% Clear temporary variables
clear opts

%%
%converting Nan to 0
userartists(isnan(userartists))=0;
% userartists = normalize(userartists,2);

%Top n arstists
top_bands = 100;
[B, I] = maxk(sum(userartists),top_bands);
ua = userartists(:,I);

%If we want to select only people who have rated n bands
total_rated =  sum(ua == 0,2);
bands_rated = 20;

ua_adjusted =  ua(sum(ua==0,2)<top_bands-bands_rated,:);

% Having it with users as columns makes some of the interpretation stuff
% easier
ua_adj_transpose = ua_adjusted';
p = table2array(artists1(:,1));
userartists2 = [userartists,p];
