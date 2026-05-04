function h = respuesta_al_impulso(a,b, s)
	M = length(b);
	N = length(a);
	l = length(s);
	
	h = zeros(1, l);
	
	for n = 1 : l % debe comenzar el 1 porque el indice 0 en octave es el 1
		suma_M = 0;
		suma_N = 0;
		# tengo que hacer cada suma por separado
		for k = 1 : M
			indice_s =  n - (k-1)  % le resto uno pq recordar que la anterior formula era para los indices empezando en 0
			if indice_s > 0 
				suma_M = suma_M + b(k)* s(indice_s);
			end
		end
		for k = 2 : N
			indice_h =  n - (k-1);  % le resto uno pq recordar que la anterior formula era para los indices empezando en 0
			if indice_h > 0 
				suma_N = suma_N + a(k)* h(indice_h);
			end
		end
		
		if a(1) ~= 0
			h(n) = (suma_M - suma_N)/ a(1);
		else
			h(n) = (suma_M - suma_N);
		endif
	endfor
endfunction