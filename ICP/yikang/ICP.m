function [R, t] = ICP(points_base, points_target, TOL)

    points_base_homo = [points_base, ones(length(points_base), 1)]';
    points_target_homo = [points_target, ones(length(points_target), 1)]';

    R = eye(3);
    t = zeros(1, 3);
    T = eye(4);
    
    e_last = 0;
    e = 1e10;
    
    while abs(e - e_last) / max(e_last, e) > TOL
    
        points_base_homo_trans = T * points_base_homo;
        
        KDTree = KDTreeSearcher(points_target);
        
        [idx, d] = knnsearch(KDTree, points_base_homo_trans(1:3, :)');
        
        points_base_homo_match = points_base_homo_trans;
        points_target_homo_match = points_target_homo(:, idx);
        
        points_base_centroid = mean(points_base_homo_match, 2);
        points_target_centroid = mean(points_target_homo_match, 2);
        
        W = zeros(3);
        for i = 1 : length(idx)
            W = W + (points_target_homo_match(1:3, i) - points_target_centroid(1:3)) * (points_base_homo_match(1:3, i) - points_base_centroid(1:3))';
        end
        
        [U, S, V] = svd(W);
        
        R = U * V';
        t = points_target_centroid(1:3) - R * points_base_centroid(1:3);
        T(1:3, :) = [R, t]
        
        e_last = e;
        e = mean(abs(d));
    end
end