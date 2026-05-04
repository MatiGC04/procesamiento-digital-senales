# determinar, amplitud A, fase phi, freq fs, periodo Tm.

 % vector de tiempo

# phi = -2pi * fs*t1
# donde t1 indica el retardo temporal en segundos

#mirando el gráfico la amplitud es 3
A = 3; 
# El periódo Ts lo obtengo fijandome las lineas
# como se que un maximo ocurre cada 0.05s
# entonces 
Ts = 0.05;
fs = 1/0.05;

# la frecuencia muestral por otro lado, la calcule mirando el grafico
# si entre t c [0.01;0.02] hay 8 mediciones, entonces para obtener cuanto vale la frecuencia divido
fm = 8/(0.02 - 0.01)
Tm = 1/fm

# ahora para obtener la fase. sabemos por enunciado
# que fase = -2*pi*fs*t1. necesito t1
# para obtener t1 se que desde t0 hasta t1, pasaron
# 5 Tm (lo podria pensar como saltitos, entre cada frecuencia muestral)
t1 = 5* Tm;

# aghora si ya que tengo todo obtengo la fase (phi)
phi = -2*pi*fs*t1;

t = 0:Tm:0.1-Tm;
x = @(t) A*sin(2*pi*fs*t + phi); % señal original
#plot(t,x(t));
stem(t,x(t))