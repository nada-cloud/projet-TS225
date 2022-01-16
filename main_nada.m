clear all
close all
clc


%% params

% h1 = 250;
% w1 = 400;
Image1 = imread('cats.png');
figure, imshow(Image1)


[x1, y1] = ginput(4);
P1 = [x1(1) y1(1); x1(2) y1(2); x1(3) y1(3); x1(4) y1(4)];

h1 = (max(P1(:,2))-min(P1(:,2))); %height img extracted
w1 = (max(P1(:,1))-min(P1(:,1))); %length img extracted
P_init1 = [1 1; h1 1; h1 w1; 1 w1];

[x2, y2] = ginput(4);
P2 = [x2(1) y2(1); x2(2) y2(2); x2(3) y2(3); x2(4) y2(4)];

h2 = (max(P2(:,2))-min(P2(:,2))); %height img extracted
w2 = (max(P2(:,1))-min(P2(:,1))); %length img extracted
P_init2 = [1 1; h2 1; h2 w2; 1 w2];


H1 = estimate_homography_matrix(P_init1,P1);
H2 = estimate_homography_matrix(P_init2,P2);


img1 = extract(Image1,H1,h1,w1);
img2 = extract(Image1,H2,h2,w2);
figure,
subplot(1,2,1)
imshow(uint8(img1))
title('image img1, choisir les pts en communs')

subplot(1,2,2)
imshow(uint8(img2))
title('image img2, choisir les pts en communs')


%% routine 1: triplet

[I1,M1,B1] = get_triplet(img1);
[I2,M2,B2] = get_triplet(img2);

[h_1,w_1,c_1] = size(img1);
[h_2,w_2,c_2] = size(img2);

%% routine 2: transformation (sur 2 image, on choisit de ramener img2 dans l'univers de img1

% figure, imshow(uint8(img1))
% title('img1: choisir points en communs :')
[x_c1, y_c1] = ginput(4);
[x_c2, y_c2] = ginput(4);
points_communs_i1 = [x_c1(1) y_c1(1); x_c1(2) y_c1(2); x_c1(3) y_c1(3); x_c1(4) y_c1(4)]; %pts en communs entre les 2 images pour l'homographie
points_communs_i2 = [x_c2(1) y_c2(1); x_c2(2) y_c2(2); x_c2(3) y_c2(3); x_c2(4) y_c2(4)];

H = estimate_homography_matrix(points_communs_i1,points_communs_i2);
H_inv = 1\H;

% boite englobante
B2_h_intermediate = zeros(4, 2);
B2_h = zeros(2,2);
pt_b1 = B2(1,:);
pt_b2 = [B2(2,1),B2(1,2)];
pt_b3 = [B2(1,1),B2(2,2)];
pt_b4 = B2(2,:);

% calcul de l'homographie des 4 pts extremes de l'image (boite englobante)
B2_h_intermediate(1,1) = (H_inv(1,1)*pt_b1(1,1) + H_inv(1,2)*pt_b1(1,2) + H_inv(1,3))/(H_inv(3,1)*pt_b1(1,1) + H_inv(3,2)*pt_b1(1,2) + 1); %x
B2_h_intermediate(1,2) = (H_inv(2,1)*pt_b1(1,1) + H_inv(2,2)*pt_b1(1,2) + H_inv(2,3))/(H_inv(3,1)*pt_b1(1,1) + H_inv(3,2)*pt_b1(1,2) + 1); %y

B2_h_intermediate(2,1) = (H_inv(1,1)*pt_b2(1,1) + H_inv(1,2)*pt_b2(1,2) + H_inv(1,3))/(H_inv(3,1)*pt_b2(1,1) + H_inv(3,2)*pt_b2(1,2) + 1); %x
B2_h_intermediate(2,2) = (H_inv(2,1)*pt_b2(1,1) + H_inv(2,2)*pt_b2(1,2) + H_inv(2,3))/(H_inv(3,1)*pt_b2(1,1) + H_inv(3,2)*pt_b2(1,2) + 1); %y

B2_h_intermediate(3,1) = (H_inv(1,1)*pt_b3(1,1) + H_inv(1,2)*pt_b3(1,2) + H_inv(1,3))/(H_inv(3,1)*pt_b3(1,1) + H_inv(3,2)*pt_b3(1,2) + 1); %x
B2_h_intermediate(3,2) = (H_inv(2,1)*pt_b3(1,1) + H_inv(2,2)*pt_b3(1,2) + H_inv(2,3))/(H_inv(3,1)*pt_b3(1,1) + H_inv(3,2)*pt_b3(1,2) + 1); %y

B2_h_intermediate(4,1) = (H_inv(1,1)*pt_b4(1,1) + H_inv(1,2)*pt_b4(1,2) + H_inv(1,3))/(H_inv(3,1)*pt_b4(1,1) + H_inv(3,2)*pt_b4(1,2) + 1); %x
B2_h_intermediate(4,2) = (H_inv(2,1)*pt_b4(1,1) + H_inv(2,2)*pt_b4(1,2) + H_inv(2,3))/(H_inv(3,1)*pt_b4(1,1) + H_inv(3,2)*pt_b4(1,2) + 1); %y

x_min = min (B2_h_intermediate(:,1));
y_min = min (B2_h_intermediate(:,2));
x_max = max (B2_h_intermediate(:,1));
y_max = max (B2_h_intermediate(:,2));
B2_h = [x_min y_min; x_max y_max]; 


% calcul de I2_h et M2_h (I et masque de l'image 2)

W_h=floor(x_max+1-x_min);
H_h=floor(y_max+1-y_min);
I2_h = zeros(H_h,W_h,3); %
M2_h = zeros(H_h,W_h);


res=zeros(1,2);
for k=B2_h(1,1):B2_h(2,1)
    for kk=B2_h(1,2):B2_h(2,2)
        %res=h_reshaped*[k;kk;1];
        res(1)=(H(1,1)*k + H(1,2)*kk + H(1,3))/(H(3,1)*k+H(3,2)*kk+H(3,3));
        res(2)=(H(2,1)*k + H(2,2)*kk + H(2,3))/(H(3,1)*k+H(3,2)*kk+H(3,3));
        
        i = floor(k - B2_h(1,1)) +1;
        j = floor(kk -  B2_h(1,2)) +1;
        
        %disp(res)
        %if res(1)>=x_i(1) && res(1)<=x_i(2) && res(2)clc>=y_i(1) && res(2)<=y_i(3)
        if res(1)>0 && res(2)>0 && res(1)<w_2 && res(2)<h_2 
            %disp('bla')
            I2_h(j,i,:)=I2(floor(res(2))+1,floor(res(1))+1,:); %
            M2_h(j,i,:)=1;
        end
    end
end

% for k=1:w_2
%     for kk=1:h_2
%         %res=h_reshaped*[k;kk;1];
%         res(1)=(H(1,1)*k + H(1,2)*kk + H(1,3))/(H(3,1)*k+H(3,2)*kk+H(3,3));
%         res(2)=(H(2,1)*k + H(2,2)*kk + H(2,3))/(H(3,1)*k+H(3,2)*kk+H(3,3));
%         
%         %disp(res)
%         %if res(1)>=x_i(1) && res(1)<=x_i(2) && res(2)clc>=y_i(1) && res(2)<=y_i(3)
%         if res(1)>0 && res(2)>0 && res(1)<w_2 && res(2)<h_2 
%             M2_h(round(1+res(2)),round(1+res(1)),:)=M2(kk,k,:);
%         end
%     end
% end

figure, imshow(uint8(I2))
figure, imshow(uint8(I2_h))
figure, imshow(uint8(M2_h))



