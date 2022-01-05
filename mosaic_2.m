clear all
close all
clc

h1 = 250;
w1 = 400;
I1 = imread('annecy.jpg');
figure, imshow(I1)

[x1, y1] = ginput(4);
P1 = [x1(1) y1(1); x1(2) y1(2); x1(3) y1(3); x1(4) y1(4)];

[x2, y2] = ginput(4);
P2 = [x2(1) y2(1); x2(2) y2(2); x2(3) y2(3); x2(4) y2(4)];

P3 = [1 1; h1 1; h1 w1; 1 w1];


H1 = estimate_homography_matrix(P3,P1);
[I, M, B] = get_triplet(I1);
[I2, M2, B2] = apply_homography(I, M, B, H1);

img1 = zeros(h1, w1, 3);
Homo_1 = 1\H1;
for i=1:h1
    for j=1:w1
        k = (Homo_1(1,1)*i + Homo_1(1,2)*j + Homo_1(1,3))/(Homo_1(3,1)*i + Homo_1(3,2)*j + 1);
        l = (Homo_1(2,1)*i + Homo_1(2,2)*j + Homo_1(2,3))/(Homo_1(3,1)*i + Homo_1(3,2)*j + 1);
        img1(i,j,:) = I1(1 + round(l), 1 + round(k), :);
    end
end

H2 = estimate_homography_matrix(P3,P2);
[II, MM, BB] = get_triplet(I1);
[I3, M3, B3] = apply_homography(II, MM, BB, H2);

img2 = zeros(h1, w1, 3);
Homo_2 = 1\H2;
for i=1:h1
    for j=1:w1
        k = (Homo_2(1,1)*i + Homo_2(1,2)*j + Homo_2(1,3))/(Homo_2(3,1)*i + Homo_2(3,2)*j + 1);
        l = (Homo_2(2,1)*i + Homo_2(2,2)*j + Homo_2(2,3))/(Homo_2(3,1)*i + Homo_2(3,2)*j + 1);
        img2(i,j,:) = I1(1 + round(l), 1 + round(k), :);
    end
end

figure, imshow(uint8(img1))
[x11, y11] = ginput(4);
P_img1 = [x11(1) y11(1); x11(2) y11(2); x11(3) y11(3); x11(4) y11(4)];

figure, imshow(uint8(img2))
[x22, y22] = ginput(4);
P_img2 = [x22(1) y22(1); x22(2) y22(2); x22(3) y22(3); x22(4) y22(4)];

H3 = estimate_homography_matrix(P_img1,P_img2);
% [Img, M, B] = get_triplet(img2);
% [img21, M4, B4] = apply_homography(Img, M, B, H3);
hm = h1;
wm = 2*w1;
I4 = zeros(hm, wm, 3);
for i=1:hm
    for j=1:wm  
        k = (H3(1,1)*i + H3(1,2)*j + H3(1,3))/(H3(3,1)*i + H3(3,2)*j + 1);
        l = (H3(2,1)*i + H3(2,2)*j + H3(2,3))/(H3(3,1)*i + H3(3,2)*j + 1);
        if k < hm && k > 0 && l < wm && l > 0 
            if j <= w1
               I4(1 + round(l), 1 + round(k), :) = img1(i,j,:);
            else
                
                I4(1 + round(l), 1 + round(k), :) = img2(i,j-w1,:);
            end       
        end
    end
end
%figure, imshow(uint8(H3))
figure, imshow(uint8(I4))
