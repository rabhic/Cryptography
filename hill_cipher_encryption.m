clc;
clear;
close all;

% Example 1:
% 
% Enter the plain Text  : attack is tonight
% Enter the Key (Size must be a perfect square): dkuujrjer
% Key Matrix formed by Entered Key : 
%      3    10    20
%     20     9    17
%      9     4    17
% 
% Inverse of Key Matrix : 
%     11    22    14
%      7     9    21
%     17     0     3
% 
% Cipher Text : 
% yajmgwmvzuncamp
% Decrypted Cipher Text : 
% attackistonight
% 


% Example 2:
% Enter the plain Text  : This is hill cipher
% Enter the Key (Size must be a perfect square): gybnqkurp
% Key Matrix formed by Entered Key : 
%      6    24     1
%     13    16    10
%     20    17    15
% 
% Inverse of Key Matrix : 
%      8     5    10
%     21     8    21
%     21    12     8
% 
% Cipher Text : 
% exvgwmlrzsvkcjlync
% Decrypted Cipher Text : 
% thisishillcipher



% Example 3:
% Enter the plain Text  : act
% Enter the Key (Size must be a perfect square): gybnqkurp
% Key Matrix formed by Entered Key : 
%      6    24     1
%     13    16    10
%     20    17    15
% 
% Inverse of Key Matrix : 
%      8     5    10
%     21     8    21
%     21    12     8
% 
% Cipher Text : 
% poh
% Decrypted Cipher Text : 
% act


%Taking Plain Text as input
plain_text = input('Enter the plain Text  : ','s');
plain_text = lower(plain_text);
plain_text = strrep(plain_text,' ','');



%Taking Key as input and converting it into NxN matrix.
key = input('Enter the Key (Size must be a perfect square): ','s');
key = lower(key);
key = strrep(key,' ','');
key = double(key);
key = key - 97;
len_of_key = length(key);
n = sqrt(len_of_key);
key = transpose(reshape(key,n,n));
disp('Key Matrix formed by Entered Key : ');
disp(key);

%Finding Inverse key matrx for decryption
inverse_matrix = invKeyMatrx(key);
disp('Inverse of Key Matrix : ');
disp(inverse_matrix);

%Calling hillCipher_encrypion function for performnig encryption
cipher_text = hillCipher_encryption(key,plain_text,n);
disp('Cipher Text : ');
disp(cipher_text);


%Calling hillCipher_decryption function for performing decryption
decrypted_text = hillCipher_decryption(inverse_matrix,cipher_text,n);
decrypted_text = decrypted_text(1,1:length(plain_text));
disp('Decrypted Cipher Text : ');
disp(decrypted_text);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ALL FUNCTIONS


% Encryption Function
function cipher_text = hillCipher_encryption(key_matrix,plain_text,n)
    
    %Converting Plain text array into blocks of size 'n'
    m = ceil(length(plain_text)/n);   % m = no of blocks formed of size 'n'
    block_of_array_2D = zeros(n,m);

    k=1;
    for i=1:m 
        for j=1:n
            if k <= length(plain_text)
                block_of_array_2D(j,i) = plain_text(1,k)-97;
                k=k+1;
            else
                break;
            end
        end
    end

   
   % Multipyling key matrix with the blocks of plain text and taking mod to
   % get cipher text
   
   %initializing cipher_text with zeros
   cipher_text = zeros(n,m); 
   for i=1:m
      cipher_text(:,i)= mod(key_matrix * block_of_array_2D(:,i),26); 
   end
  
   
   %converting digits of cipher text into english characters.
   cipher_text = cipher_text+97;
   cipher_text = char(cipher_text);
   cipher_text = transpose(cipher_text);
   
   final_cipher_text = cipher_text(1,:);
   for i=2:m
    final_cipher_text = cat(2,final_cipher_text,cipher_text(i,:));
   end
   
   cipher_text = final_cipher_text;
   
end

% Decryption Function
function decrypted_text =hillCipher_decryption(inverse_matrix,cipher_text,n);
    decrypted_text = hillCipher_encryption(inverse_matrix,cipher_text,n);
end


% Inverse Key Matrix Function
function inverse_matrix = invKeyMatrx(key)

    % Calculating multiplicative inverse of determinant of key
    determinant = det(key);
    if determinant < 0
        determinant = mod(determinant,26); 
    end
    [g,t,~] = gcd(int64(determinant),26);
    if mod(g,int64(determinant)) == 1
        if t < 0 
            multi_plicative_inverse = t+26;
        else
            multi_plicative_inverse = t;
        end
    else
        disp(' !!! Multiplicative Inverse Matrix does not Exist !!! ');
    end

    %Calulating adjoint of matrix
    adjoint_of_matrix = double(adjoint(sym(key)));
    [n,~] = size(adjoint_of_matrix);
    adjoint_of_matrix = reshape(adjoint_of_matrix,[1 n*n]);
    
    %Replacing -ve elements in adjoint of matrix with +ve numbers by
    % using -ve_element= -ve_element + Quotient+1*26, where quotient =
    % -ve_element / 26 .
    for i=1:n*n
        if adjoint_of_matrix(1,i) < 0
           temp = -floor(adjoint_of_matrix(1,i) / 26);
           adjoint_of_matrix(1,i) = adjoint_of_matrix(1,i) + 26*temp;
        end
    end
    
    %Formatting or reshaping Final inverse key Matrix.
    adjoint_of_matrix =reshape(adjoint_of_matrix,n,n);
    inverse_matrix = mod(double(multi_plicative_inverse) *adjoint_of_matrix,26);
end





