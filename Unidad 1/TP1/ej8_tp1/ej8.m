# x = s + r
# si yo quiero generar SNR de por ejemplo 20db = 10log10(Ps/Pr), necesito encontrar un r tal que el valor de Pr
# me de 20db
# sea rm = a*r0. q seria rm (ruido modificado) y r0 (ruido original)
# sabiendo q Potencia = 1/N * Sum( S[n]^2 ) para n=1 a N
# entonces Pr = 1/N * Sum( (a*r0[n])^2 ) = a^2 * Potencia del ruido original


[t,s] = generasen(0,1,50,150,0); # se debe respetar que 2*fm < fs para evitar aliasing

# genero ruido aleatorio

% size devuelve un vector con las dimensiones de S para que me permita sumarlo
r0 = randn(size(s)); # ruido blanco gaussiano con media 0 y varianza 1

X = r0 + s; # señal con ruido

# calculo la potencia de la señal y del ruido original
Ps = sum(s.^2)./length(s); # potencia de la señal
Pr0 = sum(r0.^2)./length(r0); # potencia del ruido original

# Relacion SNR
SNR = 10*log10(Ps./Pr0); # relacion señal a ruido en decibeles
fprintf('SNR original: %f dB\n', SNR) # imprimo el valor promedio de SNR
fprintf('Ps original: %f\n', Ps) # imprimo la potencia de la señal
fprintf('Pr original: %f\n', Pr0) # imprimo la potencia del ruido original


# multiplicar el ruido por un alfa
alfa = rand();
fprintf('alfa: %f\n', alfa); # imprimo el valor de alfa
r_modificado = alfa * r0; # ruido modificado
Pr = alfa.^2 * Pr0; # potencia del ruido modificado
SNR_new = 10*log10(Ps./Pr); # nueva relacion señal a ruido en decibeles
fprintf('SNR modificado: %f dB\n', SNR_new)

# 
alfa = sqrt(Ps./Pr0); # esto hara que SNR sea 0db.
fprintf('alfa para SNR=0dB: %f\n', alfa); 
SNR = 10*log10(Ps./(alfa.^2 * Pr0));
fprintf('SNR: %f dB\n', SNR)