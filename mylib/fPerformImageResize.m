function newimg = fPerformImageResize(img,p1,q1,r1,interplateMethod)

% perform_image_resize - resize an image using bicubic interpolation
%
%   newimg = perform_image_resize(img,nx,ny,nz);
% or
%   newimg = perform_image_resize(img,newsize);
%
%   Works for 2D, 2D 2 or 3 channels, 3D images.
%
%   Copyright (c) 2004 Gabriel Peyre
% revised, provide more options for interplation.
% interplateMethod 1 2 3 4
%     'nearest' - nearest neighbor interpolation
%     'linear'  - linear interpolation
%     'spline'  - spline interpolation
%     'cubic'   - cubic interpolation as long as the data is uniformly
%                 spaced, otherwise the same as 'spline'

if nargin==2
    % size specified as an array
    q1 = p1(2);
    if length(p1)>2
        r1 = p1(3);
    else
        r1 = size(img,3);
    end
    p1 = p1(1);        
end

if nargin<4
    r1 = size(img,3);
end

if nargin < 5
    interplateMethod = 1;
end

if interplateMethod == 2
    interplateMethodText = 'linear';
elseif interplateMethod == 3
    interplateMethodText = 'spline';
elseif interplateMethod == 4
    interplateMethodText = 'cubic';
else
    interplateMethodText = 'nearest';
end
disp(['interplation method uses ',interplateMethodText]);

if ndims(img)<2 || ndims(img)>3
    error('Works only for grayscale or color images');
end

if ndims(img)==3 && size(img,3)<4
    % RVB image
    newimg = zeros(p1,q1, size(img,3));
    for m=1:size(img,3)
        newimg(:,:,m) = perform_image_resize(img(:,:,m), p1, q1);
    end
    return;
elseif ndims(img)==3
    p = size(img,1);
    q = size(img,2);
    r = size(img,3);
    [Y,X,Z] = meshgrid( (0:q-1)/(q-1), (0:p-1)/(p-1), (0:r-1)/(r-1)  );
    [YI,XI,ZI] = meshgrid( (0:q1-1)/(q1-1), (0:p1-1)/(p1-1), (0:r1-1)/(r1-1) );
    newimg = interp3( Y,X,Z, img, YI,XI,ZI ,interplateMethodText); %'cubic');
    return;
end

p = size(img,1);
q = size(img,2);
[Y,X] = meshgrid( (0:q-1)/(q-1), (0:p-1)/(p-1) );
[YI,XI] = meshgrid( (0:q1-1)/(q1-1), (0:p1-1)/(p1-1) );
newimg = interp2( Y,X, img, YI,XI ,interplateMethodText); %'cubic');