function [mask, x1, y1, x2, y2] = objDetect(I)

    % Detect Entire Cell
    [~, threshold] = edge(I, 'sobel');
    BWs = edge(I, 'sobel', threshold * 0.8);
    
    % Dilate the Image
    se90 = strel('line', 3, 90);
    se0 = strel('line', 3, 0);
    BWsdil = imdilate(BWs, [se90 se0]);
    
    % Fill Interior Gaps
    BWdfill = imfill(BWsdil, 'holes');
    
    % Remove Connected Objects on Border
    BWnobord = imclearborder(BWdfill, 4);
    
    % Smoothen the Object
    seD = strel('diamond',1);
    BWfinal = imerode(BWnobord,seD);
    BWfinal = imerode(BWfinal,seD);
    BWfinal = imerode(BWfinal,seD);
    
    % Get the Rectangle Boundary
    
    s = size(I);
    x1 = s(1); y1 = s(2);
    x2 = 0; y2 = 0;
    for x = 1 : s(1)
        for y = 1 : s(2)
            if BWfinal(x, y) == 1
                x1 = min(x1, x);
                y1 = min(y1, y);
                x2 = max(x2, x);
                y2 = max(y2, y);
            end
        end
    end
    
    mask = BWfinal;
end