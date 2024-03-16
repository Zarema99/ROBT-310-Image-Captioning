function robt310_project2_histogram_equalize(input_file_name)
    input_img = imread(input_file_name);
    %histogram equilization
    hist_eq_img = histeq(input_img);
    figure
    imshow(hist_eq_img)
    title('Histogram Equalization')
    %local histogram equalization
    %block processing function
    fun = @(block_struct) histeq(block_struct.data);
    loc_hist_eq_img = blockproc(input_img, [40 40], fun);
    figure
    imshow(loc_hist_eq_img)
    title('Local Histogram Equalization')
end