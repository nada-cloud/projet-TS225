function [I, M, B] = get_triplet(Image)
    I = double(Image);
    [h,w,c] = size(I);
    M = ones(h,w);
    B = [1 1; h w];
end

