[user_count,artist_count] = size(userartists);

listen_counts_per_user = zeros(user_count,1);

for i = 1:user_count
    for j = 1:artist_count   
        listen_counts_per_user(i) = listen_counts_per_user(i) + userartists(i,j);
    end
end

number_of_users = [1:user_count];

% group users by listening count

listening_categories = [481000:-1000:0];
users_per_listening_category = zeros(length(listening_categories),1);

% compile number of users per listening category

for i = 1:length(listening_categories)
    users_per_listening_category(i) = sum(listen_counts_per_user > listening_categories(i));
end

figure
plot(users_per_listening_category,listening_categories,'b')
xlabel("Number of Users")
ylabel("Total Number of Song Listens")
title("Number of Users vs Number of Listens")



artists_played_per_user = zeros(user_count,1);

for i = 1:user_count
    artists_played_per_user(i) = sum(userartists(i,:)~=0);
end

% group users by number of artists listened to

artist_count_categories = [0:50];
users_per_artist_category = zeros(length(artist_count_categories),1);

% compile number of users per listening category

for i = 1:length(artist_count_categories)
    users_per_artist_category(i) = sum(artists_played_per_user > artist_count_categories(i));
end

figure
plot(users_per_artist_category, artist_count_categories,'b')
xlabel("Number of Users")
ylabel("Number of Artists Played")
title("Number of Users vs Number of Artists Played")