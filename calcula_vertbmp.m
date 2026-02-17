function vertbmp = calcula_vertbmp(T)
    % T matriu nt x 3
    
    nvertex = max(max(T)); % Busquem el index mes gran, que es # vèrtexs.
    
    arestes = [T(:,1), T(:,2);
               T(:,2), T(:,3);
               T(:,3), T(:,1)]; % Construisc les arestes relacionant 
    % tots els punts (vèrtexs) que estiguen a una mateixa fila.
 
    arestes = sort(arestes, 2); % Ordene arestes i elimine duplicats ([1,3] = [3,1] perr exemple)
    
    [C, ia, ic] = unique(arestes, 'rows'); 
    % Amb unique, aplicat a files, ens
    % generem el vector C de arestes que apareixen (sense duplicats), ia que
    % ens diu quin es el primer índex on apareix cada fila(no ens
    % interessa) i ic classifica cada aresta que apareix a quin lloc del vector
    % C pertany
    
    counts = accumarray(ic, 1); % Quantes vegades apareix cada posició del vector C ordenat. 
    
    arestes_frontera = C(counts == 1, :); % Amb counts==1, del vector counts que
    % compta quan apareix cada valor, si apareix una vegada marquem true i
    % si no false. Així, en els valors que posa true anem a la matriu C i
    % seleccionem les files indexades, que corresponen amb les arestes que
    % sols han sigut comptades una vegada i, per tant, son frontera.
    
    nodes_frontera = unique(arestes_frontera(:)); % Els nodes que uneixen les arestes frontera
    % son els vèrtexs frontera, i amb unique eliminem duplicats-
   
    vertbmp = ones(1, nvertex); %Inicialitzem vector de vèrtexs amb tots valent 1
    
    vertbmp(nodes_frontera) = 0;
    % Als valors frontera els avaluem a 0, i així els interiors valen 1 i
    % els frontera 0.
    
end