function R=rkf45(f,a,b,ya,M,tol)

%Input    - f is the function entered as a string 'f'
%         - a and b are the left and right endpoints
%         - ya is the initial condition y(a)
%         - M is the number of steps
%         - tol is the tolerance
%Output - R=[T' Y'] where T is the vector of abscissas
%         and Y is the vector of ordinates

% NUMERICAL METHODS: MATLAB Programs
%(c) 1999 by John H. Mathews and Kurtis D. Fink
%To accompany the textbook:
%NUMERICAL METHODS Using MATLAB,
%by John H. Mathews and Kurtis D. Fink
%ISBN 0-13-270042-5, (c) 1999
%PRENTICE HALL, INC.
%Upper Saddle River, NJ 07458

%Enter the coefficients necessary to calculate the 
%values in (28) and (29)

a2=1/4;b2=1/4;a3=3/8;b3=3/32;c3=9/32;a4=12/13;b4=1932/2197;
c4=-7200/2197;d4=7296/2197;a5=1;b5=439/216;c5=-8;d5=3680/513;
e5=-845/4104;a6=1/2;b6=-8/27;c6=2;d6=-3544/2565;e6=1859/4104;
f6=-11/40;r1=1/360;r3=-128/4275;r4=-2197/75240;r5=1/50;
r6=2/55;n1=25/216;n3=1408/2565;n4=2197/4104;n5=-1/5;

big=1e15;
h=(b-a)/M;
hmin=h/64;
hmax=64*h;
max1=200;
Y(1)=ya;
T(1)=a;
j=1;
br=b-0.00001*abs(b);

while (T(j)<b)
   if ((T(j)+h)>br)
      h=b-T(j);
   end
   
   %Calculation of values in (28) and (29)
   k1=h*feval(f,T(j),Y(j));
   y2=Y(j)+b2*k1;
   if big<abs(y2) break, end
   k2=h*feval(f,T(j)+a2*h,y2);
   y3=Y(j)+b3*k1+c3*k2;
   if big<abs(y3) break, end
   k3=h*feval(f,T(j)+a3*h,y3);
   y4=Y(j)+b4*k1+c4*k2+d4*k3;
   if big<abs(y4) break, end
   k4=h*feval(f,Y(j)+a4*h,y4);
   y5=Y(j)+b5*k1+c5*k2+d5*k3+e5*k4;
   if big<abs(y5) break, end
   k5=h*feval(f,T(j)+a5*h,y5);
   y6=Y(j)+b6*k1+c6*k2+d6*k3+e6*k4+f6*k5;
   if big<abs(y6) break, end
   k6=h*feval(f,Y(j)+a6*h,y6);
   
   err=abs(r1*k1+r3*k3+r4*k4+r5*k5+r6*k6);
   ynew=Y(j)+n1*k1+n3*k3+n4*k4+n5*k5;
   
   %Error and step size control
   if ((err<tol)|(h<2*hmin))
      Y(j+1)=ynew;
      if ((T(j)+h)>br)
         T(j+1)=b;
      else
         T(j+1)=T(j)+h;
      end
      j=j+1;
   end
   if (err==0)
      s=0;
   else
      s=0.84*(tol*h/err)^(0.25);
   end
   if ((s<0.75)&(h>2*hmin)) 
      h=h/2; 
   end
   if ((s>1.50)&(2*h<hmax))
      h=2*h;
   end
   if ((big<abs(Y(j)))|(max1==j)), break, end
   M=j;
   if (b>T(j))
      M=j+1;
   else
      M=j;
   end
end

R=[T' Y'];
