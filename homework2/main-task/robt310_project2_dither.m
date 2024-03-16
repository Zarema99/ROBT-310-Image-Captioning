function robt310_project2_dither(input_file_name, output_file_name, part)
    input_image = imread(input_file_name);
    
    if part == 0    %Floyd-Steinberg Dithering
        %preallocate output_image with double precision input_image 
        output_image = double(input_image);
        size_img = size(input_image);

        for y = 1:size_img(1)
            for x = 1: size_img(2) 
                old_pixel = output_image(y, x, :);
                %binarization (new_pixel is either 0 or 255)
                %for color images, it is performed for every color channel
                new_pixel = round(old_pixel/255)*255;
                output_image(y, x, :) = new_pixel;
                quant_error = old_pixel - new_pixel;
                %work with right, left, and bottom edges
                if x == 1 && y == size_img(1)
                    output_image(y, x + 1, :) = output_image(y, x + 1, :) + quant_error*7/16; 
                elseif x == size_img(2) && y == size_img(1)
                    output_image(y, x, :) = new_pixel;
                elseif x == 1
                    output_image(y, x + 1, :) = output_image(y, x + 1, :) + quant_error*7/16; 
                    output_image(y + 1, x, :) = output_image(y + 1, x, :) + quant_error*5/16;
                    output_image(y + 1, x + 1, :) = output_image(y + 1, x + 1, :) + quant_error*1/16;
                elseif y == size_img(1)
                    output_image(y, x + 1, :) = output_image(y, x + 1, :) + quant_error*7/16;
                elseif x == size_img(2)
                    output_image(y + 1, x - 1, :) = output_image(y + 1, x - 1, :) + quant_error*3/16;
                    output_image(y + 1, x, :) = output_image(y + 1, x , :) + quant_error*5/16;
                else    %everything except left, right, and bottom edges
                    output_image(y, x + 1, :) = output_image(y, x + 1, :) + quant_error*7/16;
                    output_image(y + 1, x - 1, :) = output_image(y + 1, x - 1, :) + quant_error*3/16;
                    output_image(y + 1, x, :) = output_image(y + 1, x, :) + quant_error*5/16;
                    output_image(y + 1, x + 1, :) = output_image(y + 1, x + 1, :) + quant_error*1/16;
                end
            end
        end

        output_image_int = uint8(output_image);
        imshow(output_image_int)
        title('Output image (Floyd-Steinberg dithering)')
        imwrite(output_image_int, output_file_name)  
    elseif part == 1    %Bayer Dithering
        %preallocate output_image with double precision intensity input_image
        output_image = im2double(input_image);
        [row, col, colorChannel] = size(input_image);
        %Bayer_matrix = [0 8 2 10; 12 4 14 6; 3 11 1 9; 15 7 13 5]./16;
        %Bayer_matrix = [0 2; 3 1]./4;
        %8x8 Bayer matric gives the best result
        Bayer_matrix = [0,32,8,40,2,34,10,42; 48,16,56,24,50,18,58,26; 12,44,4,36,14,46,6,38;
            60,28,52,20,62,30,54,22; 3,35,11,43,1,33,9,41; 51,19,59,27,49,17,57,25; 
            15,47,7,39,13,45,5,37; 63,31,55,23,61,29,53,21]./64;
        size_matrix = size(Bayer_matrix);

        for i = 1:row
            for j = 1:col
                for k = 1:colorChannel
%elements of image are compared with the corresponding elements in Bayer
%matrix part by part (size of part is equal to the size of Bayer matrix)
%for color images, it is done for each color channel
                    %add 1 because indexing starts from 1 in MATLAB
                    x = mod(i, size_matrix(1)) + 1;
                    y = mod(j, size_matrix(2)) + 1;

                    if output_image(i, j, k) < Bayer_matrix(x, y)
                    output_image(i, j, k) = 0;
                    else
                        output_image(i, j, k) = 255;
                    end

                end
            end
        end
        output_image_int = uint8(output_image);
        imshow(output_image_int)
        title('Output image (Bayer dithering)')
        imwrite(output_image_int, output_file_name)  
    end
end