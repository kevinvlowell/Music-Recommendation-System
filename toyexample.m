% toy example
 Names = ["Larry" "Earvin" "Steph" "Jordan" "Lebron" "Charles"];
 Bands = ["Metallica";"Pantera";"Katy Perry";"Justin Bieber";"Led Zeppelin"];
 m_r_p = eye(5,6);
 m_r_p(1,:) = [5 4 1 1 3 2];
 m_r_p(2,:) = [5 3 0 1 4 0];
 m_r_p(3,:) = [1 1 5 5 2 1];
 m_r_p(4,:) = [0 0 0 3 3 0];
 m_r_p(5,:) = [2 0 1 2 3 5];
 original_tab = array2table(m_r_p,"VariableNames",Names,'RowNames',Bands);
 
[w,h,d] = nnmf(m_r_p,1);


w_names = ["Hard Metal" "Pop" "Rock"];

% w_tab = array2table(w,"VariableNames",w_names,'RowNames',Bands);
% h_tab = array2table(h,"VariableNames",Names,'RowNames',w_names');
w_tab = array2table(w);
h_tab = array2table(h);
reconstructed = w*h;