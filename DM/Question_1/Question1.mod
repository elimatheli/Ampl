#Auteur : Viseux Eliot, Vanderplancke Thomas
# DM ML Question 1 modèle :

#------------------- Les Tableaux de données ---------------

# Tableau des Produits avec leur caractéristiques
set PRODUIT;

# Tableau des Trajets (1 correspond par exemple au trajet de A vers B , le 2 à B vers C ect..)
set TRAJET;

#------------------ Les Paramètres ------------------------

# Le poid de chaque produit indicé dans le tableau PRODUIT, il doit être logiquement positif ou nul.
param poid {PRODUIT} >= 0;

# Le boolean fragile représenté par un 1 ou un 0.
param fragile {PRODUIT} >= 0;

# Le volume prit par chaque produits indicé dans le tableau PRODUIT, il est logiquement positif ou nul.
param volume {PRODUIT} >= 0;

# Le stock minimum (seulement de carottes pour cette question) indicé dans le tableau TRAJET, il doit être positif ou nul.
param min_stock {TRAJET} >=0;

# Le stock du samedi indicé dans le tableau TRAJET, il doit être positif ou nul.
param samedi {TRAJET} >=0;

# Le poid maximal que peut supporter le vélo cargo , il doit être positif ou nul.
param cargo_poid >= 0;

# Le volume maximal que peut supporter le vélo cargo, il doit être positif ou nul.
param cargo_volume >= 0;

#------------------- Les Variables -------------------------

# Le chargement pour chaque trajet, s correspond au tableau TRAJET (de 1 à 3 pour les 3 trajets) et p dans PRODUIT, le chargement
# est logiquement inférieur à la quantité que dispose le magasin le samedi, en effet on ne peut pas charger plus que ce que le magasin dispose. Il doit être positif ou nul, on ne peut pas charger négativement.
var chargement {s in 1..3,p in PRODUIT} <= samedi [s] ,>= 0;

# Le déchargement après chaque trajet, s correspond au tableau TRAJET (de 1 à 3 pour les 3 trajets) et p dans PRODUIT, Le chargement
# doit être supérieur ou égale à la quantité minimal du magasin ou l'on arrive car si il n'est pas assez grand on ne respectera pas le # stock minimal voulu. pour avoir le stock minimal voulu on prend le stock minimal et on retire ce qu'il y a déjà du samedi.
var dechargement {s in 1..3,p in PRODUIT} >= (min_stock [s] - samedi [s+1]);

#------------------ L'objectif ------------------------------

# L'objectif est de minimiser le poid total transporté et dechargé on minimize donc la somme des poids des produits dans les Variables
# chargement et déchargement.
        minimize poid_total :
                (sum {s in 1..3,p in PRODUIT} chargement [s,p]*poid [p]) + (sum {s in 1..3,p in PRODUIT} dechargement [s,p]*poid [p]);


#------------------- Les Contraintes -------------------------

# Le transport est limité à la capacité en poid du vélo cargo, la somme des poids des produits chargés ne peut donc pas dépasser
# La constante cargo_poid .
subject to capacite_poid_cargo {s in 1..3} :
sum {p in PRODUIT} chargement [s,p]*poid [p] <= cargo_poid;

# Le transport est limité à la capacité en volume du vélo cargo, la somme des volumes des produits chargés ne peut donc pas dépasser
# La constante cargo_volume .
subject to capacite_volume_cargo {s in 1..3} :
sum {p in PRODUIT} chargement [s,p]*volume [p] <= cargo_volume;

# Le poid minimal chargé doit répondre aux attentes de chaque magasins, il faut donc au minimum chargé les besoins minimal du prochain
# magasin chez qui l'on va. Le chargement doit donc être supérieur au minimum moins ce qu'il y a déjà le samedi du prochain magasin.
# Le S+1 vient du fait que notre tableau de données TRAJET est de la forme A B, B C, C A, A A, il sera expliqué dans le .dat
subject to min_charge {s in 1..2,p in PRODUIT} :
chargement [s,p] >= min_stock [s] - samedi [s+1];

# Cette contrainte est spécial au dernier trajet, car en effet lors du dernier trajet il faut prévoir le stock minimal moins ce qu'il y
# a du samedi MAIS aussi ce que l'on a retiré au magasin du premier chargement donc moins chargement [1]
subject to min_charge_dernier {s in 3..3,p in PRODUIT} :
chargement [s,p] >= min_stock [s+1] - (samedi [1] - chargement[1,p]);

# Cette contrainte décrit le comportement dit dans l'énoncé, c'est à dire lors du dernier Trajet on décharge tout le contenu du vélo
# dans le dernier magasin donc "Le dernier déchargement est égale au dernier chargement" car le vélo doit repartir vide à la fin.
subject to min_decharge_dernier {s in 3..3,p in PRODUIT}:
dechargement [s,p] = chargement [s,p];

# Cette contrainte est très importante car elle vérifie que lorsqu'on fait un chargement dans un magasin, Il ne faut pas que les
# produits que l'on a retirés passent en dessous du stock minimal dans le magasin. Cette condition commence au deuxième trajet car le
# premier trajet nous partons de A mais vu que nous repassons à la fin il ne faut pas prendre le stock minimal de A au debut.
subject to condition_respectee_apres_chargement {s in 2..3, p in PRODUIT} :
(samedi [s]+dechargement [s-1,p]) - (chargement [s,p]) >= (min_stock [s-1]);

# Cette contrainte force le déchargement à être positif ou nul.
subject to min_decharge {s in 1..3,p in PRODUIT} :
dechargement [s,p] >= 0;

# Cette contrainte vérifie que la somme des produits déchargés ne depassent pas la somme des produits chargés, en effet il est
# impossible de déchargé plus que ce que l'on a chargé.
subject to dechargement_limit {s in 1..3} :
sum {p in PRODUIT} dechargement [s,p] <= sum {p in PRODUIT} chargement [s,p];


