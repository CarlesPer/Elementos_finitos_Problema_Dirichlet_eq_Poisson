function inth = int_triangle(h, s)
    s1 = s(1);
    s2 = s(2);
    % Extraem les 2 variables.

    inth = double(int(int(h, s2, 0, 1 - s1), s1, 0, 1));
end
% Com integrem en triangle (0,0), (1,0), (0,1) fem la integral de 0 a 1 per
% a la variable horitzontal i de 0 a 1-s1 per a la vertical (alçada) Notem
% que es una integral doble.