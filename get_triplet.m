function [I, M, B] = get_triplet(Image, P)
    I = double(Image);
    [h,w,c] = size(I);
    M = ones(h,w);
    x1 = P(:, 1);
    y1 = P(:, 2);
    B = [min(x1) min(y1); max(x1) max(y1)]; %Boîte englobante
end

