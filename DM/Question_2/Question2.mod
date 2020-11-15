# Auteur : Viseux Eliot, Vanderplancke Thomas
# DM ML Question 2 modèle :

#------------------- Les Tableaux de données ---------------

# Tableau des Produits avec leur caractéristiques
set PRODUIT;

# Tableau des stock minimum de produit pour chaque magasin
set STOCK_MIN;

# Tableau des stock de produit du samedi de chaque magasin
set STOCK_SAMEDI;

#------------------ Les Paramètres -------------------------

# Le poid de chaque produit indicé dans le tableau PRODUIT, il doit être logiquement positif ou nul.
param poid {PRODUIT} >= 0;

# Le boolean fragile représenté par un 1 ou un 0.
param fragile {PRODUIT} >= 0;

# Le volume prit par chaque produits indicé dans le tableau PRODUIT, il est logiquement positif ou nul.
param volume {PRODUIT} >= 0;


# Le magasin A dans le tableau STOCK_MIN, les stocks minimum doivent être positif ou nul.
param A {STOCK_MIN} >= 0;

# Le magasin B dans le tableau STOCK_MIN, les stocks minimum doivent être positif ou nul.
param B {STOCK_MIN} >= 0;

# Le magasin C dans le tableau STOCK_MIN, les stocks minimum doivent être positif ou nul.
param C {STOCK_MIN} >= 0;


# Le magasin A dans le tableau STOCK_SAMEDI, les stocks présents du samedi doivent être positif ou nul.
param Abis {STOCK_SAMEDI} >= 0;

# Le magasin B dans le tableau STOCK_SAMEDI, les stocks présents du samedi doivent être positif ou nul.
param Bbis {STOCK_SAMEDI} >= 0;

# Le magasin C dans le tableau STOCK_SAMEDI, les stocks présents du samedi doivent être positif ou nul.
param Cbis {STOCK_SAMEDI} >= 0;


# Le poid maximal que peut supporter le vélo cargo , il doit être positif ou nul.
param cargo_poid >= 0;

# Le volume maximal que peut supporter le vélo cargo, il doit être positif ou nul.
param cargo_volume >= 0;


#------------------- Les Variables -------------------------

# La variable qui représente le chargement pour le trajet de A vers B, elle doit être inférieure au stock du samedi du magasin d'où il
# part car on ne peut pas charger plus que ce qu'il n'y a dans le magasin de départ. Le chargement doit être positif ou nul.
var chargement_A_vers_B {p in PRODUIT} <= Abis [p],>= 0;

# La variable qui représente le chargement pour le trajet de B vers C, elle doit être inférieure au stock du samedi du magasin d'où il
# part car on ne peut pas charger plus que ce qu'il n'y a dans le magasin de départ. Le chargement doit être positif ou nul.
var chargement_B_vers_C {p in PRODUIT} <= Bbis [p],>= 0;

# La variable qui représente le chargement pour le trajet de C vers A, elle doit être inférieure au stock du samedi du magasin d'où il
# part car on ne peut pas charger plus que ce qu'il n'y a dans le magasin de départ. Le chargement doit être positif ou nul.
var chargement_C_vers_A {p in PRODUIT} <= Cbis [p],>= 0;

# La variable qui représente ce que l'on décharge au magasin B, elle doit être supérieure au minimum demandé dans le magasin moins ce
# qu'il y a déjà du samedi.
var dechargement_B {p in PRODUIT} >= B [p] - Bbis [p];

# La variable qui représente ce que l'on décharge au magasin C, elle doit être supérieure au minimum demandé dans le magasin moins ce
# qu'il y a déjà du samedi.
var dechargement_C {p in PRODUIT} >= C [p] - Cbis [p];

# La variable qui représente ce que l'on décharge au magasin A, elle doit être supérieure au minimum demandé dans le magasin moins ce
# qu'il y a déjà du samedi.
var dechargement_A {p in PRODUIT} >= A [p] - Abis [p];

#------------------ L'objectif ------------------------------

# L'objectif est de minimiser le poid total transporté et dechargé on minimize donc la somme des poids des produits dans les différentes
# Variables de chargement et de déchargement.
        minimize poid_total :
                (sum {p in PRODUIT} chargement_A_vers_B [p]*poid [p])+(sum {p in PRODUIT} chargement_B_vers_C [p]*poid[p])+(sum {p in PRODUIT} chargement_C_vers_A [p]*poid[p])+(sum {p in PRODUIT} dechargement_B [p]*poid[p])+(sum {p in PRODUIT} dechargement_C [p]*poid[p])+(sum {p in PRODUIT} dechargement_A [p]*poid[p]);


#------------------- Les Contraintes -------------------------

#!!------ Pour Le trajet De A vers B ------!!#

# Le transport est limité à la capacité en poid du vélo cargo, la somme des poids des produits chargés du trajet A_vers_B ne peut donc
# pas dépasser La constante cargo_poid.
subject to capacite_poid_cargo :
sum {p in PRODUIT}  chargement_A_vers_B [p]*poid [p] <= cargo_poid;

# Le transport est limité à la capacité en volume du vélo cargo, la somme des volumes des produits chargés du trajet A_vers_B ne peut
# donc pas dépasser La constante cargo_volume.
subject to capacite_volume_cargo :
sum {p in PRODUIT} chargement_A_vers_B [p]*volume [p] <= cargo_volume;

# Le Chargement doit être supérieur ou égale au minimum du magasin vers lequel on va, ici B, donc supérieur au minimum de B moins ce
# qu'il y a du samedi dans le magasin B.
subject to min_charge {p in PRODUIT} :
chargement_A_vers_B [p] >= B [p] - Bbis [p];

# Cette contrainte force le dechargement à être positif ou nul.
subject to min_decharge_B {p in PRODUIT} :
dechargement_B [p] >= 0;

# Cette contrainte vérifie que le déchargement au magasin B des produits n'est pas supérieur au chargement des produits de A vers B.
subject to dechargement_limit_B {p in PRODUIT} :
dechargement_B [p] <= chargement_A_vers_B [p];



#!!------ Pour Le trajet De B vers C ------!!#


# Le transport est limité à la capacité en poid du vélo cargo, la somme des poids des produits chargés du trajet B_vers_C mais aussi des
# éventuels produits restants du précédent trajet de A vers B (représentés par le chargement de A vers B moins ce qui ont été
# déchargés à B) ne peut donc pas dépasser la constante cargo_poid.
subject to capacite_poid_cargo_2 :
(sum {p in PRODUIT}  (chargement_A_vers_B [p]*poid [p])) - (sum {p in PRODUIT} (dechargement_B [p]*poid [p])) + sum {p in PRODUIT} (chargement_B_vers_C [p]*poid [p]) <= cargo_poid;

# Le transport est limité à la capacité en volume du vélo cargo, la somme des volumes des produits chargés du trajet B_vers_C mais aussi
# des éventuels produits restants du précédent trajet de A vers B (représentés par le chargement de A vers B moins ce qui ont été
# déchargés à B) ne peut donc pas dépasser la constante cargo_volume.
subject to capacite_volume_cargo_2 :
sum {p in PRODUIT} (chargement_A_vers_B [p]*volume [p])- sum {p in PRODUIT} (dechargement_B [p]*volume [p]) + sum {p in PRODUIT} (chargement_B_vers_C [p]*volume [p]) <= cargo_volume;

# Le Chargement doit être supérieur ou égale au minimum du magasin vers lequel on va, ici C, donc supérieur au minimum de C moins ce
# qu'il y a du samedi dans le magasin C.
subject to min_charge_B_C {p in PRODUIT} :
chargement_B_vers_C [p] >= C [p] - Cbis [p];

# Cette contrainte vérifie que lors du chargement de B vers C, les produits chargés que l'on retire au magasin B respectent toujours la
# contrainte de stock minimum de B, pour cela on prend le stock du samedi de B, on ajoute les produits que l'on vient de décharger à B
# puis on retire ceux que l'on charge et on compare ce résultat au stock minimum de B pour voir si la condition est toujours respectée.
subject to condition_respecte_avant_chargement_vers_C {p in PRODUIT}:
(Bbis [p] + dechargement_B [p]) - chargement_B_vers_C [p] >= B [p];

# Cette contrainte force le dechargement à être positif ou nul.
subject to min_decharge_C {p in PRODUIT} :
dechargement_C [p] >= 0;

# Cette contrainte vérifie que le déchargement au magasin C des produits n'est pas supérieur au chargement des produits de B vers C.
subject to dechargement_limit_C {p in PRODUIT} :
dechargement_C [p] <= chargement_B_vers_C [p];


#!!------ Pour Le trajet De C vers A ------!!#

# Le transport est limité à la capacité en poid du vélo cargo, la somme des poids des produits chargés du trajet C_vers_A mais aussi des
# éventuels produits restants du précédent trajet de B vers C (représentés par le chargement de B vers C moins ce qui ont été
# déchargés à C) et aussi des éventuels produits restants de A vers B, ne peut pas dépasser la constante cargo_poid.
subject to capacite_poid_cargo_3 :
(sum {p in PRODUIT}  (chargement_A_vers_B [p]*poid [p])) - (sum {p in PRODUIT} (dechargement_B [p]*poid [p])) + sum {p in PRODUIT} (chargement_B_vers_C [p]*poid [p])  - (sum {p in PRODUIT} (dechargement_C [p]*poid [p])) + sum {p in PRODUIT} (chargement_C_vers_A [p]*poid[p]) <= cargo_poid;


# Le transport est limité à la capacité en volume du vélo cargo, la somme des volumes des produits chargés du trajet C_vers_A mais aussi
# des éventuels produits restants du précédent trajet de B vers C (représentés par le chargement de B vers C moins ce qui ont été
# déchargés à C) et aussi des éventuels produits restants de A vers B, ne peut pas dépasser la constante cargo_volume.
subject to capacite_volume_cargo_3 :
sum {p in PRODUIT} (chargement_A_vers_B [p]*volume [p])- sum {p in PRODUIT} (dechargement_B [p]*volume [p]) + sum {p in PRODUIT} (chargement_B_vers_C [p]*volume [p]) - (sum {p in PRODUIT} (dechargement_C [p]*volume [p])) + sum {p in PRODUIT} (chargement_C_vers_A [p]*volume[p])<= cargo_volume;

# Pour le dernier trajet, la quantité de produits transportés de C vers A doit être supérieure au stock min de A moins ce qu'il y a déjà
# du samedi MAIS aussi ce que l'on a retiré du premier trajet donc du chargement_A_vers_B.
subject to min_charge_C_A {p in PRODUIT} :
chargement_C_vers_A [p] >= A [p] - (Abis [p] - chargement_A_vers_B [p]) ;


# Cette contrainte vérifie que lors du chargement de C vers A, les produits chargés que l'on retire au magasin C respectent toujours la
# contrainte de stock minimum de C, pour cela on prend le stock du samedi de C, on ajoute les produits que l'on vient de décharger à C
# puis on retire ceux que l'on charge et on compare ce résultat au stock minimum de C pour voir si la condition est toujours respectée.
subject to condition_respecte_avant_chargement_vers_A {p in PRODUIT}:
(Cbis [p] + dechargement_C [p]) - chargement_C_vers_A [p] >= C [p];

# Pour le dernier trajet , il est dit dans l'enoncé que le vélo cargo doit être vide à la fin, donc le dernier déchargement est égale au
# dernier chargement puisque l'on dercharge tout.
subject to min_decharge_A {p in PRODUIT} :
dechargement_A [p] = chargement_C_vers_A [p];

# Cette contrainte vérifie que le déchargement au magasin A des produits n'est pas supérieur au chargement des produits de C vers A.
subject to dechargement_limit_A {p in PRODUIT} :
dechargement_A [p] <= chargement_C_vers_A [p];

