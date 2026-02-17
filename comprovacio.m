clear all; clc;
syms x y real

u_cand = 2*sin(x^2 + 3*y^2 + 1);

f_calc = - (diff(u_cand, x, 2) + diff(u_cand, y, 2));

f_calc = simplify(f_calc);

disp('La f que genera aquesta u és:');
pretty(f_calc)

f_correcta = 8*x^2*sin(x^2 + 3*y^2 + 1) - 16*cos(x^2 + 3*y^2 + 1) + ...
             72*y^2*sin(x^2 + 3*y^2 + 1);
             
diff_f = simplify(f_calc - f_correcta);

if double(diff_f) == 0
    disp('Correcte.');
else
    disp('Incorrecte.');
end