clear;
clc;
close all;

% a = input('Enter Plain Text : ','s');
% a = sprintf('%X',a);
% disp(a);
% disp(size(a));
% 48454C4C4F
% b = string(a);

a = input('Enter plain Text : ','s');
a = sprintf('%X',a);

len = length(a);
mul_len = ceil(len/16);
disp(len);
disp(mul_len);
disp(a);


% b = padarray(a,[0 5],0,'post');
% 
% disp(pad_num);
% b = padarray(a,[0 pad_num],0,'post');
% disp(b);
% 
