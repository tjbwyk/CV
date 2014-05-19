function [centroid, A_shifted] = calculate_centroid(A)
  [rows cols] = size(A);

  centroid = mean(A, 1);
  A_mean = repmat(centroid, [rows, 1]);

  A_shifted = A - A_mean;
end
