%ENCRYPTION
clear all

%READ THE COVER IMAGE
I = imread('peppers.png');
I = imresize(I, [720 950]);

%READ THE IMAGE TO HIDE
J = imread('cube.jpg');
J = imresize(J, [254 254]);

%PREALLOCATE THE OUTPUT IMAGE
Output = zeros(size(I));
%REPRESENT THE NUMBER OF ROWS AND COLUMNS OF THE SECRET IMAGE
%IN BINARY FORMAT
Jsize = de2bi([size(J,1),size(J,2)]);

%RED,GREEN AND BLUE COMPONENTS OF THE SECRET IMAGE
Red_Ch = J(:,:,1);
Green_Ch = J(:,:,2);
Blue_Ch = J(:,:,3);

%CONVERT THE RED COMPONENT OF THE SECRET IMAGE INTO BINARY FORMAT
Encrypt_Red = de2bi(Red_Ch(:),8)';
Encrypt_Red = Encrypt_Red(:)';

%CONVERT THE GREEN COMPONENT OF THE SECRET IMAGE INTO BINARY FORMAT
Encrypt_Green = de2bi(Green_Ch(:),8)';
Encrypt_Green = Encrypt_Green(:)';

%CONVERT THE BLUE COMPONENT OF THE SECRET IMAGE INTO BINARY FORMAT
Encrypt_Blue = de2bi(Blue_Ch(:),8)';
Encrypt_Blue = Encrypt_Blue(:)';

%CALCULATE THE INTERVAL AND CONVERT IT INTO BINARY FORMAT
dt=floor((size(I,1)*size(I,2))/numel(Encrypt_Red));
Bi_dt = de2bi(dt,8);

Info_data = [Bi_dt,Jsize(1,:),Jsize(2,:)];

%RED,GREEN AND BLUE COMPONENT OF THE COVER IMAGE
Red_mat = I(:,:,1);
Green_mat = I(:,:,2);
Blue_mat = I(:,:,3);

% INTERVAL,NUMBER OF COLUMNS, NUMBER OF ROWS
Red_mat(1:24) = bitset(Red_mat(1:24),1,Info_data);
Green_mat(1:24) = bitset(Green_mat(1:24),1,Info_data);
Blue_mat(1:24) = bitset(Blue_mat(1:24),1,Info_data);

%%REPLACE THE LEAST SIGNIFICANT BIT OF THE COVER IMAGE
%WITH THE BINARY FORMAT OF THE SECRET IMAGE
EndValue = numel(Encrypt_Red)*dt+24;
Red_mat(25:dt:EndValue) = bitset(Red_mat(25:dt:EndValue),1,Encrypt_Red);
Green_mat(25:dt:EndValue) = bitset(Green_mat(25:dt:EndValue),1,Encrypt_Green);
Blue_mat(25:dt:EndValue) = bitset(Blue_mat(25:dt:EndValue),1,Encrypt_Blue);

%ENCRYPTED IMAGE
Output(:,:,1) = Red_mat;
Output(:,:,2) = Green_mat;
Output(:,:,3) = Blue_mat;
Output = uint8(Output);

figure,subplot(211),imshow(J),title('secret img'); 
subplot(212),imshow(I),title('cover img');
figure,imshow(Output),title('Encrypted img');
 
%DIFFERENCE BETWEEN THE ORIGINAL AND THE ENCRYPTED IMAGE
%figure,imagesc(double(I)-double(Output));colormap(jet);colorbar;

%WRITE THE ENCRYPTED IMAGE IN THE PNG FORMAT
imwrite(Output,'Encrypt_Image1.png');