function [H] = estimate_homography_matrix(P1,P2)
%P2 matrice des points sélectionnés
%P1 matrice des points extrémités
    [m, n] = size(P1);
    A = zeros(2*m);
    B = zeros(1, m);
    k = 1;
    for i=1:m
        A(2*i-1,:) = [P1(i,1), P1(i, 2), 1, 0, 0, 0, -P1(i, 1)*P2(i, 1), -P2(i,1)*P1(i,2)];
        A(2*i,:) = [0, 0, 0, P1(i, 1), P1(i, 2), 1, -P1(i, 1)*P2(i, 2), -P2(i, 2)*P1(i,2)];
        B(k) = P2(i, 1);
        B(k+1) = P2(i, n);
        k = k + 2;
    end
    B = B';
    H = (A'*A)\A'*B;
    H(2*m + 1) = 1; 
    H = (reshape(H, m - 1, m - 1))';
end

