function [t,x] = generasen(tini,tfin,fm,fs,fase)
    Tm = 1/fm;
    t=tini:Tm:tfin-Tm;
    f = @(tiempo) sin(2*pi*fs*tiempo+fase);
    x = f(t);
endfunction