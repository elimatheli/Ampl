set OBJETS;

param Poids {OBJETS} >= 0;
param Volume {OBJETS} >= 0;
param Valeur {OBJETS} >= 0;
param Disponible {OBJETS} >=0;

param max_poids >= 0;
param max_volume >= 0;

var nbObjet {o in OBJETS} integer <= Disponible [o];

maximize profit :
        sum {o in OBJETS} nbObjet [o] * Valeur [o];

subject to limite_poids :
sum {o in OBJETS}
(nbObjet [o] * Poids [o]) <= max_poids;

subject to limite_volume :
sum {o in OBJETS}
(nbObjet [o] * Volume [o]) <= max_volume;
