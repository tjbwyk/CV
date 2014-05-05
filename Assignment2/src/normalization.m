function [P_new, T] = normalization(P)

  % add homogeneus coordinate
  P(3,:) = 1;

  % calculate mean
  M = mean(P,2);

  % calculate matrix T
  M_rep = repmat(M,[1,length(P)]);

  dist = mean(sqrt(sum((P - M_rep).^2,1)));

  T = zeros(3);
  T(1,1) = sqrt(2)/dist;
  T(2,2) = sqrt(2)/dist;
  T(1,3) = -M(1) * sqrt(2) / dist;
  T(2,3) = -M(2) * sqrt(2) / dist;
  T(3,3) = 1;

  % calculate new P
  P_new = T * P;
end
