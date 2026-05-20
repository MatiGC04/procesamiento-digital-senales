
f =27;
fm = 50; % recordar que debe estar muestreada al doble, asi que lo que seguro pasa es que hay aliasing
t = 0:1/fm:1;
x = @(t) 2*sin(2*pi*f*t);

x_n = x(t);
N = length(x_n);
X_K = fft(x_n);
% ajusto
%X_K = fftshift(X_K);

k = -N/2 : N/2-1;
k = k * (fm/N); % vector de frecuencias en Hz

figure(2); clf;
stem(k, abs(X_K));