function [R, t] = icp(file_path_1, file_path_2)

  % Import data
  A1 = importdata(file_path_1);
  A2 = importdata(file_path_2);

  % Initialize R, and identity matrix I
  R = eye(3, 3);

  % Initialize t = 0
  t = 0;

  % Initialize number of iterations
  n = 50;

  for ii=1:n
    % Find the closest point for each point in A1 to any point in A2 using KDTree
    NS = KDTreeSearcher(A2, 'distance', 'euclidean');
    [IDX, D] = knnsearch(NS, A1);

    % Get matched points from A1 and A2
    A1_match_point_indexes = [1:size(IDX)]';
    % A2_match_point_indexes = unique(IDX);
    A2_match_point_indexes = IDX;

    A1_match_points = A1(A1_match_point_indexes, :);
    A2_match_points = A2(A2_match_point_indexes, :);

    % Calculate centroid of matched points
    % and sifted to the origin of coordinate system
    [A1_centroid, A1_shifted] = calculate_centroid(A1_match_points);
    [A2_centroid, A2_shifted] = calculate_centroid(A2_match_points);

    % Merge 2 point clouds
    % Matrix multiplication operation
    A = A1_shifted' * A2_shifted;

    % Apply SVD
    [U, S, V] = svd(A);

    % Calculate rotation matrix
    R = U * V';

    % Calculate translation matrix
    t = (A1_centroid - A2_centroid) * R;

    % Calculate new average distance target point clouds
    TPC = (R * A2')' + repmat(t, [size(A2, 1), 1]);
    TPC_match_points = TPC(A2_match_point_indexes, :);

    % find the average of  euclidan distance of the matched point pairs
    sum_distance = 0;
    for ii=1:size(A1_shifted, 1)
      sum_distance = sum_distance + norm(A1(ii,:) - TPC_match_points(ii,:));
    end
    average_distance = sum_distance / size(A1, 1);

    disp(average_distance);

    % plot3(A1(:,1), A1(:,2), A1(:,3),'ro');
    % plot3(TPC(:,1), TPC(:,2), TPC(:,3),'bo');

    A2 = TPC;
  end

end
