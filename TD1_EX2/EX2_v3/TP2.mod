set PUB;
param budget >= 0;
param amount_of_people >= 0;
param cout {PUB} >= 0;
param auditeurs {PUB} >= 0;
param temps {PUB};
param min_pub {PUB} >=0;
param pub_personne {PUB} >= 0;
var nbPub {p in PUB} >= min_pub [p];

maximize auditeur :
sum {p in PUB} auditeurs [p] * nbPub [p];

subject to buget_limit :
sum {p in PUB}
(nbPub [p] * cout [p]) <= budget;

subject to production_semaine :
sum {p in PUB}
(nbPub [p] * pub_personne [p]) <= amount_of_people;
