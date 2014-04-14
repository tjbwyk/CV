function [A1_centroid, A2_centroid] = icp(file_path_1, file_path_2)

  % Import data
  A1 = importdata(file_path_1);
  A2 = importdata(file_path_2);

  % Initialize R, and identity matrix I
  R = eye();

  % Initialize t = 0
  t = 0;

  % Initialize number of iterations
  n = 1;

  for ii=1:n
    % Find the closest point for each point in A1 to any point in A2 using KDTree
    NS = KDTreeSearcher(A2, 'distance', 'euclidean');
    [IDX, D] = knnsearch(NS, A1);

    % Get matched points from A1 and A2
    A1_match_point_indexes = [1:size(IDX)]';
    % A2_match_point_indexes = unique(IDX);
    A2_match_point_indexes = IDX;
    A1_match_points = A1(A1_match_point_indexes, :);
    A2_match_points = A1(A2_match_point_indexes, :);

    % Calculate centroid of matched points
    % and sifted to the origin of coordinate system
    A1_centroid = calculate_centroid(A1_match_points);
    A2_centroid = calculate_centroid(A2_match_points);

    % Apply SVD

  end

end
