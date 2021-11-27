clear;
clc;
close all;

% take plain text as input
plain_text = input('Enter any Plain Text  : ','s');
plain_text_double1 = double(plain_text);
plain_text_double2 = plain_text_double1;

% take key as input
key = input('Enter KEY : ','s');
key_double= double(key);

if key_double >=97 && key_double <=122
    key_double = key_double-97;
else
    key_double = key_double-65;
end


% Display error if entered special characters
            for i=1:length(plain_text_double2)
                 if plain_text_double2(i) == 32
                    continue;
                 elseif plain_text_double2(i) >= 97 && plain_text_double2(i) <=122 
                    continue;
                 elseif plain_text_double2(i) >= 65 && plain_text_double2(i) <= 90 
                    continue;
                 else
                     disp('!!! Entered Special Characters !!!   try again! ');    
                     break;
                 end
                
            end

            
           
%converting ASCII to 0-25 
           for i=1:length(plain_text_double2)
                if plain_text_double2(i) == 32
                    continue;
                elseif plain_text_double2(i) >= 97 && plain_text_double2(i) <=122 
                    plain_text_double2(i) = plain_text_double2(i)-97;
                elseif plain_text_double2(i) >= 65 && plain_text_double2(i) <= 90 
                    plain_text_double2(i) = plain_text_double2(i)-65;
                end
                
           end
  
           
           
% Adding key (Shifting) to every element
cipher_text = plain_text_double2;

for i=1: length(plain_text_double2)
    if plain_text_double2(i)==32
        cipher_text(i)=plain_text_double2(i);
        continue;
    else
        cipher_text(i)=plain_text_double2(i) * key_double;
    end
end
           
           
 % Taking mod of every element 
           for i=1:length(cipher_text)
                if cipher_text(i) == 32
                    continue;
                else
                    cipher_text(i) = mod(cipher_text(i),26);
                end
                
           end
           
% converting back to strings from ASCII
            for i=1:length(cipher_text)
                if cipher_text(i) == 32
                    continue;
                elseif plain_text_double1(i) >= 97 && plain_text_double1(i) <= 122
                    cipher_text(i) = cipher_text(i)+97;
                elseif plain_text_double1(i) >=65 && plain_text_double1(i) <= 90
                    cipher_text(i) = cipher_text(i)+65;
                end
                
            end
           
     cipher = char(cipher_text);
     disp(cipher);


           
           





