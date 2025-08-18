%% Longitud_Tuberia.m - ASCII con gnuplot (sin aviso al salir)
more off;                           % ⇐ evita que el pager interfiera al salir
setenv('GNUTERM','dumb');           % terminal ASCII para gnuplot

y     = @(x) 0.5*x.^2;
dy_dx = @(x) x;

a = input('Ingrese el límite inferior (a): ');
b = input('Ingrese el límite superior (b): ');
if a >= b
  fprintf(2, 'Error: a debe ser < b\n');
  return;
end

integrand   = @(x) sqrt(1 + (dy_dx(x)).^2);
arc_length  = integral(integrand, a, b);

xv = linspace(a,b,80);
yv = y(xv);

% Guardar datos con I/O básico (robusto en Octave/MATLAB)
tmp = [tempname() '.dat'];
fid = fopen(tmp,'w');
fprintf(fid,'%.12g %.12g\n',[xv(:) yv(:)].');
fclose(fid);

% Comillas dobles alrededor de la ruta (mejor en Windows)
gp = sprintf(['set terminal dumb size 80,20; ', ...
              'set title "y(x)=0.5x^2"; ', ...
              'set key off; ', ...
              'plot "%s" using 1:2 with lines notitle'], tmp);
cmd = sprintf('gnuplot -e "%s"', gp);

fprintf('\nGráfica ASCII:\n');
[status, cmdout] = system(cmd);     % ⇐ capturo la salida en vez de escribir directo
if status == 0
  fprintf('%s\n', cmdout);
else
  warning('gnuplot devolvió estado %d.\n%s', status, cmdout);
end
delete(tmp);

fprintf('\nLongitud de arco en [%0.2f,%0.2f] ≈ %0.4f\n', a, b, arc_length);
