# Cours UR06 « Géomatique » — supports et parcours d'apprentissage

Ce dossier contient les supports du cours : **16 CM**, **9 TD** et les **évaluations**. Le projet (étude de Dunkerque) est à la racine du dépôt ; il mobilise les modules **vectoriel** et **raster** vus ici.

**[中文 ↓](#中文) · [Français ↓](#français)**

---

## 中文

### 这门课到底在教什么

一句话：**把"地图"变成可计算的空间数据，再把空间数据变成能支撑决策的指标。**

课程的结构是四层递进：

| 层次 | 内容 | 对应 |
|---|---|---|
| 1. 概念 | 什么是地理信息、什么是 SIG、大地基准与投影 | CM01–CM02 |
| 2. 表达 | 矢量/栅格两种数据模型、制图语言（符号学、分级） | CM03–CM06 |
| 3. 方法 | 矢量空间分析、栅格地图代数、网络分析 | CM07–CM09, CM16 |
| 4. 应用 | WebSIG、水文建模、能源、交通，以及"支持决策" | CM10, CM13, CM15 |

真正贯穿全课的其实是第四条：**SIG 不是为了画好看的图，而是为了在多个互相冲突的准则之间做出可辩护的选择**。这也是项目里用 AMC（多准则分析）的原因。

### 目录

```
cours/
  CM/            16 份讲义（CM01–CM16，缺 CM11；A20–A23 跨学年混编）
  TD/            9 次上机题 + 3 份参考答案与批改
                 只保留题目、答案与成果（.mxd/.tbx），练习数据集已移除
  evaluations/   期中两套（A21、A23）+ 期末两套（A17 含答案、A18 扫描件）+ 复习稿
```

### CM 一览：每讲学到什么

| 编号 | 主题 | 能带走的东西 |
|---|---|---|
| CM01 | 绪论：信息地理与 géomatique | 地理信息的组成；按**图层**组织世界；SIG 的三种用途（管理图层 / 让数据说话 / 支持决策） |
| CM02 | SIG 详解 | SIG 的正式定义与组成；SIG ≠ 制图软件；提出"自某日期以来变了什么" |
| CM03 | 地图与图形符号学 | **Bertin 的视觉变量**；地图的必备要素；要避免的错误 |
| CM04 | 制图分级（discrétisation） | 等幅 / 等频 / 显著阈值；为什么分级方式会改变结论 |
| CM05 | SIG 与数据 | 数据来源、获取渠道、质量与元数据 |
| CM06 | SIG 与数据库（SGBD） | 关系模型、SQL、属性查询、PostGIS |
| CM07 | **矢量空间分析** | 空间关系类型学；缓冲区/裁剪/相交/联合/空间连接；地理处理链 |
| CM08 | 栅格与**地图代数**（一） | `Con`、`Reclassify`、加权叠加；如何用栅格回答"范围内有多少" |
| CM09 | 栅格分析（二） | 局部/焦点/分区/全局四类运算；矢量与栅格的取舍 |
| CM10 | WebSIG 入门（外来讲者） | 服务化平台带来的五个变化：可访问、可互操作、安全、解耦、性能 |
| CM12 | 空间分析与建模（讲义缺失） | — |
| CM13 | **SIG 与水文建模** | SIAR + GR4J 模型链；顺序率定；等终性（equifinality）；SIG 做数据集成与前处理 |
| CM14 | （讲义缺失） | — |
| CM15 | 能源与国土 | 消费、生产、网络；SIG 在能源规划中的位置 |
| CM16 | **SIG 与交通** | 网络数据集；最短路径、服务区、OD 矩阵、位置分配 |

### TD 一览：每次上机练什么

| TD | 场景 | 训练的能力 |
|---|---|---|
| TD1–TD2 | 巴西亚马孙朗多尼亚毁林 | 上手 ArcMap：加载、符号化、查询、排版出图 |
| TD3 | Meudon / Lotissement | 属性查询与空间查询、相交、属性更新、`Union` 后如何读属性表 |
| TD4 | 污水处理厂选址 | 完整矢量分析：适宜地块 → 导出 → 加字段 → 50 m 道路邻近 → 500/1000 m 多环缓冲 → 按位置选择 → 字段赋值 |
| TD5 | 美国犯罪数据 | 表连接、汇总、比率计算（案件/人口） |
| TD6–TD8 | Spatial Analyst 系列 | 栅格转换、重分类、距离、表面分析、成本距离、地图代数；**ModelBuilder**（`SiteAnalysis.tbx`） |
| TD9 | Network Analyst | 建网络数据集、最短路径、服务区、OD 矩阵、位置分配（商店选址） |

### 考核

- **期中（Médian）占 30%**：1 h 30 上机 + 出图 + 方案说明，**不交即淘汰**。
  - A21：用 INSEE 200 m 方格识别**能源贫困家庭**，并为"帮扶窗口"选址（三级风险规则 + 2 个新址）。
  - A23：法兰西岛救援设施与人口（缓冲区/网络 + 人口加权）。
- **期末（Final）**：11 道课程问答（15 分）+ 矢量/栅格各一道情景题（5 分）。
- **项目**：小组 2 人，20 页报告，至少两个模块，禁止气象数据与现成图层。

### 怎么用这些材料复习

1. **先背"区别"**：矢量/栅格、RGF93/Lambert 93、地理选择/属性选择、locales/focales/zonales/globales。这些题分值固定、答案结构化。
2. **再练"流程题"**：给一个场景，能在纸上画出**输入 → 操作 → 中间结果 → 输出**，并写出法语工具名。A17 第 6 题和练习部分都是这个模板。
3. **然后练"分级题"**：给一张属性表，判断每个字段的**测量尺度**，选择**视觉变量**和**分级方法**。期中期末都考。
4. **最后准备 AMC 三句话**：为什么互补、怎么归一化、怎么赋权并检验。

> 每讲、每次 TD 的详细拆解（概念定义、考点、复习建议）见 [`../docs/03_COURS_UR06.md`](../docs/03_COURS_UR06.md)。

---

## Français

### Ce que ce cours enseigne réellement

En une phrase : **transformer une carte en données spatiales calculables, puis ces données en indicateurs qui appuient une décision.**

Quatre niveaux, du concept à l'usage :

| Niveau | Contenu | Cours |
|---|---|---|
| 1. Concepts | Information géographique, SIG, géodésie et projections | CM01–CM02 |
| 2. Représentation | Modèles vecteur / raster, langage cartographique (sémiologie, discrétisation) | CM03–CM06 |
| 3. Méthodes | Analyse spatiale vectorielle, algèbre de cartes, analyse réseau | CM07–CM09, CM16 |
| 4. Applications | WebSIG, modélisation hydrologique, énergie, transport, aide à la décision | CM10, CM13, CM15 |

Le fil rouge est le quatrième : **un SIG ne sert pas à produire de belles cartes, mais à rendre défendable un choix entre des critères qui se contredisent**. C'est exactement ce que fait l'AMC du projet.

### Contenu du dossier

```
cours/
  CM/            16 supports (CM01–CM16 ; CM11 manquant ; millésimes A20–A23 mélangés)
  TD/            9 énoncés + 3 corrigés
                 seuls les énoncés, corrigés et documents produits (.mxd/.tbx) sont conservés ;
                 les jeux de données d'exercice ont été retirés
  evaluations/   deux médians (A21, A23), deux finals (A17 avec réponses, A18 scanné), un résumé de révision
```

### Les CM, un par un

| | Thème | Ce qu'on en retire |
|---|---|---|
| CM01 | Introduction | Composantes de l'information géographique ; organisation **par couches** ; les trois usages d'un SIG |
| CM02 | Le SIG en détail | Définition et composantes ; un SIG n'est pas un logiciel de cartographie |
| CM03 | La carte, sémiologie graphique | **Variables visuelles de Bertin** ; éléments obligatoires ; erreurs à éviter |
| CM04 | Discrétisation cartographique | Amplitudes égales / effectifs égaux / seuils remarquables ; pourquoi le choix change la conclusion |
| CM05 | SIG et données | Sources, acquisition, qualité, métadonnées |
| CM06 | SIG et SGBD | Modèle relationnel, SQL, requêtes attributaires, PostGIS |
| CM07 | **Analyse spatiale vectorielle** | Typologie des relations spatiales ; buffer, clip, intersect, union, jointure spatiale |
| CM08 | Raster et **algèbre de cartes** (1) | `Con`, `Reclassify`, superposition pondérée |
| CM09 | Analyse raster (2) | Opérations locales / focales / zonales / globales ; arbitrage vecteur-raster |
| CM10 | Initiation au WebSIG | Cinq effets du passage aux services : accessibilité, interopérabilité, sécurité, découplage, performance |
| CM12 | Analyse spatiale et modélisation (support manquant) | — |
| CM13 | **SIG et modélisation hydrologique** | Chaîne SIAR + GR4J ; calage séquentiel ; équifinalité ; le SIG comme intégrateur de données |
| CM14 | (support manquant) | — |
| CM15 | Énergie et territoire | Consommation, production, réseaux ; place du SIG dans la planification énergétique |
| CM16 | **SIG et transport** | Jeux de données réseau ; itinéraire, aire de service, matrice OD, affectation |

### Les TD, un par un

| TD | Cas d'étude | Compétence travaillée |
|---|---|---|
| TD1–TD2 | Déforestation au Rondônia | Premiers pas sur ArcMap : chargement, symbologie, requêtes, mise en page |
| TD3 | Meudon / lotissement | Requêtes attributaires et spatiales, intersection, mise à jour, lecture d'une table après `Union` |
| TD4 | Implantation d'une station d'épuration | Chaîne vectorielle complète : sélection → export → champs → proximité 50 m → buffers 500/1000 m → sélection par localisation → calcul de champs |
| TD5 | Données criminelles américaines | Jointures, agrégations, calcul de taux (faits / population) |
| TD6–TD8 | Spatial Analyst | Conversion, reclassification, distances, analyse de surface, coût, algèbre de cartes ; **ModelBuilder** (`SiteAnalysis.tbx`) |
| TD9 | Network Analyst | Construction du réseau, itinéraire, aire de service, matrice OD, affectation (choix de localisation) |

### Évaluation

- **Médian : 30 % de la note.** 1 h 30 sur poste, cartes et protocole ; **le non-rendu est éliminatoire**.
  - A21 : identifier les ménages en **précarité énergétique** sur le carroyage INSEE 200 m et implanter deux cellules d'accompagnement.
  - A23 : accessibilité des secours et population en Île-de-France.
- **Final :** 11 questions de cours (15 pts) + un exercice vectoriel et un exercice raster (5 pts).
- **Projet :** binôme, 20 pages, au moins deux modules, données météo et couches préconstruites interdites.

### Comment réviser avec ces documents

1. **Les « différences »** : vecteur/raster, RGF93/Lambert 93, sélection géographique/attributaire, locales/focales/zonales/globales.
2. **Les « protocoles »** : savoir dessiner *entrées → opérations → résultats intermédiaires → sortie*, avec les noms d'outils en français. C'est le format de la question 6 et de la partie II du sujet A17.
3. **Les « échelles de mesure »** : à partir d'une table d'attributs, identifier le type de chaque champ, puis choisir variable visuelle et mode de discrétisation.
4. **L'AMC en trois phrases** : pourquoi elle est complémentaire du SIG, comment normaliser, comment pondérer et tester.

> Le détail de chaque cours et de chaque TD (définitions, points d'examen, conseils) est dans [`../docs/03_COURS_UR06.md`](../docs/03_COURS_UR06.md).
