clc;
clear;
close all;

% Example 1:
% 
% Enter the Plain Text : This is Transposition Cipher.
% Enter the Key (Transposition Cipher) : hack
% hack
%  
% Transposition Matrix 
% 3124
% This
%  is 
% Tran
% spos
% itio
% n Ci
% pher
% .   
% Cipher Text : 
% hirpt h isaoiCe T Tsinp.s nsoir 
% Decrypted Text : 
% This is Transposition Cipher.   

% % Example 2:
% Enter the Plain Text : geeks for geeks
% Enter the Key (Transposition Cipher) : hack
% hack
%  
% Transposition Matrix 
% 3124
% geek
% s fo
% r ge
% eks 
% Cipher Text : 
% e  kefgsgsrekoe 
% Decrypted Text : 
% geeks for geeks 



%Taking input from user as Plaint Text
plain_text = input('Enter the Plain Text : ','s');

%Takin input from user as Key
key = input('Enter the Key (Transposition Cipher) : ','s');


%Calling Encrytion function
cipher_text = columnarTransposition_encryption(key, plain_text);
disp(' ');
disp('Cipher Text : ');
disp(cipher_text);

%Calling Decryption Function
decrypted_text = columnarTransposition_decryption(key,cipher_text);
disp(' ');
disp('Decrypted Text : ');
disp(decrypted_text)


%%%%%%%%%%%%%%%%%%%%%%%%%

%ALL FUNCTIONS


%Encryption Funciton
function cipher_text = columnarTransposition_encryption(key,plain_text)
    %Columnar Transposition Table generation
    [key_table,key] = Table_generation(key,plain_text);
    disp(' ');
    disp('Transposition Matrix ');
    disp(key_table);

    % Just reading Key_table columnwise in sorted order of key_index
      temp = [];
    for i=1:length(key)
        [~,col]=find(key_table(1,:) == min(key_table(1,:)));
        temp = cat(2,temp,transpose(key_table(2:end ,col)));
        key_table(:,col) = [];        
    end
    
    cipher_text=temp;
end



%Decryption Function

function decrypted_cipher_text = columnarTransposition_decryption(key,cipher_text)
        
    len_of_key = length(key);   
    len_of_cipher_text = length(cipher_text);
    no_of_rows_in_decrypt_table = len_of_cipher_text/len_of_key;
    [~,~,keyindex] = unique(key,'legacy');
   
    decrypted_text = char(zeros(no_of_rows_in_decrypt_table+1,len_of_key));
    decrypted_text(1,:) = string(keyindex);
    
    k=1;
    for i=1:len_of_key
        [~,col]=find(decrypted_text(1,:) == min(decrypted_text(1,:)));
        temp = cipher_text(1,k:k+no_of_rows_in_decrypt_table-1);
        temp = reshape(temp,no_of_rows_in_decrypt_table,1);
        decrypted_text(2:end,col) = temp;
        k = k+no_of_rows_in_decrypt_table;        
        decrypted_text(1,col) = 122; 
    end
    
    decrypted_cipher_text=[];
    for i=2:no_of_rows_in_decrypt_table+1
        decrypted_cipher_text = cat(2,decrypted_cipher_text,decrypted_text(i,:));  
    end
end



% Table_generation Function for encryption
function [key_table,keynew] = Table_generation(key,plain_text)
    
    keynew = lower(key);
    keynew = unique(keynew,'stable');
    [~,~,keyindex] = unique(keynew,'legacy');
    disp(keynew);
   
    %Calculating length of key and plain text
    len_of_key = length(keynew);
    len_of_plain_text = length(plain_text);
    
    %Calculating no of rows in the table
    no_of_rows_in_table = ceil(len_of_plain_text/len_of_key);
    
    %Initializing key_table with '0' or 'spaces'
    key_table = char(zeros(no_of_rows_in_table+1,len_of_key));
    key_table(1,:) =string(keyindex);
    
    %Inserting plain text message to the key table
    k=1;
    for i=2:no_of_rows_in_table+1
        for j=1:len_of_key
            if k <= len_of_plain_text
                key_table(i,j) = plain_text(k);
                k=k+1;
            else
                break
            end
        end
    end    
end






