function M = chaining()
  tic;

  % Define data directory
  files = dir('../data/TeddyBear/*.png');

  % Number of files
  len = length(files);
  % len = 3;

  M = zeros(len,1);
  Dict = zeros(len,1,2);
  new_index_column = zeros(len,1);
  m_index = 0;

  % Construct Point-View Matrix
  for ii=1:len
    index_1 = ii;

    if ii == len
      index_2 = 1;
    else
      index_2 = ii+1;
    end

    % Load image
    image_1_file = strcat('../data/TeddyBear/', files(index_1).name);
    image_2_file = strcat('../data/TeddyBear/', files(index_2).name);

    [F, P1, P2] = eight_point(image_1_file, image_2_file);

    for jj=1:length(P1)
      found = false;

      for kk=1:size(Dict,2)
        if Dict(index_1,kk,1) == P1(1,jj) && Dict(index_1,kk,2) == P1(2,jj)
          found = true;
        end
      end

      if found
      else
        new_index_column(index_1) = new_index_column(index_1) + 1;
        m_index = m_index + 1;

        Dict(index_1,new_index_column(index_1),1) = P1(1,jj);
        Dict(index_1,new_index_column(index_1),2) = P1(2,jj);

        M(index_1,m_index) = 1;
      end
    end

    for jj=1:length(P2)
      found = false;

      for kk=1:size(Dict,2)
        if Dict(index_2,kk,1) == P2(1,jj) && Dict(index_2,kk,2) == P2(2,jj)
          found = true;
        end
      end

      if found
      else
        new_index_column(index_2) = new_index_column(index_2) + 1;

        Dict(index_2,new_index_column(index_2),1) = P2(1,jj);
        Dict(index_2,new_index_column(index_2),2) = P2(2,jj);

        M(index_2,m_index) = 1;
      end
    end

  end

  runtime = toc;

end
