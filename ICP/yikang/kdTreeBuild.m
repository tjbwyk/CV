function kdTree = kdTreeBuild(baseData)
    index = [1 : length(baseData)]';
    baseData = [baseData, index];
    kdTree = kdTreeNode.empty(length(baseData), 0);
    
    kdTreeConstruct(1, length(baseData), 0);
    
    function [num, child] = kdTreeConstruct(a, b, num)
        [a b]
        if a > b
            child = -1;
            return;
        end
        
        num = num + 1;
        now = num;
        
        Vmax = -1;
        for d = 1 : 3
            v = var(baseData(a : b, d));
            if v > Vmax
                Vmax = v;
                dim = d;
            end
        end
        
        baseData(a : b, :) = sortrows(baseData(a : b, :), dim);
        
        mid = floor((a + b) / 2);
        
        kdTree(now).data = baseData(mid, :);
        kdTree(now).split = mid;
        [num, kdTree(now).left] = kdTreeConstruct(a, mid - 1, num);
        [num, kdTree(now).right] = kdTreeConstruct(mid + 1, b, num);
        
        child = now;
    end
    
end