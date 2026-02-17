function [Q, vertint] = calcula_Q(T)

    vertbmp = calcula_vertbmp(T); % Vertexs classificats, 1 int, 0 front.
    
    nv = length(vertbmp); % Longitud vector === # vertexs.
    nt = size(T, 1); % # files matriu === # triangles.
    
    vertint = find(vertbmp == 1); % Escollim vertexs int i els guardem.
    vertfront = find(vertbmp == 0); % Escollim vertexs front i els guardem.
    
    numer_vert = zeros(1, nv); % Vector tamany vertbmp amb zeros.
    
    numer_vert(vertint) = 1:length(vertint); %Numerem els vèrtexs
    numer_vert(vertfront) = -vertfront; 

    
    Q = zeros(nt, 3);
    for i = 1:nt
        for r = 1:3
            vertex = T(i, r); % Extraem el vertex de la fila i columna r.
            Q(i, r) = numer_vert(vertex); % Enviem a la matriu Q la classificacio del vert.
        end
    end
end