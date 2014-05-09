function [F, P1, P2] = eight_point_ransac(image1, image2)

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

  F = ransac(P1, P2, matches, 5000, 0.0001);

  % denormalization
  F = T2' * F * T1;

end
