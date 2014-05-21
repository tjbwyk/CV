function main()

  files = dir('../data/*.txt');

  % Experiment 1 using all points selection technique
  n = 20;

  for ii=1:length(files)
    for jj=ii+1:length(files)
      file1 = files(ii);
      file2 = files(jj);

      [R,t,Distance] = icp(strcat('../data/', file1.name), strcat('../data/', file2.name), 20);

      filename = strcat('experiment-1-file1-', num2str(ii));
      filename = strcat(filename, '-file2-');
      filename = strcat(filename, num2str(jj));

      save(filename, 'R', 't', 'Distance');
    end
  end

end
