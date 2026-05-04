% 1) Función senoidal
function [t,x] = generasen(tini,tfin,fm,fs,fase)
    Tm = 1/fm;
    t=tini:Tm:tfin-Tm;
    f = @(tiempo) sin(2*pi*fs*tiempo+fase);
    x = f(t);
endfunction

% 2) Función sinc

function [y,t] = generasinc(tini,tfin,fm,fs,fase)
    Tm = 1/fm;

    % linspace(inicio, fin, numero_de_puntos);
    % t = linspace(tini,tfin-Tm, Tm); no es posible ya que el ultimo parámetro que es el numero de puntos debe ser entero
    
    % inicio:paso:fin
    t = tini:Tm:tfin-Tm; % en cambio el parametro Tm es el paso, es decir la distancia entre cada valor
    x = 2*pi*fs*t;
    y = sin(x)./x;
    y(abs(x) < eps) = 1; % para evitar la indeterminación en x=0
    
endfunction

% 3) Onda cuadrada
function [c,t] = generacuad(tini,tfin,fm,fs,fase)
    Tm = 1/fm; % paso
    t=tini:Tm:tfin-Tm;
    v = mod(2*pi*fs*t + fase,2*pi);
    c = ones(size(t));
    c (v >= pi) = -1;
endfunction

