clc; clear all; close all;

I = imread('Taj_Mahal.jpeg');
Vanishing_Points(I);

%( A \ B ==> left division )
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

imx = imwarp(I,Hxyinvt); 
imy = imwarp(I,Hyzinvt); 
imz = imwarp(I,Hxzinvt);  

figure(1)  
imshow(imx); 
figure(2)
imshow(imy); 
figure(3)
imshow(imz);