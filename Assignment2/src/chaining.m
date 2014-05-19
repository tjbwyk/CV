function [M,PVM] = chaining(foldername)
  tic;

  % Define data directory
  files = dir(['../data/', foldername, '/*.png']);

  % Number of files
  len = length(files);

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
    image_1_file = strcat(['../data/' foldername, '/'], files(index_1).name);
    image_2_file = strcat(['../data/' foldername, '/'], files(index_2).name);

    % Extract features
    if ii == 1
        [I1, mask1, f1, d1] = features(image_1_file);
        [I2, mask2, f2, d2] = features(image_2_file);
    else
        I1 = I2;
        mask1 = mask2;
        f1 = f2;
        d1 = d2;
        [I2, mask2, f2, d2] = features(image_2_file);
    end
    
    % Calculating Transformation Matrix
    [F, P1, P2] = eight_point(I1, I2, f1, f2, d1, d2);

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
