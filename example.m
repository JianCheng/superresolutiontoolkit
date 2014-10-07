% test the Image Deconvolution using Variational Method
% function fTestImageLRTV
%%
clear;clc;
addpath mylib
n = 256;
% name = 'lena';
name = 'xch2';

f0 = load_image(name);
if ndims(f0) > 2 ; f0 = f0(:,:,1); end;

if min(size(f0)) >= n
    f0 = rescale(crop(f0,n));
else
    img = zeros(n,n);
    img(1:size(f0,1),1:size(f0,2)) = f0;
    f0=img;
    clear img;
end
org=f0;
rate = 2;

%% preprocessing
s = 1;
n=size(f0,1);
x = [0:n/2-1, -n/2:-1];
[Y,X] = meshgrid(x,x);
h = exp( (-X.^2-Y.^2)/(2*s^2) );
h = h/sum(h(:));

Phi = @(x,h)real(ifft2(fft2(x).*fft2(h)));
y0 = Phi(f0,h);

ylr = my_downsample(y0,rate);
figure(1);imshow(ylr,[]);
g = my_upsample(ylr,rate);
g=g(1:size(y0,1),1:size(y0,2)); 
figure(2);imshow(g,[]);
snr(f0,g)
figure(3);imshow(f0,[]);

% input is original and output is larger
%% image recover
para.niter = 6;
para.dt = 0.1;

[fTV, errList_H] = fTestImageLRTV2D(ylr,rate,f0,para);
snr(f0,fTV)
figure(4);imshow(fTV,[]);

