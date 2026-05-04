function y = generarampa(N, m)
    # va creciendo linealmente, con pendiente m.
    y = zeros(1, N);
    for i = 1:N
        y(i) = i * m;
    end