
clc;
clear;
close all;

key = [0 1 0 1 1 1 0 1 1 1 1 1 1 0 1 0 0 0 1 0 0 1 1 0 1 0 1 0 1 0 0 0 1 1 1 1 0 1 0 0 1 1 0 1 0 0 1 0 1 1 0 1 0 1 1 1 1 0 0 1 1 0 1 0];

%initializing registers X,Y,Z with zeros
[reg_x,reg_y,reg_z] = initialize_regseters();

%Lading registers X,Y,Z with key
[reg_x,reg_y,reg_z] = load_registers(reg_x,reg_y,reg_z,key);
% disp('Reg x : ');
% disp(reg_x);
% 
% disp('Reg y : ');
% disp(reg_y);
% 
% disp('Reg z : ');
% disp(reg_z);

%Key Stream Generation
key_stream_228bit = keyStreamGeneration(reg_x,reg_y,reg_z);

%Encryption 
plain_text =randi([0,1],1,228);
cipher_text = encryption(key_stream_228bit,plain_text);
disp('Cipher Text (228 bits) : ');
disp(join(string(cipher_text)));

%Decryption
plain_text =randi([0,1],1,228);
decrpyted_text = decryption(key_stream_228bit,cipher_text);
disp('Decrypted Text (228 bits) : ');
disp(join(string(decrpyted_text)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALL FUNCTIONS

%Encryption Function
function cipher_text = encryption(key_stream_228bit,plain_text)

    cipher_text = bitxor(key_stream_228bit,plain_text);
    disp('Key Stream (228 bits) : ');
    disp(join(string( key_stream_228bit)));
    disp('Plain Text (228 bits) : ');
    disp(join(string(plain_text)));
end

%Decryption Function
function decrpyted_text = decryption(key_stream_228bit,cipher_text)

    temp = bitxor(key_stream_228bit,cipher_text);
    decrpyted_text = temp;
end

%Initializing regesters X,Y,Z with zeros
function [reg_x,reg_y,reg_z]=initialize_regseters()
    reg_x = zeros(1,19);
    reg_y = zeros(1,22);
    reg_z = zeros(1,23);
end

%Loading Registers with key
function [reg_x,reg_y,reg_z] = load_registers(reg_x,reg_y,reg_z,key)
    
    %adding key without majority function
    for i=1:64
       reg_x(1,19) = xor(xor(xor(xor(reg_x(1,1),reg_x(1,2)),reg_x(1,3)),reg_x(1,6)),key(1,i));
       reg_x = circshift(reg_x,-1);
       
       reg_y(1,22) = xor(xor(reg_y(1,1),reg_y(1,2)),key(1,i));
       reg_y = circshift(reg_y,-1);
       
       reg_z(1,23) = xor(xor(xor(xor(reg_z(1,1),reg_z(1,2)),reg_z(1,3)),reg_z(1,16)),key(1,i));
       reg_z =circshift(reg_z,-1);
    end
    
    
   
    %adding 22 bit frame without majority function
    bit_frame_of_22bit = [1 1 1 0 1 0 1 0 1 1 0 0 1 1 1 1 0 0 1 0 1 1];
    for i=1:22
         reg_x(1,19) = xor(xor(xor(xor(reg_x(1,1),reg_x(1,2)),reg_x(1,3)),reg_x(1,6)),bit_frame_of_22bit(1,i));
         reg_x = circshift(reg_x,-1);
       
        reg_y(1,22) = xor(xor(reg_y(1,1),reg_y(1,2)),bit_frame_of_22bit(1,i));
        reg_y = circshift(reg_y,-1);
       
        reg_z(1,23) = xor(xor(xor(xor(reg_z(1,1),reg_z(1,2)),reg_z(1,3)),reg_z(1,16)),bit_frame_of_22bit(1,i));
        reg_z = circshift(reg_z,-1);
    end
    
    
    %Clocking 100 times with majority function
    for i=1:100
        m = majority(reg_x,reg_y,reg_z);
        
        if m == reg_x(1,9)
            reg_x(1,19) = xor(xor(xor(reg_x(1,1),reg_x(1,2)),reg_x(1,3)),reg_x(1,6));
            reg_x = circshift(reg_x,-1);
            
        elseif m == reg_y(1,11)
            reg_y(1,22) = xor(reg_y(1,1),reg_y(1,2));
            reg_y = circshift(reg_y,-1);
            
        elseif m == reg_z(1,11)
            reg_z(1,23) = xor(xor(xor(reg_z(1,1),reg_z(1,2)),reg_z(1,3)),reg_z(1,16));
            reg_z = circshift(reg_z,-1);
        end
    end
       
        
end
    
%Generating Key stream with the help of majority function
function key_stram_288bit = keyStreamGeneration(reg_x,reg_y,reg_z)

    temp_key = zeros(1,228);

    for i=1:228
        m = majority(reg_x,reg_y,reg_z);
        
        if m == reg_x(1,9)
            reg_x(1,19) = xor(xor(xor(reg_x(1,1),reg_x(1,2)),reg_x(1,3)),reg_x(1,6));
            reg_x = circshift(reg_x,-1);
            
        elseif m == reg_y(1,11)
            reg_y(1,22) = xor(reg_y(1,1),reg_y(1,2));
            reg_y = circshift(reg_y,-1);
            
        elseif m == reg_z(1,11)
            reg_z(1,23) = xor(xor(xor(reg_z(1,1),reg_z(1,2)),reg_z(1,3)),reg_z(1,16));
            reg_z = circshift(reg_z,-1);
        end
        
        temp_key(1,i)= xor(xor(reg_x(1,19),reg_y(1,22)),reg_z(1,23));
    end
       
    key_stram_288bit = temp_key;
end


%Majority Function
function m = majority(reg_x,reg_y,reg_z)

    x = reg_x(1,9);
    y = reg_y(1,11);
    z = reg_z(1,11);
    
    if x+y+z >1
        m = 1;
    else
        m = 0;
    end

end


















