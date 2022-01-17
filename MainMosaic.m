clear all
close all
clc

I1 = imread('tableau.jpg');
figure, imshow(I1)

[x1, y1] = ginput(4);
P2 = [x1(1) y1(1); x1(2) y1(2); x1(3) y1(3); x1(4) y1(4)];

[x2, y2] = ginput(4);
P3 = [x2(1) y2(1); x2(2) y2(2); x2(3) y2(3); x2(4) y2(4)];

[h1,w1,c1] = size(I1);

P1 = [1 1; h1 1; h1 w1; 1 w1];
%% homography
H1 = estimate_homography_matrix(P1,P2)
H2 = estimate_homography_matrix(P1,P3)
%% Application
[I, M, B] = get_triplet(I1, P2);
[I2, M2, B2] = apply_homography(I, M, B, H1);
[h2, w2, c] = size(I2);
img1 = zeros(h2, w2, 3);
Homo_1 = 1\H1;
for i=1:h1
    for j=1:w1
        k = (Homo_1(1,1)*i + Homo_1(1,2)*j + Homo_1(1,3))/(Homo_1(3,1)*i + Homo_1(3,2)*j + 1);
        l = (Homo_1(2,1)*i + Homo_1(2,2)*j + Homo_1(2,3))/(Homo_1(3,1)*i + Homo_1(3,2)*j + 1);
        img1(i,j,:) = I1(1 + round(l), 1 + round(k), :);
    end
end


[II, MM, BB] = get_triplet(I1, P3);
[II2, MM2, BB2] = apply_homography(II, MM, BB, H2);
[hh2, ww2, c] = size(I2);
img2 = zeros(hh2, ww2, 3);
Homo_2 = 1\H2;
for i=1:h1
    for j=1:w1
        k = (Homo_2(1,1)*i + Homo_2(1,2)*j + Homo_2(1,3))/(Homo_2(3,1)*i + Homo_2(3,2)*j + 1);
        l = (Homo_2(2,1)*i + Homo_2(2,2)*j + Homo_2(2,3))/(Homo_2(3,1)*i + Homo_2(3,2)*j + 1);
        img2(i,j,:) = I1(1 + round(l), 1 + round(k), :);
    end
end

figure,
subplot(1,2,1)
imshow(uint8(img1))

subplot(1,2,2)
imshow(uint8(img2))


[x4, y4] = ginput(4);
P4 = [x4(1) y4(1); x4(2) y4(2); x4(3) y4(3); x4(4) y4(4)];

[x5, y5] = ginput(4);
P5 = [x5(1) y5(1); x5(2) y5(2); x5(3) y5(3); x5(4) y5(4)];

%% Estimation homographie
H3 = estimate_homography_matrix(P1,P4)
H4 = estimate_homography_matrix(P1,P5)

%% Application
[I4, M4, B4] = get_triplet(img2, P4);
[I5, M5, B5] = apply_homography(I4, M4, B4, H3);


[I6, M6, B6] = get_triplet(img1, P5);
[I7, M7, B7] = apply_homography(I6, M6, B6, H4);

figure, 
subplot(1,2,1)
imshow(uint8(I7))

subplot(1,2,2)
imshow(uint8(I5))




