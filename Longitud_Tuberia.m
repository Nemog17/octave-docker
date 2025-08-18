%% Longitud_Tuberia.m - ASCII sin gnuplot
% Calcula la longitud de arco de y(x) definida por el usuario en [a,b]
% y muestra una gráfica ASCII sin usar gnuplot. La derivada se estima
% numéricamente con diferencias finitas.

while true
  func_str = input('Ingrese la función y(x) (vacío para salir): ', 's');
  if isempty(func_str)
    break;
  end

  try
    y = str2func(["@(x) " func_str]);
    % Prueba de evaluación para validar la función
    y(0);
  catch
    fprintf('Función inválida. Intente de nuevo.\n\n');
    continue;
  end

  a_in = input('Ingrese el límite inferior (a): ', 's');
  if isempty(a_in)
    break;
  end
  b_in = input('Ingrese el límite superior (b): ', 's');
  if isempty(b_in)
    break;
  end

  a = str2double(a_in);
  b = str2double(b_in);
  if isnan(a) || isnan(b)
    fprintf('Entradas no válidas. Intente de nuevo.\n\n');
    continue;
  end
  if a >= b
    fprintf('a debe ser < b\n\n');
    continue;
  end

  eps = 1e-6;
  dy_dx = @(x) (arrayfun(y, x + eps) - arrayfun(y, x - eps)) ./ (2 * eps);
  integrand = @(x) sqrt(1 + (dy_dx(x)).^2);
  arc_length = integral(integrand, a, b);

  % Gráfica ASCII con ejes simples
  nx = 80; ny = 20;
  xv = linspace(a, b, nx);
  yv = arrayfun(y, xv);
  ymin = min(yv); ymax = max(yv);
  scale = ymax - ymin;
  if scale == 0
    scale = 1;
  end
  canvas = repmat(' ', ny + 1, nx + 1); % espacio extra para los ejes
  for idx = 1:nx
    row = round((yv(idx) - ymin)/scale*(ny - 1)) + 1;
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

  fprintf('Rangos: x en [%0.2f,%0.2f], y en [%0.2f,%0.2f]\n', a, b, ymin, ymax);
  fprintf('Longitud de arco en [%0.2f,%0.2f] ≈ %0.4f\n\n', a, b, arc_length);
end

