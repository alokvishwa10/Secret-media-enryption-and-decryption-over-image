%DECRYPT IMAGE
clear all

%READ THE ENCRYPTED IMAGE
A = imread('Encrypt_Image1.png');

%RED,GREEN AND BLUE COMPONENTS
Red_ch = A(:,:,1);
Green_ch = A(:,:,2);
Blue_ch = A(:,:,3);

%INTERVAL
Dt = bitget(Red_ch(1:8),1);
Dt = double(bi2de(Dt));

%NUMBER OF COLUMNS
Ncols = bitget(Red_ch(9:16),1);
Ncols = double(bi2de(Ncols));

%NUMBER OF ROWS
Nrows = bitget(Red_ch(17:24),1);
Nrows = double(bi2de(Nrows));

%FETCH THE LEAST SIGNIFICANT BIT FROM THE ENCRYPTED IMAGE
EndPoint = (Dt*Nrows*Ncols*8)+24;
Decrypt_Red = bitget(Red_ch(25:Dt:EndPoint),1);
Decrypt_Green = bitget(Green_ch(25:Dt:EndPoint),1);
Decrypt_Blue = bitget(Blue_ch(25:Dt:EndPoint),1);

Decrypt_Red = reshape(Decrypt_Red,8,[])';
Decrypt_Red = bi2de(Decrypt_Red);
Decrypt_Red = reshape(Decrypt_Red,Ncols,Nrows);

Decrypt_Green = reshape(Decrypt_Green,8,[])';
Decrypt_Green = bi2de(Decrypt_Green);
Decrypt_Green = reshape(Decrypt_Green,Ncols,Nrows);

Decrypt_Blue = reshape(Decrypt_Blue,8,[])';
Decrypt_Blue = bi2de(Decrypt_Blue);
Decrypt_Blue = reshape(Decrypt_Blue,Ncols,Nrows);

Decrypted_Image = zeros([Ncols,Nrows,3]);
Decrypted_Image(:,:,1)=Decrypt_Red;
Decrypted_Image(:,:,2)=Decrypt_Green;
Decrypted_Image(:,:,3)=Decrypt_Blue;

Decrypted_Image = uint8(Decrypted_Image);


figure,imshow(Decrypted_Image);title('Secret Image');