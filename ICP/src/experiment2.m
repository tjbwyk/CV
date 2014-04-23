function experiment2()
  TOL = 0.0001;
  TIME = 20;

  files = dir('../data/*.txt');
  file1 = files(1);

  S = importdata(strcat('../data/', file1.name));

  for ii=2:length(files)
    file2 = files(ii);
    T = importdata(file2);

    [R, t] = ICP(S, T, TOL, TIME);

    S_new = S * R + t;
    S_new = [S_new;T];
    S = S_new;
  end

end
