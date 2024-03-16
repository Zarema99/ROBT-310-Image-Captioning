function new_img = compare_pieces(img, data)
size_data = size(data);
difference = zeros(1, size_data(1));

%convert image to double precision
img = im2double(img);
for i = 1:size(data)
    img2 = data{i, 1};
    img2 = im2double(img2);
    diff = img - img2;
    power = diff.^2;
    summa = sum(power(:));
    dist = sqrt(summa);
    difference(i) = dist;
end
[~, ind] = min(difference);
new_img = data{ind, 1};
end