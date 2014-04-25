function experiment2()
  % Define minimum treshold and number of maximum iterations
  TOL = 0.0001;
  TIME = 20;

  % Define data directory
  files = dir('../data/*.txt');

  % Number of files
  len = length(files);

  % Initialize Source Points
  file1 = files(1);
  Source = importdata(strcat('../data/', file1.name));

  % Initialize figure
  % figure;
  % hold on;
  % h1 = plot3(Source(:, 1), Source(:, 2), Source(:, 3), 'bo');
  % h2 = plot3(Source(:, 1), Source(:, 2), Source(:, 3), 'ro');

  for ii=2:len
    ii

    % Define Target points
    file2 = files(ii);
    Target = importdata(strcat('../data/', file2.name));

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
    Source_new = [Source_h_trans(1:3,:)';Target];

    % Plot result
    % delete(h1);
    % delete(h2);
    % h1 = plot3(Source_h_trans(1, :)', Source_h_trans(2,:)', Source_h_trans(3,:)', 'bo');
    % h2 = plot3(Target(:, 1), Target(:, 2), Target(:, 3), 'ro');
    % drawnow;

    % Update Source Point Clouds
    Source = Source_new;

    filename = strcat('experiment2-', num2str(ii));
    save(filename, 'Source', 'D');

  end

end
