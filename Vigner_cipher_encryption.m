clc;
clear;
close all;
 
% Enter the Plain Text : This is Vigner Cipher
% Enter key (Vigner Cipher): abhi
% Cipher Text : 
% tipaitcqgolzcjwpes
% Decrypted Text : 
% thisisvignercipher



%Taking input from user as plain text
plain_text = input('Enter the Plain Text : ','s');
plain_text = strrep(plain_text,' ','');
plain_text = lower(plain_text);


%Taking input as Key;
key = input('Enter key (Vigner Cipher): ','s');
key = lower(key);
key = strrep(key,' ','');


%Creating standard Key (Usable key) for Vigner cipher
standard_key = key_transformation(key,plain_text);

%Forming vigner table
vigner_table = char(zeros(26,26));
vigner_table(1,:)= 'abcdefghijklmnopqrstuvwxyz';

for i=2:26
   vigner_table(i,:) = circshift(vigner_table(i-1,:),-1); 
end


%Encryption
cipher_text = vigner_encryption(plain_text,standard_key,vigner_table);
disp('Cipher Text : ');
disp(cipher_text);

%Decryption
decrypted_text = vigner_decryption(cipher_text,standard_key,vigner_table);
disp('Decrypted Text : ');
disp(decrypted_text);



%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALL FUNCTIONS


% Function for key transformation 
function standard_key = key_transformation(key,plain_text)
    
    len_of_key = length(key);
    len_of_Plain_text = length(plain_text);
    
    if len_of_key == len_of_Plain_text
        standard_key = key;
    elseif len_of_key > len_of_Plain_text
        standard_key = key(1:len_of_Plain_text);
    else
        standard_key =[];
        len_of_standard_key = length(standard_key);
        while len_of_standard_key <=  len_of_Plain_text
            standard_key = cat(2,standard_key,key);
            len_of_standard_key = length(standard_key);
        end
        standard_key = standard_key(1:len_of_Plain_text);
    end
        
end


%Encryption Function
function cipher_text = vigner_encryption(plain_text,standard_key,vigner_table);

    temp =[];
    for i=1:length(plain_text)
        col = double(standard_key(1,i))-96;
        row = double(plain_text(1,i))-96;
        temp = cat(2,temp,vigner_table(row,col));
    end
    cipher_text = temp;
end


%Decryption Function
function decrypted_text = vigner_decryption(cipher_text,standard_key,vigner_table)
    
        temp =[];
    for i=1:length(cipher_text)
        row = double(standard_key(1,i)-96);
        index = strfind(vigner_table(row,:), cipher_text(1,i));
        temp = cat(2,temp,vigner_table(1,index));
    end
    decrypted_text = temp;

end






















