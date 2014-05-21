function [F, matches, P1, P2, I1, I2] = eight_point(I1, I2, f1, f2, d1, d2)

  [matches, scores] = vl_ubcmatch(d1, d2);
  
  P1 = f1(1:2, :);
  P2 = f2(1:2, :);
  
  % Estimate fundamental matrix

  % Normalization
  P1_match = f1(1:2,matches(1,:));
  P2_match = f2(1:2,matches(2,:));
  
  % Show point pairs
  idx = randperm(length(matches), 50);
  figure;
  showMatchedFeatures(I1, I2, P1_match(:, idx)', P2_match(:, idx)', 'montage');

  [P1_match_norm, T1] = normalization(P1_match);
  [P2_match_norm, T2] = normalization(P2_match);

  % Construct A matrix
  A = zeros(length(matches),9);

  A = [
        P1_match_norm(1, :) .* P2_match_norm(1, :);
            P1_match_norm(1, :) .* P2_match_norm(2, :);
            P1_match_norm(1, :);
            P1_match_norm(2, :) .* P2_match_norm(1, :);
            P1_match_norm(2, :) .* P2_match_norm(2, :);
            P1_match_norm(2, :);
            P2_match_norm(1, :);
            P2_match_norm(2, :);
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
