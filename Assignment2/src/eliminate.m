function [f, d] = eliminate(f, d, mask)
    l = length(f);
    s = size(mask);
    u = zeros(l, 1);
    
    n = 0;
    for i = 1 : l
        y = max(1, min(round(f(1, i)), s(1)));
        x = max(1, min(round(f(2, i)), s(2)));
        
        if mask(x,y) == 0
            n = n + 1;
            u(n) = i;
        end
    end
    
    f(:, u(1:n)) = [];
    d(:, u(1:n)) = [];
end