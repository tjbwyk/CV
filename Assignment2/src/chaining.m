function [M,PVM] = chaining()
  tic;

  % Define data directory
  files = dir('../data/TeddyBear/*.png');

  % Number of files
  len = length(files);
  len = 3;

  M = zeros(len,1);
  PVM = cell(len,0);

  % Construct Point-View Matrix
  for ii=1:len
    ii
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

    for ii=1:length(P1)
      % find points in PV Matrix
      found = false;
      found_col = 0;

      for kk=1:size(PVM,2)
        if isequal(PVM{index_1,kk},P1(1:2,ii))
          found = true;
          found_col = kk;
          break;
        end
      end

      if found
        PVM{index_2,found_col} = P2(1:2,ii);
      else
        PVM{index_1,end + 1} = P1(1:2,ii);
        PVM{index_2,end} = P2(1:2,ii);
      end
        
    end

  end

  for ii=1:size(PVM,1)
    for jj=1:size(PVM,2)
      if isempty(PVM{ii,jj})
        M(ii,jj) = 1;
      else
        M(ii,jj) = 0;
      end
    end
  end

  runtime = toc;

end
