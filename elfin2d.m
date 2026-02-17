function uh = elfin2d(V, T, f, g)
    % V matriu vertex.
    % T matriu indexs vertexs triangle
    % f: funcio interior. 
    % g: Condicio front. Dirichlet.

    nv = size(V, 1); % # files V
    nt = size(T, 1); % # files T 
    
    [Q, vertint_idxs] = calcula_Q(T); % Calculem Q (diapo 16) i vertexs interiors.
    m = length(vertint_idxs); % # vertexs interiors(incognites a resoldre)
    
    syms s1 s2 real;
s = [s1; s2];

Lt = {1 - s1 - s2; s1; s2}; % Base de Lagrange

Dife_Lt = cell(3,1);

for r = 1:3
    Dife_Lt{r} = gradient(Lt{r}, s);
end    

    c = zeros(2, 2, 3, 3);
    for r = 1:3
        for t = 1:3
            for alpha = 1:2
                for beta = 1:2
                    expr = Dife_Lt{r}(alpha) * Dife_Lt{t}(beta);
                    c(alpha, beta, r, t) = double(int_triangle(expr, s));
                end
            end
        end
    end
    % Hem calculat els coeficients c_alpha_beta_r_t que apareixen a la
    % diapo 27.
    
    A = sparse(m, m); 
    b = zeros(m, 1);
    
    for i = 1:nt % Bucle on cada i es una fila distinta ( = triangle)
        idx_vert = T(i, :);  % indexs dels vertexs.
        A1 = V(idx_vert(1), :)'; 
        A2 = V(idx_vert(2), :)'; 
        A3 = V(idx_vert(3), :)';
        % Ens recuperem les coordenades dels vertexs A1,A2,A3 que formen triangle i.
        % Els posem en format columna.

       % 
        BK = [A2 - A1, A3 - A1]; % Matriu transformacio (diapo 4)
        det_BK = det(BK); 
        Di = abs(det_BK);  % Ens calculem el valor absolut del determinant de la transformacio
        Mi = Di * inv(BK' * BK); % formula diapo 17.
        
        centre = (A1 + A2 + A3) / 3;
        eval_f = f(centre(1), centre(2));
        % Avaluem el punt del triangle per a fer la quadratura
        % i aproximar la integral de f en el triangle (diapo 18)
        
        % Algorisme diapo 19 !!!
        for r = 1:3
            glob_idx_r = Q(i, r); 

            % Calcul termes independents (diapo 18)
            if glob_idx_r > 0 % Es a dir, node de dins.
                b(glob_idx_r) = b(glob_idx_r) + (Di / 6) * eval_f;
            end

            for t = 1:3
                glob_idx_t = Q(i, t); % Índex global (o codi) per a la columna
                val_rigidesa = 0;
                % segons la diapo 19 aci vindria un if glob_idx_t > 0,
                % pero com estem amb el problema no homogeni hem de
                % modificar l'algorisme
                for alpha = 1:2
                    for beta = 1:2
                        val_rigidesa = val_rigidesa + Mi(alpha, beta) * c(alpha, beta, r, t);
                    end
                end
                
                if glob_idx_r > 0 
                    if glob_idx_t > 0 
                        % Aresta entre nodes interiors, no sabem valor u. 
                        A(glob_idx_r, glob_idx_t) = A(glob_idx_r, glob_idx_t) + val_rigidesa;
                    else
                        % Aresta entre nodes interior-exterior. Sabem que
                        % val u_t
                        original_node_idx = -glob_idx_t; % llevem el signe negatiu.
                        node_coords = V(original_node_idx, :);
                        u_boundary_val = g(node_coords(1), node_coords(2));      
                        b(glob_idx_r) = b(glob_idx_r) - val_rigidesa * u_boundary_val;
                    end
                end
            end
        end
    end
    
    u_int = A \ b; % Resolem el sistema de incognites.
    
    uh = zeros(nv, 1);

    uh(vertint_idxs) = u_int; 

    is_boundary = true(nv, 1);
    is_boundary(vertint_idxs) = false; % Nodes interiors = 0, exteriirs = 1.
    boundary_indexs = find(is_boundary);
    
    for k = 1:length(boundary_indexs)
        idx = boundary_indexs(k);
        coords = V(idx, :); % Extraem les coordenades del vertex frontera
        uh(idx) = g(coords(1), coords(2)); % Condicions Dirichlet a la frontera !!!
    end
end