clc; clear all; close all;

s = rng;



%% get the start_points and end_points of each straight line use LSD.
% note: input parameter is the path of image, use '/' as file separator.
lines = lsd('./Taj_Mahal.jpeg');
%im=imread('./images/abcd.jpg');

%% Load parameters
load('paramjet.mat');
axes=axes';
%% Lines 
no_of_points = size(lines,2);
e1 = ones(no_of_points,3); e2 = ones(no_of_points,3);
e1(:,1) = lines(1,:);%x1
e1(:,2) = lines(3,:);%y1
e2(:,1) = lines(2,:);%x2 
e2(:,2) = lines(4,:);%y2
A = cross(e1,e2); % [x1 y1 1] and [x2 y2 1]

B = A./A(:,3); %homogenous
%B=A;
B_length = sqrt((e2(:,2)-e1(:,2)).^2+(e2(:,1)-e1(:,1)).^2);

%% Origin Lines

thresh = 70;
B_filtered=zeros(0,4);
% 
% for i=1:length(B)
%     if(B_length(i)> thresh)
%         B_filtered(end+1,:) = [B(i,:) i];
%     end
% end
% temp = zeros(size(B,1),1);
% for i=1:size(B,1)
%     temp(i)=sum(cross(origin',B(i,:)));
%    if abs(temp(i))<0.5
%        B_filtered(end+1,:)=[B(i,:) i];
%    end
%end 
for i=1:size(B,1)
    
       B_filtered(end+1,:)=[B(i,:) i];
   
end 

%% Cluster into different axes
B_filtered = B;
Theta = zeros(size(B_filtered,1),3);
B_x = zeros(0,4);
B_y = zeros(0,4);
B_z = zeros(0,4);
axes=axes'
slope_axes = -axes(:,1)./axes(:,2)
for i=1:size(B_filtered,1)
    
    Theta(i,1) = acosd(dot(B(i,:),axes(1,:))/(norm(B(i,:))*norm(axes(1,:))));
    Theta(i,2) = acosd(dot(B(i,:),axes(2,:))/(norm(B(i,:))*norm(axes(2,:))));
    Theta(i,3) = acosd(dot(B(i,:),axes(3,:))/(norm(B(i,:))*norm(axes(3,:))));
    [val,idx] = min(Theta(i,:));
    if val <= 90

    if idx==1
        B_x(end+1,:) = [B_filtered(i,:) i];
        
    elseif idx == 2
        B_y(end+1,:) = [B_filtered(i,:) i];
    else
        B_z(end+1,:) = [B_filtered(i,:) i];
    end
    
    end
%     %slope = -B_filtered(i,1)/B_filtered(i,2)
%     slope  = (e2(i,2)-e1(i,2))/(e2(i,1)-e1(i,1));
%     
%     if ((slope-slope_axes(1)) < 10.8) && ((slope-slope_axes(1)) > 0)  
%         B_x(end+1,:) = [B_filtered(i,:)];
%     
% 
%     elseif ((slope-slope_axes(2)) < 0.8) && ((slope-slope_axes(2)) > 0)  
%         B_y(end+1,:) = [B_filtered(i,:)];
%     
%         elseif ((slope-slope_axes(3)) < 0.9) && ((slope-slope_axes(3)) > 0)  
%         B_z(end+1,:) = [B_filtered(i,:)];
%     end
end

%% plot
imshow(im);
hold on;
axes=axes';
x = 700:1:900;
y = (-axes(1,1)*x - 1)/axes(1,2);
plot(x,y,'r')


B_plot = B_filtered;
for i=1:size(B_plot,1)
    j = B_plot(i,4);
    plot([e1(j,1) e2(j,1)],[e1(j,2) e2(j,2)],'r');
end
%% Ransac for orthogonality
vp_x = ransac(B_x(:,1:3));
vp_y = ransac(B_y(:,1:3));
vp_z = ransac(B_z(:,1:3));
vp=[vp_x;vp_y;vp_z];
vp = vp./vp(:,3);
%% rem
%vp=vp';
axes=axes';
%origin=origin';
a_x = ( vp(:,1) \ (axes(:,1)-origin ) ) / axes_length(1);
a_y = ( vp(:,2) \ (axes(:,2)-origin ) ) / axes_length(2);
a_z = ( vp(:,3) \ (axes(:,3)-origin ) ) / axes_length(3);

P = [vp(:,1)*a_x vp(:,2)*a_y vp(:,3)*a_z origin ];

Hxy=projective2d(P(:,[1,2,4])'); 
Hyz=projective2d(P(:,[2,3,4])'); 
Hxz=projective2d(P(:,[1,3,4])'); 
Hxyinvt=invert(Hxy); 
Hyzinvt=invert(Hyz); 
Hxzinvt=invert(Hxz);

I = imread('./images/abcd.jpg');

imx = imwarp(I,Hxyinvt); 
imy = imwarp(I,Hyzinvt); 
imz = imwarp(I,Hxzinvt);  
figure(1)  
imshow(imx); 
figure(2)
imshow(imy); 
figure(3)
imshow(imz);