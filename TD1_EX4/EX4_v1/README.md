Le model de base nous donne ici une solution à 1288.370787 de profit

```bash
MINOS 5.51: optimal solution found.
4 iterations, objective 1288.370787
nbObjet [*] :=
       lecteur_DVD  13.0225
            montre  43.2584
telephone_portable  20
;
```

---


`var nbObjet {o in OBJETS} integer <= Disponible [o];`

Result :

```bash
Gurobi 8.1.0: optimal solution; objective 1285
2 simplex iterations
1 branch-and-cut nodes
nbObjet [*] :=
       lecteur_DVD  13
            montre  43
telephone_portable  20
;
```
