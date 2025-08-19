%% Longitud_Tuberia.m - ASCII con gnuplot (sin errores de comillas ni aviso)
more off;                           % desactiva el pager de Octave
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

% --- guardar datos en temporal ---
datafile = [tempname() '.dat'];
fid = fopen(datafile,'w');
fprintf(fid,'%.12g %.12g\n',[xv(:) yv(:)].');
fclose(fid);

% --- crear script de gnuplot en temporal ---
gpscript = [tempname() '.gp'];
fgp = fopen(gpscript,'w');
fprintf(fgp, 'set terminal dumb size 80,20\n');
fprintf(fgp, 'set title "y(x)=0.5x^2"\n');
fprintf(fgp, 'set key off\n');
fprintf(fgp, 'plot "%s" using 1:2 with lines notitle\n', datafile);
fclose(fgp);

% --- ejecutar gnuplot y capturar la salida ---
fprintf('\nGráfica ASCII:\n');
[status, cmdout] = system(sprintf('gnuplot "%s"', gpscript));
if status == 0
  fprintf('%s\n', cmdout);
else
  warning('gnuplot devolvió estado %d.\n%s', status, cmdout);
end

% --- limpiar temporales ---
if exist(gpscript,'file'), delete(gpscript); end
if exist(datafile,'file'), delete(datafile); end

fprintf('\nLongitud de arco en [%0.2f,%0.2f] ≈ %0.4f\n', a, b, arc_length);
