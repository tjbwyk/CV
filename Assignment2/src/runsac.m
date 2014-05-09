function [best_F] = runsac(P1, P2, matches, time, threshold)
    len = size(matches, 2);
    best_inliers_num = 0;
    for i = 1 : time
        sel_idx = randperm(len);
        sel_idx = sel_idx(1:8);
        sel_idx_P1 = matches(1, sel_idx);
        sel_idx_P2 = matches(2, sel_idx);
        A = [
                P1(1, sel_idx_P1) .* P2(1, sel_idx_P2);
                P1(1, sel_idx_P1) .* P2(2, sel_idx_P2);
                P1(1, sel_idx_P1);
                P1(2, sel_idx_P1) .* P2(1, sel_idx_P2);
                P1(2, sel_idx_P1) .* P2(2, sel_idx_P2);
                P1(2, sel_idx_P1);
                P2(1, sel_idx_P2);
                P2(2, sel_idx_P2);
                ones(1, 8)
            ];
        
        [U, D, V] = svd(A);
        
        f = reshape(V(:, end), 3, 3);
        [Uf, Df, Vf] = svd(f);
        F = Uf * diag([Df(1, 1), Df(2, 2), 0]) * Vf';
        FP1 = F * P1;
        FP2 = F' * P2;
        d = ((P2' * F * P1) .^ 2) ./ (FP1(1, :) .^ 2 + FP1(2, :) .^ 2 ...
            + FP2(1, :) .^ 2 + FP2(2, :) .^ 2);
        
        inliers_idx = zeros(len, 0);
        inliers_num = 0;
        for j = 1 : len
            if d(j) < threshold
                inliers_num = inliers_num + 1;
                inliers_idx(inliers_num) = j;
            end
        end
        if inliers_num > best_inliers_num
            best_inliers_num = inliers_num;
            best_inliers_idx = inliers_idx;
            best_F = F;
        end
    end
    
    sel_idx_P1 = matches(1, best_inliers_idx);
    sel_idx_P2 = matches(2, best_inliers_idx);
    A = [
            P1(1, sel_idx_P1) .* P2(1, sel_idx_P2);
            P1(1, sel_idx_P1) .* P2(2, sel_idx_P2);
            P1(1, sel_idx_P1);
            P1(2, sel_idx_P1) .* P2(1, sel_idx_P2);
            P1(2, sel_idx_P1) .* P2(2, sel_idx_P2);
            P1(2, sel_idx_P1);
            P2(1, sel_idx_P2);
            P2(2, sel_idx_P2);
            ones(1, 8)
        ];

    [U, D, V] = svd(A);

    f = reshape(V(:, end), 3, 3);
    [Uf, Df, Vf] = svd(f);
    best_F = Uf * diag([Df(1, 1), Df(2, 2), 0]) * Vf';
end