addpath('../../../Funciones')

% pruebo la funcionn convolucion_circular
x = [1,2,2];
h = [2,1,0.5];

y_circular = convolucion_circular_formula(x, h);
disp('Resultado de la convolución circular:');
disp(y_circular);
n = 1 : length(y_circular);
figure('Name', 'Convolución circular', 'NumberTitle', 'on');
subplot(2,1,1);
stem(n, y_circular, 'filled', 'LineWidth', 1.5);
xlabel('n (muestras)');
ylabel('y[n]');

% pruebo convolucion_circular

y_circular_directa = convolucion_circular(x, h);
disp('Resultado de la convolución circular (método directo):');
disp(y_circular_directa);
subplot(2,1,2);
stem(n, y_circular_directa, 'filled', 'LineWidth', 1.5);
xlabel('n (muestras)');
ylabel('y[n]');

