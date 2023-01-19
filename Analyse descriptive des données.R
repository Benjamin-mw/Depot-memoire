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
