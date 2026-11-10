# Annexe technique — données, schémas, paramètres / 技术附录 — 数据、字段、参数

Ce document décrit **ce qui est réellement dans les fichiers**, sans interprétation. Il sert à rouvrir le projet, à retrouver un paramètre, ou à recalculer un résultat.
本文只描述**文件中实际存在的内容**，不做解释，用于重新打开项目、查找参数或复算结果。

---

## 1. Réouvrir le projet / 重新打开项目

1. Ouvrir **ArcMap** (version 10.x, format `.mxd`).
2. Charger `projet/ProjetV2.mxd`.
3. Vérifier les sources : les couches pointent vers `projet/donnée/` et `projet/donnée/EffetDataBase.gdb`. Les chemins enregistrés sont **absolus** : après un déplacement du dossier, les réparer avec **Set Data Source**.
4. Vérifier le système de coordonnées du data frame : **RGF93 / Lambert 93 (EPSG:2154)**, unités **mètres**.
5. Les trois rasters finaux sont dans `projet/donnée/` :
   - `Impact Thermique des Batiments1.tif`
   - `Effet de Rafraîchissement1.tif`
   - `Effet de rafraîchissement des zones d'eau.tif`
6. Le raster de synthèse `EffetEns` est **dans la géodatabase** (`EffetDataBase.gdb`), pas en GeoTIFF.

> 注意：文件名的重音符号在部分系统上显示为 `?`（如 `Effet de rafra?chissement...`），这是编码显示问题，**不要重命名**，否则 `ProjetV2.mxd` 中的图层链接会断开。

---

## 2. Inventaire des dossiers / 文件夹清单

| Dossier / 文件夹 | Contenu / 内容 | Volume |
|---|---|---|
| `projet/` | **Le projet lui-même** : `ProjetV2.mxd`, shapefiles de travail, 3 rasters, `EffetDataBase.gdb` (18 classes d'entités et rasters) | 111 fichiers, 99 Mo |
| `projet/donnée/` | Couches de travail et rasters (le cœur du projet) | 96 Mo |
| `projet/sources/` | Énoncé du projet, documentation (Dunkerque, îlot de chaleur urbain), `Projet.mxd` (version antérieure), cadastre vert et zones de circulation | ~10 Mo |
| `cours/CM/` | 16 PDF de cours magistraux (CM01–CM16) | 82 Mo |
| `cours/TD/` | Énoncés et corrigés des TD1–TD9, plus les documents ArcMap (`.mxd`) produits pendant les séances. **Les jeux de données d'exercice ont été retirés** | 48 fichiers, 82 Mo |
| `cours/evaluations/` | Sujet A17 avec réponses, sujet A18 (scan), résumé de révision, médian 2021 (énoncé + `.mxd` + carte rendue), médian 2023 | ~7 Mo |
| `docs/` | Rapport reconstitué (FR/ZH), cours, annexe technique | 4 fichiers |
| `figures/` | 4 cartes régénérées depuis les rasters | 4 fichiers |
| `sources/chatgpt/` | Export des trois conversations ChatGPT utilisées pour la reconstruction | 3 fichiers |
| `tools/` | `render_figures.ps1` — rendu des rasters sans ArcGIS | 1 fichier |

> Les données massives et publiquement re-téléchargeables (CORINE Land Cover, INSEE, émissions, SRCE-TVB, prévisions Météo-France, jeux d'exercice des TD) ont été **supprimées** pour garder un dépôt de taille raisonnable. Elles restent citées avec leur producteur dans les sections 3 et 4 ci-dessous.

---

## 3. Schémas des couches vectorielles / 矢量图层字段

Champs listés tels quels (noms tronqués à 10 caractères par le format DBF).

### `Batiment` — 43 912 entités
`ID`, `NATURE`, `USAGE1`, `USAGE2`, `LEGER`, `ETAT`, `DATE_CREAT`, `DATE_MAJ`, `DATE_APP`, `DATE_CONF`, `SOURCE`, `ID_SOURCE`, `ACQU_PLANI`, `PREC_PLANI`, `ACQU_ALTI`, `PREC_ALTI`, `NB_LOGTS`, `NB_ETAGES`, `MAT_MURS`, `MAT_TOITS`, `HAUTEUR`, `Z_MIN_SOL`, `Z_MIN_TOIT`, `Z_MAX_TOIT`, `Z_MAX_SOL`, `ORIGIN_BAT`, `APP_FF`

> Champs utiles pour l'analyse : `HAUTEUR` (hauteur), `NB_ETAGES` (niveaux), `NB_LOGTS` (logements), `NATURE` / `USAGE1` (typologie), `MAT_MURS` / `MAT_TOITS` (matériaux — proxy d'albédo).

### `Vegetation` / `VegetationPoint` — 1 131 entités chacune
`OBJECTID`, `FID_ZONE_D`, `ID`, `NATURE`, `DATE_CREAT`, `DATE_MAJ`, `DATE_APP`, `DATE_CONF`, `ACQU_PLANI`, `PREC_PLANI`, `SOURCE`, `ID_SOURCE`, `FID_Dunker`, `gml_id`, `oid_1`, `code`, `nom`, `nom_min`, `statut`, `surface_km`, `population`, `populati_1`, `Shape_Leng`, `Shape_Area` (+ `ORIG_FID` pour la version point)

### `Reservoir` — 626 entités
`ID`, `NATURE`, `ETAT`, dates, `SOURCE`, `ACQU_PLANI`, `ACQU_ALTI`, `Z_MIN_SOL`, `Z_MIN_TOIT`, `HAUTEUR`, `Z_MAX_TOIT`, `Z_MAX_SOL`, `ORIGIN_BAT`, **`VOLUME`** (volume, m³)

### `Eau` — 254 tronçons / `Hydro` — 307 entités
`ID_TRONCON`, `CODE_HYDRO`, `CODE_PAYS`, `NATURE`, `FICTIF`, `POS_SOL`, `ETAT`, dates, `SOURCE`, `TOP_COORD`, `ALT_COORD`, `STATUT`, `PERSISTANC`, `LARGEUR`, `COMMENT`, `CODE_CARTH`, `ID_C_EAU`, `NOM_C_EAU`, `ID_ENT_TR`, `NOM_ENT_TR` (+ rattachement communal)

### `Communes` — 3 789 entités
`gml_id`, `oid`, `code` (code INSEE), `nom`, `nom_min`, `statut`, `surface_km`, `population`, `populati_1`

### `ConsomationElectrique` — 42 entités (IRIS)
Champs d'origine IRIS / Enedis :
`annee`, `code_iris`, `nom_iris`, `type_iris`, `code_commu`, `nom_commun`, `code_epci`, `nom_epci`, `type_epci`, `code_depar`, `nom_depart`, `code_regio`, `nom_region`, `code_categ`, `code_grand`, `code_secte`, `nb_sites`, `conso_tota`, `conso_moye`, `part_therm`, `conso_to_1`, `conso_to_2`, `thermosens`, `conso_to_3`, `conso_mo_1`, `conso_mo_2`, `thermose_1`, `conso_mo_3`, `dju_a_tr`, `dju_a_tn`, `nombre_d_h`, `taux_de_lo`, `taux_de_re`, `superficie`, `superfic_1`…`superfic_5`, `residences`, `residenc_1`…`residenc_6`, `taux_de_ch`
Champs de jointure / calcul : `FID_Dunker`, `gml_id`, `oid_1`, `code`, `nom`, `nom_min`, `statut`, `surface_km`, `population`, `Shape_Leng`, `Shape_Area`, **`Aire`**, **`Densité_conso`**

> `Aire` et `Densité_conso` sont des **champs calculés** : ils matérialisent l'étape « superficie → densité de consommation » décrite dans le rapport (§ 3.2).

### Autres couches de contexte
- `Dunkerque` — 1 entité (emprise de l'étude)
- `Cimetiere` — 15 ; `Construction` — 43 ; `TerrainDeSport` — 89 (toutes avec `NATURE`, `DATE_*`, `SOURCE`, `TOPONYME` le cas échéant)
- `Estran` — 53 ; `LimiteDeMer` — 64

---

## 4. Rasters : paramètres et statistiques / 栅格参数与统计

Valeurs lues dans les fichiers `.tfw` (géoréférencement) et `.tif.aux.xml` (statistiques calculées par ArcGIS).

| Raster | Taille de cellule | X origine | Y origine | Min | Max | Moyenne | Écart-type |
|---|---|---|---|---|---|---|---|
| `Impact Thermique des Batiments1.tif` | 35,5106 m | 646 578,18 | 7 106 967,70 | 0 | 0,0619146 | 0,00753637 | 0,0106998 |
| `Effet de Rafraîchissement1.tif` | 33,4977 m | 646 584,91 | 7 106 786,90 | 0 | 0,0190182 | 0,00437929 | 0,00445756 |
| `Effet de rafraîchissement des zones d'eau.tif` | 44,3671 m | 646 569,22 | 7 106 850,46 | 0 | 0,00113333 | 0,000147501 | 0,000191600 |

**Rapports dérivés (à recalculer si les poids changent) :**

| Comparaison | Max | Moyenne |
|---|---|---|
| Bâti / Végétation | 0,06191 / 0,01902 = **3,26** | 0,007536 / 0,004379 = **1,72** |
| Bâti / Eau | 0,06191 / 0,001133 = **54,6** | 0,007536 / 0,0001475 = **51,1** |

**Histogrammes** : 256 classes, distribution fortement asymétrique à droite (première classe = 3 716 à 8 160 cellules, dernière classe ≈ 1 cellule). Autrement dit : **une minorité de cellules porte l'essentiel de l'intensité**.

---

## 5. Chaîne de traitement attestée par la géodatabase / 由地理数据库证实的工作流

Noms de classes d'entités et de rasters présents dans `EffetDataBase.gdb` :

```
Vectoriel :
  VegetationPoint
  BatiUnion  →  BatiPoint
  EauBuffer  →  ZoneEau  →  EauPoint
  ResPoint, HydroPoint

Rasters (avec pyramides fras_ras_/fras_aux_/fras_blk_/fras_bnd_) :
  VegeKer1  →  VegeKer2  →  VegeEffet
  BatiKer1  →  BatiKer2  →  BatiEffet
  EauKer1   →  EauKer2   →  EauEffet
  EffetEns                     ← raster de synthèse
```

Lecture : pour chaque famille (bâti, végétation, eau), **deux calculs de densité de noyau** (`Ker1`, `Ker2`), puis un raster d'effet (`Effet`), puis un raster d'ensemble (`EffetEns` = « effet d'ensemble »).

> Les **paramètres** des outils (rayon de recherche, taille de cellule, fonction de noyau) ne sont **pas stockés** dans la géodatabase : ils ont été saisis dans la boîte de dialogue de l'outil et ne sont pas conservés. C'est la principale lacune de reproductibilité (voir rapport, § 4.2).

---

## 6. Formulaire de recalcul rapide / 快速复算

### 6.1 Recalculer l'indice de synthèse

```
1. Raster → Project Raster (ou Resample) les 3 rasters sur une grille commune de 25 m, Lambert 93.
2. Raster Calculator :
      Bn = ("Impact_Bati" - 0) / 0.0619146
      Vn = ("Effet_Vege" - 0) / 0.0190182
      En = ("Effet_Eau"  - 0) / 0.00113333
3. Raster Calculator :
      S = 0.50*Bn + 0.33*(1-Vn) + 0.17*(1-En)
4. Extract by Mask sur la couche "Dunkerque".
5. Reclassify en 5 classes (Jenks).
6. Tabulate Area (S_reclass × Dunkerque) pour le tableau des surfaces.
```

### 6.2 Isoler les « points noirs » (forte chaleur, pas de compensation)

```
Con( (Bn > 0.7) & (Vn < 0.2) & (En < 0.2), 1, 0 )
```

Puis `Raster to Polygon` pour obtenir des zones vectorielles exploitables, et `Zonal Statistics` pour la population concernée.

### 6.3 Analyse de sensibilité des poids

```
S1 = 0.60*Bn + 0.25*(1-Vn) + 0.15*(1-En)   -- bâti dominant
S2 = 0.35*Bn + 0.45*(1-Vn) + 0.20*(1-En)   -- végétation dominante
S3 = 0.333*Bn + 0.333*(1-Vn) + 0.333*(1-En) -- égalitaire
```
Comparer les 5 classes : les zones qui restent « très fortes » dans les trois scénarios sont les **conclusions robustes**.

---

## 7. Points de vigilance avant réutilisation / 复用的注意事项

1. **Ne pas renommer** les fichiers contenant des accents (liens du `.mxd`).
2. **Vérifier les chemins** si le dossier est déplacé : ArcMap stocke des chemins absolus. Utiliser *File → Map Document Properties → Pathnames → Store relative pathnames*.
3. **Les trois rasters n'ont pas la même grille** — toute combinaison directe provoque un rééchantillonnage implicite.
4. **Les valeurs ne sont pas des degrés Celsius** : ce sont des densités de noyau pondérées. Ne pas les étiqueter « °C » sur une carte.
5. **Le rapport original est perdu** : les poids (0,50 / 0,33 / 0,17) et les rayons de noyau sont des **reconstructions**, à valider ou à remplacer.
