clc;
clear;
close all;
% 
% m = input('Enter Plaint Text : ','s');
% m = double(m);
% for i=1:length(m)
%                 if m(i) == 32
%                     continue;
%                 elseif m(i) >= 97 && m(i) <=122 
%                     m(i) = m(i)-97;
%                 elseif m(i) >= 65 && m(i) <= 90 
%                     m(i) = m(i)-65;
%                 end
%                 
% end
% 
% 
% 
% m = string(m);
% m = replace( strjoin(m)," ","");
% disp(m);
% disp(class(m));
% 
% m = str2double(m);
% disp(m);
% disp(class(m));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



p = input('Enter P : ');
q = input('Enter Q : ');

n=p*q;
[e,d] = calculate_e_and_d(p,q);


%disp('MI of e (Value of d) : ');
%disp(d);

%encrypting message
cipher_text = encryption(m,e,n);
disp('Cipher Text : ');
disp(cipher_text);


%decrypting message
decrypted_text = decryption(cipher_text,d,n);
disp('Decrypted Text (Plain Text) : ');
disp(decrypted_text);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALL FUNCTION
function [e,d] = calculate_e_and_d(p,q)
    
    phi_n = (p-1)*(q-1);
    disp(phi_n);

    for e=2:phi_n-1

        if gcd(e,phi_n)==1
            break;
        end
    end

    e = 343;

    %Calculating d (MI of e)
    [g,t,~] = gcd(e,phi_n);
    if mod(g,e)==1
        if t<0
            d=26+t;
        else
            d=t;
        end
    end


end

%Encryption function
function cipher_text = encryption(m,e,n)
    cipher_text = powermod(m,e,n);
end

%Decryption function
function decrypted_text = decryption(c,d,n)
    decrypted_text = powermod(c,d,n);
end


