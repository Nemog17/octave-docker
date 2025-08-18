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

% Gráfica ASCII con ejes simples
nx = 80; ny = 20;
xv = linspace(a, b, nx);
yv = y(xv);
ymin = min(yv); ymax = max(yv);
canvas = repmat(' ', ny + 1, nx + 1); % espacio extra para los ejes
for idx = 1:nx
  row = round((yv(idx) - ymin)/(ymax - ymin)*(ny - 1)) + 1;
  col = idx + 1;                 % desplazar por eje Y
  canvas(ny - row + 1, col) = '*';
end
% Dibujar ejes X e Y
canvas(ny + 1, :) = '-';         % eje X en la parte inferior
canvas(:, 1) = '|';              % eje Y en la primera columna
canvas(ny + 1, 1) = '+';         % origen
% Mostrar la gráfica conservando los espacios en blanco
for r = 1:(ny + 1)
  fprintf('%s\n', canvas(r, :));
end

fprintf('\nLongitud de arco en [%0.2f,%0.2f] ≈ %0.4f\n', a, b, arc_length);

