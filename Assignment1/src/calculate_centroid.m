function [centroid, A_shifted] = calculate_centroid(A)
  [rows cols] = size(A);

  centroid = mean(A, 2);
  A_mean = repmat(centroid, [1, cols]);

  A_shifted = A - A_mean;
end
