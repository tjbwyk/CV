function [best_F, inliers_idx] = runsac(P1, P2, matches, time, threshold)
    len = size(matches, 2);
    best_inliers_num = 0;
    for i = 1 : time
        sel_idx = randperm(len);
        sel_idx = sel_idx(1:8);

        A = [
                P1(1, sel_idx) .* P2(1, sel_idx);
                P1(1, sel_idx) .* P2(2, sel_idx);
                P1(1, sel_idx);
                P1(2, sel_idx) .* P2(1, sel_idx);
                P1(2, sel_idx) .* P2(2, sel_idx);
                P1(2, sel_idx);
                P2(1, sel_idx);
                P2(2, sel_idx);
                ones(1, 8)
            ]';
        
        [U, D, V] = svd(A);
        
        f = reshape(V(:, end), 3, 3);
        [Uf, Df, Vf] = svd(f);
        F = Uf * diag([Df(1, 1), Df(2, 2), 0]) * Vf';
        
        [inliers_num, inliers_idx] = find_inliers(P1, P2, matches, F, threshold);
        
        if inliers_num > best_inliers_num
            best_inliers_num = inliers_num;
            best_inliers_idx = inliers_idx;
        end
    end
    
    best_inliers_idx(best_inliers_num + 1:end) = [];
    A = [
            P1(1, best_inliers_idx) .* P2(1, best_inliers_idx);
            P1(1, best_inliers_idx) .* P2(2, best_inliers_idx);
            P1(1, best_inliers_idx);
            P1(2, best_inliers_idx) .* P2(1, best_inliers_idx);
            P1(2, best_inliers_idx) .* P2(2, best_inliers_idx);
            P1(2, best_inliers_idx);
            P2(1, best_inliers_idx);
            P2(2, best_inliers_idx);
            ones(1, best_inliers_num)
        ]';

    [U, D, V] = svd(A);

    f = reshape(V(:, end), 3, 3);
    [Uf, Df, Vf] = svd(f);
    best_F = Uf * diag([Df(1, 1), Df(2, 2), 0]) * Vf';
    [~, inliers_idx] = find_inliers(P1, P2, matches, best_F, threshold);
end