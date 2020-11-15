Pour cette Question, j'ai ajouté un param appelé *tonnage_max*, j'ai ajouté une contrainte **"subject to tonnage_maximum"** qui limite la sum totale de production au tonnage maximal.

Dans le fichier .dat le paramètre tonnage_max est fixé à 7000 et voici le résultat :
```bash
ampl TP3_v2.run
MINOS 5.51: optimal solution found.
3 iterations, objective 190071.4286
qte_produite [*] :=
  bandes  3357.14
 poutres  3142.86
rouleaux   500
;
```
Le modèle ici , avec une contrainte supplémentaire de tonnage, va voir sa variable qte_produite baisser si le tonnage max baisse et donc le profit baisser également.


