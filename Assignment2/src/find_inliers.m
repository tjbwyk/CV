% Calculate inliers

function [inliers_num, inliers_idx] = find_inliers(P1, P2, matches, F, threshold)
    len = size(matches, 2);
    
    % Calculate the Sampson distance
    FP1 = F * P1;
    FP2 = F' * P2;
    d = (sum((P2' * F)' .* P1, 1) .^ 2) ./ (FP1(1, :) .^ 2 + FP1(2, :) .^ 2 ...
        + FP2(1, :) .^ 2 + FP2(2, :) .^ 2);

    % find outliers based on the Sampson distance
    inliers_idx = zeros(len, 1);
    inliers_num = 0;
    for j = 1 : len
        if d(j) < threshold
            inliers_num = inliers_num + 1;
            inliers_idx(inliers_num) = j;
        end
    end
    
    inliers_idx(inliers_idx == 0) = [];
end