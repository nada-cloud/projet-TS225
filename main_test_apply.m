clear all
close all
clc

I1 = imread('arbre.jpg');
figure, imshow(I1)

[x1, y1] = ginput(4);
P2 = [x1(1) y1(1); x1(2) y1(2); x1(3) y1(3); x1(4) y1(4)];

I_prime = imread('lena.bmp');
[h1,w1,c1] = size(I1);
P1 = [1 1; h1 1; h1 w1; 1 w1];
% 
% I1 = imread('bouygues.jpg');
% figure, imshow(I1)
% 
%H2 = [0.1814 0.7402 34.3412; 1.0209 0.1534 60.3258; 0.0005 0 1.0000];
H2 = estimate_homography_matrix(P1,P2);
[I, M, B] = get_triplet(I1);
[I2, M2, B2] = apply_homography(I, M, B, H2);
h_test = round(B2(2, 2) - B2(1, 2)) + 1;
w_test = round(B2(2, 1) - B2(1, 1)) + 1;
img = zeros(h_test, w_test, 3);
H = 1\H2;

% new_h = P2(3, 1) - P2(1, 1) + 1;
% new_w = P2(3, 2) - P2(1, 2) + 1;
for i=1:h1
    for j=1:w1
        k = (H(1,1)*i + H(1,2)*j + H(1,3))/(H(3,1)*i + H(3,2)*j + 1);
        l = (H(2,1)*i + H(2,2)*j + H(2,3))/(H(3,1)*i + H(3,2)*j + 1);
        img(i,j,:) = I1(1 + round(l), 1 + round(k), :);
    end
end
img2 = bilinearInterpolation(img, [h_test w_test]);
%  figure, imshow(uint8(I2))
%  figure, imshow(M2)
figure, imshow(uint8(img))
figure, imshow(uint8(img2))
