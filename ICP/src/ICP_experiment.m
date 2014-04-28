function [R, t, Tr, S_homo, T_homo, E] = ICP_experiment(S, T, TOL, TIME, Tr, selection, n_points)

    % Tranform to homogeneous coordinates
    S_homo = [S, ones(length(S), 1)]';
    T_homo = [T, ones(length(T), 1)]';

    % Initialize R, and identity matrix I
    R = eye(3, 3);

    % Initialize t = 0
    t = zeros(1, 3);
    
    % Initialize transformation matrix Tr under homogeneous coordinates
    if nargin == 4
        Tr = eye(4);
    end
    
    % Build KDTree sourced on target cloud
    KDTree = KDTreeSearcher(T, 'distance', 'euclidean');
    
    % Initialize error
    e_last = 0;
    e = 1e10;
    E = zeros(1, TIME);

    for i = 1 : TIME
        
        % Update the source cloud
        S_homo_trans = Tr * S_homo;
        
        % plot3(T(:, 1), T(:, 2), T(:, 3), 'b.');
        % hold on;
        % plot3(S_homo_trans(1, :), S_homo_trans(2, :), S_homo_trans(3, :), 'r.');
        % grid on;
        % hold off;
        % pause(0.01);
        
        % point selection techniques
        if strcmp(selection, 'uniform')
          selected_points = randi(length(S_homo_trans(1:3, :)), 1, n_points);
          S_selected_points = S_homo_trans(:, selected_points);
        else
          S_selected_points = S_homo_trans;
        end

        % Find the closest point for each point in tranformed S to any point in T using KDTree
        % [IDX, D] = knnsearch(KDTree, S_homo_trans(1:3, :)');
        [IDX, D] = knnsearch(KDTree, S_selected_points(1:3, :)');

        % Get matched points from S and T
        S_match_point_indexes = [1:size(IDX)]';
        T_match_point_indexes = IDX;

        % S_homo_match_points = S_homo_trans(:, S_match_point_indexes);
        S_homo_match_points = S_selected_points(:, S_match_point_indexes);
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
        e = mean(abs(D));
        [i e]
        
        E(i) = e;
        
        % Stop iteration if the change of average distance is small enough
        % if abs(e - e_last) / max(e_last, e) < TOL
        %     break;
        % end
    end
    
    R = Tr(1:3, 1:3);
    t = Tr(1:3, 4);
end
