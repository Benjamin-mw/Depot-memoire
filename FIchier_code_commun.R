#Packages
library(tables); library(ggExtra) ; library(FactoMineR) ; library(factoextra) ; library(CASdatasets)
library(tidyverse) ; library(MASS) ; library(knitr) ; library(ggplot2) ; library(cowplot)
library(reshape2) ; library(dplyr) ; library(GGally) ; library(corrplot) ; library(carData) 
library(car) ; library(questionr) ;library(multcomp) ; library(dplyr) ; library(leaps)
library(TeachingDemos) ; library(FactoMineR) ; library(factoextra) ; library(ROCR) ; library(plotROC)
library(graphics)

#Import jeu de données
data(freMPL5)
summary(freMPL5)

#Ajustement type des variables
freMPL5$HasKmLimit <- factor(freMPL5$HasKmLimit)
freMPL5$ClaimInd <- factor(freMPL5$ClaimInd)
freMPL5$RiskArea <- factor(freMPL5$RiskArea)
freMPL5$OutUseNb <- as.numeric(freMPL5$OutUseNb)

#Suppression des valeurs négatives
freMPL5 <- subset(freMPL5, freMPL5$ClaimAmount >= 0)

#Segmentation des tranches d'âge
freMPL5$DrivAge_fact <- cut(freMPL5$DrivAge, c(20,25,30,35,40,45,50,58,65,120), include.lowest = TRUE)

#Découpage CSP
freMPL5$Categ = 0
freMPL5$Categ[freMPL5$SocioCateg == "CSP50"] = 1
freMPL5$Categ[freMPL5$SocioCateg == "CSP55"] = 2
freMPL5$Categ[freMPL5$SocioCateg == "CSP60"] = 3
freMPL5$Categ[freMPL5$SocioCateg == "CSP1"] = 4
freMPL5$Categ[freMPL5$SocioCateg == "CSP42"] = 5
freMPL5$Categ[freMPL5$SocioCateg == "CSP46"] = 6
freMPL5$Categ[freMPL5$SocioCateg == "CSP48"] = 7
freMPL5$Categ[freMPL5$SocioCateg == "CSP66"] = 8

