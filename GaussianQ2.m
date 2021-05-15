function y = GaussianQ2(f, a, b)
  c0 = 1;
  c1=1;
  x0 = - c0 / sqrt(3);
  x1 = c1 / sqrt(3);
  
  x = @(xd) ((b+a) + (b-a) * xd) / 2;
  dx = (b-a)/2;
  
  f0 = f(x(x0));
  f1 = f(x(x1));
  
  y = (c0 * f0 + c1 * f1) * dx;

end
