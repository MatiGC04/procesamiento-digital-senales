function [t,y] = generaondacuadrada(tini,tfin,fm,fs,fase,amplitud)
    A = amplitud;
    Tm = 1/fm; # periodo de la señal
    t = tini:Tm:tfin-Tm;
    x = 2*pi*fs*t;
    y = -1*A*(mod(x+fase,2*pi)>=pi) + A*(mod(x+fase,2*pi)<pi);
endfunction