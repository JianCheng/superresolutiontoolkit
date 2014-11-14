function [imagetype,imagesize,voxelsize,img] = readHeaderInMatlab(filename)

info = analyze75info(filename);
if info.Dimensions(4) == 1
    imagesize = double([info.Dimensions(1:3)]);
else
    imagesize = double([info.Dimensions(1:4)]);
end
voxelsize = [info.PixelDimensions(1:3)];
% hard define
if info.BitDepth == 8
    imagetype = 'uint8';
elseif info.BitDepth == 16
    imagetype = 'uint16';
elseif info.BitDepth == 32
    imagetype = 'float';
elseif info.BitDepth == 64
    imagetype = 'doulbe';
else
    disp(['BitDepth = ',num2str(info.BitDepth),' , hard define it as uint16']);
    imagetype = 'uint16';
end
% save
% fid = fopen([filename(1:end-4),'.img'],'r');
% img = fread(fid,imagetype);
% fclose(fid);
% img = reshape(img,imagesize);
img = analyze75read(info);
img = permute(img,[2 1 3]);
img = double(img);

% function [imgtype,xdim,ydim,zdim] = readHeaderInMatlab(filename)
% % read head
% if filename(end-2:end) == 'img'
%     filename = [filename(1:end-3),'hdr'];
% end
% fhead=fopen(filename,'rb');
% fread(fhead,40,'int8');%skip 40 byte
% mDim=fread(fhead,8,'int16');%read dim
% fread(fhead,14,'int8');%skip 14bype
% mType=fread(fhead,1,'int16');% read data type
% % hard decide
% if mType == 2
%     imgtype = 'uint8';
% elseif mType == 4
%     imgtype = 'uint16';
% elseif mType >= 8
%     imgtype = 'float';
% end
% fclose(fhead);
% xdim = mDim(2);
% ydim = mDim(3);
% zdim = mDim(4);

% function [imagetype,imagesize,voxelsize,img] = readHeaderInMatlab(filename)
% % read head
% if filename(end-2:end) == 'img'
%     filename = [filename(1:end-3),'hdr'];
% end
% 
% % % fix the space in file name
% % k = findstr(filename,' ');
% % filename2 = [];
% % step = 1;
% % for i = 1:size(k,2)
% %     filename2 = [filename2,filename(step:k(i)-1),'\'];
% %     step = k(i);
% % end
% % filename2 = [filename2,filename(k(i):end)];
% % disp(filename);
% % % fix end
% 
% fhead=fopen(filename,'rb');
% fread(fhead,40,'int8');%skip 40 byte
% mDim=fread(fhead,8,'int16');%read dim
% fread(fhead,14,'int8');%skip 14bype
% mType=fread(fhead,1,'int16');% read data type
% % hard decide
% if mType == 2
%     imagetype = 'uint8';
% elseif mType == 4
%     imagetype = 'uint16';
% elseif mType >= 8
%     imagetype = 'float';
% end
% fclose(fhead);
% info = analyze75info(filename);
% if info.Dimensions(4) ~= 1
%     imagesize = double([info.Dimensions(1:4)]);
% else
% imagesize = double([info.Dimensions(1:3)]);
% end
% voxelsize = [info.PixelDimensions(1:3)];
% 
% % read the image
% if nargout > 3
%     fid = fopen([filename(1:end-4),'.img'],'r');
%     img = fread(fid,imagetype);
%     fclose(fid);
%     img = reshape(img,imagesize);
% end
