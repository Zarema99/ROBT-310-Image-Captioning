function robt310_project2_interpolation(input_file_name, output_file_name, scale_factor)
    input_img = imread(input_file_name);
    [row, col, colorChannel] = size(input_img);
    %preallocate output_img with zeros()
    %use round() because scale_factor could be not only a whole number
    output_img = uint8(zeros(round(row*scale_factor), round(col*scale_factor), colorChannel));
    output_size = size(output_img);
    for i_output = 1:output_size(1)
        for j_output = 1:output_size(2)
%ceil() rounds floating-point number to the nearest integer greater than or equal to it 
            i_input = ceil(i_output/scale_factor);
            j_input = ceil(j_output/scale_factor);
%locations in output_img are assigned to the intensities of their nearest
%neighbors in input_img
%for color images, it is done for each color channel
            output_img(i_output, j_output, :) = input_img(i_input, j_input, :);
        end
    end
    imwrite(output_img, output_file_name);
    imshow(output_img)
    title('Output image (Nearest-Neighbor Interpolation)')
end