function [fTV, errList_H] = fTestImageLRTV3D(ylr,rate,f0,para)
% read a 3D image and produce out a 3D result.
% input: LR image, scale factor, the HR ground truth image
% output: HR image
% test the Image Deconvolution using Variational Method
% para is for parameters with a struct format, test exist: isfield(para,'t')

%%
% addpath mylib
% disp(para);
if nargin > 3
    if isfield(para,'rho') > 0 ; rho = para.rho; else rho = 0.1; end
    if isfield(para,'dt') > 0 ; dt = para.dt; else dt = 0.1; end
    if isfield(para,'epsilon') > 0 ; epsilon = para.epsilon; else epsilon = 1e-5; end
    if isfield(para,'lambdaTV') > 0 ; lambdaTV = para.lambdaTV; else lambdaTV = 0.01; end
    if isfield(para,'lambdaRank') > 0 ; lambdaRank = para.lambdaRank; else lambdaRank = 0.01; end
    if isfield(para,'niter') > 0 ; niter = para.niter; else niter = 20; end
    if isfield(para,'n') > 0 ; n = para.n; else n = 256; end
end

s = 1;
% y0 = double(gauss3filter(f0,s));

% x = [0:n/2-1, -n/2:-1];
% [Y,X] = meshgrid(x,x);
% h = exp( (-X.^2-Y.^2)/(2*s^2) );
% h = h/sum(h(:));
% Phi = @(x,h)real(ifft2(fft2(x).*fft2(h)));
h = s;

% rho = 0.1;
% dt = 0.1;
% epsilon = 1e-5;
% lambdaTV = 0.01;
% lambdaRank = 0.01;
% niter = 2; %20; % use 5 for fast testing.

alpha = [1, 1, 1];
alpha = alpha / sum(alpha);

if nargin <3        % f0 is not inputed
    f0 = my_upsample(ylr,rate);
%     f0 = f0(1:size(h,1),1:size(h,2));
end
    

%% High Accuracy LRTC (solve the original problem, HaLRTC algorithm in the paper)

[fTV, errList_H] = myHaLRTC_3D(...
    ylr, ...                       % a tensor whose elements in Omega are used for estimating missing value
    h, ... % kenerl
    rate, ... % rate
    alpha, ...                  % the coefficient of the objective function, i.e., \|X\|_* := \alpha_i \|X_{i(i)}\|_* 
    lambdaTV, ...   % for TV
    lambdaRank, ... % for low rank
    rho,...                      % the initial value of the parameter; it should be small enough  
    niter,...               % the maximum iterations
    dt,...  % for tv
    epsilon, ...                 % the tolerance of the relative difference of outputs of two neighbor iterations 
    f0 ...  % ground truth
    );
% disp(snr(f0,fTV));
