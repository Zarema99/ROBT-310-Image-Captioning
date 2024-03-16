%%
%a grayscale image of constant intensity 100
I = uint8(ones(1000, 1000));
I_new = 100*I;
figure
imshow(I_new)
title('A grayscale image of constant intensity 100')

%%
%alternating black and white vertical stripes
I2 = uint8([zeros(1000, 4), 255*ones(1000, 4)]);
I2_new = repmat(I2, 1, 125);
figure
imshow(I2_new)
title('Alternating black and white vertical stripes')

%%
%ramp intensity distribution
[~,x] = meshgrid(0:999, 0:999);
I3 = x/2;
I3_new = uint8(I3);
figure
imshow(I3, [0 255])
title('Ramp intensity distribution')

%%
%gaussian intensity distribution
[y,x] = meshgrid(0:999,0:999);
I4 = 255*exp(-((x - 128).^2 + (y - 128).^2)/200^2);
I4_new = uint8(I4);
figure
imshow(I4_new, [0 255]);
title('Gaussian intensity distribution')

%%
%color image
I5 = zeros(1000, 1000, 3);
I5(1:500, 1:500, 1) = 255; I5(1:500, 1:500, 2) = 255; I5(1:500, 1:500, 3) = 0;  %yellow
I5(1:500, 500:1000, 1) = 0; I5(1:500, 500:1000, 2) = 255; I5(1:500, 500:1000, 3) = 0;   %green
I5(500:1000, 1:500, 1) = 255; I5(500:1000, 1:500, 2) = 0; I5(500:1000, 1:500, 3) = 0;   %red
I5_new = uint8(I5);
figure
imshow(I5_new)
title('A color image')