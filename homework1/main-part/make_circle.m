function new_img = make_circle(img)
size_img = size(img);
center_x = size_img(2)/2;
center_y = size_img(1)/2;
R = size_img(2)/2;
circle = zeros(size_img(1), size_img(2));
for i = 1:size_img(1)
    for j = 1:size_img(2)
        if (j - center_x)^2 + (i - center_y)^2 < R^2    %inside the circle
            circle(i, j) = 1;
        else
            circle(i, j) = 0;   %outside the circle
        end 
    end
end
new_img = img.*uint8(circle);
end

