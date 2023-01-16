library(dplyr)
library(FactoMineR)
library(factoextra)
library(CASdatasets)
?CASdatasets

#freMPL veut dire French Motor Personal Line datasets
#On utilisera le dataset 5 qui contient environ 26000 contrats de l'annee 2004

data(freMPL5)

#On a dans ce dataset 20 variables :

#1 --- Exposure
#   The exposure, in years.

#2 --- RecordBeg
#   Beginning date of record.

#3 --- RecordEnd
#   End date of record.
#Remarque : certains assurés ont pour valeur NA, ce qui veut dire qu'ils n'ont 
#pas rompu leur contrat avec 2005

#Les trois premières variables permettront de connaitre si certaines durées de
#contrat durent moins d'un an (un assuré a moins de risque d'accident toute chose
#égale par ailleurs sur une periode plus courte qu'un an que sur une année complète)

#4 --- DrivAge
#   The driver age, in years (in France, people can drive a car at 18).
#surement une donnée pirmordiale

#5 --- LicAge
#   The driving licence age, in months.
#attention a ne pas interpreter deux fois la meme observation qu'avec l'age du conducteur

#6 --- Gender
#   The gender, either "Male" or "Female".
#normalement très utile mais pas légale de l'utiliser comme telle

#7 --- MariStat
#The marital status, either "Alone" or "Other".
#variable binaire

#8 --- SocioCateg
#The social category known as CSP in France, between "CSP1" and "CSP99".

#9 --- HasKmLimit
#A numeric, 1 if there is a km limit for the policy, 0 otherwise.

#10 --- BonusMalus
#A numeric for the bonus/malus, between 50 and 350: <100 means bonus, >100 means malus in France.
#facteur important et légalement obligatoire

#11 --- VehUsage
#The vehicle usage among "Private", "Private+trip to office" "Professional", "Professional run".

#12 --- RiskArea
#Unkonw risk area between 1 and 13, possibly ordered.

#13 --- ClaimNbResp
#Number of responsible claims in the 4 preceding years.

#14 --- ClaimNbNonResp
#Number of non-responsible claims in the 4 preceding years.

#15 --- ClaimNbParking
#Number of parking claims in the 4 preceding years.

#16 --- ClaimNbFireTheft
#Number of fire-theft claims in the 4 preceding years.

#17 --- ClaimNbWindscreen
#Number of windscreen claims in the 4 preceding years.

#18 --- OutUseNb
#Number of out-of-use in the 4 preceding years.

#19 --- ClaimAmount
#Total claim amount of the guarantee.

#20 --- ClaimInd
#Claim indicator of the guarantee. (this is not the claim number)
#a-t-il reclame de l'argent


#Exposure est une variable relatant de la duree d'un contrat (en fraction d'annee)
#obtenue a partir des variables RecordBeg et RecordEnd
#On devra alors supposer que les fréquences et couts sont independants de la 
#periode de l'annee pour l'utiliser convenablement

#Ensuite, on introduira une nouvelle variable sur le cout moyen (a expliquer :
#CoutMoyen = ClaimAmount[pour les assures ayant eu au moins un sinistre]/NbSinistres[de cet assuré])

#Questions : Pourquoi certains assures possedent un montant reclame negatif ?
#S'agit-il d'une regularisation suite a un avancement trop important ?

freMPL5$Freq = factor(ifelse(freMPL5$ClaimNbNonResp+freMPL5$ClaimNbResp+freMPL5$ClaimNbParking+freMPL5$ClaimNbFireTheft+freMPL5$ClaimNbWindscreen+freMPL5$OutUseNb > 0, 1, 0))

cout_moyen = mean(freMPL5$ClaimAmount)

x <- freMPL5[, c(1,2,9,11,12,13,14,15,16,17,18,19)]

#C'est une ACP sur les données quantitatives (on a ici considéré la zone
#comme faisant partie des variables quantitatives car c'est "possibly ordered")
z <- princomp(x, cor = FALSE, scores = TRUE)
biplot(z)

#On veut ici supprimer les lignes dont les montants réclamés sont négatifs.
#En effet, elles donnent lieu à une régularisation et ne nous apporterons rien.

freMPL5 <- subset(freMPL5, freMPL5$ClaimAmount >= 0)
freMPL5$HasKmLimit <- factor(freMPL5$HasKmLimit)
freMPL5$RiskArea <- factor(freMPL5$RiskArea)
freMPL5$ClaimInd <- factor(freMPL5$CLaimInd)
freMPL5$ClaimNbFireTheft <- factor(freMPL5$ClaimNbFireTheft)
freMPL5$ClaimNbResp <- factor(freMPL5$ClaimNbResp)
freMPL5$ClaimNbNonResp <- factor(freMPL5$ClaimNbNonResp)
freMPL5$ClaimNbParking <- factor(freMPL5$ClaimNbParking)
freMPL5$ClaimNbWindscreen <- factor(freMPL5$ClaimNbWindscreen)
freMPL5$ClaimInd <- factor(freMPL5$ClaimInd)
freMPL5$OutUseNb <- factor(freMPL5$OutUseNb)


#Pour faire une analyse de données, nous allons transformer toutes les variables
#quantitatives en variables qualitatives de manière à avoir un nombre homogènes
#d'assurés dans chaque classe.

freMPL5$Exposure <- cut(freMPL5$Exposure, quantile(freMPL5$Exposure, probs = seq(0,1,1/10)), include.lowest = TRUE)
freMPL5$DrivAge <- cut(freMPL5$DrivAge, quantile(freMPL5$DrivAge, probs = seq(0,1,1/10)), include.lowest = TRUE)
freMPL5$LicAge <- cut(freMPL5$LicAge, quantile(freMPL5$LicAge, probs = seq(0,1,1/10)), include.lowest = TRUE)
freMPL5$BonusMalus <- cut(freMPL5$BonusMalus, seq(50, 190, 10), include.lowest = TRUE)
freMPL5$IntervalCout <- cut(freMPL5$ClaimAmount, seq(0, 95152, 10), include.lowest = TRUE)

summary(freMPL5)

fact <- select(freMPL5, -c("RecordBeg", "RecordEnd", "ClaimAmount"))
summary(fact)
res.mca = MCA(fact, ncp = 5, graph = TRUE)
summary(res.mca)
fviz_mca_var(res.mca, col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE, 
             ggtheme = theme_minimal())
mca.graph(res.mca, choix = "var", axes = 1)

data_cout = select(freMPL5[freMPL5$ClaimInd == 1, ], -c("ClaimInd", "IntervalCout","Freq","RecordBeg", "RecordEnd"))
mod0 <- glm(ClaimAmount~. , data = data_cout, family=Gamma)
summary(mod0)
