[t,x] =  generasen(0,2,129,4000,0);
stem(t,x)
hold on
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('Señal Senoidal Muestreada')
grid on

#Genere y grafique una se ̃nal senoidal con frecuencia 4000 Hz y du-
#raci ́on 2 seg., utilizando una frecuencia de muestreo de 129 Hz. Grafique el
#resultado y estime la frecuencia de la onda sinusoidal que se observa en la
#figura. Analice y obtenga conclusiones

# como 2*fs no es <= fm. entronces