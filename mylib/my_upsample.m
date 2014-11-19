function outMatrix = my_upsample(inMatrix, rate)

if nargin < 2
    rate = 2;
end
inSize = size(inMatrix);
dim = nb_dims(inMatrix);

if (dim==1)
    if inSize(1)==1
        inMatrix = inMatrix';
        inSize = size(inMatrix);
    end
    lengthOut = max(inSize)*rate;
    outMatrix = zeros(lengthOut,1);
    for i = 1:rate
        outMatrix(i:rate:end) = inMatrix;
    end
elseif (dim==2)
    if inSize(1)==1 || inSize(2)==1
        error('Logical Error');
    end
%     lengthOut = max(inSize)*rate;
    lengthOut = inSize*rate;
    outMatrix = zeros(lengthOut);
    for i = 1:rate
        for j = 1:rate
            outMatrix(i:rate:end,j:rate:end) = inMatrix;
        end
    end
elseif (dim==3)
    if inSize(1)==1 || inSize(2)==1 || inSize(3)==1
        error('Logical Error');
    end
    %lengthOut = max(inSize)*rate;
    lengthOut = inSize*rate;
    outMatrix = zeros(lengthOut(1),lengthOut(2),lengthOut(3));
    for i = 1:rate
        for j = 1:rate
            for k = 1:rate
                outMatrix(i:rate:end,j:rate:end,k:rate:end) = inMatrix;
            end
        end
    end
else
    error('TODO');
end