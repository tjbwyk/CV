function [points_merged] = merge_orderly(interval)
    
    for i = 0 : interval : 99
        i
        filename = sprintf('../data/%010d_filtered.txt', i);
        source = load(filename);
        if i == 0
            Tr_all = eye(4);
            target = source;
            points_merged = source;
        else
            [R, t, Tr, source_homo, target_homo] = ICP(source, target, 0.01, 20);
            Tr_all = Tr * Tr_all;
            source_homo_trans = Tr_all * source_homo;
            
            KDTree = KDTreeSearcher(points_merged);
            [IDX, D] = knnsearch(KDTree, source_homo_trans(1:3, :)');
            points_merged(IDX, :) = [];
            points_merged = [points_merged; source_homo_trans(1:3, :)'];
            
            target = source;
        end
        plot3(points_merged(:, 1), points_merged(:, 2), points_merged(:, 3), '.');
        pause(0.1);
    end
end