function y = RKM (f, x1, xf, y1, h)
  n=(xf-x1) /h;
  y=zeros(n+1,1);
  x= (x1:h: xf);
  y (1) =y1;
  for i=1: n
    k1 = f(x(i), y(i));
    k2 = f(x(i)+h/2, y(i)+h*k1/2);
    y(i+1) = y(i) + h*k2;
  end
end