function [] = Double_predictions(pred_nnmf,pred_svd,table_of_artists,index)
%Takes in a pred matrix and outputs the recommended bands for user x to
%listen to for both svd and nnmf

[len,wid] = size(pred_nnmf);
fprintf('Press 0 to quit\n');
x = input("Which user would you like suggestions for? ");
while x~=0
    if x>=wid-1
        x = randi([1 wid],1,1);
        fprintf('Using random user, no user exists for that number\n');
    end
    individual_user_index = ~index(:,x);
    
    
    b = input('Total Artist Recommendations or New Only?\n1 for new, 2 for total: ');
    if sum(individual_user_index) == 0
        fprintf('No new artists recommended, here are there top artists:\n');
        individual_user = pred_nnmf(:,[x end]);
        individual_user =sortrows(individual_user,'desc');
        individual_user2 = pred_svd(:,[x end]);
        individual_user2 =sortrows(individual_user2,'desc');
        [newl,~] = size(individual_user);
 fprintf('Users top recommendations from nnmf are:                Users top recommendations from svd are:\n');
        for i = 1:newl

            band_index = ismember(table_of_artists.id,individual_user(i,end));
            band_table = table_of_artists(band_index,:);
            band_index2 = ismember(table_of_artists.id,individual_user2(i,end));
            band_table2 = table_of_artists(band_index2,:);
             s = sprintf('%d: %-52s %d: %s\n',i,band_table.name(1),i,band_table2.name(1));
             fprintf(s);
        end
         fprintf('\n\n');
    elseif b == 1
        individual_user = pred_nnmf(individual_user_index,[x end]);
        individual_user =sortrows(individual_user,'desc');
        individual_user2 = pred_svd(individual_user_index,[x end]);
        individual_user2 =sortrows(individual_user2,'desc');
        [newl,~] = size(individual_user);
 fprintf('Users top recommendations from nnmf are:                Users top recommendations from svd are:\n');
        for i = 1:newl

            band_index = ismember(table_of_artists.id,individual_user(i,end));
            band_table = table_of_artists(band_index,:);
            band_index2 = ismember(table_of_artists.id,individual_user2(i,end));
            band_table2 = table_of_artists(band_index2,:);
             s = sprintf('%d: %-52s %d: %s\n',i,band_table.name(1),i,band_table2.name(1));
             fprintf(s);
        end
         fprintf('\n\n');
    elseif b == 2
        
        individual_user = pred_nnmf(:,[x end]);
        individual_user =sortrows(individual_user,'desc');
        individual_user2 = pred_svd(:,[x end]);
        individual_user2 =sortrows(individual_user2,'desc');
        [newl,~] = size(individual_user);
 fprintf('Users top recommendations from nnmf are:                Users top recommendations from svd are:\n');
        for i = 1:newl

            band_index = ismember(table_of_artists.id,individual_user(i,end));
            band_table = table_of_artists(band_index,:);
            band_index2 = ismember(table_of_artists.id,individual_user2(i,end));
            band_table2 = table_of_artists(band_index2,:);
             s = sprintf('%d: %-52s %d: %s\n',i,band_table.name(1),i,band_table2.name(1));
             fprintf(s);
        end
         fprintf('\n\n');

    elseif b == 0
        x = 0;
        return
    end
        
    
    x = input("Which user would you like suggestions for? ");
end

end

