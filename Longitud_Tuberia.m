%% Longitud_Tuberia.m - ASCII sin gnuplot
% Calcula la longitud de arco de y(x) = 0.5*x.^2 en [a,b]
% y muestra una gráfica ASCII sin usar gnuplot

y      = @(x) 0.5*x.^2;
dy_dx  = @(x) x;

a = input('Ingrese el límite inferior (a): ');
b = input('Ingrese el límite superior (b): ');
if a >= b, error('a debe ser < b'); end

integrand   = @(x) sqrt(1 + (dy_dx(x)).^2);
arc_length = integral(integrand, a, b);

% Gráfica ASCII simple
nx = 80; ny = 20;
xv = linspace(a, b, nx);
yv = y(xv);
ymin = min(yv); ymax = max(yv);
canvas = repmat(' ', ny, nx);
for idx = 1:nx
  row = round((yv(idx) - ymin)/(ymax - ymin)*(ny-1)) + 1;
  canvas(ny - row + 1, idx) = '*';
end

disp(char(canvas));

fprintf('\nLongitud de arco en [%0.2f,%0.2f] ≈ %0.4f\n', a, b, arc_length);

