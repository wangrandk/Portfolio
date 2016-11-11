clear all
close all
clc
% sobel
A = imread('BookImage.jpg');
B=rgb2gray(A);
% C=double(B);
% for i=1:size(C,1)-2
%     for j=1:size(C,2)-2
%         %Sobel mask for x-direction:
%         Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
%         %Sobel mask for y-direction:
%         Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
%       
%         %The gradient of the image
%         %B(i,j)=abs(Gx)+abs(Gy);
%        
%         if (Gx)^2+(Gy)^2 > 0.9
%            B(i,j)=(Gx)^2+(Gy)^2;
%         end
%         %B(i,j)=sqrt(Gx.^2+Gy.^2);
%       
%     end
% end
% figure,imshow(B); title('Sobel gradient');

% % threshold value
% Thresh=100;
% B=max(B,Thresh);
% B(B==round(Thresh))=0;
% B=uint8(B);
% figure,imshow(~B);title('Edge detected Image');

% B_edge = edge(B,'sobel',0.03);
% imshow(B_edge);
rotI = imrotate(B,43,'crop');
[H,T,R] = hough(B);
imshow(H,[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');
lines = houghlines(B,T,R,P,'FillGap',5,'MinLength',7)
figure, imshow(rotI), hold on

max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
%    plot(xy(3,1),xy(3,2),'x','LineWidth',2,'Color','blue');
   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue');
