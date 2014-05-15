function [F, P1, P2, I1, I2] = eight_point(image1, image2)

  % Read images
  I1 = imread(image1);
  I2 = imread(image2);

  % image(I1);
  % image(I2);

  if size(I1,3) == 3
    I1 = single(rgb2gray(I1));
    I2 = single(rgb2gray(I2));
  else
    I1 = single(I1);
    I2 = single(I2);
  end

  % extract the object
  [x11, y11, x12, y12] = objDetect(I1);
  [x21, y21, x22, y22] = objDetect(I2);
  I1 = I1(x11:x12, y11:y12);
  I2 = I2(x21:x22, y21:y22);
  
  % compute SIFT frames and descriptors
  [f1, d1] = vl_sift(I1);
  [f2, d2] = vl_sift(I2);

  % perm = randperm(size(f2,2));
  % sel = perm(1:50);
  % h1 = vl_plotframe(f2(:,sel));
  % h2 = vl_plotframe(f2(:,sel));
  % set(h1,'color','k','linewidth',3);
  % set(h2,'color','y','linewidth',2);

  % h3 = vl_plotsiftdescriptor(d2(:,sel),f2(:,sel));
  % set(h3,'color','g');

  % matching
  [matches, scores] = vl_ubcmatch(d1, d2);

  % subplot(121);
  % imshow(uint8(I1));
  % hold on;
  % plot(f1(1,matches(1,:)),f1(2,matches(1,:)),'b*');

  % subplot(122);
  % imshow(uint8(I2));
  % hold on;
  % plot(f2(1,matches(2,:)),f2(2,matches(2,:)),'g*');

  % Estimate fundamental matrix

  % Normalization
  P1 = f1(1:2,matches(1,:));
  P2 = f2(1:2,matches(2,:));

  [P1, T1] = normalization(P1);
  [P2, T2] = normalization(P2);

  % Construct A matrix
  A = zeros(length(matches),9);

  A = [
        P1(1, :) .* P2(1, :);
            P1(1, :) .* P2(2, :);
            P1(1, :);
            P1(2, :) .* P2(1, :);
            P1(2, :) .* P2(2, :);
            P1(2, :);
            P2(1, :);
            P2(2, :);
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
