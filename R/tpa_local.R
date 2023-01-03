
#------------------------#
# QUESTION 1            #
#------------------------#
# Installation/mise Ã  jour des librairies
install.packages("cluster")
install.packages("dbscan")
install.packages("ggplot2")
install.packages("RPresto")
install.packages("rpart")
install.packages("randomForest")
install.packages("kknn")
install.packages("ROCR")

# Activation des librairies
library(cluster)
library(dbscan)
library(ggplot2)
library(RPresto)
library(DBI)
library(rpart)
library(randomForest)
library(kknn)
library(ROCR)

#CHANGER LE PATH PAR VOTRE PATH
path<-"C:/Users/dofla/Desktop/tpa-groupe2/R/csv/"
catalogueDB<- read.csv( paste(path,"Catalogue.csv",sep=""), header = TRUE, sep = ",", dec = ".", stringsAsFactors = T)

vehicules = catalogueDB[-1,]

#------------------------#
# AFFiCHAGES D'EFFECTIFS #
#------------------------#
# Table d'effectif
table(vehicules$marque)
table(vehicules$nom)
table(vehicules$puissance)
table(vehicules$longueur)
table(vehicules$nbplaces)
table(vehicules$nbportes)
table(vehicules$couleur)
table(vehicules$occasion)
table(vehicules$prix)



# Graphique sectoriel des marques
pie(table(vehicules$marque), main = "R?partition des marques")
pie(table(vehicules$nom), main = "R?partition des noms")
pie(table(vehicules$puissance), main = "R?partition des puissances")
pie(table(vehicules$longueur), main = "R?partition de la longueur")
pie(table(vehicules$nbplaces), main = "R?partition du nombre de places")
pie(table(vehicules$nbportes), main = "R?partition du nombre de portes")
pie(table(vehicules$couleur), main = "R?partition des couleurs")
pie(table(vehicules$occasion), main = "R?partition des occasions")
pie(table(vehicules$prix), main = "R?partition du prix")

#----------------#
# HISTOGRAMMES #
#---------------#
#Histogramme
#Ajouter la classe en couleur 
qplot(marque, data=vehicules)
qplot(nom, data=vehicules)
qplot(puissance, data=vehicules)
qplot(longueur, data=vehicules)
qplot(nbplaces, data=vehicules)
qplot(nbportes, data=vehicules)
qplot(couleur, data=vehicules)
qplot(occasion, data=vehicules)
qplot(prix, data=vehicules)

#------------------#
# NUAGES DE POINTS #
#------------------#
#Nuages de points
qplot(marque, puissance, data=vehicules, main="Nuage de points de Marque / Puissance", xlab="Marque", 
      ylab="Puissance")

#--------------------#
# BOITES A MOUSTACHE #
#--------------------#

# Boxplot (Boite ? moustache)
# Boxplot de marque dans 'vehicules'
boxplot(as.factor(vehicules$marque), data=vehicules)
boxplot(as.factor(vehicules$marque), data=vehicules, main="Distibution des marques", ylab="Valeur de marque")
summary(as.factor(vehicules$marque))

# Boxplot de nom dans 'vehicules'
boxplot(as.factor(vehicules$nom), data=vehicules)
boxplot(as.factor(vehicules$nom), data=vehicules, main="Distibution des noms de voiture", ylab="Nom")
summary(as.factor(vehicules$nom))

# Boxplot de puissance dans 'vehicules'
boxplot(vehicules$puissance, data=vehicules)
boxplot(vehicules$puissance, data=vehicules, main="Distibution des puissances de voiture", ylab="Valeur de la puissance")
summary(vehicules$puissance)

# Boxplot de la longueur dans 'vehicules'
boxplot(as.factor(vehicules$longueur), data=vehicules)
boxplot(as.factor(vehicules$longueur), data=vehicules, main="Distibution de la longueur de voiture", ylab="Valeur de la longueur")
summary(as.factor(vehicules$longueur))

# Boxplot de nombre de places dans 'vehicules'
boxplot(vehicules$nbplaces, data=vehicules)
boxplot(vehicules$nbplaces, data=vehicules, main="Distibution du nombre de places", ylab="Nombre de places")
summary(vehicules$nbplaces)

# Boxplot de nombre de places dans 'vehicules'
boxplot(vehicules$nbportes, data=vehicules)
boxplot(vehicules$nbportes, data=vehicules, main="Distibution du nombre de portes", ylab="Nombre de portes")
summary(vehicules$nbportes)

# Boxplot de la couleur dans 'vehicules'
boxplot(as.factor(vehicules$couleur), data=vehicules)
boxplot(as.factor(vehicules$couleur), data=vehicules, main="Distibution de la couleur", ylab="couleur")
summary(as.factor(vehicules$couleur))

# Boxplot de la couleur dans 'vehicules'
boxplot(as.factor(vehicules$occasion), data=vehicules)
boxplot(as.factor(vehicules$occasion), data=vehicules, main="Distibution d'occasion", ylab="occasion")
summary(as.factor(vehicules$occasion))

# Boxplot de la couleur dans 'vehicules'
boxplot(vehicules$prix, data=vehicules)
boxplot(vehicules$prix, data=vehicules, main="Distibution du prix", ylab="prix")
summary(vehicules$prix)


#------------------------#
# QUESTION 2            #
#------------------------#



#------------------------#
# QUESTION 3           #
#------------------------#
table(vehicules$categorie) 
vehicules_EA <- vehicules[1:180,]
vehicules_ET <- vehicules[181:270,]
vehicules_EA <- subset(vehicules_EA, select=-nom)
vehicules_EA <- subset(vehicules_EA, select=-moyennerejet)
vehicules_EA <- subset(vehicules_EA, select=-moyennebonus)
vehicules_EA <- subset(vehicules_EA, select=-moyenneenergie)


# Affichages
View(vehicules_EA)
View(vehicules_ET)
summary(vehicules_EA)
summary(vehicules_ET)

# Construction de l'arbre de decision
tree1 <- rpart(categorie~longueur+puissance+nbportes, vehicules_EA)

# Affichage de l'arbre par les fonctions de base de R
plot(tree1)
text(tree1, pretty=0)

#-----------------------#
# TEST DE L'ARBRE RPART #
#-----------------------#

# Application de l'arbre de decision a l'ensemble de test 'vehicules_ET'
test_tree1 <- predict(tree1, vehicules_ET, type="class")


# Affichage du vecteur de predictions de la classe des exemples de test
test_tree1

# Affichage du nombre de predictions pour chacune des classes
table(test_tree1)

# Ajout des predictions comme une nouvelle colonne 'Prediction' dans le data frame 'vehicules_ET'
vehicules_ET$Prediction <- test_tree1
View(vehicules_ET)

# Affichage de liste des exemples de test correctement predits
View(vehicules_ET[vehicules_ET$categorie==vehicules_ET$Prediction, ])

# Calcul du nombre de succes : nombre d'exemples avec classe reelle et prediction identiques
nbr_succes <- length(vehicules_ET[vehicules_ET$categorie==vehicules_ET$Prediction,"nom"])
nbr_succes

# Calcul du taux de succes : nombre de succes sur nombre d'exemples de test
taux_succes <- nbr_succes/nrow(vehicules_ET)
taux_succes

# Calcul du nombre d'echecs : nombre d'exemples avec classe reelle et prediction differentes
nbr_echecs <- length(vehicules_ET[vehicules_ET$categorie!=vehicules_ET$Prediction,"nom"])
nbr_echecs

# Calcul du taux d'echecs : nombre d'echecs sur nombre d'exemples de test
taux_echecs <- nbr_echecs/nrow(vehicules_ET)
taux_echecs

# 3)  Application des catégories de véhicules définies aux données des Immatriculations 

#-------------------------------#
# PREDICTIONS PAR L'ARBRE RPART #
#-------------------------------#

# Chargement des exemples immatriculations ( vehicules à predire ) dans un data frame 'vehicules_imm'
immatriculationsDB <- read.csv(paste(path,"immatriculations.csv",sep=""), header = TRUE, sep = ",", dec = ".", stringsAsFactors = T)
vehicules_imm = immatriculationsDB
# Application de l'arbre de decision aux véhicules dans 'vehicule_imm' : classe predite
pred_tree1 <- predict(tree1, vehicules_imm, type="class")

# Affichage des resultats (predictions)
pred_tree1

# Affichage du nombre de predictions pour chaque classe
table(pred_tree1)

# Ajout dans le data frame vehicules_imm d'une colonne CategoriePredite contenant la classe predite 
vehicules_imm$CategoriePredite <- pred_tree1
View(vehicules_imm)

# Enregistrement du fichier de resultats au format csv
# quote=false:  toutes les colonnes ne seront pas entourées de guillemets doubles
write.table(vehicules_imm, file='immatriculations_complet.csv', sep=",", dec=".", row.names = F,quote = FALSE)


# Creation d'un data frame contenant les predictions 'berline'
vehicules_imm_berline <- vehicules_imm[vehicules_imm$CategoriePredite=="berline",]
vehicules_imm_berline
# Creation d'un data frame contenant les predictions 'citadine'
vehicules_imm_citadine <- vehicules_imm[vehicules_imm$CategoriePredite=="citadine",]
vehicules_imm_citadine
# Creation d'un data frame contenant les predictions 'compacte'
vehicules_imm_compacte <- vehicules_imm[vehicules_imm$CategoriePredite=="compacte",]
vehicules_imm_compacte
# Creation d'un data frame contenant les predictions 'familiale'
vehicules_imm_familiale <- vehicules_imm[vehicules_imm$CategoriePredite=="familiale",]
vehicules_imm_familiale
# Creation d'un data frame contenant les predictions 'monospace'
vehicules_imm_monospace <- vehicules_imm[vehicules_imm$CategoriePredite=="monospace",]
vehicules_imm_monospace
# Creation d'un data frame contenant les predictions 'routiere'
vehicules_imm_routiere <- vehicules_imm[vehicules_imm$CategoriePredite=="routiere",]
vehicules_imm_routiere
# Creation d'un data frame contenant les predictions 'sportive'
vehicules_imm_sportive <- vehicules_imm[vehicules_imm$CategoriePredite=="sportive",]
vehicules_imm_sportive


#4)  Fusion des données Clients et Immatriculations :
# mettre sur une meme ligne : les infos du client et les infos du vehicule acheté ( AVEC LA CATEGORIE )
clients <- read.csv(paste(path,"clients.csv",sep=""), header = TRUE, sep = ",", dec = ".", stringsAsFactors = T)
vehicules_imm <- read.csv("immatriculations_complet.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = T)

#function pour fusionner
clientsV <- merge(x = clients, y = vehicules_imm[ , c("immatriculation","categorie")], by = "immatriculation")
clientsV$estdeuxiemevoiture <- as.logical(clientsV$estdeuxiemevoiture)
clientsV$age <- as.integer(as.character(clientsV$age))
clientsV$nbenfantsacharge <- as.integer(as.character(clientsV$nbenfantsacharge))
clientsV$taux <- as.integer(as.character(clientsV$taux))
clientsV<-na.omit(clientsV)
clientsV$sexe[clientsV$sexe=="Masculin"] <- "M"

colnames(clientsV)[7] <- 'deuxiemevoiture'
clientsV$sexe <- as.character(clientsV$sexe)
clientsV$situationFamiliale <- as.character(clientsV$situationFamiliale)


# 5) Pour la 5 eme partie, on va utiliser clients_vehicules

#------------------------#
# QUESTION 5             #
#------------------------#
clientsV_EA <- clientsV[1:100096,]
clientsV_ET <- clientsV[100097:198017,]
clientsV_EA <- subset(clientsV_EA, select=-immatriculation)
clientsV_ET <- subset(clientsV_ET, select=-immatriculation)





# Affichage
View(clientsV)
View(clientsV_EA)
View(clientsV_ET)
summary(clientsV_EA)
summary(clientsV_ET)

# Arbre de decision

# Mettre les donn�es � la bonne forme
clientsV_EA$deuxiemevoiture <- as.factor(clientsV_EA$deuxiemevoiture)
clientsV_EA$situationFamiliale[clientsV_EA$situationFamiliale=="N/D"] <- "Celibataire"
clientsV_EA$situationFamiliale[clientsV_EA$situationFamiliale=="Seul"] <- "Celibataire"

clientsV_EA$nbenfantsacharge[clientsV_EA$nbenfantsacharge=="?"] <- 0
clientsV_EA$nbenfantsacharge[clientsV_EA$nbenfantsacharge=="N/D"] <- 0
clientsV_EA$nbenfantsacharge[clientsV_EA$nbenfantsacharge==" "] <- 0
clientsV_EA$nbenfantsacharge[clientsV_EA$nbenfantsacharge=="-1"] <- 0
clientsV_EA$nbenfantsacharge <- as.factor(clientsV_EA$nbenfantsacharge)


clientsV_ET$deuxiemevoiture <- as.factor(clientsV_ET$deuxiemevoiture)
clientsV_ET$situationFamiliale[clientsV_ET$situationFamiliale=="N/D"] <- "Celibataire"
clientsV_ET$situationFamiliale[clientsV_ET$situationFamiliale=="Seul"] <- "Celibataire"

clientsV_ET$nbenfantsacharge[clientsV_ET$nbenfantsacharge=="?"] <- 0
clientsV_ET$nbenfantsacharge[clientsV_ET$nbenfantsacharge=="N/D"] <- 0
clientsV_ET$nbenfantsacharge[clientsV_ET$nbenfantsacharge==" "] <- 0
clientsV_ET$nbenfantsacharge[clientsV_ET$nbenfantsacharge=="-1"] <- 0
clientsV_ET$nbenfantsacharge <- as.factor(clientsV_ET$nbenfantsacharge)


# Construction de l'arbre de decision
#RPART
treeClients <- rpart(categorie~nbenfantsacharge+situationFamiliale+deuxiemevoiture+taux+sexe+age, clientsV_EA)
# Affichage de l'arbre par les fonctions de base de R
plot(treeClients)
text(treeClients, pretty=0)
clientsV_EA$nbenfantsacharge
#-----------------------#
# TEST DE L'ARBRE RPART #
#-----------------------#

# Application de l'arbre de decision a l'ensemble de test 'vehicules_ET'
test_treeClients <- predict(treeClients, clientsV_ET, type="class")


# Affichage du vecteur de predictions de la classe des exemples de test
test_treeClients

# Affichage du nombre de predictions pour chacune des classes
table(test_treeClients)
# Ajout des predictions comme une nouvelle colonne 'Prediction' dans le data frame 'vehicules_ET'
clientsV_ET$Prediction <- test_treeClients
View(clientsV_ET)
#########
# Affichage de liste des exemples de test correctement predits
View(clientsV_ET[clientsV_ET$categorie==clientsV_ET$Prediction, ])

# Calcul du nombre de succes : nombre d'exemples avec classe reelle et prediction identiques
nbr_succes <- length(clientsV_ET[clientsV_ET$categorie==clientsV_ET$Prediction,"immatriculation"])
nbr_succes

# Calcul du taux de succes : nombre de succes sur nombre d'exemples de test
taux_succes <- nbr_succes/nrow(clientsV_ET)
taux_succes

# Calcul du nombre d'echecs : nombre d'exemples avec classe reelle et prediction differentes
nbr_echecs <- length(clientsV_ET[clientsV_ET$categorie!=clientsV_ET$Prediction,"immatriculation"])
nbr_echecs

# Calcul du taux d'echecs : nombre d'echecs sur nombre d'exemples de test
taux_echecs <- nbr_echecs/nrow(clientsV_ET)
taux_echecs

# Random forest
View(clientsV_EA)

clientsV_ET <- subset(clientsV_ET, select=-Prediction)

rf <- randomForest(categorie~., clientsV_EA, ntree = 100, mtry = 1)
# Test du classifeur : classe predite
rf_class <- predict(rf,clientsV_ET, type="class")
# Matrice de confusion
print(table(clientsV_ET$categorie, rf_class))

#Autre randomForest avec d'autres param�tres
rf <- randomForest(categorie~., clientsV_EA, ntree = 300, mtry = 5)
rf_class <- predict(rf,clientsV_ET, type="class")
print(table(clientsV_ET$categorie, rf_class))

# KNN, cr�ation d'une fonction
test_knn <- function(arg1, arg2){
  # Apprentissage et test simultanes du classifeur de type k-nearest neighbors
  knn <- kknn(categorie~ age + sexe + taux + nbenfantsacharge, clientsV_EA, clientsV_ET, k = arg1, distance = arg2)
  #Test classifieur
  
  # Matrice de confusion
  print(table(clientsV_ET$categorie, knn$fitted.values))
  invisible()
}

test_knn(10, 2) 
test_knn(10, 4) 
test_knn(10, 5) 
test_knn(50, 5) 
test_knn(100, 5)

#RANDOM FOREST AVEC NTREE=300 et MTRY=5 EST POUR NOUS LA MEILLEURE PREDICTION
############ CREATION DUN FICHIER MARKETING AVEC LES PREDICTIONS
  marketingDB<-read.csv(paste(path,"Marketing.csv",sep=""), header = TRUE, sep = ",", dec = ".", stringsAsFactors = T)
  marketingDB$situationFamiliale <- as.character(marketingDB$situationFamiliale)
  marketingDB$sexe <- as.character(marketingDB$sexe)
  marketingDB$deuxiemevoiture <- as.logical(marketingDB$deuxiemevoiture)
  
  marketingDB$nbenfantsacharge <- as.factor(marketingDB$nbenfantsacharge)
  marketingDB$deuxiemevoiture <- as.factor(marketingDB$deuxiemevoiture)
  
  predictionVoiture <- predict(rf,marketingDB, type="response")
  marketingDB$predictionvoiture <- predictionVoiture

  View(marketingDB)
  write.table(vehicules_imm, file='Marketing_predites.csv', sep=",", dec=".", row.names = F,quote = FALSE)
  



