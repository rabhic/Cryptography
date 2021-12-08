clc;
clear ;
close all;

%Taking Plain Text as input
plain_text = input('Enter Plain Text : ','s');
disp(plain_text);

%Taking Key as input
key = input('Enter Key : ','s');
disp(key);

Z = uint8(pRandomGenerator(keySchedule(key), size(plain_text,2)));
P = uint8(char(plain_text));
res = bitxor(Z, P);

%printing result in hex and unicode
result = mat2str(dec2hex(res,2));
disp(result);

%res_in_unicode = char(res)
function  S  = keySchedule( key )

key = char(key);
key = uint16(key);

key_length = size(key,2);
S=0:255;

j=0;
for i=0:1:255
    j =  mod( j + S(i+1) + key(mod(i, key_length) + 1), 256);
    S([i+1 j+1]) = S([j+1 i+1]);
end

end

function  key  = pRandomGenerator( S, n )
%S is the result from key schedule function
%n number of characters to be encrypted

i = 0;
j = 0;
key = uint16([]);


while n> 0
    n = n - 1;
    i = mod( i + 1, 256);
    j = mod(j + S(i+1), 256);
    S([i+1 j+1]) = S([j+1 i+1]);
    K = S( mod(  S(i+1) + S(j+1)   , 256)  + 1  );
    key = [key, K]; 
end
end