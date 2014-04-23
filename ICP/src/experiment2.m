function experiment2()
  TOL = 0.0001;
  TIME = 20;

  files = dir('../data/*.txt');
  file1 = files(1);

  S = importdata(strcat('../data/', file1.name));
  len = 5;

  for ii=2:len
    file2 = files(ii);
    T = importdata(strcat('../data/', file2.name));

    [R, t] = ICP(S, T, TOL, TIME);

    S_new = S * R + repmat(t',length(S),1);
    S_new = [S_new;T];
    S = S_new;

    size(S)
  end

end
