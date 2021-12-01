


clc;
clear;
close all;

%Taking Plain Text as input
plain_text = input('Enter Plain Text : ','s');
plain_text =  getStateMatrix(plain_text);

%Taking key as plain_text
key = input('Enter key : ','s');
key = getStateMatrix(key);

%Creating all Sub Keys (key-0 to key-10)
sub_keys = subKeyGeneration(key);

%Calling aes_encryption function to get cipher text from plain text
cipher_text = aes_encryption(plain_text,sub_keys);
disp('Cipher Text Generated : ');
disp(cipher_text);


%Calling Decryption Function to get plain text from cipher text;
Decrypted_text = aes_decryption(cipher_text,sub_keys);
disp('Decrpyted Text : ');
disp(Decrypted_text);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALL FUNCTIONS

%AES Decryption Function
function decrypted_text = aes_decryption(cipher_text,sub_keys)
    
    %Getting state matrix for Cipher Text
    cipher_text = char(cipher_text);
    temp = [];
    for i=1:2:32
        temp = cat(2,temp,string (cipher_text(1,i:i+1))); 
    end
    cipher_text = temp;
    cipher_text = reshape(cipher_text,4,4);
    
    
    %Reversing all Sub Keys
    temp = [];
    k=41;
    while k>0 
        temp = cat(2,temp,sub_keys(:,k:k+3)); 
        k = k-4;
    end
    sub_keys = temp;
    
    
    
    %Calling addRoundkey Function
    op_of_add_round_key = addRoundKey(cipher_text,sub_keys);
    disp(op_of_add_round_key);
    k = 9;
for i=1:10
    
    if i==1
        
        %Shift Operation
        op_of_Shift_operation = invShiftOperation(op_of_add_round_key);
        
        %Substitution Operation
        op_of_Substitution_operation = invSubstitutionOperation(op_of_Shift_operation);
        
        %Add Round Key Operation
        op_of_add_round_key = AddRoundKey(op_of_Substitution_operation,sub_keys(:,5:8));
        disp(op_of_add_round_key);
    else
        
        %Mix Column Operation
        op_of_Mix_Column_operation = invMixOperation(op_of_add_round_key);
        
        %Shift Operation
        op_of_Shift_operation =invShiftOperation(op_of_Mix_Column_operation);
        
        %Substitution Operation
        op_of_Substitution_operation = invSubstitutionOperation(op_of_Shift_operation);
        
        %Add Round Key Operation
        op_of_inv_Add_Round_key = AddRoundKey(op_of_Substitution_operation,sub_keys(:,k:k+3));
        k = k+4;
        op_of_add_round_key = op_of_inv_Add_Round_key;
        disp(op_of_add_round_key);
    end
    
    
        
    
end
    decrypted_text = reshape(op_of_add_round_key,1,16);
    decrypted_text = replace (string( strjoin(decrypted_text)),' ',''); 

end

%Inverse Substitution Function
function state_matrix=  invSubstitutionOperation(state_matrix)

    s_box = ["52" "09" "6a" "d5" "30" "36" "a5" "38" "bf" "40" "a3" "9e" "81" "f3" "d7" "fb";...
	"7c" "e3" "39" "82" "9b" "2f" "ff" "87" "34" "8e" "43" "44" "c4" "de" "e9" "cb";...
	"54" "7b" "94" "32" "a6" "c2" "23" "3d" "ee" "4c" "95" "0b" "42" "fa" "c3" "4e";...
	"08" "2e" "a1" "66" "28" "d9" "24" "b2" "76" "5b" "a2" "49" "6d" "8b" "d1" "25";...
	"72" "f8" "f6" "64" "86" "68" "98" "16" "d4" "a4" "5c" "cc" "5d" "65" "b6" "92";...
	"6c" "70" "48" "50" "fd" "ed" "b9" "da" "5e" "15" "46" "57" "a7" "8d" "9d" "84";...
	"90" "d8" "ab" "00" "8c" "bc" "d3" "0a" "f7" "e4" "58" "05" "b8" "b3" "45" "06";...
	"d0" "2c" "1e" "8f" "ca" "3f" "0f" "02" "c1" "af" "bd" "03" "01" "13" "8a" "6b";...
	"3a" "91" "11" "41" "4f" "67" "dc" "ea" "97" "f2" "cf" "ce" "f0" "b4" "e6" "73";...
	"96" "ac" "74" "22" "e7" "ad" "35" "85" "e2" "f9" "37" "e8" "1c" "75" "df" "6e";...
	"47" "f1" "1a" "71" "1d" "29" "c5" "89" "6f" "b7" "62" "0e" "aa" "18" "be" "1b";...
	"fc" "56" "3e" "4b" "c6" "d2" "79" "20" "9a" "db" "c0" "fe" "78" "cd" "5a" "f4";...
	"1f" "dd" "a8" "33" "88" "07" "c7" "31" "b1" "12" "10" "59" "27" "80" "ec" "5f";...
	"60" "51" "7f" "a9" "19" "b5" "4a" "0d" "2d" "e5" "7a" "9f" "93" "c9" "9c" "ef";...
	"a0" "e0" "3b" "4d" "ae" "2a" "f5" "b0" "c8" "eb" "bb" "3c" "83" "53" "99" "61";...
	"17" "2b" "04" "7e" "ba" "77" "d6" "26" "e1" "69" "14" "63" "55" "21" "0c" "7d"];

 
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

% Inverse Shift Operationg function
function state_matrixx = invShiftOperation(state_matrix)
    state_matrixx = state_matrix(1,:);
    state_matrixx = cat( 1,state_matrixx ,circshift(state_matrix(2,:),1));
    state_matrixx = cat( 1,state_matrixx ,circshift(state_matrix(3,:),2));
    state_matrixx = cat( 1,state_matrixx ,circshift(state_matrix(4,:),3));
end

% Inverse Mix Coulumn Operation
function state_matrixx = invMixOperation(state_matrix)
   constant_matrix = ["0E" "0B" "0D" "09";...
        "09" "0E" "0B" "0D";...
        "0D" "09" "0E" "0B";...
        "0B" "0D" "09" "0E"];  
    state_matrixx = string(zeros(4,4));
    
    
for i=1:4
    for j=1:4
        a =hexToBinaryVector(constant_matrix(i,1),16);
        b =hexToBinaryVector(state_matrix(1,j),16);
        c =hexToBinaryVector(constant_matrix(i,2),16);
        d =hexToBinaryVector(state_matrix(2,j),16);
        e =hexToBinaryVector(constant_matrix(i,3),16);
        f =hexToBinaryVector(state_matrix(3,j),16);
        g =hexToBinaryVector(constant_matrix(i,4),16);
        h =hexToBinaryVector(state_matrix(4,j),16);


        sum = conv(a,b)+conv(c,d)+conv(e,f)+conv(g,h);


        for k=1:31
            if mod(sum(1,k),2)==0
                sum(1,k) = 0;
            else
                sum(1,k) = 1;
            end
        end

        irreducible_polynomial = [1 0 0 0 1 1 0 1 1];
        [~,r] = deconv(sum,irreducible_polynomial);

        result = r(1,24:end);

        for m =1:8
            if result(1,m)==-1 || result(1,m) == 1
                result(1,m)=1;
            else
                result(1,m) = 0;
            end
        end

        state_matrixx(i,j) = string( binaryVectorToHex(result));
        
    end
end
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% AES Encryption Function
function cipher_text = aes_encryption(plain_text,sub_keys)

    %Calling addRoundkey Function
    op_of_add_round_key = addRoundKey(plain_text,sub_keys);
    disp(plain_text);
    
k = 5;
for i=1:10
    
    if i<10
        %Substitution Operation
        op_of_Substitution_operation = substitutionOperation(op_of_add_round_key);

        %Shift Operation
        op_of_Shift_operation = shiftOperation(op_of_Substitution_operation);

        %Mix Column Operation
        op_of_Mix_Column_operation = mixOperation(op_of_Shift_operation);

        %Add Round Key Operation
        op_of_Add_Round_key = AddRoundKey(op_of_Mix_Column_operation,sub_keys(:,k:k+3));
        k = k+4;

        op_of_add_round_key = op_of_Add_Round_key;
    else
        %Substitution Operation
        op_of_Substitution_operation = substitutionOperation(op_of_add_round_key);

        %Shift Operation
        op_of_Shift_operation = shiftOperation(op_of_Substitution_operation);

        %Add Round Key Operation
        op_of_Add_Round_key = AddRoundKey(op_of_Shift_operation,sub_keys(:,41:44));

        cipher_text = reshape(op_of_Add_Round_key,1,16);
    end
    
end

   cipher_text = replace (string( strjoin(cipher_text)),' ',''); 
   
end


%Add Round Key Function at each Round
function state_matrixx = AddRoundKey(state_matrix,roundkey)

    state_matrixx=string(zeros(4,4));
    for i=1:4
        for j=1:4
            a=hexToBinaryVector( state_matrix(i,j),8);
            b=hexToBinaryVector( roundkey(i,j),8);
            xor_result = xor(a,b);
            state_matrixx(i,j) = string( binaryVectorToHex(xor_result));
        end
    end

end

% Mix operation function
function state_matrixx = mixOperation(state_matrix)
   constant_matrix = ["02" "03" "01" "01";...
        "01" "02" "03" "01";...
        "01" "01" "02" "03";...
        "03" "01" "01" "02"];  
state_matrixx = string(zeros(4,4));
    
for i=1:4
    for j=1:4
        a =hexToBinaryVector(constant_matrix(i,1),16);
        b =hexToBinaryVector(state_matrix(1,j),16);
        c =hexToBinaryVector(constant_matrix(i,2),16);
        d =hexToBinaryVector(state_matrix(2,j),16);
        e =hexToBinaryVector(constant_matrix(i,3),16);
        f =hexToBinaryVector(state_matrix(3,j),16);
        g =hexToBinaryVector(constant_matrix(i,4),16);
        h =hexToBinaryVector(state_matrix(4,j),16);


        sum = conv(a,b)+conv(c,d)+conv(e,f)+conv(g,h);


        for k=1:31
            if mod(sum(1,k),2)==0
                sum(1,k) = 0;
            else
                sum(1,k) = 1;
            end
        end

        irreducible_polynomial = [1 0 0 0 1 1 0 1 1];
        [~,r] = deconv(sum,irreducible_polynomial);

        result = r(1,24:end);

        for m =1:8
            if result(1,m)<0
                result(1,m)=1;
            end
        end

        state_matrixx(i,j) = string( binaryVectorToHex(result));
    end
end
end

%Shift Operation Function
function state_matrixx = shiftOperation(state_matrix)
    state_matrixx = state_matrix(1,:);
    state_matrixx = cat( 1,state_matrixx ,circshift(state_matrix(2,:),-1));
    state_matrixx = cat( 1,state_matrixx ,circshift(state_matrix(3,:),-2));
    state_matrixx = cat( 1,state_matrixx ,circshift(state_matrix(4,:),-3));
end


% Substitution operation Function
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


%Shift operation function at begining of 10 rounds
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

