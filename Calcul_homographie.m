clear all
close all
clc

img_depart = imread('lena.bmp');
img_arrivee = imread('Cap.PNG');

[h1,w1,c1] = size(img_depart);
P_input = [1 1; h1 1; h1 w1; 1 w1];
%P_input = [1 1; w1 1;1 h1; w1 h1];
figure, imshow(img_arrivee)

x_len = 4;
[x2, y2] = ginput(4);
P_output = [x2(1) y2(1); x2(2) y2(2); x2(3) y2(3); x2(4) y2(4)];
k = 1;
for i=1:4
    A(2*i-1,:) = [P_input(i,1), P_input(i, 2), 1, 0, 0, 0, -P_input(i, 1)*P_output(i, 1), -P_output(i,1)*P_input(i,2)];
    A(2*i,:) = [0, 0, 0, P_input(i, 1), P_input(i, 2), 1, -P_input(i, 1)*P_output(i, 2), -P_output(i, 2)*P_input(i,2)];
    B(k) = P_output(i, 1);
    B(k+1) = P_output(i, 2);
    k = k + 2;
end
B = B';
H = (A'*A)\A'*B;
H(2*x_len + 1) = 1; 
H = (reshape(H, x_len - 1, x_len - 1))';

[h2,w2,c2] = size(img_depart);
res = zeros(h2, w2, c2);

img_depart = im2double(img_depart);
img_arrivee = im2double(img_arrivee);
for hh=1:w2
    for ww=1:h2
        s = H*[ww; hh; 1];
        s = s/s(3);
        if (s(1) > 0 && s(2) > 0 && s(3) > 0)
            img_arrivee(round(1 + s(2)),round(1 + s(1)),:) = img_depart(ww, hh,:);
        end
    end
end
figure, imshow(img_arrivee)
