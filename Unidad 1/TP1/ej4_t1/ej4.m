fs = 5;
ts = 1/fs;

t0 = 0;
tf = 1;
fase = 0;

[t,x] = generasen(t0,tf,10,fs,fase)
stem(t,x)
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('Señal Senoidal Muestreada')
grid on
