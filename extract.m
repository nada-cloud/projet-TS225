function [img] = extract(Image,H,h,w)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% p1 = points(:,1);
% p2 = points(:,2);
% p3 = points(:,3);
% p4 = points(:,4);


img = zeros(floor(w), floor(h), 3);
H_inv = 1\H;
for i=1:h
    for j=1:w
        k = (H_inv(1,1)*i + H_inv(1,2)*j + H_inv(1,3))/(H_inv(3,1)*i + H_inv(3,2)*j + 1);
        l = (H_inv(2,1)*i + H_inv(2,2)*j + H_inv(2,3))/(H_inv(3,1)*i + H_inv(3,2)*j + 1);
        img(j,i,:) = Image(round(l)+1, round(k)+1, :);
    end
end

end

