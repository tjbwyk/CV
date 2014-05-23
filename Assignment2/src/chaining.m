function [M,PVM] = chaining(foldername)
  tic;

  % Define data directory
  files = dir(['../data/', foldername, '/*.png']);

  % Number of files
  len = length(files);

  M = zeros(len,1);
  PVM = cell(len,0);

  % Construct Point-View Matrix
  for i=1:len
    i
    index_1 = i;

    if i == len
      index_2 = 1;
    else
      index_2 = i+1;
    end

    % Load image
    image_1_file = strcat(['../data/' foldername, '/'], files(index_1).name);
    image_2_file = strcat(['../data/' foldername, '/'], files(index_2).name);

    % Extract features
    if i == 1
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
    [F, matches, P1, P2] = eight_point(I1, I2, f1, f2, d1, d2);

    for j = 1 : length(matches)
        Pnum1 = matches(1, j);
        Pnum2 = matches(2, j);
        x1 = P1(1, Pnum1);
        y1 = P1(2, Pnum1);
        x2 = P2(1, Pnum2);
        y2 = P2(2, Pnum2);
        
        found = false;
        found_col = 0;
        for k = size(PVM, 2) : -1 : 1
            if isequal(PVM{index_1, k}, [x1, y1, Pnum1])
                found = true;
                found_col = k;
                break;
            end
        end
        
        if found
            PVM{index_2, found_col} = [x2, y2, Pnum2];
        else
            PVM{index_1, end + 1} = [x1, y1, Pnum1];
            PVM{index_2, end} = [x2, y2, Pnum2];
        end
    end
  end

  for i=1:size(PVM,1)
    for j=1:size(PVM,2)
      if isempty(PVM{i,j})
        M(i,j) = 1;
      else
        M(i,j) = 0;
      end
    end
  end

  runtime = toc;

end
