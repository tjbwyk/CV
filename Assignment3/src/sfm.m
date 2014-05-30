function [M,S] = sfm(PVM)

  D = zeros(2 * size(PVM,1), size(PVM,2));

  % Normalize Points
  for ii=1:size(PVM,1)
    Temp = cat(1,PVM{ii,:});
    Mean_Temp = mean(Temp,1);

    for jj=1:size(PVM,2)
      if ~isempty(PVM{ii,jj})
        D(ii*2-1,jj) = PVM{ii,jj}(1) - Mean_Temp(1);
        D(ii*2,jj) = PVM{ii,jj}(2) - Mean_Temp(2);
      else
        D(ii*2-1,jj) = 0;
        D(ii*2,jj) = 0;
      end
    end
  end

  % Apply SVD
  [U,W,V] = svd(D);

  U3 = U(:,1:3);
  W3 = W(1:3,1:3);
  V3 = V(:,1:3)';

  % Obtain matrix Motion and Shape
  M = U3 * sqrt(W3);
  S = sqrt(W3) * V3;

end
