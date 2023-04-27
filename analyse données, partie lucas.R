### Utilisation du véhicule

```{r}
summary(freMPL5$VehUsage)
```

La variable VehUsage de notre jeu de données a quatre modalités concernant l'utilisation des vehicules (Private+trip to office, Private, Professionanal, Professional run). L'usage le plus fréquent étant "Private+trip to office" et la modalité la moins utilisée est "Professional run"

##### Etude par rapport à la sinistralité

```{r}
table(freMPL5$VehUsage, freMPL5$ClaimInd)

summary(freMPL5$VehUsage[freMPL5$ClaimInd == 0])

summary(freMPL5$VehUsage[freMPL5$ClaimInd == 1])

mosaicplot(table(freMPL5$ClaimInd,freMPL5$VehUsage))
```

##### Etude par rapport au coût

```{r}
plot(freMPL5$ClaimAmount ~ freMPL5$VehUsage)
boxplot(freMPL5$ClaimAmount[freMPL5$ClaimAmount>0] ~ freMPL5$VehUsage[freMPL5$ClaimAmount>0], ylim=c(0,6000))

```

### Limite kilométrique

```{r}
summary(freMPL5$HasKmLimit)
```

##### Etude par rapport à la sinistralit

```{r}
table(freMPL5$HasKmLimit, freMPL5$ClaimInd)

summary(freMPL5$HasKmLimit[freMPL5$ClaimInd == 0])

summary(freMPL5$HasKmLimit[freMPL5$ClaimInd == 1])

mosaicplot(table(freMPL5$ClaimInd,freMPL5$HasKmLimit))
```

Que ce soit avec ou sans limite de km sur le contrat, une faible partie des individus auront tendances à avoir un sinistre.

##### Etude par rapport au coût

```{r}
boxplot(freMPL5$ClaimAmount ~ freMPL5$HasKmLimit)
boxplot(freMPL5$ClaimAmount[freMPL5$ClaimAmount>0] ~ freMPL5$HasKmLimit[freMPL5$ClaimAmount>0], ylim=c(0,6000))
```

Lègère tendance à la hausse du prix à payer pour les individus ayant pris un contrat avec une limite de km

### Zone de risque

Cette catégorie devra être regroupée (idem CSP)

```{r}
summary(freMPL5$RiskArea)
```

Très peu d'individu sont classés dans les zones de risques de niveau 1, 12 et 13.

La grande majorité des individus sont dans la zone de niveau 7, puis dans les zones 10,6,19 et 11

##### Etude par rapport à la sinistralité

```{r}
table(freMPL5$RiskArea,freMPL5$ClaimInd)

summary(freMPL5$RiskArea[freMPL5$ClaimInd == 0])

summary(freMPL5$RiskArea[freMPL5$ClaimInd == 1])

boxplot(freMPL5$RiskArea ~ freMPL5$ClaimInd)

mosaicplot(table(freMPL5$ClaimInd,freMPL5$RiskArea))
```

A chaque zone de risque, il y a largement davantage d'individus n'ayant pas déclaré de garanti que d'individu ayant déclaré une garanti.

##### Etude par rapport au coût

```{r}
plot(freMPL5$ClaimAmount ~ freMPL5$RiskArea)
boxplot(freMPL5$ClaimAmount[freMPL5$ClaimAmount>0] ~ freMPL5$RiskArea[freMPL5$ClaimAmount>0], ylim=c(0,6000))
```

Les individus ayant tendances à payer plus cher les sinistres se situent dans les zones de risques de niveau les plus élévées.
