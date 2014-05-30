function [merged_points, runtime] = experiment2()

  tic;

  % Define minimum treshold and number of maximum iterations
  TOL = 0.0001;
  TIME = 1e10;

  % Define data directory
  files = dir('../data/*.txt');

  % Number of files
  len = length(files);

  % Initialize Source Points
  file1 = files(1);
  Target = load(strcat('../data/', file1.name));

  % Initialize figure
  %figure;
  %hold on;
  %h1 = plot3(Target(:, 1), Target(:, 2), Target(:, 3), 'b.');
  %h2 = plot3(Target(:, 1), Target(:, 2), Target(:, 3), 'r.');

  Tr = eye(4);
  
  for ii=2:len
    ii

    % Define Target points
    file2 = files(ii);
    Source = importdata(strcat('../data/', file2.name));

    % Apply ICP
    [R, t, Tr, Source_h, Target_h] = ICP(Source, Target, TOL, TIME);

    % Transform Source Points
    Source_h_trans = Tr * Source_h;

    % Find matched point between Source and Target
    KDTree = KDTreeSearcher(Target, 'distance', 'euclidean');
    [IDX, D] = knnsearch(KDTree, Source_h_trans(1:3,:)');

    % Remove matched points from Target
    Target(unique(IDX), :) = [];

    % Merge points Source and Target
    Target_new = [Target; Source_h_trans(1:3,:)'];

    % Plot result
    %delete(h1);
    %delete(h2);
    %h2 = plot3(Target(:, 1), Target(:, 2), Target(:, 3), 'b.');
    %h1 = plot3(Source_h_trans(1, :)', Source_h_trans(2,:)', Source_h_trans(3,:)', 'r.');
    %drawnow;

    % Update Source Point Clouds
    Target = Target_new;

    %filename = strcat('../result/experiment-2/experiment2-', num2str(ii));
    %save(filename, 'Target', 'D');

  end

  merged_points = Target;
  %exportMeshlab(merged_points, '../result/experiment-2/merged_points.ply')
  
  runtime = toc;
end