function [best_F, inliers_idx] = runsac(P1, P2, matches, time, threshold)
    len = size(matches, 2);
    best_inliers_num = 0;
    for i = 1 : time
        
        % Pick out 8 pares of points randomly
        sel_idx = randperm(len);
        sel_idx = sel_idx(1:8);

        % Construct A matrix
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
        
        % apply SVD
        [U, D, V] = svd(A);
        
        % Calculate fundamental matrix
        f = reshape(V(:, end), 3, 3);
        [Uf, Df, Vf] = svd(f);
        F = Uf * diag([Df(1, 1), Df(2, 2), 0]) * Vf';
        
        % Count the inliers
        [inliers_num, inliers_idx] = find_inliers(P1, P2, matches, F, threshold);
        
        % Compare the count of inliers with the best record
        if inliers_num > best_inliers_num
            best_inliers_num = inliers_num;
            best_inliers_idx = inliers_idx;
        end
    end
    
    % Re-calculate the result based on the inliers.
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