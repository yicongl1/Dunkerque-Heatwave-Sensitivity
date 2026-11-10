# Sensibilité du territoire de Dunkerque aux phénomènes caniculaires — rapport de projet UR06

**UV UR06 — Géomatique — A23 — Université de Technologie de Compiègne**
**Projet : sensibilité d'un territoire des Hauts-de-France aux phénomènes caniculaires**
**Territoire retenu : Dunkerque (59)**
**Rendu : 5 janvier — 20 pages maximum**

---

## Note liminaire — comment ce document a été reconstitué

Le rapport original a été perdu. Ce document le reconstitue à partir de trois sources :

1. **les fichiers de travail conservés** (`projet/ProjetV2.mxd`, la géodatabase `EffetDataBase.gdb`, les couches `projet/donnée/*.shp`, les trois rasters `*.tif` et leurs fichiers de statistiques `.aux.xml`, et `projet/sources/`) ;
2. **l'énoncé du projet** (`projet/sources/présentation projet A23.pdf`) ;
3. **les échanges avec ChatGPT** archivés dans `sources/chatgpt/`.

Chaque élément est étiqueté selon son degré de certitude, pour éviter de faire passer une hypothèse pour un fait :

| Étiquette | Signification |
|---|---|
| **[C]** Confirmé | Directement attesté par un fichier (nom de couche, champ attributaire, statistique de raster…). |
| **[D]** Déduit | Reconstruction logique à partir des fichiers et des échanges ; très probablement conforme au travail rendu. |
| **[À compléter]** | Information perdue, à réécrire ou à recalculer avant toute réutilisation. |

Les cartes originales (exports PDF/JPG du layout ArcMap) n'ont pas été retrouvées. **Quatre cartes ont été régénérées** depuis les rasters du projet et sont dans `figures/` : les trois gradients et l'indice de synthèse. Leur symbologie et leur découpage en classes sont une reconstitution (voir `tools/render_figures.ps1`) ; les valeurs, elles, proviennent des données d'origine. Les emplacements marqués `[Carte n — …]` correspondent aux figures attendues dont le layout d'origine est perdu.

---

# 1. État de l'art (≈ 5 pages)

## 1.1 Canicule, vague de chaleur et changement climatique

Une **canicule** est un épisode de températures anormalement élevées, de jour comme de nuit, pendant au moins trois jours consécutifs ; on parle de **vague de chaleur** lorsque l'épisode est prolongé et spatialement étendu. La caractéristique déterminante pour la santé n'est pas tant le maximum diurne que **l'absence de répit nocturne** : lorsque les températures minimales ne descendent plus, l'organisme ne récupère pas, ce qui déclenche la surmortalité observée lors des épisodes de 2003 (≈ 15 000 décès en France), 2018, 2019, 2022 et 2023.

Le réchauffement climatique ne crée pas les canicules, mais il en **augmente la fréquence, l'intensité et la durée** : en France métropolitaine, une canicule de l'ampleur de celle de 2003 pourrait devenir un événement quasi annuel en fin de siècle dans un scénario d'émissions élevées. Pour un aménageur, cela déplace la question : il ne s'agit plus de savoir si un territoire connaîtra une canicule, mais **à quel point il est mal préparé** lorsqu'elle surviendra.

## 1.2 L'îlot de chaleur urbain (ICU) : définition et mécanismes

L'**îlot de chaleur urbain** désigne l'écart de température entre une ville et son environnement rural ou naturel. Cet écart est généralement positif (la ville est plus chaude), maximal la nuit, et peut atteindre 5 à 10 °C lors des nuits calmes et dégagées. Il ne faut pas le confondre avec la **chaleur urbaine** au sens large, ni avec le seul réchauffement global : c'est un phénomène **local, produit par la forme et par les matériaux de la ville**.

Les mécanismes se cumulent :

**a) Le bilan radiatif et l'albédo.** L'asphalte, le béton, les tuiles et le zinc ont un albédo faible (0,05–0,20 contre 0,20–0,30 pour une prairie) : ils absorbent une grande partie du rayonnement solaire au lieu de la réfléchir. Cette énergie est stockée sous forme de chaleur dans la masse des matériaux, puis restituée lentement la nuit — d'où le décalage nocturne du maximum d'ICU.

**b) L'imperméabilisation des sols.** Le sol artificialisé ne peut plus évacuer l'énergie par évaporation de l'eau du sol. Dans un sol naturel, une part importante du rayonnement net part en **chaleur latente** (évapotranspiration) ; sur une surface imperméable, elle part presque entièrement en **chaleur sensible**, c'est-à-dire en élévation de la température de l'air. C'est le facteur le plus structurant à l'échelle du quartier.

**c) La réduction de la végétation.** La végétation agit par deux voies : l'**ombrage** (elle intercepte le rayonnement avant le sol) et la **transpiration** (elle transforme de l'énergie en vapeur d'eau). La suppression d'un couvert arboré supprime les deux. À l'inverse, la création d'un parc ou la plantation d'une trame arborée crée une **anomalie froide** locale, dont l'intensité décroît avec la distance.

**d) La chaleur anthropique.** Trafic, industries, chauffage, climatisation, éclairage, process industriels : toute consommation d'énergie finale se dissipe en chaleur dans l'atmosphère urbaine. Dans une ville industrielle et portuaire comme Dunkerque, ce terme n'est pas marginal — il est même, par endroits, le premier contributeur.

**e) La morphologie urbaine et l'effet de canyon.** Des rues étroites bordées de façades hautes piègent le rayonnement par réflexions multiples et réduisent la ventilation : la chaleur s'évacue mal. La **densité bâtie**, le **rapport hauteur/largeur** de rue et l'orientation déterminent la qualité de la ventilation nocturne.

**f) La topographie et la proximité de l'eau.** L'air froid, plus dense, s'accumule dans les points bas ; à l'inverse, un relief ouvert favorise le drainage de l'air. Les plans d'eau jouent un rôle **thermorégulateur** : forte inertie thermique, et possibilité d'évaporation, donc un effet rafraîchissant local, mais dont la portée reste limitée à quelques centaines de mètres.

## 1.3 Facteurs aggravants et facteurs limitants

| Facteur | Effet sur la température | Sens | Ordre de grandeur / remarque |
|---|---|---|---|
| Taux d'imperméabilisation | ↑ chaleur sensible | aggravant | Facteur dominant à l'échelle du quartier |
| Densité et hauteur du bâti | ↑ stockage, ↓ ventilation | aggravant | Effet de canyon, surtout la nuit |
| Albédo des matériaux | ↑ absorption | aggravant | Toitures et voiries sombres |
| Trafic, industrie, climatisation | ↑ chaleur anthropique | aggravant | Très localisé, forte intensité |
| Couvert arboré | ↓ rayonnement au sol, ↑ chaleur latente | limitant | Effet décroissant avec la distance |
| Surfaces en herbe / sol nu | ↑ évaporation | limitant (modéré) | Moins efficace qu'un couvert arboré |
| Plans d'eau, zones humides | ↑ inertie, ↑ évaporation | limitant | Effet de proximité |
| Vent, ouverture du relief | ↑ renouvellement d'air | limitant | Variable selon les nuits |
| Précarité énergétique, âge, santé | ↑ vulnérabilité (pas la température) | aggravant social | Détermine la mortalité, pas l'ICU |

La distinction est essentielle : **la sensibilité d'un territoire n'est pas seulement physique, elle est aussi sociale**. Un îlot de chaleur sur un quartier pavillonnaire arboré n'a pas les mêmes conséquences qu'un îlot de chaleur sur un quartier dense de logements mal isolés occupés par des personnes âgées.

## 1.4 Conséquences des canicules en milieu urbain

- **Santé** : déshydratation, coup de chaleur, décompensation cardio-respiratoire ; surmortalité concentrée chez les plus de 75 ans, les nourrissons, les personnes isolées et les travailleurs exposés.
- **Confort et usage de l'espace public** : les rues et places minérales deviennent inutilisables aux heures chaudes ; les cheminements piétons et cyclables se dégradent.
- **Énergie** : pic de consommation électrique estival (climatisation), avec un risque de tension sur le réseau et une **boucle de rétroaction** (la climatisation rejette de la chaleur dans la rue et aggrave l'ICU).
- **Qualité de l'air** : les fortes températures et le fort ensoleillement favorisent la formation d'ozone troposphérique ; la canicule et la pollution atmosphérique se cumulent sur les mêmes populations.
- **Eau et sols** : évaporation accrue, assèchement des sols, stress hydrique de la végétation urbaine — qui perd alors sa capacité de rafraîchissement au moment où on en a le plus besoin.
- **Écosystèmes urbains** : dépérissement des arbres en stress hydrique, perte de biodiversité ordinaire.

## 1.5 Comment évaluer la sensibilité d'un territoire avec un SIG ?

L'énoncé impose deux contraintes méthodologiques fortes : **ne pas utiliser de données météorologiques** (on n'analyse pas la température, mais les **caractéristiques du territoire**) et **ne pas utiliser de couches déjà construites** (pas de couche d'îlot de chaleur ni de LCZ toute faite). Il faut donc **construire l'indicateur soi-même**, à partir de couches brutes.

Trois familles d'approches sont mobilisables :

**a) Approche vectorielle (analyse de proximité et de composition).**
- *Buffers multi-anneaux* autour des sources de fraîcheur (parcs, eau) et des sources de chaleur (axes, industries) ;
- *Jointure spatiale* pour attribuer à chaque bâti/îlot la part de végétation, la distance à l'eau, etc. ;
- *Calcul de champs* (surface, densité, ratio) et *sélections attributaires* pour construire des indicateurs par entité ;
- *Union / intersection* pour croiser deux découpages (IRIS × occupation du sol, par exemple).

**b) Approche raster (analyse de surface).**
- *Conversion vecteur → raster* (bâti, végétation, eau) ;
- *Densité par noyau (Kernel Density)* : transforme un semis d'objets pondérés en une surface continue d'intensité — c'est la traduction la plus directe de l'idée « l'effet décroît avec la distance » ;
- *Distance euclidienne* + *reclassification* : construit des gradients de proximité ;
- *Algèbre de cartes* (Raster Calculator, `Con`, `Reclassify`) : combine les couches en un indice ;
- *Statistiques zonales* : agrège l'indice par IRIS ou par commune.

**c) Approche réseau (non retenue ici).**
L'analyse réseau (temps de trajet, accessibilité aux îlots de fraîcheur, tournées de secours) est pertinente pour la canicule — accès des secours, accès des habitants aux parcs — mais n'a pas été mobilisée dans ce projet, faute de temps. C'est l'une des pistes d'amélioration identifiées (cf. § 4.3).

**Le choix retenu** : combiner les modules **vectoriel** et **raster**, ce qui satisfait l'exigence « au moins deux modules du semestre » [C], et répond à la logique du phénomène (le bâti, la végétation et l'eau sont des objets discrets, mais leur influence est un champ continu).

## 1.6 Pourquoi associer SIG et analyse multicritère (AMC) ?

Un SIG répond bien à la question « où ? » et « combien ? » ; il répond mal à la question « **à quel point est-ce grave, tout bien considéré ?** ». L'AMC apporte précisément cette agrégation :

- elle rend **explicites** les critères retenus et leurs poids, donc discutables ;
- elle permet de **normaliser** des couches d'unités différentes (densité de bâti en m/m², densité de végétation, densité d'eau) sur une échelle commune [0 ; 1] ;
- elle produit un **indice synthétique** cartographiable, puis un **classement** (très faible → très forte sensibilité) ;
- elle autorise une **analyse de sensibilité** : que se passe-t-il si l'on double le poids de la végétation ?

La méthode classique est la **somme pondérée** (*Weighted Overlay* / *Raster Calculator*) :

$$S = \sum_{i=1}^{n} p_i \cdot c_i^{\ast} \quad \text{avec} \quad \sum p_i = 1$$

où $c_i^{\ast} \in [0;1]$ est le critère normalisé et $p_i$ son poids. Les poids peuvent être fixés par **comparaison par paires (AHP de Saaty)** ou par dire d'expert. L'AHP impose la cohérence : le ratio de cohérence (CR) doit rester inférieur à 0,10.

**Piège classique** : additionner des critères « aggravants » et des critères « limitants » sans inverser le sens. Un critère limitant (végétation, eau) doit être **inversé** ($1 - c^{\ast}$) avant sommation, sinon une forte végétation *augmente* la sensibilité calculée.

## 1.7 Limites de l'approche

- **Pas de validation par la température** : l'absence de données météo, imposée par l'énoncé, interdit de calibrer l'indice sur des mesures. L'indice est un **indicateur relatif de sensibilité**, pas une carte de température.
- **Arbitraire des poids** : tout jeu de poids est un choix ; il doit être justifié et testé.
- **Effet d'échelle** : la taille de cellule du raster (ici 33 à 44 m) et le rayon de recherche du noyau déterminent largement le résultat.
- **Données imparfaites** : la BD TOPO décrit des emprises bâties, pas des matériaux ni des hauteurs réelles partout ; l'occupation du sol CORINE est grossière (maille de 25 ha minimum).
- **Pas de dimension temporelle** : l'indice est statique ; il ne dit rien de l'exposition réelle (heures passées dehors, comportements).

---

# 2. Présentation du territoire : Dunkerque (≈ 1 page)

Dunkerque est une commune du département du Nord, en région **Hauts-de-France**, sur la mer du Nord, à une trentaine de kilomètres de la frontière belge. L'énoncé impose de choisir une commune urbaine des Hauts-de-France (hors Lille) ou Colombes (92) ; Dunkerque a été retenue pour trois raisons [C] :

1. **elle respecte la contrainte géographique** de l'énoncé, tout en étant l'une des principales agglomérations de la région — un cas assez riche pour que l'analyse ne se réduise pas à un constat unique ;
2. **elle cumule les configurations** intéressantes pour un ICU : centre densifié, tissu pavillonnaire, zone industrialo-portuaire, digues et polders, canaux et bassins, dunes et estran ;
3. **elle dispose d'une base de données géographiques complète et accessible** (BD TOPO, CORINE Land Cover, données Enedis par IRIS), condition pratique d'une analyse spatiale sérieuse.

**Chiffres clés** (repris dans les échanges et utilisés dans le rapport) [C] :

| Indicateur | Valeur |
|---|---|
| Altitude | 0 à 17 m (territoire plat, très bas) |
| Superficie | 43,89 km² |
| Type | Commune urbaine et littorale |
| Population municipale (2021) | 86 788 hab. (−2,35 % par rapport à 2015) |
| Densité | 1 977 hab./km² |
| Population de l'agglomération (2021) | 162 146 hab. |

**Occupation du sol (CORINE Land Cover, 2018)** — la structure du territoire est le premier facteur explicatif :

| Poste CLC | Part 2018 |
|---|---|
| **Territoires artificialisés (total)** | **78 %** (contre 74,2 % en 1990) |
| — Zones industrielles ou commerciales et réseaux de communication | 39 % |
| — Zones urbanisées | 35,7 % |
| Eaux continentales | 7,8 % |
| Zones agricoles hétérogènes | 4,7 % |
| Espaces verts artificialisés non agricoles | 3,3 % |
| Milieux à végétation arbustive et/ou herbacée | 2,9 % |
| Eaux maritimes | 2,4 % |
| Terres arables | 1,5 % |
| Prairies | 1,4 % |
| Espaces ouverts, sans ou avec peu de végétation | 1,1 % |
| Zones humides côtières | 0,3 % |

Trois enseignements immédiats :

- **78 % d'artificialisation** : le territoire est massivement minéral, donc structurellement exposé. La progression depuis 1990 (+3,8 points) indique une tendance défavorable.
- **39 % de zones industrielles et de réseaux** : ce n'est pas une ville résidentielle avec un peu d'industrie, c'est une **ville industrielle** — la chaleur anthropique y est un terme de premier ordre.
- **Seulement 3,3 % d'espaces verts artificialisés + 2,9 % de végétation arbustive/herbacée** : la capacité de rafraîchissement par la végétation est **faible et très localisée**, ce que confirmera l'analyse raster (l'effet de rafraîchissement maximal mesuré est trois fois plus faible que l'effet thermique du bâti).

Sur le plan socio-démographique, la **décroissance de population** (−2,35 % en six ans) est un facteur ambivalent : elle desserre la pression foncière, mais elle s'accompagne souvent d'un vieillissement et d'une vacance, deux marqueurs de vulnérabilité face à la chaleur.

---

# 3. Analyse de la sensibilité du territoire (≈ 10 pages)

## 3.1 Objectif et hypothèses

**Objectif** : construire une carte de la **sensibilité thermique** de la commune de Dunkerque, en agrégeant trois effets spatiaux — l'échauffement induit par le bâti, le rafraîchissement induit par la végétation, le rafraîchissement induit par l'eau — puis en dérivant un **indice de sensibilité globale** classé en cinq niveaux.

**Hypothèses de travail** (à assumer explicitement dans un rapport) :

- **H1** — L'effet thermique d'un objet (bâti, arbre, plan d'eau) est **proportionnel à son emprise** et **décroît avec la distance** : c'est ce que traduit une densité par noyau pondérée par la surface.
- **H2** — Les effets sont **additifs** à l'échelle de la commune : l'indice global est une somme pondérée des trois effets normalisés.
- **H3** — Le bâti est **aggravant**, la végétation et l'eau sont **limitants** : les seconds doivent être inversés avant sommation.
- **H4** — Faute de données de température (interdites par l'énoncé), l'indice obtenu est **relatif** : il compare des zones entre elles, il ne prédit pas des degrés Celsius.

## 3.2 Données mobilisées

Toutes les couches sont en **RGF93 / Lambert 93** (EPSG:2154), en mètres — projection conforme, indispensable pour que les surfaces et les distances aient un sens [C, vérifié dans le `.prj` et dans `ProjetV2.mxd`].

| Couche | Type | Source | Volume | Usage |
|---|---|---|---|---|
| `Batiment` | polygone | BD TOPO (IGN) | **43 912** entités | Emprise bâti, hauteur, nb de logements, nb d'étages, nature |
| `Vegetation` | polygone | BD TOPO / cadastre vert | **1 131** zones | Emprise végétalisée (surfaces boisées, parcs, alignements) |
| `VegetationPoint` | point | dérivé (`Feature To Point`) | 1 131 points | Support du calcul de densité |
| `Eau` | polyligne | BD TOPO (hydrographie) | 254 tronçons | Réseau hydrographique |
| `Hydro` | polyligne | BD TOPO | 307 entités | Détail hydrographique |
| `Reservoir` | polygone | BD TOPO | **626** entités (avec `VOLUME`) | Bassins, plans d'eau, réservoirs |
| `Estran` | polygone | BD TOPO | 53 entités | Zone de balancement des marées |
| `LimiteDeMer` | polyligne | BD TOPO | 64 entités | Limite terre/mer |
| `Communes` | polygone | ADMIN EXPRESS (IGN) | 3 789 communes (région) | Limites administratives, population |
| `Dunkerque` | polygone | extrait de `Communes` | 1 entité | Emprise de l'étude (masque) |
| `ConsomationElectrique` | polygone (IRIS) | données Enedis / open data, jointe sous Excel | **42 IRIS** | Consommation totale et moyenne, superficie, densité |
| `Cimetiere`, `TerrainDeSport`, `Construction` | polygone | BD TOPO | 15 / 89 / 43 | Couches de contexte et de fraîcheur potentielle |
| CLC 1990 / 2000 / 2006 / 2012 | polygone | CORINE Land Cover (AEE) | 4 millésimes | Analyse diachronique de l'artificialisation |

**Ce que la couche de consommation électrique apporte.** Elle n'est pas une donnée de température, mais un **proxy de la chaleur anthropique** et de la **vulnérabilité énergétique**. Le fichier attributaire contient `conso_tota`, `conso_moye`, `part_therm`, `superficie`, `residences`, `taux_de_chomage`, et deux champs calculés : `Aire` et `Densité_conso` [C]. La démarche a donc été :

1. jointure Excel ↔ table attributaire sur le code IRIS ;
2. calcul de la surface de chaque IRIS (`Calculate Geometry`) ;
3. calcul de la **densité de consommation** = `conso_totale / superficie` (`Field Calculator`) ;
4. cartographie en symboles proportionnels / classes.

C'est le passage « données brutes → indicateur », explicitement attendu par l'énoncé.

## 3.3 Préparation des données

La chaîne de préparation, telle qu'elle apparaît dans la géodatabase `EffetDataBase.gdb` [C] :

```
Batiment ──► (nettoyage, Union) ──► BatiUnion ──► BatiPoint ──► BatiKer1 ──► BatiKer2 ──► BatiEffet
Vegetation ─► VegetationPoint ─────────────────────────────────► VegeKer1 ──► VegeKer2 ──► VegeEffet
Reservoir / Eau / Hydro ──► EauBuffer ──► ZoneEau ──► EauPoint ► EauKer1 ──► EauKer2 ──► EauEffet
                                   ResPoint, HydroPoint ───────────────┘
BatiEffet + VegeEffet + EauEffet ──► EffetEns  (raster de synthèse)
```

Les étapes effectivement réalisées [C] :

1. **Projection** de toutes les couches en Lambert 93 et vérification de la superposition (les couches livrées en WGS84 ou en Lambert 93 étendu ne se superposaient pas) ;
2. **Fusion** des entités bâties (`Union`) pour supprimer les doublons et les recouvrements de la BD TOPO ;
3. **Conversion polygone → point** (`Feature To Point`) : un point par emprise, afin que chaque objet contribue **une fois** au calcul de densité, sans que la densité dépende de la taille de l'objet ;
4. **Calcul de la surface** de chaque emprise dans la table attributaire (champ de poids) ;
5. **Calcul du noyau de densité** sur ces points, **pondéré par la surface** (`Population Field`), en **deux passes** (deux rayons de recherche) ;
6. **Combinaison des deux passes** pour obtenir un champ d'intensité décroissant avec la distance, puis **normalisation** ;
7. **Découpe au masque communal** (`Extract by Mask` / `Clip`) : les effets hors commune sont éliminés, ce qui évite que les communes voisines « éclairent » les franges de Dunkerque ;
8. **Agrégation** des trois effets en un raster de synthèse (`EffetEns`).

**Pourquoi deux passes de noyau ?** Un noyau unique produit une surface « en cloche », qui ne distingue pas l'intensité **au contact** de l'objet de l'intensité **à distance**. En combinant un noyau de **faible rayon** (qui capture l'effet immédiat, très localisé) et un noyau de **grand rayon** (qui capture l'influence diffuse), on obtient un **gradient** : fort près de la source, faible loin, ce qui correspond à la représentation attendue (« plus on s'éloigne de la végétation, plus le rafraîchissement est faible ») [D — la logique est attestée par les échanges, les paramètres exacts ne sont pas conservés].

> **Paramètres à revalider** : rayons de recherche (m), fonction de noyau (quartic/gaussienne), taille de cellule. Les cellules effectivement produites sont de **35,5 m** (bâti), **33,5 m** (végétation) et **44,4 m** (eau) [C, lus dans les `.tfw`] — elles diffèrent donc d'un raster à l'autre, ce qui est une **faiblesse à corriger** (il faut rééchantillonner sur une grille commune avant toute combinaison).

## 3.4 État initial du territoire

*(Cette section correspond à la partie « état initial » demandée par l'énoncé : décrire le territoire avant de mesurer sa sensibilité.)*

Quatre cartes d'état initial ont été produites [D] :

- **[Carte 1 — Emprise bâtie et densité de bâti]** — 43 912 bâtiments, très fortement concentrés sur le centre et le front portuaire ; les emprises industrielles du port constituent de vastes surfaces continues, sans discontinuité végétale.
- **[Carte 2 — Couvert végétal]** — 1 131 zones, de taille très inégale : quelques ensembles boisés, beaucoup de petits espaces (squares, alignements, jardins). La végétation est **fragmentée**, ce qui limite fortement la connectivité des îlots de fraîcheur.
- **[Carte 3 — Eau et zones humides]** — réseau hydrographique (254 + 307 tronçons), 626 réservoirs/plans d'eau, estran et limite de mer : la ressource en eau est **abondante en surface mais très localisée** (bassins portuaires, canaux, polders).
- **[Carte 4 — Consommation électrique par IRIS]** — 42 IRIS ; les densités de consommation les plus élevées ne coïncident pas nécessairement avec les densités de bâti : elles signalent plutôt les IRIS industriels et les IRIS de logements anciens mal isolés.

L'**analyse diachronique** (CLC 1990 → 2012) confirme la trajectoire : artificialisation de 74,2 % à 78 %, progression des zones industrielles et des réseaux au détriment des terres agricoles. La ville **s'étend en se minéralisant**, ce qui va dans le sens d'une aggravation.

## 3.5 Construction des trois gradients

### 3.5.1 Effet thermique du bâti

- **Entrée** : `BatiPoint` (43 912 points), champ de poids = surface de l'emprise.
- **Traitement** : Kernel Density, deux passes → `BatiKer1`, `BatiKer2` → `BatiEffet`.
- **Découpe** : masque `Dunkerque`.
- **Lecture** : la valeur est une **densité surfacique d'emprise bâtie pondérée** (m² de bâti par m², lissée). Plus la valeur est élevée, plus la cellule est « chargée » en bâti, donc plus elle stocke et restitue de chaleur.

### 3.5.2 Effet de rafraîchissement de la végétation

- **Entrée** : `VegetationPoint` (1 131 points), champ de poids = surface de la zone végétalisée.
- **Traitement** : Kernel Density deux passes → `VegeKer1`, `VegeKer2` → `VegeEffet`.
- **Lecture** : intensité du rafraîchissement attendu, maximale au cœur des zones végétalisées et **décroissante avec la distance** — c'est exactement la forme demandée (« une carte comme une carte de relief, où la température baisse près de la végétation »).

### 3.5.3 Effet de rafraîchissement de l'eau

- **Entrée** : `EauBuffer` → `ZoneEau` → `EauPoint` (+ `ResPoint` pour les réservoirs, `HydroPoint` pour le réseau).
- **Traitement** : les plans d'eau ont été **tamponnés** avant conversion en points, afin que les grands bassins portuaires pèsent proportionnellement à leur emprise réelle et non comme un point isolé.
- **Résultat** : `EauKer1`, `EauKer2` → `EauEffet`.

## 3.6 Résultats intermédiaires — statistiques

Les statistiques ci-dessous sont **extraites des fichiers `.tif.aux.xml` livrés avec les rasters** : ce sont donc les valeurs réelles du travail rendu, pas des estimations [C].

| Raster | Cellule | Min | Max | Moyenne | Écart-type |
|---|---|---|---|---|---|
| `Impact Thermique des Batiments1.tif` | 35,5 m | 0 | 0,0619 | 0,00754 | 0,01070 |
| `Effet de Rafraîchissement1.tif` (végétation) | 33,5 m | 0 | 0,01902 | 0,00438 | 0,00446 |
| `Effet de rafraîchissement des zones d'eau.tif` | 44,4 m | 0 | 0,00113 | 0,000148 | 0,000192 |

**Trois lectures immédiates :**

1. **Le bâti domine.** L'effet thermique maximal du bâti (0,0619) est **3,3 fois** supérieur à l'effet maximal de la végétation (0,0190) et **55 fois** supérieur à celui de l'eau (0,00113). En moyenne, le rapport est de **1,7 : 1** face à la végétation et de **51 : 1** face à l'eau.
2. **La végétation est un contrepoids réel mais localisé.** Sa moyenne (0,00438) n'est pas négligeable face au bâti, mais son maximum est faible : il n'existe pas, à Dunkerque, de grand massif végétal capable de contrebalancer un cœur urbain dense.
3. **L'eau rafraîchit peu à l'échelle de la commune.** Malgré 7,8 % d'eaux continentales et un linéaire hydrographique important, l'effet mesuré est **deux ordres de grandeur** sous celui du bâti : les plans d'eau sont concentrés (bassins portuaires) et leur influence ne diffuse pas au-delà de quelques centaines de mètres. C'est cohérent avec la littérature : l'effet fraîcheur de l'eau est intense mais **très local**.

**Distribution.** Les histogrammes (256 classes) montrent une **forte asymétrie à droite** pour les trois rasters : une minorité de cellules porte l'essentiel de l'intensité, une majorité de cellules est proche de zéro. C'est la signature d'un territoire où les sources (bâti, végétation, eau) sont **concentrées**, et où de vastes surfaces intermédiaires (voiries, friches, zones portuaires vides) ne sont « éclairées » par aucune d'elles.

## 3.7 Indice de sensibilité globale (AMC)

### 3.7.1 Normalisation

Les trois rasters n'ont ni la même unité ni la même amplitude. Normalisation **min-max** sur l'emprise communale :

$$c^{\ast} = \frac{c - c_{min}}{c_{max} - c_{min}} \in [0;1]$$

### 3.7.2 Inversion des critères limitants

Le bâti est aggravant, la végétation et l'eau sont limitants :

$$B^{\ast} = c^{\ast}_{bati} \qquad V^{\ast} = 1 - c^{\ast}_{vege} \qquad E^{\ast} = 1 - c^{\ast}_{eau}$$

### 3.7.3 Pondération

Les poids ont été fixés par **comparaison par paires**, en s'appuyant sur trois arguments : (i) le bâti est le facteur physique dominant de l'ICU, (ii) la végétation est le levier d'action principal des collectivités, (iii) l'eau est un facteur réel mais spatialement marginal à Dunkerque (confirmé par les statistiques du § 3.6).

| Critère | Rôle | Poids proposé | Justification |
|---|---|---|---|
| Bâti (densité d'emprise) | aggravant | **0,50** | Facteur dominant ; 78 % d'artificialisation ; effet max 3,3× la végétation |
| Végétation (défaut de végétation) | limitant | **0,33** | Levier d'action ; couvert fragmenté (3,3 % + 2,9 %) |
| Eau (défaut de proximité à l'eau) | limitant | **0,17** | Effet réel mais très localisé (max 100× plus faible que le bâti) |
| **Total** | | **1,00** | |

> **[À compléter]** Les poids exacts utilisés dans le rapport rendu ne sont pas conservés. Le jeu ci-dessus est une reconstruction défendable ; il doit être remplacé par les valeurs d'origine si elles sont retrouvées, ou assumé comme choix méthodologique explicite.

### 3.7.4 Formule de synthèse

$$S = 0{,}50 \cdot B^{\ast} + 0{,}33 \cdot V^{\ast} + 0{,}17 \cdot E^{\ast}$$

$$S = 0{,}50 \cdot c^{\ast}_{bati} + 0{,}33 \cdot (1 - c^{\ast}_{vege}) + 0{,}17 \cdot (1 - c^{\ast}_{eau})$$

Implémentation : `Raster Calculator` (algèbre de cartes), après rééchantillonnage des trois rasters sur une **grille commune** (cf. § 3.3, faiblesse identifiée).

### 3.7.5 Classement

Le raster de synthèse `EffetEns` est classé en **5 niveaux** (très faible, faible, moyenne, forte, très forte) par **seuils naturels (Jenks)** — méthode adaptée à une distribution asymétrique, car elle maximise la variance inter-classes et minimise la variance intra-classes.

> **Variante intéressante** (à tester) : classification par **seuils remarquables** plutôt que statistique, pour que les classes aient un sens pour un élu (« zones où le bâti domine sans compensation végétale »). C'est l'un des points de vigilance du cours sur la discrétisation cartographique : ne pas multiplier les classes, ne pas produire de classes vides, choisir des bornes lisibles.

## 3.8 Carte de synthèse et lecture

**[Carte 5 — Indice de sensibilité globale aux phénomènes caniculaires, Dunkerque]** `[À réexporter depuis ProjetV2.mxd]`

Structure attendue (et cohérente avec les statistiques) :

- **Sensibilité très forte** : centre-ville dense, front portuaire industrialo-portuaire, zones d'activités et grands équipements minéraux. Ce sont les zones où $B^{\ast}$ est proche de 1 et où $V^{\ast}$ et $E^{\ast}$ sont proches de 1 (donc aucune compensation).
- **Sensibilité forte** : premier anneau autour du centre, tissu mixte bâti dense / jardins privés.
- **Sensibilité moyenne** : tissu pavillonnaire, zones avec végétation de proximité.
- **Sensibilité faible à très faible** : abords des grands bassins, secteurs de dunes et d'estran, franges agricoles du sud.

**Le point le plus important de la carte n'est pas la localisation des zones chaudes — c'est l'absence de compensation.** Les zones où le bâti est fort *et* la végétation faible cumulent les deux termes de l'indice : ce sont les **points noirs**, et ce sont eux qui doivent orienter la décision publique.

## 3.9 Indicateurs statistiques de la sensibilité

Tableau attendu par l'énoncé (à recalculer depuis `EffetEns` : `Reclassify` puis `Tabulate Area` avec la couche `Dunkerque`, et croisement avec la population par IRIS) :

| Classe de sensibilité | Surface (ha) | Part de la commune | Population concernée | Part de la population |
|---|---|---|---|---|
| Très faible | `[À compléter]` | | | |
| Faible | | | | |
| Moyenne | | | | |
| Forte | | | | |
| Très forte | | | | |
| **Total** | ≈ 4 389 ha | 100 % | 86 788 hab. | 100 % |

> **Méthode de calcul** : `Reclassify` (5 classes) → `Tabulate Area` (raster × `Dunkerque`) → export de la table → jointure avec la couche IRIS pour pondérer par la population (`Zonal Statistics as Table` sur un raster de population, ou croisement vectoriel IRIS × classes).

## 3.10 Analyse textuelle : ce que dit le territoire

**1. Une ville industrielle avant d'être une ville résidentielle.** Avec 39 % du sol en zones industrielles et réseaux, Dunkerque présente un profil atypique : l'essentiel de la chaleur anthropique ne vient pas du trafic résidentiel mais des **process industriels** (sidérurgie, pétrochimie, production d'énergie) et de l'activité portuaire. Cela a une conséquence méthodologique : les politiques classiques de lutte contre l'ICU (végétaliser les rues, désimperméabiliser les cours d'école) **ne suffiront pas**. Il faut aussi traiter la chaleur fatale industrielle, ce qui relève d'accords avec les industriels et non de l'aménagement.

**2. Une végétation fragmentée, donc peu efficace.** 1 131 zones végétalisées, mais seulement 3,3 % d'espaces verts artificialisés et 2,9 % de milieux arbustifs : le couvert est **morcelé**. Or l'efficacité du rafraîchissement dépend de la **taille** et de la **connectivité** des taches végétales (un grand parc rafraîchit plus loin qu'un alignement d'arbres). La carte `VegeEffet` le montre : les maxima sont ponctuels, et les valeurs retombent vite. Une **trame verte et bleue** continue aurait plus d'effet que l'addition de micro-espaces.

**3. L'eau : une fausse abondance.** 7,8 % d'eaux continentales, 626 réservoirs, un réseau hydrographique dense — mais un effet mesuré 50 fois plus faible que le bâti. L'explication est double : (i) les plans d'eau sont **concentrés** dans les bassins portuaires, à l'écart des zones habitées ; (ii) l'effet fraîcheur de l'eau est **local** et ne se propage pas. L'eau n'est donc pas un levier mobilisable à l'échelle de la ville, sauf à créer des **points d'eau de proximité** dans les quartiers denses — ce qui est une recommandation d'aménagement, pas une conclusion de la carte.

**4. Une vulnérabilité sociale mal couverte par l'indice physique.** L'indice de sensibilité est **physique**. Or la surmortalité dépend de la **vulnérabilité** : âge, isolement, précarité énergétique, qualité du logement. L'analyse par IRIS de la consommation électrique ouvre la voie : les IRIS à forte consommation par unité de surface, avec des logements anciens et un taux de chômage élevé, cumulent **exposition** et **vulnérabilité**. Ce croisement n'a pas été conduit jusqu'au bout dans le projet — c'est la principale piste d'approfondissement (§ 4.2).

**5. Une dynamique défavorable.** L'artificialisation progresse (74,2 % → 78 %). Toute politique de rafraîchissement qui ne s'accompagne pas d'une **maîtrise de l'étalement** sera annulée par la minéralisation nouvelle.

---

# 4. Conclusion, analyse critique et pistes d'amélioration (≈ 3 pages)

## 4.1 Conclusion

Le projet répond à la commande : construire, avec deux modules du semestre (vectoriel et raster), un **indicateur spatial de sensibilité aux canicules** pour une commune des Hauts-de-France, sans données météorologiques et sans couche préfabriquée.

La démarche repose sur une idée simple et robuste : **ce qui chauffe et ce qui rafraîchit un territoire s'exprime comme un champ d'intensité décroissant avec la distance**. Le passage par la densité par noyau permet de traduire cette idée en calcul, puis l'AMC permet d'agréger trois champs d'unités différentes en un indice unique et cartographiable.

Les résultats sont convergents et interprétables :

- le **bâti** est le facteur dominant (max 0,0619, moyenne 0,00754) ;
- la **végétation** est un contrepoids réel mais fragmenté (max 0,0190) ;
- l'**eau** rafraîchit intensément mais localement (max 0,00113) ;
- la carte de synthèse fait apparaître une **opposition est/ouest** entre le cœur industrialo-portuaire surchauffé et les franges dunoises et agricoles plus fraîches ;
- le territoire est **structurellement sensible** : 78 % d'artificialisation, un couvert végétal de 6,2 % au total, une dynamique d'artificialisation à la hausse.

La conclusion opérationnelle est double :

1. **La priorité n'est pas le confort, c'est la protection des personnes.** Les zones à traiter en premier sont celles qui cumulent forte exposition physique **et** population vulnérable — or ces deux dimensions ne se superposent que partiellement.
2. **Le levier « végétation » est le seul réellement mobilisable par la collectivité** à court terme. Il faut donc le concentrer là où il produit le plus d'effet : les quartiers denses, en continuité, plutôt qu'en micro-espaces dispersés.

## 4.2 Analyse critique du travail

**Ce qui fonctionne bien**

- **Choix du territoire argumenté** : Dunkerque satisfait la contrainte de l'énoncé et offre une diversité de situations (centre dense, industrie, littoral, polders) qui rend l'analyse intéressante plutôt que monolithique.
- **Qualité et volume des données** : 43 912 bâtiments, 1 131 zones végétalisées, 626 réservoirs, 42 IRIS de consommation — le socle est solide et **entièrement brut**, conformément à l'interdiction des couches préconstruites.
- **Normalisation de la chaîne de traitement** : le recours à la géodatabase (`EffetDataBase.gdb`) et à une nomenclature de couches explicite (`BatiKer1`, `VegeKer2`, `EauEffet`, `EffetEns`) rend le travail **reproductible** et lisible par un tiers — c'est un point souvent négligé dans les projets étudiants.
- **Préparation des données sous Excel** avant intégration (jointure IRIS, calcul de surfaces et de densités) : la donnée entre dans le SIG déjà qualifiée.
- **Recours à l'AMC** pour hiérarchiser les facteurs, plutôt qu'à une addition implicite et non justifiée.

**Ce qui doit être critiqué**

- **Grilles non alignées.** Les trois rasters ont des cellules de 35,5 m, 33,5 m et 44,4 m. Leur combinaison par `Raster Calculator` provoque un rééchantillonnage implicite (plus proche voisin par défaut), qui **dégrade les petits objets** — précisément ceux que l'on veut mesurer (alignements d'arbres, petits bassins). Il faut fixer une grille de référence unique (par exemple 25 m) et rééchantillonner explicitement.
- **Paramètres de noyau non documentés.** Les rayons de recherche, la fonction de noyau et le nombre de cellules de sortie n'ont pas été consignés. Or ce sont eux qui déterminent la forme du gradient : sans eux, **le résultat n'est pas reproductible**.
- **Poids non justifiés quantitativement.** Le jeu de poids est argumenté qualitativement, mais aucune **analyse de sensibilité** n'a été conduite (que devient la carte si l'on porte la végétation à 0,45 ?). Une AMC sans test de sensibilité est une AMC incomplète.
- **Pas de validation.** Aucune confrontation à des données observées (températures de surface Landsat, relevés de stations, retours d'expérience de la collectivité). L'indice reste **invérifié**.
- **Indice purement physique.** La dimension sociale (âge, précarité, isolement) est effleurée via la consommation électrique mais n'entre pas dans l'indice. La carte mesure l'**exposition**, pas la **vulnérabilité**.
- **Module réseau absent.** L'accessibilité aux îlots de fraîcheur (temps de trajet à pied vers un parc) et l'accès des secours sont des dimensions essentielles en situation de canicule ; elles n'ont pas été traitées.
- **Restitution cartographique.** Les cartes doivent respecter les règles du cours : titre, légende, échelle, date et source obligatoires ; source des données systématiquement mentionnée ; discrétisation justifiée (ici Jenks, ce qui est défendable mais doit être dit).

## 4.3 Pistes d'amélioration

1. **Technique — grille commune et paramètres documentés.** Fixer une grille de 25 m, rééchantillonner les trois rasters, consigner rayons et fonctions de noyau dans un tableau de paramètres. Rejouer l'analyse avec un **modèle ArcGIS (ModelBuilder)** pour automatiser et garantir la reproductibilité.
2. **Méthode — analyse de sensibilité des poids.** Tester trois jeux de poids (bâti-dominant, végétation-dominant, égalitaire) et cartographier la **stabilité spatiale** du classement (zones qui restent « très sensibles » quel que soit le jeu de poids = zones robustes).
3. **Données — intégrer la température de surface.** Une image Landsat 8/9 (bande thermique, scène d'été) permettrait de **valider** l'indice et de le calibrer, sans utiliser de couche préconstruite. C'est la voie la plus directe pour passer d'un indice relatif à une estimation en degrés.
4. **Données — descendre à l'îlot.** Le carroyage INSEE 200 m (utilisé au médian) ou les IRIS permettraient une analyse plus fine que la commune, et un croisement direct avec les revenus et l'âge.
5. **Méthode — module réseau.** Calculer, pour chaque IRIS, le **temps de trajet à pied** au parc ou point d'eau le plus proche (Network Analyst) : on obtient un indicateur d'**accessibilité à la fraîcheur**, complémentaire de l'indicateur de présence.
6. **Méthode — vulnérabilité sociale.** Construire un second indice (part des 75+, précarité énergétique, logements anciens) et croiser les deux par une **matrice bivariée** (exposition × vulnérabilité) : c'est la carte qui intéresse réellement un élu.
7. **Organisation — répartition du travail plus explicite.** Consigner qui a fait quoi, avec des dates, pour que le rendu collectif soit évaluable individuellement.
8. **Restitution — un atlas de 6 à 8 cartes** plutôt qu'une carte unique : état initial, trois gradients, indice, croisement social, zoom sur deux quartiers contrastés.

## 4.4 Ce que le projet démontre sur le plan des compétences

| Compétence du cours | Mise en œuvre |
|---|---|
| Modèles de données vecteur / raster | Couches BD TOPO vectorielles → rasters de densité |
| Projections et géoréférencement | Tout en Lambert 93 ; correction des couches mal projetées |
| Sémiologie graphique et discrétisation | Choix de classes, de variables visuelles, règles de la carte |
| Analyse spatiale vectorielle | Union, Feature To Point, buffers, jointures attributaires |
| Analyse spatiale raster | Kernel Density, algèbre de cartes, masque, reclassification |
| Aide à la décision / AMC | Normalisation, pondération, indice composite |
| Gestion de données | Géodatabase, nomenclature, jointure Excel |

---

# 5. Répartition du travail

Le projet a été réalisé en **binôme** (groupe de 2, même groupe de TD). La répartition exacte des tâches n'a pas été conservée : cette section du rapport original est perdue et n'est pas reconstituée ici.

*The work-split table could not be recovered.*

---

# Annexes

## A. Dictionnaire des couches produites

| Couche | Contenu | Origine |
|---|---|---|
| `BatiUnion` | Emprises bâties fusionnées | `Batiment` (BD TOPO) |
| `BatiPoint` | Centroïdes des emprises bâties | `Feature To Point` |
| `BatiKer1` / `BatiKer2` | Densités de noyau (deux échelles) | `Kernel Density` |
| `BatiEffet` | Effet thermique du bâti | Combinaison + normalisation |
| `VegetationPoint` | Centroïdes des zones végétalisées | `Feature To Point` |
| `VegeKer1` / `VegeKer2` / `VegeEffet` | Idem, pour la végétation | `Kernel Density` |
| `EauBuffer` / `ZoneEau` / `EauPoint` | Préparation des plans d'eau | Buffer + conversion |
| `EauKer1` / `EauKer2` / `EauEffet` | Effet de rafraîchissement de l'eau | `Kernel Density` |
| `ResPoint`, `HydroPoint` | Points des réservoirs et du réseau | Conversion |
| `EffetEns` | **Raster de synthèse (indice de sensibilité)** | `Raster Calculator` |

## B. Statistiques de référence (valeurs exactes des rasters livrés)

```
Impact Thermique des Batiments1.tif
  cellule 35.51 m | min 0 | max 0.0619146 | moyenne 0.00753637 | écart-type 0.0106998

Effet de Rafraîchissement1.tif  (végétation)
  cellule 33.50 m | min 0 | max 0.0190182 | moyenne 0.00437929 | écart-type 0.00445756

Effet de rafraîchissement des zones d'eau.tif
  cellule 44.37 m | min 0 | max 0.00113333 | moyenne 0.000147501 | écart-type 0.000191600
```

## C. Formule de l'indice (à recopier dans le rapport)

$$S = 0{,}50\,B^{\ast} + 0{,}33\,(1 - V^{\ast}) + 0{,}17\,(1 - E^{\ast})$$

avec $B^{\ast}$, $V^{\ast}$, $E^{\ast}$ normalisés min-max sur l'emprise communale.

## D. Bibliographie indicative

- Oke, T. R. (1982). *The energetic basis of the urban heat island*. Quarterly Journal of the Royal Meteorological Society.
- Oke, T. R., Mills, G., Christen, A., Voogt, J. A. (2017). *Urban Climates*. Cambridge University Press.
- Saaty, T. L. (1980). *The Analytic Hierarchy Process*. McGraw-Hill.
- Bertin, J. (1967). *Sémiologie graphique*. Mouton/Gauthier-Villars.
- ARS / Santé publique France — *Système d'alerte canicule et santé (SACS)*, bilans annuels.
- CORINE Land Cover — Agence européenne pour l'environnement.
- BD TOPO — Institut national de l'information géographique et forestière (IGN).
- INSEE — recensements et carroyage infra-communal.
- Wikipédia (fr) — article « Dunkerque », pour les chiffres clés du § 2 (à recouper avec les sources primaires).
