function centroid = calculate_centroid(A)
  [rows cols] = size(A);

  A_mean = mean(A, 1);
  A_mean = repmat(A_mean, [rows, 1]);

  centroid = A - A_mean;
end
