function [Model,M,S] = main(PVM)

  Model = zeros(size(PVM,1)*2,size(PVM,2));
  len = size(PVM,1);

  figure
  hold on;

  for i=1:len
    index_1 = i;

    if i == len
      index_2 = 1;
    else
      index_2 = i+1;
    end

    D = zeros(2*2,size(PVM,2));

    % Normalize Points
    % for ii=1:size(PVM,1)
    for ii=1:2
      if ii == 1
        index = index_1;
      else
        index = index_2;
      end

      Temp = cat(1,PVM{index,:});
      Mean_Temp = mean(Temp,1);

      for jj=1:size(PVM,2)
        if ~isempty(PVM{index,jj})
          D(ii*2-1,jj) = PVM{index,jj}(1) - Mean_Temp(1);
          D(ii*2,jj) = PVM{index,jj}(2) - Mean_Temp(2);
        else
          D(ii*2-1,jj) = 0;
          D(ii*2,jj) = 0;
        end
      end
    end

    % Apply SVD
    [U,W,V] = svd(D);

    U = U(:,1:3);
    W = W(1:3,1:3);
    V = V(:,1:3)';

    % Obtain matrix Motion and Shape
    M = U * W.^0.5;
    S = W.^0.5 * V;

    % % plot3(S(1,:),S(2,:),S(3,:))
    % size(U)
    % size(W)
    % size(V)
    % size(M)
    % size(S)
    plot3(S(1,:),S(2,:),S(3,:),'b.');
  end
end
