# Ejercicio 2: Compruebe que el producto interno mide el grado de parecido entre
# dos señales dadas. Para ello, genere dos señales senoidales y realice el
# producto interno entre ellas. Evalúe el efecto que producen los distintos
# parámetros (A, f, φ) sobre el cálculo del producto interno.
addpath('../../Funciones');
clc;

tini = 0;
tfin = 20;
fm   = 10;

# Señal de referencia fija
f_fija    = 0.5;
fase_fija = 0;
A_fija    = 1;
[ts2, s2] = generasenoidal(tini, tfin, fm, f_fija, fase_fija, A_fija);
fprintf('Señal de referencia: A=%.1f  f=%.1f  phi=%.3f\n\n', A_fija, f_fija, fase_fija);

% Al duplicar A, el producto interno se duplica.
% Esto confirma la linealidad del producto interno: <A*x1, x2> = A * <x1, x2>
fprintf('=== EFECTO DE LA AMPLITUD (A) ===\n');
amplitudes = [0.5, 1, 2, 4];
for i = 1:length(amplitudes)
    A = amplitudes(i);
    [~, s1] = generasenoidal(tini, tfin, fm, f_fija, fase_fija, A);
    pi_val = producto_interno(s1, s2);
    fprintf('  A=%.1f -> producto interno = %.4f\n', A, pi_val);
end

% Cuando f1 == f2 el producto interno es máximo.
% Cuando f1 != f2 el resultado tiende a ~0: señales de distinta frecuencia
% son ortogonales en un período completo (no se "parecen").
fprintf('\n=== EFECTO DE LA FRECUENCIA (f) ===\n');
frecuencias = [0.1, 0.25, 0.5, 1.0, 1.5];
for i = 1:length(frecuencias)
    f1 = frecuencias(i);
    [~, s1] = generasenoidal(tini, tfin, fm, f1, fase_fija, A_fija);
    pi_val = producto_interno(s1, s2);
    fprintf('  f1=%.2f Hz -> producto interno = %.4f\n', f1, pi_val);
end

% El producto interno varía como cos(phi): máximo en phi=0 (señales idénticas),
% cero en phi=pi/2 (señales ortogonales) y mínimo en phi=pi (señales opuestas).
% Esto muestra que el producto interno mide el "alineamiento" entre señales.
fprintf('\n=== EFECTO DE LA FASE (phi) ===\n');
fases         = [0, pi/4, pi/2, 3*pi/4, pi];
nombres_fases = {'0', 'pi/4', 'pi/2', '3pi/4', 'pi'};
for i = 1:length(fases)
    [~, s1] = generasenoidal(tini, tfin, fm, f_fija, fases(i), A_fija);
    pi_val = producto_interno(s1, s2);
    fprintf('  phi=%-6s -> producto interno = %.4f\n', nombres_fases{i}, pi_val);
end

% El producto interno mide el grado de similitud entre dos señales, pero al variar
% la amplitud el resultado cambia aunque la forma sea idéntica.
% Esto se debe a que el producto interno depende tanto del ángulo entre las señales
% (similitud de forma) como de sus normas (amplitudes).
% Para medir similitud pura independiente de la amplitud se debería normalizar
% por las normas (similitud coseno), pero el enunciado pide solo el producto interno.
% Conclusión: el producto interno es una buena medida de similitud entre señales
% siempre que se tenga en cuenta la norma/energía de las mismas.