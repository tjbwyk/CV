function main(PVM)

  len = size(PVM,1);

  for i=1:len
    index_1 = i;
    D = cell(0);

    if i == len
      index_2 = 1;
    else
      index_2 = i+1;
    end

    % Find points that only appear in the first image and second image
    D(1,:) = {PVM{index_1,:}};
    D(2,:) = {PVM{index_2,:}};

    empty_cells = cellfun('isempty', D);
    D(:, any(empty_cells, 1)) = [];

    [M, S] = sfm(D);

    figure
    plot3(S(1,:),S(2,:),S(3,:),'b.');
  end
end
