function [y,t] = generasync(tini,tfin,fm,fs,fase)
    Tm = 1/fm;

    % linspace(inicio, fin, numero_de_puntos);
    % t = linspace(tini,tfin-Tm, Tm); no es posible ya que el ultimo parámetro que es el numero de puntos debe ser entero
    
    % inicio:paso:fin
    t = tini:Tm:tfin-Tm; % en cambio el parametro Tm es el paso, es decir la distancia entre cada valor
    x = 2*pi*fs*t;
    y = sin(x)./x;
    y(abs(x) < eps) = 1; % para evitar la indeterminación en x=0
    
endfunction