


clc;
clear;
close all;

%Taking Plain Text as input
plain_text = input('Enter Plain Text : ','s');
plain_text =  getStateMatrix(plain_text);

%Taking key as plain_text
key = input('Enter key : ','s');
key = getStateMatrix(key);

% Creating all Sub Keys (key-0 to key-10)
sub_keys = subKeyGeneration(key);

%Calling addRoundkey Function
op_of_add_round_key = addRoundKey(plain_text,sub_keys);


%Substitution Operation
op_of_Substitution_operation = substitutionOperation(op_of_add_round_key);

%Shift Operation
op_of_Shift_operation = shiftOperation(op_of_Substitution_operation);

%Mix Column Operation
op_of_Mix_Column_operation = mixOperation(op_of_Shift_operation);
disp(op_of_Mix_Column_operation);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALL FUNCTIONS

function state_matrixx = mixOperation(state_matrix)
    constant_matrix = ["02" "03" "01" "01";...
        "01" "02" "03" "01";...
        "01" "01" "02" "03";...
        "03" "01" "01" "02"];
    state_matrixx = constant_matrix;

end


function state_matrixx = shiftOperation(state_matrix)
    state_matrixx = state_matrix(1,:);
    state_matrixx = cat( 1,state_matrixx ,circshift(state_matrix(2,:),-1));
    state_matrixx = cat( 1,state_matrixx ,circshift(state_matrix(3,:),-2));
    state_matrixx = cat( 1,state_matrixx ,circshift(state_matrix(4,:),-3));
end


function state_matrix = substitutionOperation(state_matrix)
    s_box =["63" "7c" "77" "7b" "f2" "6b" "6f" "c5" "30" "01" "67" "2b" "fe" "d7" "ab" "76";...
    "ca" "82" "c9" "7d" "fa" "59" "47" "f0" "ad" "d4" "a2" "af" "9c" "a4" "72" "c0";...
    "b7" "fd" "93" "26" "36" "3f" "f7" "cc" "34" "a5" "e5" "f1" "71" "d8" "31" "15";...
    "04" "c7" "23" "c3" "18" "96" "05" "9a" "07" "12" "80" "e2" "eb" "27" "b2" "75";...
    "09" "83" "2c" "1a" "1b" "6e" "5a" "a0" "52" "3b" "d6" "b3" "29" "e3" "2f" "84";...
    "53" "d1" "00" "ed" "20" "fc" "b1" "5b" "6a" "cb" "be" "39" "4a" "4c" "58" "cf";...
    "d0" "ef" "aa" "fb" "43" "4d" "33" "85" "45" "f9" "02" "7f" "50" "3c" "9f" "a8";...
    "51" "a3" "40" "8f" "92" "9d" "38" "f5" "bc" "b6" "da" "21" "10" "ff" "f3" "d2";...
    "cd" "0c" "13" "ec" "5f" "97" "44" "17" "c4" "a7" "7e" "3d" "64" "5d" "19" "73";...
    "60" "81" "4f" "dc" "22" "2a" "90" "88" "46" "ee" "b8" "14" "de" "5e" "0b" "db";...
    "e0" "32" "3a" "0a" "49" "06" "24" "5c" "c2" "d3" "ac" "62" "91" "95" "e4" "79";...
    "e7" "c8" "37" "6d" "8d" "d5" "4e" "a9" "6c" "56" "f4" "ea" "65" "7a" "ae" "08";...
    "ba" "78" "25" "2e" "1c" "a6" "b4" "c6" "e8" "dd" "74" "1f" "4b" "bd" "8b" "8a";...
    "70" "3e" "b5" "66" "48" "03" "f6" "0e" "61" "35" "57" "b9" "86" "c1" "1d" "9e";...
    "e1" "f8" "98" "11" "69" "d9" "8e" "94" "9b" "1e" "87" "e9" "ce" "55" "28" "df";...
    "8c" "a1" "89" "0d" "bf" "e6" "42" "68" "41" "99" "2d" "0f" "b0" "54" "bb" "16"];
 
    state_matrix = reshape(state_matrix,1,16);    
    for i=1:16
       temp = state_matrix(1,i);
       temp = hexToBinaryVector(temp,8);
       row = binaryVectorToDecimal(temp(1,1:4))+1;
       col = binaryVectorToDecimal(temp(1,5:8))+1;
       state_matrix(1,i) = s_box(row,col);
    end
    
    state_matrix = reshape(state_matrix,4,4);

end


function state_matrix =  addRoundKey(plain_text,sub_keys)
    
    plain_text =reshape( hexToBinaryVector(reshape(plain_text,1,16),8)',1,128);
    key = reshape(hexToBinaryVector(reshape(sub_keys(:,1:4),1,16),8)',1,128);
    
    %performing xor of plain text and sub key 1
    xor_result = xor(plain_text,key);
    
    xor_result = reshape(string (reshape(binaryVectorToHex(xor_result)',2,16)'),4,4);
    state_matrix = xor_result;
   
end


function  sub_keys = subKeyGeneration(sub_keys)
        
    j=0;
    for k=1:10
        %Calling g function to get G(W)
        j=j+4;
        result_of_g_function = gFunction(sub_keys(:,j),k)';
        result_of_g_function = reshape(hexToBinaryVector(result_of_g_function,8)',1,32);
        word = reshape(hexToBinaryVector(sub_keys(:,j-3)',8)',1,32);

        %XORing W to G(W)
        xor_result = xor(word,result_of_g_function);    
        xor_result_hex =string (reshape( binaryVectorToHex(xor_result),2,4)');

        %Adding updated word to sub_keys
        sub_keys = cat(2,sub_keys,xor_result_hex);        
        
        for i=j-2:j
            xor_result_hex = reshape(hexToBinaryVector(xor_result_hex,8)',1,32);
            word = reshape(hexToBinaryVector(sub_keys(:,i)',8)',1,32);

            xor_result_hex = xor(word,xor_result_hex);
            xor_result_hex = string(reshape(binaryVectorToHex(xor_result_hex),2,4)');
            sub_keys = cat(2,sub_keys,xor_result_hex);

        end
    end
end
 


function output_of_g_function =gFunction(word,k)
    % Sbox table
    s_box =["63" "7c" "77" "7b" "f2" "6b" "6f" "c5" "30" "01" "67" "2b" "fe" "d7" "ab" "76";...
    "ca" "82" "c9" "7d" "fa" "59" "47" "f0" "ad" "d4" "a2" "af" "9c" "a4" "72" "c0";...
    "b7" "fd" "93" "26" "36" "3f" "f7" "cc" "34" "a5" "e5" "f1" "71" "d8" "31" "15";...
    "04" "c7" "23" "c3" "18" "96" "05" "9a" "07" "12" "80" "e2" "eb" "27" "b2" "75";...
    "09" "83" "2c" "1a" "1b" "6e" "5a" "a0" "52" "3b" "d6" "b3" "29" "e3" "2f" "84";...
    "53" "d1" "00" "ed" "20" "fc" "b1" "5b" "6a" "cb" "be" "39" "4a" "4c" "58" "cf";...
    "d0" "ef" "aa" "fb" "43" "4d" "33" "85" "45" "f9" "02" "7f" "50" "3c" "9f" "a8";...
    "51" "a3" "40" "8f" "92" "9d" "38" "f5" "bc" "b6" "da" "21" "10" "ff" "f3" "d2";...
    "cd" "0c" "13" "ec" "5f" "97" "44" "17" "c4" "a7" "7e" "3d" "64" "5d" "19" "73";...
    "60" "81" "4f" "dc" "22" "2a" "90" "88" "46" "ee" "b8" "14" "de" "5e" "0b" "db";...
    "e0" "32" "3a" "0a" "49" "06" "24" "5c" "c2" "d3" "ac" "62" "91" "95" "e4" "79";...
    "e7" "c8" "37" "6d" "8d" "d5" "4e" "a9" "6c" "56" "f4" "ea" "65" "7a" "ae" "08";...
    "ba" "78" "25" "2e" "1c" "a6" "b4" "c6" "e8" "dd" "74" "1f" "4b" "bd" "8b" "8a";...
    "70" "3e" "b5" "66" "48" "03" "f6" "0e" "61" "35" "57" "b9" "86" "c1" "1d" "9e";...
    "e1" "f8" "98" "11" "69" "d9" "8e" "94" "9b" "1e" "87" "e9" "ce" "55" "28" "df";...
    "8c" "a1" "89" "0d" "bf" "e6" "42" "68" "41" "99" "2d" "0f" "b0" "54" "bb" "16"];
 

    % 1 Byte circular left shit  
    word = circshift(word,-1);
    
    % Byte substitution with help of sbox look up table
    for i=1:4
       temp = word(i,1);
       temp = hexToBinaryVector(temp,8);
       row = binaryVectorToDecimal(temp(1,1:4))+1;
       col = binaryVectorToDecimal(temp(1,5:8))+1;
       word(i,1) = s_box(row,col);
    end
    
    % XORing with Round Constant RC
    round_constant = ["01" "02" "04" "08" "10" "20" "40" "80" "1b" "36";...
        "00" "00" "00" "00" "00" "00" "00" "00" "00" "00" ;...
        "00" "00" "00" "00" "00" "00" "00" "00" "00" "00" ;...
        "00" "00" "00" "00" "00" "00" "00" "00" "00" "00" ];
    
    for i=1:4
        xor_result =string( binaryVectorToHex(xor (hexToBinaryVector( word(i,1) ,8) ,hexToBinaryVector(round_constant(i,k),8))));
        word(i,1) =  xor_result;
    end
    output_of_g_function = word; 
end

function state_matrix = getStateMatrix(str)
    str =  string(dec2hex( reshape(str,4,4)));
    str = reshape(str,4,4);    
    state_matrix = str;
end

