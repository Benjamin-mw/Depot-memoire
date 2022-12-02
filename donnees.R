library(CASdatasets)
?CASdatasets

#Cours de LaTeX le 16 janvier
#l'avoir préparer avant peut etre utile
#MarkDown ou (Quorto ?) sur Rstudio pour rediger du LaTeX sans etre aussi rigoureux
#outil assez puissant car plus souple
#Bien faire les bibliographies avec des noms de référence clicables

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


#Exposure est une variable relatant de la duree d'un contrat (en fraction d'annee)
#obtenue a partir des variables RecordBeg et RecordEnd
#On devra alors supposer que les fréquences et couts sont independants de la 
#periode de l'annee pour l'utiliser convenablement

#Qu'est-ce que le ClaimInd et le ClaimNbParking ?

#Faut-il mettre les accidents non-responsables dans le calcul de fréquence ?
#Ou alors est-ce a l'assureur du responsable de dédomager ?

#On devra introduire une nouvelle variable pour la frequence (a expliquer :
#Freq = ClaimNbResp+ClaimNbParking+ClaimNbFireTheft+ClaimNbWindscreen+OutUseNb)
#Devra-t-on la diviser par 4 (oui) pour obtenir une moyenne sur 1 an plutot que sur 4 ans

#Ensuite, on introduira une nouvelle variable sur le cout moyen (a expliquer :
#CoutMoyen = ClaimAmount[pour les assures ayant eu au moins un sinistre]/NbSinistres[de cet assuré])

#Questions : Pourquoi certains assures possedent un montant reclame negatif ?
#S'agit-il d'une regularisation suite a un avancement trop important ?

freMPL5$Freq = (freMPL5$ClaimNbResp+freMPL5$ClaimNbParking+freMPL5$ClaimNbFireTheft+freMPL5$ClaimNbWindscreen+freMPL5$OutUseNb)/4
freMPL5$Cout = ifelse(freMPL5$Freq != 0, freMPL5$Amount/freMPL5$Freq, 0)
#ce code ne fonctionne pas car R comprend mal la division a faire ici ?

summary(freMPL5)

x <- freMPL5[, c(1,2,9,11,12,13,14,15,16,17,18,19)]

y <- princomp(x, cor = FALSE, scores = TRUE)
#C'est une ACP sur les données quantitatives (on a ici considéré la zone
#comme faisant partie des variables quantitatives car c'est "possibly ordered")