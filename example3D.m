% test the Image Deconvolution using Variational Method
% function fTestImageLRTV
% make it work on 3D images
%%
clear;clc;
addpath mylib
addpath data

neoName='atlas90-raw-256_256_256-removeCere.hdr';
[~,~,~,neoImg] = readHeaderInMatlab(neoName);

%% preprocessing
n = 256;
rate = 2;

% prepare the ylr data, has to be cu
f0 = zeros(n,n,n);
f0(1:size(neoImg,1),1:size(neoImg,2),1:size(neoImg,3)) = double(neoImg);

% s = 1;
% n=size(f0,1);
% x = [0:n/2-1, -n/2:-1];
% [Y,X] = meshgrid(x,x);
% h = exp( (-X.^2-Y.^2)/(2*s^2) );
% h = h/sum(h(:)); 
% Phi = @(x,h)real(ifft2(fft2(x).*fft2(h)));
% y0 = Phi(f0,h);

s=1;
y0 = gauss3filter(f0,s);

slice = 100;
ylr = my_downsample(y0,rate);

figure(1);imshow(ylr(:,:,round(slice/2)),[]);
g = my_upsample(ylr,rate);
figure(2);imshow(g(:,:,slice),[]);
disp(snr(f0,g));
figure(3);imshow(f0(:,:,slice),[]);

% input is original and output is larger
%% image recover
% para.niter = 6;
% para.dt = 0.1;
% 
% [fTV, errList_H] = fTestImageLRTV3D(ylr,rate,f0,para);
% figure(4);imshow(fTV(:,:,slice),[]);

% I tested the above method, and get below results
% speed is quite slow, 
% [fTV, errList_H] = fTestImageLRTV3D(ylr,rate,f0,para);
% HaLRTC: iterations = 1   difference=0.660878
%  snr= 12.197910
% HaLRTC: iterations = 2   difference=0.559551
%  snr= 7.183178
% HaLRTC: iterations = 3   difference=0.652630
%  snr= 13.416870
% HaLRTC: iterations = 4   difference=0.352042
%  snr= 9.537511
% HaLRTC: iterations = 5   difference=0.264128
%  snr= 12.176691
% HaLRTC: iterations = 6   difference=0.237614
%  snr= 9.895984

%% image recover test on fewer slices
para.niter = 6;
para.dt = 0.1;

f0 = neoImg(:,:,101:106);
y0 = gauss3filter(f0,s);
ylr = my_downsample(y0,rate);
[fTV, errList_H] = fTestImageLRTV3D(ylr,rate,f0,para);

% I tested the above method, and get below results
% speed is acceptable
% [fTV, errList_H] = fTestImageLRTV3D(ylr,rate,f0,para);
% HaLRTC: iterations = 1   difference=0.657885
%  snr= 12.218735
% HaLRTC: iterations = 2   difference=0.508596
%  snr= 19.189320
% HaLRTC: iterations = 3   difference=0.158892
%  snr= 23.142400
% HaLRTC: iterations = 4   difference=0.116486
%  snr= 20.419477
% HaLRTC: iterations = 5   difference=0.141124
%  snr= 24.107353
% HaLRTC: iterations = 6   difference=0.193581
%  snr= 18.961545

% after revision on update of M
% HaLRTC: iterations = 1   difference=0.657885
%  snr= 12.218735
% HaLRTC: iterations = 2   difference=0.505030
%  snr= 21.299089
% HaLRTC: iterations = 3   difference=0.125684
%  snr= 24.434797
% HaLRTC: iterations = 4   difference=0.037805
%  snr= 25.189988
% HaLRTC: iterations = 5   difference=0.016834
%  snr= 25.504802
% HaLRTC: iterations = 6   difference=0.010369
%  snr= 25.687932
