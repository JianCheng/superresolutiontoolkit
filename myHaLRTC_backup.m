%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADM algorithm: tensor completion
% paper: Tensor completion for estimating missing values in visual data
% date: 05-22-2011
% min_X: \sum_i \alpha_i \|X_{i(i)}\|_*
% s.t.:  X_\Omega = T_\Omega
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function [X, errList] = myHaLRTC(T, Omega, alpha, beta, maxIter, epsilon, X)
function [X, out,gTV] = myHaLRTC_backup(T, h, rate, alpha, lambdaTV, lambdaRank, beta, maxIter, dt, epsilon, T0)
% the gTV is the first TV.

g = my_upsample(T,rate);
g=g(1:size(h,1),1:size(h,2)); 

X = g;

out.errList = zeros(maxIter, 1);
if ~isempty(T0)
    out.snr = zeros(maxIter, 1);
end
dim = size(T);
Y = cell(ndims(T), 1);
M = Y;

normT = norm(T(:));
for i = 1:ndims(T)
    Y{i} = zeros(size(X));
    M{i} = zeros(size(Y{i}));
end


for k = 1: maxIter
    % update X
    lastX = X;

   X = myTV(T, h,rate, M, Y,lambdaTV,beta,dt);
   % gTV is not the result from TV method
    if k == 1; gTV = X; end;
    
    % update M
    for i = 1:ndims(T)
        M{i} = Pro2TraceNorm(X+Y{i}, lambdaRank*alpha(i)/beta);
    end
    
    % update Y
    for i = 1:ndims(T)
        Y{i} = Y{i} + X - M{i};
    end
    
    % update information
    if ~isempty(T0)
        out.snr(k) = snr(T0, X);
    end
    
    out.errList(k) = norm(X(:)-lastX(:)) / normT;
    
    %if mod(k, 10) == 1
        fprintf('HaLRTC: iterations = %d   difference=%f\n', k, out.errList(k));
        %figure(10); imshow(X);
        
        if ~isempty(T0)
            fprintf(' snr= %f\n', out.snr(k));
        end
    %end
    beta = beta * 1.05;
    
    % stop check
    if out.errList(k) < epsilon
        break;
    end
end

out.errList = out.errList(1:k);
%fprintf('HaLRTC ends: total iterations = %d   difference=%f\n\n', k, out.errList(k));
end

function fTV = myTV(T,h,rate, M,Y,lambdaTV, rho,dt)
    %%
    Phi = @(x,h)real(ifft2(fft2(x).*fft2(h)));
    g = my_upsample(T,rate);
    g=g(1:size(h,1),1:size(h,2)); % this works when the downsample-upsampled image has different size with original image.

    fTV = g;
    % lambdaTV = 1./lambdaTV;
    % dt=0.1;
    niter=200;
    fValue=zeros(niter,1);
    tveps=1e-4;

    for i = 1 : niter

        aa = Phi(fTV,h);
        aa = my_upsample(my_downsample(aa,rate),rate);
        aa=aa(1:size(h,1),1:size(h,2)); 
        
        temp1 = Phi( g-aa , h);

        [ux,uy,uxx,uyy,uxy] = gradSecondOrder(fTV);

        temp2 =lambdaTV* (uxx.*(uy.^2+tveps) - 2*uxy.*ux.*uy + uyy.*(ux.^2+tveps) ) ./ ((ux.^2+uy.^2+tveps).^(1.5)) ;

        temp3 = zeros(size(M{1}));
        for jj = 1:ndims(fTV)
            temp3 = temp3 - rho*(fTV-M{jj}+Y{jj});
        end

        temp3 = temp1+temp2+temp3;
    %     temp3 = temp1+temp2;

        fTV = fTV + dt*temp3;
        fTV(fTV<0) = 0; % simple non-negative

        d = sqrt( tveps^2 + sum3([ux, uy].^2,3) );
        tv = sum(d(:));
        diff = (T-my_downsample(Phi(fTV,h),rate)).^2;
        fValue(i) = lambdaTV*tv + sum(diff(:));
        for jj = 1:ndims(fTV)
           diff = fTV-M{jj}+Y{jj};
           fValue(i) = fValue(i) + rho/2*norm(diff(:),'fro')^2;
        end
        if i>=2 && fValue(i)<fValue(i-1) && (fValue(i-1)-fValue(i))/fValue(i-1)<1e-5
    %         dt = dt*0.5;
    %         if dt<1e-8
    %             fTV = fTV - dt*temp3;
                break;
    %         end
        end
    end

end




