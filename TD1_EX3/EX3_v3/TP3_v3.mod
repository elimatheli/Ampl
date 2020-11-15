set PROD;
param heures_ouvrees >= 0;
param vitesse_production {PROD} >= 0;
param prix_vente {PROD} >= 0;
param vente_max {PROD} >= 0;
param vente_min {PROD} >= 0;
param tonnage_max >=0;
var qte_produite {p in PROD} >=vente_min [p], <=vente_max [p];
maximize tonnage_total :
sum {p in PROD} vente_max [p];

subject to production_limitee :
sum {p in PROD}
(qte_produite [p] / vitesse_production [p]) = heures_ouvrees;
