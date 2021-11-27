% clear;
% clc;
% close all; 
% 
% % Example :
% % Plain Text -> This is Data Encrytption Standard
% % Key -> 0E329232EA6D0D73
% 
% 
% 
% % Took input as plain text from user input
% a = input('Enter text : ','s');
% 
% %Converted Plain text (taken from user) into Hex string
% b=sprintf('%X',a);
% disp(b);
% 
% % Calculated no of 64 bits possible frm plain text entere by user
% mul_len=ceil(length(b)/16);
% 
% %Converted the Hex string into ASCII values for Padding
% temparray=zeros(1,length(b));
% for i=1:length(b)
%     temparray(i)= b(i);
% end
% 
% %Cocatenating '48' ASCII value of zero(0) to the converted string
% padd_array =randi([48,48],1,16*mul_len - length(b));  
% 
% %Padding zeros to the Hex String
% plain_text = cat(2,temparray,padd_array);
% final_plain_text =char(plain_text);
% 
% %Dividing Hex String into blocks of 64 bits for giving input to DES Algo
% %and Stored all blocks in blocks_of_plain_text.
% blocks_of_plain_text= strings(mul_len,1);
% k=1;
% for i=1:mul_len
%     blocks_of_plain_text(i,1) = final_plain_text(k:k+15);
%     k=k+16;
% end
% 
% 
% 
% 
% 
% %Taking KEY as HEXADECIMAL and converting it to binary (1,0)
% key_string = input('Enter key : ','s');
% %Created all subkeys K1 to k16
% key_matrix = key_genrate(key_string);     
% 
% 
% 
% %Calling encryption function of DES i.e encryption_des();
% m=1;
% block_of_cipher_text = strings(mul_len,1);
% for i=1:mul_len
%      cipher_text = encryption_des(key_matrix,blocks_of_plain_text(i,:));
%      cipher_text =binaryVectorToHex(cipher_text);
%      block_of_cipher_text(i,:) =cipher_text;
% end
% % disp('Plain Text Hex String : ')
% % disp(blocks_of_plain_text);
% 
% % disp('Ciphertext Generated : ');
% % disp(block_of_cipher_text);
% 
% 
% %%%%%
% 
% blockOfCipherText = transpose(block_of_cipher_text);
% temp_join= strjoin(blockOfCipherText);
% temp_join = strrep(temp_join,' ','');
% disp(temp_join);
% 
% 
% 
% %%%%%
% 
% 
% 
%  %Calling decryption function of DES i.e decryption_des();
%  n=1;
%  block_of_decrypted_cipher_text = strings(mul_len,1);
%  for i=1:mul_len
%      cipher_text = block_of_cipher_text(i,:); 
%      plain_text_after_decryption = decryption_des(cipher_text,key_matrix); 
%      decrypted_cipher_text = binaryVectorToHex(plain_text_after_decryption);
%      block_of_decrypted_cipher_text(i,:) = decrypted_cipher_text;
%  end
% %  disp('Decrypted Cipher Text : ');
% %  disp(block_of_decrypted_cipher_text);
% %  
%  
%  
%  
%  
%  %%%%%% Code for converting block_of_decrypted_cipher_text to simple
%  %%%%%% english language.
%  
%  block_of_decrypted_cipher_text = transpose(block_of_decrypted_cipher_text);
% temp_join= strjoin(block_of_decrypted_cipher_text);
% temp_join = strrep(temp_join,' ','');
% 
% 
% temp_join= convertStringsToChars(temp_join);
% tempJoin2 = zeros(1,length(temp_join));
% 
% 
% for i=1:length(temp_join)
%    tempJoin2(1,i) = temp_join(i); 
% end
% tempJoin2 = char(tempJoin2(1:length(b)));
% disp(tempJoin2);
% tempJoin3 = string(zeros(1,length(b) /2));
% z=1;
% t=1;
% for i=1:(length(b)/2)
%    tempJoin3(t) = tempJoin2(z:z+1);
%    z=z+2;
%    t=t+1;
% end
% 
% tempJoin4 = zeros(1,length(tempJoin3));
% for i=1:length(tempJoin3)
%     tempJoin4(1,i) = hex2dec(tempJoin3(i));
% end
% disp(char(tempJoin4));
% 
%  %%%%%%
%  
%  
%  
%  
%  
% 
%  
% 
% % ALL FUNCTIONS
% 
% % Decryption Function (DES)
% function plain_text_after_decryption = decryption_des(cipher_text,key_matrix)
%     reversed_key_matrix = flipud(key_matrix);
%     plain_text_after_decryption = encryption_des(reversed_key_matrix,cipher_text); 
% end
% 
% 
% 
% % Encryption Function (DES)
% function cipher_text = encryption_des(key_matrix, plain_text)
% 
%     plain_text_binary= hexToBinaryVector(plain_text,64);
%     
%     % Initial Permutaion Table (IP)
%     initial_permutaion_table = [58,50,42,34,26,18,10,2,...
% 	60,52,44,36,28,20,12,4, ...
% 	62,54,46,38,30,22,14,6, ...
% 	64,56,48,40,32,24,16,8, ...
% 	57,49,41,33,25,17,9,1, ...
% 	59,51,43,35,27,19,11,3, ...
% 	61,53,45,37,29,21,13,5, ...
% 	63,55,47,39,31,23,15,7 ];
%     
%     % Final Permutation or Inverse Permutaion (IP^-1)
%     final_permutation_table = [40,8,48,16,56,24,64,32, ...
% 	39,7,47,15,55,23,63,31, ...
% 	38,6,46,14,54,22,62,30, ...
% 	37,5,45,13,53,21,61,29, ...
% 	36,4,44,12,52,20,60,28, ...
% 	35,3,43,11,51,19,59,27, ...
% 	34,2,42,10,50,18,58,26, ...
% 	33,1,41,9,49,17,57,25 ];
% 
%     % Expansion Table of the 'f' function
%     expansion_table = [32,1,2,3,4,5,4,5, ...
% 	6,7,8,9,8,9,10,11, ...
% 	12,13,12,13,14,15,16,17, ... 
% 	16,17,18,19,20,21,20,21, ...
% 	22,23,24,25,24,25,26,27, ...
% 	28,29,28,29,30,31,32,1 ];
%     
%     % Permutaion Table of the 'f' function
%     permutation_table_for_f_function = [16,7,20,21,29,12,28,17,... 
% 	1,15,23,26,5,18,31,10, ...
% 	2,8,24,14,32,27,3,9, ...
% 	19,13,30,6,22,11,4,25 ];
%     
%     % Subsition Boexs which will contain values  0<= values <=15
%     s_box(:,:,1) =[14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7;... 
%         0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8; ...
%         4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0; ...
%         15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13 ];
%     
%     s_box(:,:,2) = [15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10;... 
%         3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5; ...
%         0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15; ...
%         13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9 ];
%     
%     s_box(:,:,3) = [10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8;... 
%         13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1; ...
%         13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7; ...
%         1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12 ];
%     
%     s_box(:,:,4) = [ 7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15; ...
%         13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9; ...
%         10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4; ...
%         3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14 ];
%     
%     s_box(:,:,5) = [ 2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9; ... 
%         14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6; ...
%         4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14;... 
%         11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3 ];
%     
%     s_box(:,:,6) = [12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11; ... 
%         10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8; ...
%         9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6; ...
%         4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13 ];
%     
%     s_box(:,:,7) = [4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1; ... 
%         13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6; ...
%         1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2; ...
%         6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12 ];
%     
%     s_box(:,:,8) = [13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7; ...
%         1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2; ...
%         7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8; ...
%         2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11 ];
%     
%     % Performing Initial Permutaion
%     permuted_64_bits_plain_text = zeros(1,64);  
%     for i=1:64
%         permuted_64_bits_plain_text(i) = plain_text_binary(initial_permutaion_table(i)); 
%     end
%    
%     
%     % Splitting Permuted_64_bits_plaint_text into left_32_bits_plain_text
%     % and right_32_bits_plain_text
%     left_permuted_32_bits_plain_text = permuted_64_bits_plain_text(1:32);
%     right_permuted_32_bits_plain_text = permuted_64_bits_plain_text(33:64);
%     
%     
%     Expanded_right_permuted_32_bits_plain_text_to_48=zeros(1,48);
%     
%     % Encrypting Plain Text 16 times (The 16 Rounds of DES )
%     for j=1:16
%         
%         % Expanding 32-bit Right part of permuted 64 bit plain text to 48 bits using permutaion_table_for_f_function 
%         for i=1:48
%             Expanded_right_permuted_32_bits_plain_text_to_48(i) = right_permuted_32_bits_plain_text(expansion_table(i)); 
%         end
%         
%         % The Expanded 48 bits are then XORED with the subkey
%         xored_result_in_f_function_48_bits = xor(Expanded_right_permuted_32_bits_plain_text_to_48,key_matrix(j,:));
%         
%         % Initializing some temp values
%             row = zeros(1,2);
%             col = zeros(1,4);
%             k=1;
%             m=1;
%             
%         % Using S_boxes for compression of 48 bits to 32 bits
%         for i=1:6:48
%             
%             row(1) = xored_result_in_f_function_48_bits(i);
%             row(2) = xored_result_in_f_function_48_bits(i+5);
%             col(1) = xored_result_in_f_function_48_bits(i+1);
%             col(2) = xored_result_in_f_function_48_bits(i+2);
%             col(3) = xored_result_in_f_function_48_bits(i+3);
%             col(4) = xored_result_in_f_function_48_bits(i+4);
%              
%             % Fetching row value and column value for selecting 4 bit value
%             % from S_boxes
%             temp_row = binaryVectorToDecimal(row)+1;
%             temp_col = binaryVectorToDecimal(col)+1;
%             
%             % Getting decimal value from 8 s_boxes
%             val = s_box(temp_row, temp_col,k);
%             k=k+1;
%             
%             % Converting decimal value to binary value obtained from S_boxes 
%             val = decimalToBinaryVector(val,4);          
%             
%             % Creating 1x32 array for storing compressed 32 bits from 48
%             % bits of the 'f' function
%             compressed_48_bits_to_32_bits(m:m+3) = val;
%             m=m+4;
%             
%         end
%         
%        
%         % Using permutation_table_for_f_function to do permutation (rearrangement)
%         output_of_f_function = zeros(1,32);
%         for i=1:32
%             output_of_f_function(i) = compressed_48_bits_to_32_bits(permutation_table_for_f_function(i));
%         end
%         
%         
%         % Taking xor of left_permuted_32_bits_plain_text with
%         % Output_of_f_function
%         xor_result_of_left_part_with_output_of_f_function = xor(left_permuted_32_bits_plain_text , output_of_f_function);
%         
%         % Swapping final xor_result_of_left_part_with_output_of_f_funtion with right_permuted_32_bits_plain_text 
%         left_permuted_32_bits_plain_text =right_permuted_32_bits_plain_text;
%         right_permuted_32_bits_plain_text=xor_result_of_left_part_with_output_of_f_function;
%        
%         % Combining left_part and right_part
%         combined_64_bits = cat(2,right_permuted_32_bits_plain_text,left_permuted_32_bits_plain_text);
%        
%         % Doing Final permutation of Inverse Permutaion
%         cipher = zeros(1,64);
%         for i=1:64
%             cipher(i) = combined_64_bits(final_permutation_table(i));
%         end        
%     end
%     
%     
%     cipher_text=cipher;       
% end
% 
% 
% 
% % Function for Key Generation
% function all_keys = key_genrate(key_string)
%         key_binary = hexToBinaryVector(key_string,64);
% 
%         % Permuted Choice-1 (PC-1 Table) Size PC-1 : 56
%         pc_one = [57,49,41,33,25,17,9, ...
%             1,58,50,42,34,26,18,...
%             10,2,59,51,43,35,27, ...
%             19,11,3,60,52,44,36, ...		 
%             63,55,47,39,31,23,15, ...
%             7,62,54,46,38,30,22, ...
%             14,6,61,53,45,37,29, ...
%             21,13,5,28,20,12,4 ];
% 
% 
%         % Permuted Choice-2 (PC-2 Table) Size PC-2 : 48
%         pc_two = [14,17,11,24,1,5, ...
%             3,28,15,6,21,10, ...
%             23,19,12,4,26,8, ...
%             16,7,27,20,13,2, ...
%             41,52,31,37,47,55, ...
%             30,40,51,45,33,48, ...
%             44,49,39,56,34,53, ...
%             46,42,50,36,29,32 ];
% 
% 
%         % Used PC-1 table to compress 64-bit key to 56-bit key
%         comp_key = zeros(1,56);
%         for i=1:56
%             comp_key(i) = key_binary(pc_one(i)); 
%         end
% 
%         % Splitting Compressed Key into Left_compressed_key (of size 28 bits) and
%         % Right_coompressed_key (of size 28 bits)
%         left_comp_key = comp_key(1:28);
%         right_comp_key = comp_key(29:56);
% 
%         % Initializing 16 keys to zeros
%         all_keys = zeros(16,48);
% 
%         % Creating all 16 Keys
%         final_key = zeros(1,48);    
%         for i=1:16
%             % For iterations i =  1,2,9,16 we do left_shit once according to algo.
%             if i==1 || i==2 || i==9 || i==16
%                 left_comp_key = circshift(left_comp_key,-1);
%                 right_comp_key = circshift(right_comp_key,-1);
%             % For iterations i not equal to 1,2,9,16 we do left_shit twice according to
%             % algo.
%             else
%                 left_comp_key = circshift(left_comp_key,-2);
%                 right_comp_key = circshift(right_comp_key,-2);
%             end
% 
%             % Combining left_comp_key and right_comp_key after circular shift
%            temp_comp_key = cat(2,left_comp_key,right_comp_key);
% 
%             % Using Permuted Choice (PC-2 table) for permutation and compression of keys to 48 bits
%             for j = 1:48
%                 final_key(j) = temp_comp_key(pc_two(j));
%             end   
%             all_keys(i,:) = final_key;
%         end
% end
% 
% 






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



clc;
clear;
close all;

%Example :  
%  plain_text- 8787878787878787 
%  key- 0E329232EA6D0D73 
%  cipher-0000000000000000


%Taking plain_text as HEXADECIMAL
% plain_text = input('Enter the Plain Text : ','s');
plain_text = '0123456789abcdef'
disp(plain_text);


%Taking KEY as HEXADECIMAL and converting it to binary (1,0)
% key_string = input('Enter key : ','s');
key_string = '3b3898371520f75e'
%Created all subkeys K1 to k16
key_matrix = key_genrate(key_string);     


%Calling encryption function of DES i.e encryption_des();

cipher_text = encryption_des(key_matrix,plain_text);
cipher_text =binaryVectorToHex(cipher_text);
disp('Ciphertext Generated : ');
disp(cipher_text);


 %Calling decryption function of DES i.e decryption_des();

 plain_text_after_decryption = decryption_des(cipher_text,key_matrix); 
 decrypted_cipher_text = binaryVectorToHex(plain_text_after_decryption);
 disp('Decrypted Cipher Text : ');
 disp(decrypted_cipher_text);
 
 

% ALL FUNCTIONS

% Decryption Function (DES)
function plain_text_after_decryption = decryption_des(cipher_text,key_matrix)
    reversed_key_matrix = flipud(key_matrix);
    plain_text_after_decryption = encryption_des(reversed_key_matrix,cipher_text); 
end



% Encryption Function (DES)
function cipher_text = encryption_des(key_matrix, plain_text)

    plain_text_binary= hexToBinaryVector(plain_text,64);
    
    % Initial Permutaion Table (IP)
    initial_permutaion_table = [58,50,42,34,26,18,10,2,...
	60,52,44,36,28,20,12,4, ...
	62,54,46,38,30,22,14,6, ...
	64,56,48,40,32,24,16,8, ...
	57,49,41,33,25,17,9,1, ...
	59,51,43,35,27,19,11,3, ...
	61,53,45,37,29,21,13,5, ...
	63,55,47,39,31,23,15,7 ];
    
    % Final Permutation or Inverse Permutaion (IP^-1)
    final_permutation_table = [40,8,48,16,56,24,64,32, ...
	39,7,47,15,55,23,63,31, ...
	38,6,46,14,54,22,62,30, ...
	37,5,45,13,53,21,61,29, ...
	36,4,44,12,52,20,60,28, ...
	35,3,43,11,51,19,59,27, ...
	34,2,42,10,50,18,58,26, ...
	33,1,41,9,49,17,57,25 ];

    % Expansion Table of the 'f' function
    expansion_table = [32,1,2,3,4,5,4,5, ...
	6,7,8,9,8,9,10,11, ...
	12,13,12,13,14,15,16,17, ... 
	16,17,18,19,20,21,20,21, ...
	22,23,24,25,24,25,26,27, ...
	28,29,28,29,30,31,32,1 ];
    
    % Permutaion Table of the 'f' function
    permutation_table_for_f_function = [16,7,20,21,29,12,28,17,... 
	1,15,23,26,5,18,31,10, ...
	2,8,24,14,32,27,3,9, ...
	19,13,30,6,22,11,4,25 ];
    
    % Subsition Boexs which will contain values  0<= values <=15
    s_box(:,:,1) =[14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7;... 
        0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8; ...
        4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0; ...
        15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13 ];
    
    s_box(:,:,2) = [15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10;... 
        3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5; ...
        0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15; ...
        13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9 ];
    
    s_box(:,:,3) = [10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8;... 
        13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1; ...
        13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7; ...
        1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12 ];
    
    s_box(:,:,4) = [ 7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15; ...
        13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9; ...
        10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4; ...
        3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14 ];
    
    s_box(:,:,5) = [ 2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9; ... 
        14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6; ...
        4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14;... 
        11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3 ];
    
    s_box(:,:,6) = [12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11; ... 
        10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8; ...
        9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6; ...
        4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13 ];
    
    s_box(:,:,7) = [4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1; ... 
        13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6; ...
        1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2; ...
        6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12 ];
    
    s_box(:,:,8) = [13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7; ...
        1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2; ...
        7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8; ...
        2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11 ];
    
    % Performing Initial Permutaion
    permuted_64_bits_plain_text = zeros(1,64);  
    for i=1:64
        permuted_64_bits_plain_text(i) = plain_text_binary(initial_permutaion_table(i)); 
    end
   
    
    % Splitting Permuted_64_bits_plaint_text into left_32_bits_plain_text
    % and right_32_bits_plain_text
    left_permuted_32_bits_plain_text = permuted_64_bits_plain_text(1:32);
    right_permuted_32_bits_plain_text = permuted_64_bits_plain_text(33:64);
    
    
    Expanded_right_permuted_32_bits_plain_text_to_48=zeros(1,48);
    
    % Encrypting Plain Text 16 times (The 16 Rounds of DES )
    for j=1:16
        
        % Expanding 32-bit Right part of permuted 64 bit plain text to 48 bits using permutaion_table_for_f_function 
        for i=1:48
            Expanded_right_permuted_32_bits_plain_text_to_48(i) = right_permuted_32_bits_plain_text(expansion_table(i)); 
        end
        
        % The Expanded 48 bits are then XORED with the subkey
        xored_result_in_f_function_48_bits = xor(Expanded_right_permuted_32_bits_plain_text_to_48,key_matrix(j,:));
        
        % Initializing some temp values
            row = zeros(1,2);
            col = zeros(1,4);
            k=1;
            m=1;
            
        % Using S_boxes for compression of 48 bits to 32 bits
        for i=1:6:48
            
            row(1) = xored_result_in_f_function_48_bits(i);
            row(2) = xored_result_in_f_function_48_bits(i+5);
            col(1) = xored_result_in_f_function_48_bits(i+1);
            col(2) = xored_result_in_f_function_48_bits(i+2);
            col(3) = xored_result_in_f_function_48_bits(i+3);
            col(4) = xored_result_in_f_function_48_bits(i+4);
             
            % Fetching row value and column value for selecting 4 bit value
            % from S_boxes
            temp_row = binaryVectorToDecimal(row)+1;
            temp_col = binaryVectorToDecimal(col)+1;
            
            % Getting decimal value from 8 s_boxes
            val = s_box(temp_row, temp_col,k);
            k=k+1;
            
            % Converting decimal value to binary value obtained from S_boxes 
            val = decimalToBinaryVector(val,4);          
            
            % Creating 1x32 array for storing compressed 32 bits from 48
            % bits of the 'f' function
            compressed_48_bits_to_32_bits(m:m+3) = val;
            m=m+4;
            
        end
        
       
        % Using permutation_table_for_f_function to do permutation (rearrangement)
        output_of_f_function = zeros(1,32);
        for i=1:32
            output_of_f_function(i) = compressed_48_bits_to_32_bits(permutation_table_for_f_function(i));
        end
        
        
        % Taking xor of left_permuted_32_bits_plain_text with
        % Output_of_f_function
        xor_result_of_left_part_with_output_of_f_function = xor(left_permuted_32_bits_plain_text , output_of_f_function);
        
        % Swapping final xor_result_of_left_part_with_output_of_f_funtion with right_permuted_32_bits_plain_text 
        left_permuted_32_bits_plain_text =right_permuted_32_bits_plain_text;
        right_permuted_32_bits_plain_text=xor_result_of_left_part_with_output_of_f_function;
       
        % Combining left_part and right_part
        combined_64_bits = cat(2,right_permuted_32_bits_plain_text,left_permuted_32_bits_plain_text);
       
        % Doing Final permutation or Inverse Permutaion
        cipher = zeros(1,64);
        for i=1:64
            cipher(i) = combined_64_bits(final_permutation_table(i));
        end        
    end
    
    
    cipher_text=cipher;       
end



% Function for Key Generation
function all_keys = key_genrate(key_string)
        key_binary = hexToBinaryVector(key_string,64);

        % Permuted Choice-1 (PC-1 Table) Size PC-1 : 56
        pc_one = [57,49,41,33,25,17,9, ...
            1,58,50,42,34,26,18,...
            10,2,59,51,43,35,27, ...
            19,11,3,60,52,44,36, ...		 
            63,55,47,39,31,23,15, ...
            7,62,54,46,38,30,22, ...
            14,6,61,53,45,37,29, ...
            21,13,5,28,20,12,4 ];


        % Permuted Choice-2 (PC-2 Table) Size PC-2 : 48
        pc_two = [14,17,11,24,1,5, ...
            3,28,15,6,21,10, ...
            23,19,12,4,26,8, ...
            16,7,27,20,13,2, ...
            41,52,31,37,47,55, ...
            30,40,51,45,33,48, ...
            44,49,39,56,34,53, ...
            46,42,50,36,29,32 ];


        % Used PC-1 table to compress 64-bit key to 56-bit key
        comp_key = zeros(1,56);
        for i=1:56
            comp_key(i) = key_binary(pc_one(i)); 
        end

        % Splitting Compressed Key into Left_compressed_key (of size 28 bits) and
        % Right_coompressed_key (of size 28 bits)
        left_comp_key = comp_key(1:28);
        right_comp_key = comp_key(29:56);

        % Initializing 16 keys to zeros
        all_keys = zeros(16,48);

        % Creating all 16 Keys
        final_key = zeros(1,48);    
        for i=1:16
            % For iterations i =  1,2,9,16 we do left_shit once according to algo.
            if i==1 || i==2 || i==9 || i==16
                left_comp_key = circshift(left_comp_key,-1);
                right_comp_key = circshift(right_comp_key,-1);
            % For iterations i not equal to 1,2,9,16 we do left_shit twice according to
            % algo.
            else
                left_comp_key = circshift(left_comp_key,-2);
                right_comp_key = circshift(right_comp_key,-2);
            end

            % Combining left_comp_key and right_comp_key after circular shift
           temp_comp_key = cat(2,left_comp_key,right_comp_key);

            % Using Permuted Choice (PC-2 table) for permutation and compression of keys to 48 bits
            for j = 1:48
                final_key(j) = temp_comp_key(pc_two(j));
            end   
            all_keys(i,:) = final_key;
        end
end







