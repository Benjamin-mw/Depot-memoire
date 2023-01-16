#install.packages("CASdatasets", repos = "http://dutangc.perso.math.cnrs.fr/RRepository/", type="source")
#install.packages("CASdatasets", repos = "http://dutangc.free.fr/pub/RRepos/", type="source")
#install.packages("CASdatasets", repos = "http://cas.uqam.ca/pub/", type="source")

#library(CASdatasets)
install.packages("rpart")
install.packages("partykit")
library(rpart)
library(partykit)
install.packages("devtools")
devtools::install_github("dutangc/CASdatasets", subdir="pkg")
library(CASdatasets)


install.packages("xts")
install.packages("sp")
install.packages("zoo")
