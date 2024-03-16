%this function takes an original image and dataset as inputs
%and gives rectangular and circular mosaics as outputs
function [rectangular, circular] = mosaic(original_image, dataset)
%load dataset
ds = imageDatastore(dataset);
data = readall(ds);

%scale original images using user's input
prompt1 = 'Please enter the number of rows for patches: ';
prompt2 = 'Please enter the number of columns for patches: ';
rows = input(prompt1);
columns = input(prompt2);
for i = 1:size(data)
    img = data{i, 1};
    patch = imresize(img, [rows columns]);
    data{i, 1} = patch;
end


%dividing the main image into small pieces
main_image = imread(original_image);
imshow(main_image)
title('Original image')
size_patch = size(patch);
size_img = size(main_image);
img_over_patch1 = round(size_img(1)/size_patch(1));
img_over_patch2 = round(size_img(2)/size_patch(2));

%resize the main image so that the whole number of patches could fit into
%it
main_image = imresize(main_image, [size_patch(1)*img_over_patch1 size_patch(2)*img_over_patch2]);

%divide image into color channels and divide each color channel into
%sections
main_image_red = main_image(:, :, 1);
main_image_green = main_image(:, :, 2);
main_image_blue = main_image(:, :, 3);
divided_image_red = mat2cell(main_image_red, size_patch(1)*ones(1, img_over_patch1), size_patch(2)*ones(1, img_over_patch2));
divided_image_green = mat2cell(main_image_green, size_patch(1)*ones(1, img_over_patch1), size_patch(2)*ones(1, img_over_patch2));
divided_image_blue = mat2cell(main_image_blue, size_patch(1)*ones(1, img_over_patch1), size_patch(2)*ones(1, img_over_patch2)) ;

%combine color channels for each section
size_divided = size(divided_image_red);
divided_image = cell(img_over_patch1 , img_over_patch2);
for i = 1:size_divided(1)
    for j = 1:size_divided(2)
        img1 = divided_image_red{i, j};
        img2 = divided_image_green{i, j};
        img3 = divided_image_blue{i, j};
        img = cat(3, img1, img2, img3);
        divided_image{i, j} = img;
    end
end


%comparing images using method 2
new_image_divided = cell(img_over_patch1, img_over_patch2);
for i = 1:size_divided(1)
    for j = 1:size_divided(2)
        img = divided_image{i, j};
        new_img = compare_pieces(img, data);
        new_image_divided{i, j} = new_img;
    end
end
rectangular = cell2mat(new_image_divided);
figure
imshow(rectangular)
title('Mosaic using rectangular patches')


%resize patches to squares
data_square = cell(size(data));
for i = 1:size(data)
    img = data{i, 1};
    size_img = size(img);
    if size_img(1) < size_img(2)
        new_img = imresize(img, [size_img(1) size_img(1)]);
    else
        new_img = imresize(img, [size_img(2) size_img(2)]);
    end
    data_square{i, 1} = new_img;
end
 
%from squares to circles
data_circle = cell(size(data));
for i = 1:size(data)
    img = data_square{i, 1};
    new_img = make_circle(img);
    data_circle{i, 1} = new_img;
end



%dividing the main image into square and circular pieces 
size_patch = size(data_circle{1, 1});
size_img = size(main_image);
img_over_patch1 = round(size_img(1)/size_patch(1));
img_over_patch2 = round(size_img(2)/size_patch(2));

%resize the main image so that the whole number of patches could fit into
%it
main_image = imresize(main_image, [size_patch(1)*img_over_patch1 size_patch(2)*img_over_patch2]); 

%divide image into color channels and divide each color channel into
%sections
main_image_red = main_image(:, :, 1);
main_image_green = main_image(:, :, 2);
main_image_blue = main_image(:, :, 3);
divided_image_red = mat2cell(main_image_red, size_patch(1)*ones(1, img_over_patch1), size_patch(2)*ones(1, img_over_patch2));
divided_image_green = mat2cell(main_image_green, size_patch(1)*ones(1, img_over_patch1), size_patch(2)*ones(1, img_over_patch2));
divided_image_blue = mat2cell(main_image_blue, size_patch(1)*ones(1, img_over_patch1), size_patch(2)*ones(1, img_over_patch2)) ;

%combine color channels for each section
size_divided = size(divided_image_red);
divided_image_circle = cell(img_over_patch1 , img_over_patch2);
for i = 1:size_divided(1)
    for j = 1:size_divided(2)
        img1 = divided_image_red{i, j};
        img2 = divided_image_green{i, j};
        img3 = divided_image_blue{i, j};
        img = cat(3, img1, img2, img3);
        img_circle = make_circle(img);
        divided_image_circle{i, j} = img_circle;
    end
end


%comparing pieces using method 2
circle_divided = cell(img_over_patch1, img_over_patch2);
for i = 1:size_divided(1)
    for j = 1:size_divided(2)
        img_circle = divided_image_circle{i, j};
        new_img = compare_pieces(img_circle, data_circle);
        circle_divided{i, j} = new_img;   
    end
end
circular = cell2mat(circle_divided);
figure
imshow(circular)
title('Mosaic from circular patches')


