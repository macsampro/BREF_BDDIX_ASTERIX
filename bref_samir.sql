--1. Liste des potions : Numéro, libellé, formule et constituant principal. (5 lignes)
select *
from potion p
;

--2. Liste des noms des trophées rapportant 3 points. (2 lignes)
select *
from categorie c
where nb_points = 3;

--3. Liste des villages (noms) contenant plus de 35 huttes. (4 lignes)
select *
from village v
where nb_huttes  > 35;

--4. Liste des trophées (numéros) pris en mai / juin 52. (4 lignes)
SELECT num_trophee
FROM trophee
WHERE date_prise BETWEEN '2052-05-01 00:00:00' AND '2052-06-30 23:59:59';


--5. Noms des habitants commençant par 'a' et contenant la lettre 'r'. (3 lignes)
SELECT nom
FROM habitant
WHERE nom
ILIKE 'a%' AND nom ILIKE '%r%';

--6. Numéros des habitants ayant bu les potions numéros 1, 3 ou 4. (8 lignes)
SELECT DISTINCT num_hab
FROM absorber
WHERE num_potion IN (1, 3, 4);


--7. Liste des trophées : numéro, date de prise, nom de la catégorie et nom du preneur. (10lignes)
SELECT t.num_trophee, t.date_prise, c.nom_categ, h.nom AS nom_preneur
FROM trophee t
    JOIN categorie c ON t.code_cat = c.code_cat
    JOIN habitant h ON t.num_preneur = h.num_hab;

--8. Nom des habitants qui habitent à Aquilona. (7 lignes)
select num_village
from habitant h
where num_village = 1;

--9. Nom des habitants ayant pris des trophées de catégorie Bouclier de Légat. (2 lignes)
SELECT habitant.nom
FROM habitant
    JOIN trophee ON habitant.num_hab = trophee.num_preneur
    JOIN categorie ON trophee.code_cat = categorie.code_cat
WHERE categorie.nom_categ = 'Bouclier de Légat';


--10. Liste des potions (libellés) fabriquées par Panoramix : libellé, formule et constituantprincipal. (3 lignes)
select potion.lib_potion , potion.formule , potion.constituant_principal
from potion
    join fabriquer on potion.num_potion = fabriquer.num_potion
    join habitant on fabriquer.num_hab  = habitant.num_hab
where habitant.nom = 'Panoramix';

--11. Liste des potions (libellés) absorbées par Homéopatix. (2 lignes)
select distinct potion.lib_potion
from potion
    join absorber on absorber.num_potion = potion.num_potion
    join habitant on absorber.num_hab = habitant.num_hab
where habitant.nom = 'Homéopatix';


--12. Liste des habitants (noms) ayant absorbé une potion fabriquée par l'habitant numéro 3. (4 lignes)
select distinct habitant.nom
from habitant
    join absorber on habitant.num_hab = absorber.num_hab
    join potion on absorber.num_potion = potion.num_potion
    join fabriquer on potion.num_potion = fabriquer.num_potion
where fabriquer.num_hab = '3';

--13. Liste des habitants (noms) ayant absorbé une potion fabriquée par Amnésix. (7 lignes)
select distinct h.nom
from habitant h
    join absorber a on h.num_hab = a.num_hab
    join potion p on a.num_potion = p.num_potion
    join fabriquer f on p.num_potion  = f.num_potion
    join habitant h2 on f.num_hab = h2.num_hab
where h2.nom  = 'Amnésix';


--14. Nom des habitants dont la qualité n'est pas renseignée. (2 lignes)
SELECT nom
from habitant h
where h.num_qualite  is null;

--15. Nom des habitants ayant consommé la Potion magique n°1 (c'est le libellé de lapotion) en février 52. (3 lignes)
select distinct h.nom
from habitant h
    join absorber a on h.num_hab = a.num_hab
    join potion p on a.num_potion = p.num_potion
    join absorber a2 on p.num_potion = a2.num_potion
where p.num_potion = 1 and a.date_a between '2052-02-01' and '2052-02-28';

--16. Nom et âge des habitants par ordre alphabétique. (22 lignes)

select nom, age
from habitant h
ORDER BY h.nom;

--17. Liste des resserres classées de la plus grande à la plus petite : nom de resserre et nom du village. (3 lignes)
SELECT r.nom_resserre, v.nom_village
FROM resserre r
    JOIN village v ON r.num_village = v.num_village
ORDER BY r.superficie DESC;

--18. Nombre d'habitants du village numéro 5. (4)

select COUNT(nom)
from habitant h
    join village v on h.num_village  = v.num_village
where v.num_village = '5';


--19. Nombre de points gagnés par Goudurix. (5)
select sum(nb_points)
from categorie c
    join trophee t on c.code_cat = t.code_cat
    join habitant h on t.num_preneur = h.num_hab
where h.nom = 'Goudurix';


--20. Date de première prise de trophée. (03/04/52)
select min(t.date_prise)
from trophee t
;


--21. Nombre de louches de Potion magique n°2 (c'est le libellé de la potion) absorbées. (19)
select sum(quantite)
from absorber a
    join potion p on a.num_potion  = p.num_potion
where p.lib_potion = 'Potion magique n°2';

--22. Superficie la plus grande. (895)
select max(r.superficie)
from resserre r;


--***

--23. Nombre d'habitants par village (nom du village, nombre). (7 lignes)
select v.nom_village , count(h.nom) as Nombre_habitants_par_village
from habitant h
    join village v on h.num_village = v.num_village
group by v.num_village
;



--24. Nombre de trophées par habitant (6 lignes)
SELECT t.num_preneur, h.nom, COUNT(t.num_preneur) AS nombre_trophees
FROM trophee t
    JOIN habitant h ON t.num_preneur = h.num_hab
GROUP BY t.num_preneur, h.nom;


--25. Moyenne d'âge des habitants par province (nom de province, calcul). (3 lignes)
select p.nom_province , round(avg(h.age),2)
from habitant h
    join village v on h.num_village = v.num_village
    join province p on V.num_province = p.num_province
group by p.nom_province
;



--26. Nombre de potions différentes absorbées par chaque habitant (nom et nombre). (9lignes)
SELECT h.nom, COUNT(DISTINCT a.num_potion) AS nombre_potions_diff
FROM habitant h
    JOIN absorber a ON h.num_hab = a.num_hab
GROUP BY h.nom;

--27. Nom des habitants ayant bu plus de 2 louches de potion zen. (1 ligne)

select h.nom
from habitant h
    join absorber a on h.num_hab = a.num_hab
    join potion p on a.num_potion = p.num_potion
where a.quantite > 2 and p.lib_potion = 'Potion Zen';


--***
--28. Noms des villages dans lesquels on trouve une resserre (3 lignes)
select v.nom_village
from village v
    join resserre r on v.num_village = r.num_village;

--29. Nom du village contenant le plus grand nombre de huttes. (Gergovie)
select v.nom_village
from village v
where nb_huttes = (
	select max(nb_huttes)
from village v2
);


--30. Noms des habitants ayant pris plus de trophées qu'Obélix (3 lignes).
SELECT h.nom
FROM habitant h
WHERE (
    SELECT COUNT(*)
FROM trophee t
WHERE t.num_preneur = h.num_hab
) > (
    SELECT COUNT(*)
FROM trophee t
    JOIN habitant h2 ON h2.num_hab = t.num_preneur
WHERE h2.nom = 'Obélix'
);



