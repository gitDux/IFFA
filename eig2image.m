%Find the eigenvalues of the hessian matrix and give the edge direction
function [Lambda1,Lambda2,Ix,Iy]=eig2image(Dxx,Dxy,Dyy)

%Find the eigenvalues
Dxx=double(Dxx);
Dxy=double(Dxy);
Dyy=double(Dyy);
temp=sqrt(double((Dxx-Dyy).^2+4*Dxy.^2));
v2_x=2*Dxy;
v2_y=Dyy-Dxx+temp;

%standardization
mag=sqrt(v2_x.^2+v2_y.^2);
i=(mag~=0);
v2_x(i)=v2_x(i)./mag(i);
v2_y(i)=v2_y(i)./mag(i);

%Orthogonalization
v1_x=-v2_y;
v1_y=v2_x;

mu1=0.5*(Dxx+Dyy+temp);
mu2=0.5*(Dxx+Dyy-temp);

%give the edge direction
check=abs(mu1)>abs(mu2);
Lambda1=mu1;
Lambda1(check)=mu2(check);
Lambda2=mu2;
Lambda2(check)=mu1(check);

Ix=v1_x;
Ix(check)=v2_x(check);
Iy=v1_y;
Iy(check)=v2_y(check);