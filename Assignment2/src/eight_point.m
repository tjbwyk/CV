function [matches, scores] = eight_point(image1, image2)

  I1 = imread(image1);
  I2 = imread(image2);

  image(I1);
  image(I2);

  I1 = single(I1);
  I2 = single(I2);

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

  [matches, scores] = vl_ubcmatch(d1, d2);

  subplot(121);
  imshow(uint8(I1));
  hold on;
  plot(f1(1,matches(1,:)),f1(2,matches(1,:)),'b*');

  subplot(122);
  imshow(uint8(I2));
  hold on;
  plot(f2(1,matches(2,:)),f2(2,matches(2,:)),'g*');

  [xa1 ya1] = ds2nfu(f1(1,matches(1,:)), f1(2,matches(1,:)));
  [xa2 ya2] = ds2nfu(f2(1,matches(2,:)), f2(2,matches(2,:)));

  for k=1:numel(matches(1,:))
    xxa1 = xa1(1, k);
    yya1 = ya1(1, k);
    xxa2 = xa2(1, k);
    yya2 = ya2(1, k);

    annotation('line',[xxa1 xxa2],[yya1 yya2],'color','r');
  end

end
