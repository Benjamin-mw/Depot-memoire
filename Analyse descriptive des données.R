library(FactoMineR)
library(factoextra)
library(CASdatasets)
library(tidyverse)
library(MASS)
library(knitr)
library(ggplot2)
library(cowplot)
library(reshape2)
library(dplyr)
library(GGally)
library(corrplot)
library(carData) 
library(car)
library(questionr)
library(multcomp)
library(dplyr)
library(leaps)
library(TeachingDemos)
library(FactoMineR)
library(factoextra)
library(ROCR)
library(plotROC)
?CASdatasets

#freMPL veut dire French Motor Personal Line datasets
#On utilisera le dataset 5 qui contient environ 26000 contrats de l'annee 2004

data(freMPL5)

summary(freMPL5)

#On remarque que certaines variables sont numériques au lieu d'être considérées
#comme des facteurs. Nous allons donc les changer :
freMPL5$HasKmLimit <- factor(freMPL5$HasKmLimit)
freMPL5$ClaimInd <- factor(freMPL5$ClaimInd)
freMPL5$RiskArea <- factor(freMPL5$RiskArea)

#Pour le coefficient de bonus-malus, il commence à 1 et peut descendre jusqu'à 0.5
#si le conducteur n'a pas d'accidents responsables ou semi-responsables
#A l'inverse, en cas d'accidents responsables, le coefficient augmente et peut atteindre
#jusqu'à 3.5.
#Dans notre jeu de données, la valeur maximale est 1.85. 
#Nous n'avons donc aucune information sur des éventuels assurés possédant un malus
#supérieur. Cela pourra donc être compliqué de prédire les primes d'assurances pour ce
#genre d'individus. De manière générale, ici on a princialement des très bons conducteurs
#puisque la médianne vaut 0.5 et le 3eme quartile 0.6 et 98% des assurés sont en dessous de 1
quantile(freMPL5$BonusMalus, seq(0,1,0.02))


#   -------------------------Etude de la variables coût--------------------------------
#en fonction de la sinistralité
plot(freMPL5$ClaimAmount ~ freMPL5$ClaimInd)
summary(freMPL5$ClaimAmount[freMPL5$ClaimInd == 1]) #resumé lorsque de l'argent est demandé
summary(freMPL5$ClaimAmount[freMPL5$ClaimInd == 0])
#On remarque donc l'apparition de quelques données étranges. En effet, on a l'apparition
#de variables de coût négatives. Ceci est du à une régularisation.
#ne pouvant pas traiter cela, nous supprimerons les lignes correspondantes qui sont au
#nombre de 278
sum(ifelse(freMPL5$ClaimAmount[freMPL5$ClaimInd == 0]<0,1,0)) #=278

freMPL5 <- subset(freMPL5, freMPL5$ClaimAmount >= 0) #suppression des lignes en questions
#Nous avons autrement une distribution des coût qui est  relativement proche de 0 avec
#tout de même l'apparition de quelques sinistres graves qui faussent la moyenne.
hist(freMPL5$ClaimAmount) #écrasé par 0 car il y a énormément de petits sinistres
hist(freMPL5$ClaimAmount[freMPL5$ClaimInd == 1]) #de nouveau écrasé dans les petites valeurs
#Pour mieux voir la potentielle distribution, nous allons essayer de zoomer vers les petites valeurs
hist(freMPL5$ClaimAmount[freMPL5$ClaimInd == 1], breaks=seq(0,100000,10),xlim=c(0,3000))
#Voilà donc un graphique qui donne plus d'informations


#tests faits ici car ilisible sur le document rmd
summary(freMPL5[freMPL5$ClaimAmount>0,])
summary(freMPL5[freMPL5$ClaimAmount<110 & freMPL5$ClaimAmount>90,])
summary(freMPL5[freMPL5$ClaimInd == 0,])
summary(freMPL5[freMPL5$ClaimInd == 1,])
