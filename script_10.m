%% Apartat A
clear all;

f = @(x,y) 8*x.^2.*sin(x.^2 + 3*y.^2 + 1) - 16*cos(x.^2 + 3*y.^2 + 1) + ...
           72*y.^2.*sin(x.^2 + 3*y.^2 + 1);
g = @(x,y) 2*sin(x.^2 + 3*y.^2 + 1);

u_exacta = @(x,y) 2*sin(x.^2 + 3*y.^2 + 1);

load('mallas.mat'); 

malles = {V1, T1; V2, T2; V3, T3; V4, T4};
num_malles = size(malles, 1);

resultats = []; % k, err1, err2, errInf

for k = 1:num_malles
    V = malles{k, 1};
    T = malles{k, 2};
    
    % 1. Traem la aproximacio amb cada malla
    uh = elfin2d(V, T, f, g);
    
    % 2. Calcular Error
    % Trobem vertexs interiors per a traure els errors
    vertbmp = calcula_vertbmp(T);
    vertint_idxs = find(vertbmp == 1);
    m = length(vertint_idxs);
    
    e_vec = zeros(m, 1);
    for j = 1:m
        idx = vertint_idxs(j);
        val_exact = u_exacta(V(idx,1), V(idx,2));
        format long
        e_vec(j) = val_exact - uh(idx);
    end
    
   % Calcul normes errors.
    err1 = (1/m) * sum(abs(e_vec));
    err2 = sqrt((1/m) * sum(e_vec.^2));
    errInf = max(abs(e_vec));
    
    resultats = [resultats; k, err1, err2, errInf];
    % A cada iteracio anem anyadint les normes dels erros.
    

   % Apartat B
     
        figure;
        subplot(1,2,1);
        trisurf(T, V(:,1), V(:,2), uh, 'FaceColor', 'interp', 'EdgeColor', [0.3 0.3 0.3], 'EdgeAlpha', 0.5);
        title(['Aproximacio (Malla ' num2str(k) ')']);
        xlabel('x'); 
        ylabel('y'); 
        colorbar;

        subplot(1,2,2);
        
        min_x = min(V(:,1)); max_x = max(V(:,1));
        min_y = min(V(:,2)); max_y = max(V(:,2));
        [Xg, Yg] = meshgrid(linspace(min_x, max_x, 100), ...
                            linspace(min_y, max_y, 100));
        Z_ex = u_exacta(Xg, Yg);
        
        surf(Xg, Yg, Z_ex, 'EdgeColor', 'none', 'FaceColor', 'interp');
        title('Solució Exacta (Real)');
        xlabel('x'); ylabel('y'); zlabel('u'); view(3); colorbar;

    figure(k); 
    clf;       
    hold on;  
    grid on;

    min_x = min(V(:,1)); max_x = max(V(:,1));
    min_y = min(V(:,2)); max_y = max(V(:,2));
    
    [Xg, Yg] = meshgrid(linspace(min_x, max_x, 60), linspace(min_y, max_y, 60));
    Z_ex = u_exacta(Xg, Yg);
    h1 = surf(Xg, Yg, Z_ex, 'EdgeColor', 'none', 'FaceColor', 'cyan');
    alpha(h1, 0.3); 

    h2 = trisurf(T, V(:,1), V(:,2), uh, ...
                 'FaceColor', 'interp', ...
                 'EdgeColor', 'k', ...      
                 'EdgeAlpha', 0.5, ...       
                 'FaceAlpha', 0.9);          

    legend([h2, h1], 'FEM (Aproximada)', 'Solució Exacta', 'Location', 'best');
    title(['Superposició Malla k=' num2str(k)]);
    xlabel('x'); 
    ylabel('y'); 
    zlabel('u');
    view(3);
    
    hold off;
    
end

% Mostrar taula
disp(' Taula de Errors:');
disp('   k      ||e||_1      ||e||_2      ||e||_inf');
disp(resultats);

format short


% --- Calcul de la Taula de Ratios (Simple) ---
% Volem veure quant es redueix el error cada vegada que refinem la malla.
% Ratio = Error_anterior / Error_actual

disp(' Divisio errors');
disp('   k       Ràtio 1     Ràtio 2     Ràtio Inf');

err1_n = resultats(1, 2);
err2_n = resultats(1, 3);
errInf_n = resultats(1, 4);

for i = 2:num_malles

    k_actual = resultats(i, 1);
    err1_2n = resultats(i, 2);
    err2_2n = resultats(i, 3);
    errInf_2n = resultats(i, 4);
    
    ratio1 = err1_n / err1_2n;
    ratio2 = err2_n / err2_2n;
    ratioInf = errInf_n / errInf_2n;
    
    fprintf('   %d      %8.4f    %8.4f    %8.4f\n', k_actual, ratio1, ratio2, ratioInf);
    
    err1_n = err1_2n;
    err2_n = err2_2n;
    errInf_n = errInf_2n;
end

