function [Dxx,Dxy,Dyy] = Hessian2D(I,Sigma)    
% inputs,    
%   I : The image, class preferable double or single    
%   Sigma : The sigma of the gaussian kernel used    
%    
% outputs,    
%   Dxx, Dxy, Dyy: The 2nd derivatives    
    
if nargin < 2, Sigma = 1; end    
    
% Make kernel coordinates 3σ区间    
%[X,Y]   = ndgrid(-round(3*Sigma):round(3*Sigma));   
% N_row=round(2*Sigma);
N_row=round(2*Sigma);
if N_row<1, N_row=1;end
if     Sigma==0,Sigma=0.01;end
%高斯滤波
gausFilter = fspecial('gaussian',[N_row N_row],Sigma);      %matlab 自带高斯模板滤波
I=imfilter(I,gausFilter,'conv');
%双边滤波
% I=BilateralFilt2(I,Sigma,100,N_row);
% Build the gaussian 2nd derivatives filters    
% DGaussxx = 1/(2*pi*Sigma^4) * (X.^2/Sigma^2 - 1) .* exp(-(X.^2 + Y.^2)/(2*Sigma^2));    
% DGaussxy = 1/(2*pi*Sigma^6) * (X .* Y).* exp(-(X.^2 + Y.^2)/(2*Sigma^2));    
% DGaussyy = 1/(2*pi*Sigma^4) * (Y.^2/Sigma^2 - 1) .* exp(-(X.^2 + Y.^2)/(2*Sigma^2));    
DGaussxx=[0 0 0;1 -2 1;0 0 0];
DGaussxy = [0 0 0;0 1 -1;0 -1 1];
DGaussyy =[0 1 0;0 -2 0;0 1 0];

Dxx = imfilter(I,DGaussxx,'conv');    
Dxy = imfilter(I,DGaussxy,'conv');    
Dyy = imfilter(I,DGaussyy,'conv'); 