function main(PVM)

  len = size(PVM,1);

  for i=1:len
    index_1 = i;

    if i == len
      index_2 = 1;
    else
      index_2 = i+1;
    end

    D(1,:) = {PVM{index_1,:}};
    D(2,:) = {PVM{index_2,:}};

    [M, S] = sfm(D);

    figure
    plot3(S(1,:),S(2,:),S(3,:),'b.');
  end
end
