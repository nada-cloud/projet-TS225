function [I2, M2, B2] = apply_homography(I1, M1, B1, H)
    I1 = double(I1);
    [h,w,c] = size(I1);
    I2 = zeros(h, w, c);
    M2 = zeros(h, w);
    for j=1:w  
        for i=1:h
            k = (H(1,1)*i + H(1,2)*j + H(1,3))/(H(3,1)*i + H(3,2)*j + 1);
            l = (H(2,1)*i + H(2,2)*j + H(2,3))/(H(3,1)*i + H(3,2)*j + 1);
            if k < h && k > 0 && l < w && l > 0 && M1(i, j) == 1
               I2(1 + round(l), 1 + round(k), :) = I1(i,j,:);
               M2(1 + round(l), 1 + round(k)) = 1;
            end
        end
    end
    %B2 = B1;
    [a, b] = size(B1);
    B2 = zeros(a, b);
    for n=1:b
        B2(n, 1) = (H(1,1)*B1(n, 1) + H(1,2)*B1(n, 2) + H(1,3))/(H(3,1)*B1(n, 1) + H(3,2)*B1(n, 2) + 1);
        B2(n, 2) = (H(2,1)*B1(n, 1) + H(2,2)*B1(n, 2) + H(2,3))/(H(3,1)*B1(n, 1) + H(3,2)*B1(n, 2) + 1);
    end

end

