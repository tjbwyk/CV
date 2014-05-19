function [F, P1, P2, I1, I2] = eight_point(I1, I2, f1, f2, d1, d2)

  [matches, scores] = vl_ubcmatch(d1, d2);

  % Estimate fundamental matrix

  % Normalization
  P1 = f1(1:2,matches(1,:));
  P2 = f2(1:2,matches(2,:));
  
  % Show point pairs
  idx = randperm(length(matches), 50);
  figure;
  showMatchedFeatures(I1, I2, P1(:, idx)', P2(:, idx)', 'montage');

  [P1n, T1] = normalization(P1);
  [P2n, T2] = normalization(P2);

  % Construct A matrix
  A = zeros(length(matches),9);

  A = [
        P1n(1, :) .* P2n(1, :);
            P1n(1, :) .* P2n(2, :);
            P1n(1, :);
            P1n(2, :) .* P2n(1, :);
            P1n(2, :) .* P2n(2, :);
            P1n(2, :);
            P2n(1, :);
            P2n(2, :);
            ones(1, length(matches))
      ]';

  % apply SVD
  [U,S,V] = svd(A);

  % if normalization applied
  % calculate fundamental matrix
  F_ = reshape(V(:,end), 3, 3);
  [Uf,Sf,Vf] = svd(F_);
  F = Uf * diag([Sf(1,1), Sf(2, 2), 0]) * Vf';

  % denormalization
  F = T2' * F * T1;

end
