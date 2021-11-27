clc;
clear;
close all;

% Example: Plain-Text -> affine cipher
%          key_a  -> d
%          key_b  -> f
%          
%         Cipher Text 
%         FUUDSR LDYARE
%         Decrpyted Message 
%         AFFINE CIPHER
% 


%Taking plain text as input 
plain_text = input('Enter the Plain Text : ','s');
plain_text_in_ASCII = double(plain_text);

%Taking key 'A' and 'B' as input 
key_a = input('Enter key A : ','s');
key_b = input('Enter Key B : ','s');
key_a = double(key_a);
key_b = double(key_b);

%Converting plain text letters between 0-25
for i=1:length(plain_text_in_ASCII)
    if(plain_text_in_ASCII(i)>= 97 && plain_text_in_ASCII(i)<= 122 )
        plain_text_in_ASCII(i) = plain_text_in_ASCII(i)-97;
    elseif(plain_text_in_ASCII(i)==32)
            continue;
    elseif (plain_text_in_ASCII(i)>=65 && plain_text_in_ASCII(i)<=90 )
        plain_text_in_ASCII(i)=plain_text_in_ASCII(i)-65;
    else
        disp('!!! Entered Special Characters !!!');
        break;
    end
end


%Converting Key_a to  ASCII
if key_a>=97 && key_a<=122
    key_a = key_a -97;
elseif key_a >=65 && key_a <=90
    key_a = key_a-65;
else
    disp('!!! Entered Special Characters !!! ');
end

%Converting Key_b to  ASCII
if key_b >= 97 && key_b <=122
    key_b = key_b -97;
elseif key_b >=65 && key_b <=90
    key_b = key_b-65;
else
    disp('!!! Entered Special Characters !!! ');
end


%Calling affineEncryption Function to get cipher_text
cipher_text = affineEncryption(key_a,key_b,plain_text_in_ASCII);
cipher_text = char(cipher_text);
disp('Cipher Text ');
disp(cipher_text);


%Converting Cipher text letters between 0-25
for i=1:length(cipher_text)
    if(cipher_text(i)>= 97 && cipher_text(i)<= 122 )
        cipher_text(i) = cipher_text(i)-97;
    elseif(cipher_text(i)==32)
            continue;
    elseif (cipher_text(i)>=65 && cipher_text(i)<=90 )
        cipher_text(i)=cipher_text(i)-65;
    else
        disp('!!! Entered Special Characters !!!');
        break;
    end
end


%Calling affineDecryption Function to get decrypted message
decrpyted_message = affineDecryption(key_a,key_b,cipher_text);
decrpyted_message = char(decrpyted_message);
disp('Decrpyted Message ');
disp(decrpyted_message);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ALL FUNCTION


% Encryption Function
function cipher = affineEncryption(key_a,key_b,plain_text_in_ASCII)
   
    % Converting ascii plain text to ascii cipher text using affine cipher
    % algorithm
    temp_cipher = zeros(1,length(plain_text_in_ASCII));
    for i=1:length(plain_text_in_ASCII)
        if plain_text_in_ASCII(i) == 32
            temp_cipher(1,i)=32;
        else
            temp_cipher(1,i) = mod((plain_text_in_ASCII(i)*key_a) + key_b,26);   
        end 
    end
    
    
    
    % Converting ascii cipher to Character cipher
    for i=1:length(temp_cipher)
        if temp_cipher(1,i) == 32
            continue;
        else
            temp_cipher(1,i)= temp_cipher(1,i)+65;
        end
    end
    cipher = temp_cipher;
end





% Decryption Function
function decrypted_message = affineDecryption(key_a,key_b,cipher_text)
    
    [g,s,~] = gcd(key_a,26);
    if mod(g,key_a) ==1 
        if s<0
            key_a = 26+s;
        else
            key_a = s;
        end
        
            % Converting ascii cipher text to ascii decrpytd(plain text) text using affine cipher
            % algorithm
            temp_decrpyted = zeros(1,length(cipher_text));
            for i=1:length(cipher_text)
                if cipher_text(i) == 32
                    temp_decrpyted(1,i)=32;
                else
                    temp_decrpyted(1,i) = mod(key_a*(cipher_text(i) - key_b),26);   
                end 
            end


            % Converting ascii decrpyted message to decrpyted character
            for i=1:length(temp_decrpyted)
                if temp_decrpyted(1,i) == 32
                    continue;
                else
                    temp_decrpyted(1,i)= temp_decrpyted(1,i)+65;
                end
            end
            decrypted_message = temp_decrpyted;
        
    else
        disp('!!! Inverse of Key A does not exist !!! ');
    end
    
    
end


