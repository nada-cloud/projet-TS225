function [I2, M2, B2] = apply_homography(I1, M1, B1, H)
    I1 = double(I1);
    [h,w,c] = size(I1);
    x_min = B1(1,1);
    y_min = B1(1,2);
    x_max = B1(2,1);
    y_max = B1(2,2);
    height = round(y_max - y_min) + 1;
    width = round(x_max - x_min) + 1;
    I2 = zeros(height, width, c);
    M2 = zeros(height, width, c);
    for i=1:h
        for j=1:w
            k = (H(1,1)*i + H(1,2)*j + H(1,3))/(H(3,1)*i + H(3,2)*j + 1);
            l = (H(2,1)*i + H(2,2)*j + H(2,3))/(H(3,1)*i + H(3,2)*j + 1);
            if l-y_min <= w && k-x_min <= h && l-y_min > 0 && k-x_min > 0 && M1(i, j) == 1       
                    I2(1 + round(l-y_min), 1 + round(k-x_min), :) = I1(i,j,:); 
                    M2(1 + round(l-y_min), 1 + round(k-x_min), :) = 1; 
            end
        end
    end
    B2 = B1;
end

