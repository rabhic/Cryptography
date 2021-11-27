
clc;
clear;
close all;

% Taking plain text as input
plain_text = input('Enter Plain text : ','s');
lowercase_plain_text = lower(plain_text);


% Taking key as input
key = input('Enter the key : ','s');
lowercase_key =lower(key);  


% Removeing spaces from key and plain text
lowercase_key = strrep(lowercase_key,' ','');
lowercase_plain_text=strrep(lowercase_plain_text,' ','');
pair_of_plain_text= make_pairs(lowercase_plain_text);
disp('Pairs of plain text : ');
disp(pair_of_plain_text);

% Extracting unique letters/characters from the key 
unique_char_key = unique(lowercase_key,'stable');


% Calling key_table_genereation for reciving key_table
key_table = key_table_generation(unique_char_key);
disp('Key table matrix of size 6x6 : ')
key_table=char(key_table);
disp(key_table);


% Calling playFair_encryption function for performing encryption
cipher_text = playFair_encryption(key_table,pair_of_plain_text);
disp(' ');
disp('Cipher Text ');
disp(cipher_text);


% Calling playFair_decryption functin for performing decryption
decrypted_text = playFair_decryption(key_table,cipher_text);
disp(' ');
disp('Decrypted Cipher : ');
disp(decrypted_text);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ALL FUNCTIONS

% Fucntion for key table    
function key_table = key_table_generation(unique_char_key)
    key_space ='abcdefghijklmnopqrstuvwxyz0123456789';
    key_table = zeros(6,6);

                % Copying alphabets/characters of unique_char_key to key_table_array
                key_table_array = zeros(1,36); % creating 1D key_table_array to temporarily stor key_matrix
                for i=1:length(unique_char_key)
                    index=strfind(key_space,unique_char_key(i));
                    key_table_array(i)=key_space(index);
                    key_space = erase(key_space,key_space(index));
                end


                % Copying remaining alphabet and numbers of key_pace to key_table_array
                for i=1:length(key_space)
                   key_table_array(length(unique_char_key)+i)=key_space(i);
                end
                
                % Creating 2D matrix of key_table from 1D key_table_array
                key_table=reshape(key_table_array,6,6);
                key_table=transpose(key_table);                

end


% Function for making pairs
function pair_of_plain_text=make_pairs(lowercase_plain_text)
        
        % Finding length of lowercase_plain_text
        len_of_plain_text = length(lowercase_plain_text);

        temp_lowercase_plain_text=[];
        i=1;
        while i<=len_of_plain_text

            % to make a completer pair we add extra 'z' to make a complete pair
            if i+1 >len_of_plain_text 
                temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,lowercase_plain_text(i));
                if lowercase_plain_text(i)~= 'z'
                    temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,'z');
                else
                    temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,'0');
                end
                break;
            else 
                    if lowercase_plain_text(i)~=lowercase_plain_text(i+1)

                        % if dulicate letters are not present in pairs then we do
                        % notihng and also if pair contains singel letter than we add 'z' to make a completee pair 
                       temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,lowercase_plain_text(i));
                       if i+1<=len_of_plain_text
                            temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,lowercase_plain_text(i+1));
                       else
                            temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,'z');
                       end
                       i=i+2;

                       % if duplicate letters are present in pair we add 'x' do
                       % remove duplicate letters from pair
                    else
                        temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,lowercase_plain_text(i));
                        if lowercase_plain_text(i) ~= 'x'
                            temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,'x');
                        else
                            temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,'z');
                        end
                        i=i+1;
                    end
            end

        end
        
        pair_of_plain_text=temp_lowercase_plain_text;
end


% Function for encryption
function cipher_text = playFair_encryption(key_table,pair_of_plain_text)
    len_of_pair_pair_of_plain_text = length(pair_of_plain_text);
    
    temp_cipher_text = [];
    for i=1:2:len_of_pair_pair_of_plain_text
       first_char_of_pair = pair_of_plain_text(1,i) ;
       second_char_of_pair = pair_of_plain_text(1,i+1);
       [row1,col1] =find(key_table == first_char_of_pair);
       [row2,col2] =find(key_table == second_char_of_pair);
       
       if row1 ~= row2 && col1 ~= col2
          temp_cipher_text = cat(2,temp_cipher_text, key_table(row1,col2));
          temp_cipher_text = cat(2,temp_cipher_text, key_table(row2,col1));
       elseif col1 == col2
           temp_cipher_text = cat(2,temp_cipher_text, key_table(row1+1,col1));
           temp_cipher_text = cat(2,temp_cipher_text, key_table(row2+1,col2));
       elseif row1 == row2
           temp_cipher_text = cat(2,temp_cipher_text, key_table(row1,col1+1));
           temp_cipher_text = cat(2,temp_cipher_text, key_table(row2,col2+1));           
       end
       
    end
    
    cipher_text = temp_cipher_text;
end


% Function for decryption
function decrypted_text = playFair_decryption(key_table,cipher_text)
    len_of_cipher_text = length(cipher_text);
    
    temp_decrypted_text = [];
    for i=1:2:len_of_cipher_text
       first_char_of_pair = cipher_text(1,i) ;
       second_char_of_pair = cipher_text(1,i+1);
       [row1,col1] =find(key_table == first_char_of_pair);
       [row2,col2] =find(key_table == second_char_of_pair);
 
       
       if row1 ~= row2 && col1 ~= col2
          temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row1,col2));
          temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row2,col1));
       elseif col1 == col2
           temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row1-1,col1));
           temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row2-1,col2));
       elseif row1 == row2
           temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row1,col1-1));
           temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row2,col2-1));           
       end
       
    end
    
    decrypted_text = temp_decrypted_text;
    
end








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% 
% 
% clc;
% claer;
% close all;
% 
% Taking key as input
% key = input('Enter the key : ','s');
% lowercase_key =lower(key);
% lowercase_key = strrep(lowercase_key,'j','i');
% 
% 
% Taking plain text as input
% plain_text = input('Enter Plain text : ','s');
% lowercase_plain_text = lower(plain_text);
% lowercase_plain_text = strrep(lowercase_plain_text,'j','i');
% 
% Removeing spaces from key and plain text
% lowercase_key = strrep(lowercase_key,' ','');
% lowercase_plain_text=strrep(lowercase_plain_text,' ','');
% pair_of_plain_text= make_pairs(lowercase_plain_text);
% disp('Pairs of plain text : ');
% disp(pair_of_plain_text);
% 
% Extracting unique letters/characters from the key 
% unique_char_key =unique(lowercase_key,'stable');
% 
% 
% Calling key_table_genereation for reciving key_table
% key_table = key_table_generation(unique_char_key);
% disp('Key table matrix of size 6x6 : ')
% key_table=char(key_table);
% disp(key_table);
% 
% 
% Calling playFair_encryption function for performing encryption
% cipher_text = playFair_encryption(key_table,pair_of_plain_text);
% disp(' ');
% disp('Cipher Text ');
% disp(cipher_text);
% 
% 
% Calling playFair_decryption functin for performing decryption
% decrypted_text = playFair_decryption(key_table,cipher_text);
% disp(' ');
% disp('Decrypted Cipher : ');
% disp(decrypted_text);
% 
% ALL FUNCTIONS
% 
% Fucntion for key table    
% function key_table = key_table_generation(unique_char_key)
%     key_space ='abcdefghiklmnopqrstuvwxyz';
%     key_table = zeros(5,5);
% 
%                 Copying alphabets/characters of unique_char_key to key_table_array
%                 key_table_array = zeros(1,25); % creating 1D key_table_array to temporarily stor key_matrix
%                 for i=1:length(unique_char_key)
%                     index=strfind(key_space,unique_char_key(i));
%                     key_table_array(i)=key_space(index);
%                     key_space = erase(key_space,key_space(index));
%                 end
% 
% 
%                 Copying remaining alphabet and numbers of key_pace to key_table_array
%                 for i=1:length(key_space)
%                    key_table_array(length(unique_char_key)+i)=key_space(i);
%                 end
%                 
%                 Creating 2D matrix of key_table from 1D key_table_array
%                 key_table=reshape(key_table_array,5,5);
%                 key_table=transpose(key_table);                
% 
% end
% 
% 
% Function for making pairs
% function pair_of_plain_text=make_pairs(lowercase_plain_text)
%         
%         Finding length of lowercase_plain_text
%         len_of_plain_text = length(lowercase_plain_text);
% 
%         temp_lowercase_plain_text=[];
%         i=1;
%         while i<=len_of_plain_text
% 
%             to make a complete pair we add extra 'z' to make a complete pair
%             if i+1 >len_of_plain_text 
%                 temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,lowercase_plain_text(i));
%                 if lowercase_plain_text(i)~= 'z'
%                     temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,'z');
%                 else
%                     temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,'0');
%                 end
%                 break;
%             else 
%                     if lowercase_plain_text(i)~=lowercase_plain_text(i+1)
% 
%                         if dulicate letters are not present in pairs then we do
%                         notihng and also if pair contains singel letter than we add 'z' to make a completee pair 
%                        temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,lowercase_plain_text(i));
%                        if i+1<=len_of_plain_text
%                             temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,lowercase_plain_text(i+1));
%                        else
%                             temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,'z');
%                        end
%                        i=i+2;
% 
%                        if duplicate letters are present in pair we add 'x' do
%                        remove duplicate letters from pair
%                     else
%                         temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,lowercase_plain_text(i));
%                         if lowercase_plain_text(i) ~= 'x'
%                             temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,'x');
%                         else
%                             temp_lowercase_plain_text=cat(2,temp_lowercase_plain_text,'z');
%                         end
%                         i=i+1;
%                     end
%             end
% 
%         end
%         
%         pair_of_plain_text=temp_lowercase_plain_text;
% end
% 
% 
% Function for encryption
% function cipher_text = playFair_encryption(key_table,pair_of_plain_text)
%     len_of_pair_pair_of_plain_text = length(pair_of_plain_text);
%     
%     disp('Checking len_of_pair_of_plain_text : ');
%     disp(len_of_pair_pair_of_plain_text);
%     
%     temp_cipher_text = [];
%     for i=1:2:len_of_pair_pair_of_plain_text
%        first_char_of_pair = pair_of_plain_text(1,i) ;
%        second_char_of_pair = pair_of_plain_text(1,i+1);
%        [row1,col1] =find(key_table == first_char_of_pair);
%        [row2,col2] =find(key_table == second_char_of_pair);
%        
%        disp(row1);
%        disp(col1)
%        disp(row2);
%        disp(col2);
%        
%        if row1 ~= row2 && col1 ~= col2
%           temp_cipher_text = cat(2,temp_cipher_text, key_table(row1,col2));
%           temp_cipher_text = cat(2,temp_cipher_text, key_table(row2,col1));
%        elseif col1 == col2
%            temp_cipher_text = cat(2,temp_cipher_text, key_table(row1+1,col1));
%            temp_cipher_text = cat(2,temp_cipher_text, key_table(row2+1,col2));
%        elseif row1 == row2
%            temp_cipher_text = cat(2,temp_cipher_text, key_table(row1,col1+1));
%            temp_cipher_text = cat(2,temp_cipher_text, key_table(row2,col2+1));           
%        end
%        
%     end
%     
%     cipher_text = temp_cipher_text;
% end
% 
% 
% Function for decryption
% function decrypted_text = playFair_decryption(key_table,cipher_text)
%     len_of_cipher_text = length(cipher_text);
%     
%     temp_decrypted_text = [];
%     for i=1:2:len_of_cipher_text
%        first_char_of_pair = cipher_text(1,i) ;
%        second_char_of_pair = cipher_text(1,i+1);
%        [row1,col1] =find(key_table == first_char_of_pair);
%        [row2,col2] =find(key_table == second_char_of_pair);
%        
%        if row1 ~= row2 && col1 ~= col2
%           temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row1,col2));
%           temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row2,col1));
%        elseif col1 == col2
%            temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row1-1,col1));
%            temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row2-1,col2));
%        elseif row1 == row2
%            temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row1,col1-1));
%            temp_decrypted_text = cat(2,temp_decrypted_text, key_table(row2,col2-1));           
%        end
%        
%     end
%     
%     decrypted_text = temp_decrypted_text;
%     
% end
% 
% 
% 
% 
% 
% 
% 
% 
