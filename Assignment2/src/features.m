function [I, mask, f, d] = features(filename)
    I = imread(filename);
    
    if size(I, 3) == 3
        I = single(rgb2gray(I));
    else
        I = single(I);
    end
    
    mask = objDetect(I);
    
    [f, d] = vl_sift(I);
    
    [f, d] = eliminate(f, d, mask);
end