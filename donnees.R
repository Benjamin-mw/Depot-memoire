library(dplyr)
library(FactoMineR)
library(factoextra)
library(CASdatasets)
?CASdatasets

#freMPL veut dire French Motor Personal Line datasets
#On utilisera le dataset 5 qui contient environ 26000 contrats de l'annee 2004

data(freMPL5)

#Cette variable est-elle utile ?
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

freMPL5$Exposure <- cut(freMPL5$Exposure, quantile(freMPL5$Exposure, probs = seq(0,1,1/4)), include.lowest = TRUE)
freMPL5$DrivAge <- cut(freMPL5$DrivAge, quantile(freMPL5$DrivAge, probs = seq(0,1,1/6)), include.lowest = TRUE)
freMPL5$LicAge <- cut(freMPL5$LicAge, quantile(freMPL5$LicAge, probs = seq(0,1,1/6)), include.lowest = TRUE)
freMPL5$BonusMalus <- cut(freMPL5$BonusMalus, c(50,54,seq(60, 200, 20)), include.lowest = TRUE)
freMPL5$IntervalCout <- cut(freMPL5$ClaimAmount, c(0,seq(1, 100000, 1000)), include.lowest = TRUE)

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

#Un premier modèle linéaire généralisé de loi gamma
data_cout = select(freMPL5[freMPL5$ClaimInd == 1, ], -c("ClaimInd", "IntervalCout","Freq","RecordBeg", "RecordEnd"))
mod0 <- glm(ClaimAmount~. , data = data_cout, family=Gamma(link="inverse"))
summary(mod0)

#Etude des résidus de Pearson et de Deviance
residus.P = residuals(mod0, type="pearson")
residus.D = residuals(mod0, type="deviance")
