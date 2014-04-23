function [R, t] = ICP(S, T, TOL, TIME)

    % Tranform to homogeneous coordinates
    S_homo = [S, ones(length(S), 1)]';
    T_homo = [T, ones(length(T), 1)]';

    % Initialize R, and identity matrix I
    R = eye(3, 3);

    % Initialize t = 0
    t = zeros(1, 3);
    
    % Initialize transformation matrix Tr under homogeneous coordinates
    Tr = eye(4);
    
    % Build KDTree sourced on target cloud
    KDTree = KDTreeSearcher(T, 'distance', 'euclidean');
    
    % Initialize error
    e_last = 0;
    e = 1e10;

    for i = 1 : TIME
        
        % Update the source cloud
        S_homo_trans = Tr * S_homo;
        
        % Find the closest point for each point in tranformed S to any point in T using KDTree
        [IDX, D] = knnsearch(KDTree, S_homo_trans(1:3, :)');

        % Get matched points from S and T
        S_match_point_indexes = [1:size(IDX)]';
        T_match_point_indexes = IDX;

        S_homo_match_points = S_homo_trans(:, S_match_point_indexes);
        T_homo_match_points = T_homo(:, T_match_point_indexes);

        % Calculate centroid of matched points
        % and sifted to the origin of coordinate system
        [S_homo_centroid, S_homo_shifted] = calculate_centroid(S_homo_match_points);
        [T_homo_centroid, T_homo_shifted] = calculate_centroid(T_homo_match_points);

        % Merge 2 point clouds
        % Matrix multiplication operation
        W = T_homo_shifted(1:3, :) * S_homo_shifted(1:3, :)';

        % Apply SVD
        [U, S, V] = svd(W);

        % Calculate rotation matrix (transformed source to target)
        R = U * V';

        % Calculate translation matrix (transformed source to target)
        t = T_homo_centroid(1:3) - R * S_homo_centroid(1:3);
        
        % Calculate the overall homogeneous transformation matrix
        Tr = [R, t; 0, 0, 0, 1] * Tr;

        % Calculate new average distance target point clouds
        e_last = e;
        e = mean(abs(D))
        
        % Stop iteration if the change of average distance is small enough
        if abs(e - e_last) / max(e_last, e) < TOL
            break;
        end
    end
    
    R = Tr(1:3, 1:3);
    t = Tr(1:3, 4);
end
