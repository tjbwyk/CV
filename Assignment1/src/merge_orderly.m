function [points_merged, runtime] = merge_orderly(interval, TOL, TIME)
    
    % Set start timestamp
    tic;

    for i = 0 : interval : 99
        i
        filename = sprintf('../data/%010d_filtered.txt', i);
        source = load(filename);
        if i == 0
            Tr_all = eye(4);
            target = source;
            points_merged = source;
        else
            % ICP function, transform the source point cloud to the target point cloud
            [R, t, Tr, source_homo, target_homo] = ICP(source, target, TOL, TIME);
            
            % Multiply up the homogeneous transformation matrix
            Tr_all = Tr * Tr_all;
            
            % Calculate the new position of the source point cloud
            source_homo_trans = Tr_all * source_homo;
            
            % Merge the two point clouds
            KDTree = KDTreeSearcher(points_merged);
            [IDX, D] = knnsearch(KDTree, source_homo_trans(1:3, :)');
            points_merged(IDX, :) = [];
            points_merged = [points_merged; source_homo_trans(1:3, :)'];
            
            target = source;
            
%             plot3(points_merged(:, 1), points_merged(:, 2), points_merged(:, 3), 'b.');
%             hold on;
%             plot3(source_homo_trans(1, :), source_homo_trans(2, :), source_homo_trans(3, :), 'r.');
%             grid on;
%             hold off;
%             pause(0.1);
        end
    end
    
    runtime = toc;
end