## 2D Finite Element Method (FEM) Solver

Este repositorio contiene una implementación robusta y eficiente en MATLAB del **Método de los Elementos Finitos (FEM)** para resolver problemas de valores en la frontera en dominios 2D arbitrarios.

El solver aborda la ecuación de Poisson con condiciones de frontera de Dirichlet no homogéneas, utilizando una discretización espacial basada en una triangulación $\mathcal{T}$ y **elementos finitos lineales a trozos ($P_1$ de Lagrange)**.

## 📋 Descripción del Problema

El código resuelve el siguiente problema diferencial parcial:

$$
\begin{cases}
-\Delta u(x,y) = f(x,y) & \text{en } \Omega \\
u(x,y) = g(x,y) & \text{en } \partial\Omega
\end{cases}
$$

Donde:
* $\Omega \subseteq \mathbb{R}^2$ es un dominio abierto acotado.
* $f \in L^2(\Omega)$ es el término fuente.
* $g \in \mathcal{C}(\partial\Omega)$ define las condiciones de frontera **no homogéneas**.

## 🚀 Características Principales

Esta implementación destaca por su enfoque en la eficiencia computacional y la precisión matemática:

* **Matrices Dispersas (Sparse Matrices):** El ensamblaje de la matriz de rigidez ($A$) se realiza utilizando almacenamiento disperso (`sparse`), optimizando el uso de memoria y tiempo de cómputo para mallas finas con gran número de nodos.
* **Integración Simbólica:** Implementación de cuadraturas exactas sobre el **triángulo de referencia** $\tilde{T}$ mediante cálculo simbólico para garantizar la máxima precisión en los términos de la formulación variacional.
* **Mapeo de Referencia:** Uso de transformaciones afines para mapear cada elemento $T \in \mathcal{T}$ al triángulo de referencia definido por los vértices $(0,0), (1,0), (0,1)$.
* **Detección Automática de Fronteras:** Algoritmos internos (`calcula_vertbmp`, `calcula_Q`) para identificar automáticamente nodos interiores y nodos frontera a partir de la topología de la malla.
* **Visualización:** Incluye herramientas para visualizar tanto la malla (`triplot`) como la solución numérica (`trisurf`).

## 🛠️ Estructura del Código

El núcleo del proyecto es la función `elfin2d`, diseñada modularmente:

```matlab
function uh = elfin2d(V, T, f, g)
