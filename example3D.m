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

s=1;
y0 = gauss3filter(f0,s);

slice = 100;
ylr = my_downsample(y0,rate);

figure(1);imshow(ylr(:,:,round(slice/2)),[]);
g = my_upsample(ylr,rate);
figure(2);imshow(g(:,:,slice),[]);
disp(snr(f0,g));
figure(3);imshow(f0(:,:,slice),[]);

%% image recover test on fewer slices
para.niter = 6;
para.dt = 0.1;

f0 = neoImg(:,:,101:106);
y0 = gauss3filter(f0,s);
ylr = my_downsample(y0,rate);
[fTV, errList_H] = fTestImageLRTV3D(ylr,rate,f0,para);

% I tested the above method, and get below results
% speed is acceptable
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
