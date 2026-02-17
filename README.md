# 2D Finite Element Method (FEM) Solver
Este repositorio contiene una implementación eficiente en MATLAB del **Método de los Elementos Finitos (FEM)** para resolver problemas de valores en la frontera en abiertos acotados en 2 dimensiones.

El código aborda la ecuación de Poisson con condiciones de frontera de Dirichlet no homogéneas, utilizando una discretización espacial basada en una triangulación $\mathcal{T}$ que nos viene dada y **elementos finitos lineales a trozos ($P_1$ de Lagrange)**.

## 📋 Descripción del Problema
El código resuelve el siguiente problema con derivadas parciales:

$$
\begin{cases}
-\Delta u(x,y) = f(x,y) & \text{en } \Omega \\
u(x,y) = g(x,y) & \text{en } \partial\Omega
\end{cases}
$$

Donde:
* $\Omega \subseteq \mathbb{R}^2$ es un abierto acotado.
* $f \in L^2(\Omega)$ es el término fuente.
* $g \in \mathcal{C}(\partial\Omega)$ define las condiciones de frontera **no homogéneas**.

## 🚀 Características Principales
Esta implementación destaca por su enfoque en la eficiencia computacional y en el rigor matemático:

* **Matrices Dispersas (Sparse Matrixs):** El ensamblaje de la matriz de rigidez ($A$) se realiza utilizando almacenamiento disperso (`sparse`), optimizando el uso de memoria y tiempo de cómputo para mallas finas con gran número de nodos.
* **Integración Simbólica:** Implementación de cuadraturas exactas sobre el **triángulo de referencia** $\tilde{T}$ mediante cálculo simbólico para garantizar la máxima precisión en los términos de la formulación variacional.
* **Detección Automática de Fronteras:** Algoritmos internos (`calcula_vertbmp`, `calcula_Q`) para identificar automáticamente nodos interiores y nodos frontera a partir de la estructuración de la malla.
* **Visualización:** Incluye herramientas para visualizar tanto la malla (`triplot`) como la solución numérica que hemos desarrollado (`trisurf`).

## 🛠️ Estructura del Código
El código se estructura en 4 funciones que hacen tareas específicas importantes y un último script que, con las funciones y mallas dadas resuelve el problema:

### calcula_vertbmp(T)
Es nuestra función detectora de fronteras. Analiza la matriz de triángulos ($T$) para identificar qué vértices están en el borde del abierto y cuáles están en el interior. Devuelve un vector donde marca con 0 los de frontera y 1 los interiores.

### calcula_Q(T)
Esta función es, a grosso modo, un indexador. Utiliza la información del ejercicio anterior para generar la matriz $Q$ y el vector vertint. Su función es enumerar y organizar los grados de libertad reales (los nodos interiores donde resolverás la ecuación), separándolos de los nodos de frontera que ya tienen valor fijo. En un lenguaje más coloquial, esta matriz $Q$ nos ordena la información para que en las siguientes funciones y scripts nos sea más fácil trabajar.

### int_triangle(h, s)
Esta es la función que nos hace el cálculo exacto de integrales sobre el triangulo de referencia de Lagrange. Para ello, se puede observar que usamos cálculo simbólico. Esta función es fundamenyal para calcular los coeficientes de la matriz de rigidez sin errores de aproximación numérica.

### elfin2d(V, T, f, g)
Esta es la función principal. En ella se construye la matriz de rigidez $A$ (dispersa/sparse) y el vector  de términos independientes $b$. Con ello, se construye y se resuelve un sistema de ecuaciones con las que obtenemos nuestra aproximación. Además, en los nodos frontera también impone las condiciones de frontera no homogéneas ($g$) donde no tiene sentido resolver el sistema, modificando el sistema lineal y devolviendo la solución completa mejor aproximada $u_h$ para el abierto que nos interesa.

### script_10
En este script usamos un ejemplo, del que resolvemos el problema de manera exacta con el cálculo simbólico de matlab por una parte, y por otra calculamos la solución aproximada $u_h$ con las funciones ya mencionadas. Lo hacemos para 4 triangulaciones distintas (V1,T1),(V2, T2), (V3, T3), (V4,T4) que nos vienen dadas en el fichero "mallas.mat". Además, comparamos mediante una tabla de errores como de buenas han sido las aproximaciones y, gráficamente superponiendo la solución exacta con la aproximada.

## Conclusión.
La conclusión, como se puede ver en el script_10, es que nuestro código resuelve el problema satisfactoriamente, mostrando que con las triangulaciones más finas obtenemos una solución aproximada muy buena. Esto se ve reflejado tanto en la parte gráfica, donde las diferencias entre las gráficas entre la solución exacta y la aproximada son casi imperceptibles, como en las tablas de errores, donde se presentan errores de aproximación muy pequeños que disminuyen rápidamente conforme usamos triangulaciones más finas.


