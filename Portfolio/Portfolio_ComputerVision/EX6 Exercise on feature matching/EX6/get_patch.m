function Y = get_patch(img, x, y, n)
c = [x, y];
%Make sure the image is grayscale
if (size(img,3) == 3)
    img = rgb2gray(img)
end

%Make sure the point is in range
if (x < 0 || x > size(img, 2))
    error('x should be within width of the image.');
end
if (y < 0 || y > size(img, 1))
    error('y should be within height of the image.');
end

%Set up the patch size based on input value
patch_x = 2*n + 1;
patch_y = 2*n + 1;

%Get the starting X index
x_s = round(x - patch_x);
if (x_s <= 0)
    x_s = 1;
end

%Get the ending X index
x_e = round(x + patch_x);
if (x_e > size(img, 2))
    x_e = size(img, 2);
end

%Get the starting Y index
y_s = round(y - patch_y);
if (y_s <= 0)
    y_s = 1;
end

%Get the ending Y index
y_e = round(y + patch_y);
if (y_e > size(img, 1))
    y_e = size(img, 1);
end

%Set the image patch

d1 = sqrt((c(1) - c(1))^2 + (c(2) - 1)^2);
d2 = sqrt((c(1) - 1)^2 + (c(2) - c(2))^2);
d3 = sqrt((c(1) - c(1))^2 + (c(2) - 2*n)^2);
d4 = sqrt((c(1) - 2*n)^2 + (c(2) - c(2))^2);

if (d1 < n || d2 < n || d3 < n || d4 < n)
    Y = zeros(2*n + 1);
else
    Y = img(y_s:y_e, x_s:x_e);
end




