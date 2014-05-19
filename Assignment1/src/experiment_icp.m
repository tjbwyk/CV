function E = experiment_icp()

  % Define minimum treshold and number of maximum iterations
  TOL = 0.0001;
  TIME = 100;

  % Define data directory
  files = dir('../data/*.txt');

  % Initialize Source and Target Points
  file1 = files(1);
  file2 = files(2);

  Target = importdata(strcat('../data/', file1.name));
  Source = importdata(strcat('../data/', file2.name));

  selection = 'uniform';
  n_points = round(length(Source)/2);
  Tr = eye(4);

  [R, t, Tr, Source_h, Target_h, E] = ICP_experiment(Source, Target, TOL, TIME, Tr, selection, n_points);

  filename = strcat('../result/icp-experiment-', selection);
  save(filename, 'E');

end
