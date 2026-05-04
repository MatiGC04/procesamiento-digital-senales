function [t,x] = generasenoidal(tini,tfin,fm,fs,fase,amplitud) # recordar que 2*fm<= fs para evitar aliasing
    if(2*fs > fm)
        warning('%f > %f', 2*fs, fm);
        warning('La frecuencia de muestreo no cumple con la relacion 2*fs <= fm. Habrá aliasing.');
    end
    Tm = 1/fm;
    t=tini:Tm:tfin-Tm;
    f = @(tiempo) amplitud*sin(2*pi*fs*tiempo+fase);
    x = f(t);
endfunction