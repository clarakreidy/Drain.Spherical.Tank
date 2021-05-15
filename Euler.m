function y = Euler (f, x0, xf, y0, h)
  n=(xf-x0) /h; %number of steps
  y=zeros(n+1,1); % n+1 is the length of the discrete solution y
  x=(x0:h:xf);
  y(1)=y0;
  
  for i=1:n
    k1 = f(x(i),y(i)) ;
    y(i+1) = y(i) + h*k1 ;
  end
end