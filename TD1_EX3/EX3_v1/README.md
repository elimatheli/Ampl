Le model de base nous donne ici une solution à 194828.5714 de profit

```bash
ampl TP3_base.run
MINOS 5.51: optimal solution found.
2 iterations, objective 194828.5714
qte_produite [*] :=
  bandes  6000
 poutres  1028.57
rouleaux   500
;
```
Nous pouvons voir que dans le model de base il y a une contrainte "subject to" qui limite la somme des heures de production de chaque produit **inférieure** ou égale au nombre d'heures ouvrées.

Il suffit donc de changer la condition "<=" en "=".

Cela ne change pas le résultat car pour avoir le profit maximal, il faut la quantité maximale possible donc égale à la contrainte.
