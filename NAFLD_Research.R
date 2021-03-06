#Reading in the file
library(readxl)
data <- read_excel("Mexican Bariatric Surgery Database_april_2019.xlsx")
 

## Classification based on Diagnostic Status
final <- data[,c(2, 3, 4, 19, 20, 21, 13, 15, 62, 74, 42, 43, 37)]#Subsetting the required variables
final <- final[-c(1, 2), ]#Removing first two rows
 

  
library(dplyr)
final <- final[complete.cases(final), ]#Removing NAs
colnames(final)[2] <- "Sex"
colnames(final)[7] <- "Total_Cholestrol"
colnames(final)[12] <- "PNPLA3_genotype"
final[, 1:12] <- final[, 1:12] %>% mutate_if(is.character, as.numeric)#Converting character variables to numeric
final[, 4:10] <- lapply(final[, 4:10], log)#Taking the log of the required variables
final[final$Status_diagnostic == "Uncertain", 13] <- "NASH Bordeline"
final[final$Status_diagnostic == "Control", 13] <- "Steatosis"
final <- final[complete.cases(final), ]
#colSums(is.na(final))
 

#### Correlation Plot
library(corrplot)
corrplot(cor(final[,1:12]), order = "hclust")
 

#### Random Forest Variable Importance Plot
library(randomForest)
forest.nafld <- randomForest(factor(Status_diagnostic) ~., data=final, type="classification")
varImpPlot(forest.nafld, type = 2)
 

#### Decision Tree Variable Importance Values
library(tree)
library(caret)
library(rpart)
tree.nafld = rpart(factor(Status_diagnostic) ~., data=final, method = "class")
tree.nafld$variable.importance
 

## Linear Model for Steatosis Stage
final_steatosis <- data[,c(2, 3, 4, 19, 20, 21, 13, 15, 62, 74, 42, 43, 45:91, 38)]
final_steatosis <- subset(final_steatosis, select = -c(44, 51))
final_steatosis <- final_steatosis[-c(1, 2), ]
final_steatosis <- final_steatosis[, c(1:43, 58)]
 

  
#Data Cleaning
colnames(final_steatosis)[2] <- "Sex"
colnames(final_steatosis)[7] <- "Total_Cholestrol"
colnames(final_steatosis)[9] <- "Total_PC_Plasmalogens1"
colnames(final_steatosis)[10] <- "Total_TG1"
colnames(final_steatosis)[12] <- "PNPLA3_genotype"
final_steatosis <- final_steatosis %>% mutate_if(is.character, as.numeric)
final_steatosis[, c(4:10, 13:43)] <- lapply(final_steatosis[, c(4:10, 13:43)], log)
#final1[is.na(final1)] <- 0
final_steatosis <- final_steatosis[complete.cases(final_steatosis), ]
#colSums(is.na(final_steatosis))
 

#### Linear Model (r-squared = 42%) - Asterisks near variable row indicate significance
m1 <- lm(final_steatosis$Steatosis_stage~., data = final_steatosis)
summary(m1)
 

#### Random Forest Regression (Top 10)
library(randomForest)
m2 <- randomForest(final_steatosis$Steatosis_stage~., data = final_steatosis, type="regression")
varImpPlot(m2, type = 2, n.var = 10, main = "Steatosis Stage Linear Model")
 

## Linear Model for Inflammation Stage
final_inflammation <- data[,c(2, 3, 4, 19, 20, 21, 13, 15, 62, 74, 42, 43, 45:91, 39)]
final_inflammation <- subset(final_inflammation, select = -c(44, 51))
final_inflammation <- final_inflammation[-c(1, 2), ]
final_inflammation <- final_inflammation[, c(1:43, 58)]
 

  
#Data Cleaning
colnames(final_inflammation)[2] <- "Sex"
colnames(final_inflammation)[7] <- "Total_Cholestrol"
colnames(final_inflammation)[9] <- "Total_PC_Plasmalogens1"
colnames(final_inflammation)[10] <- "Total_TG1"
colnames(final_inflammation)[12] <- "PNPLA3_genotype"
final_inflammation <- final_inflammation %>% mutate_if(is.character, as.numeric)
final_inflammation[, c(4:10, 13:43)] <- lapply(final_inflammation[, c(4:10, 13:43)], log)
#final1[is.na(final1)] <- 0
final_inflammation <- final_inflammation[complete.cases(final_inflammation), ]
#colSums(is.na(final_inflammation))
 

#### Linear Model (r-squared = 17%) - Asterisks near variable row indicate significance
m3 <- lm(final_inflammation$Inflammation_stage~., data = final_inflammation)
summary(m3)
 

#### Random Forest Regression (Top 10)
library(randomForest)
m4 <- randomForest(final_inflammation$Inflammation_stage~., data = final_inflammation, type="regression")
varImpPlot(m4, type = 2, n.var = 10, main = "Inflammation Stage Linear Model")
 

## Linear Model for Ballooning Stage
final_ballooning <- data[,c(2, 3, 4, 19, 20, 21, 13, 15, 62, 74, 42, 43, 45:91, 40)]
final_ballooning <- subset(final_ballooning, select = -c(44, 51))
final_ballooning <- final_ballooning[-c(1, 2), ]
final_ballooning <- final_ballooning[, c(1:43, 58)]
 

  
#Data Cleaning
colnames(final_ballooning)[2] <- "Sex"
colnames(final_ballooning)[7] <- "Total_Cholestrol"
colnames(final_ballooning)[9] <- "Total_PC_Plasmalogens1"
colnames(final_ballooning)[10] <- "Total_TG1"
colnames(final_ballooning)[12] <- "PNPLA3_genotype"
final_ballooning <- final_ballooning %>% mutate_if(is.character, as.numeric)
final_ballooning[, c(4:10, 13:43)] <- lapply(final_ballooning[, c(4:10, 13:43)], log)
#final1[is.na(final1)] <- 0
final_ballooning <- final_ballooning[complete.cases(final_ballooning), ]
#colSums(is.na(final_ballooning))
 

#### Linear Model (r-squared = 32%) - Asterisks near variable row indicate significance
m5 <- lm(final_ballooning$Balloning_stage~., data = final_ballooning)
summary(m5)
 

#### Random Forest Regression (Top 10)
library(randomForest)
m6 <- randomForest(final_ballooning$Balloning_stage~., data = final_ballooning, type="regression")
varImpPlot(m6, type = 2, n.var = 10, main = "Balooning Stage Linear Model")
 

## Linear Model for NAS Score
final_NAS <- data[,c(2, 3, 4, 19, 20, 21, 13, 15, 62, 74, 42, 43, 45:91, 41)]
final_NAS <- subset(final_NAS, select = -c(44, 51))
final_NAS <- final_NAS[-c(1, 2), ]
final_NAS <- final_NAS[, c(1:43, 58)]
 

  
#Data Cleaning
colnames(final_NAS)[2] <- "Sex"
colnames(final_NAS)[7] <- "Total_Cholestrol"
colnames(final_NAS)[9] <- "Total_PC_Plasmalogens1"
colnames(final_NAS)[10] <- "Total_TG1"
colnames(final_NAS)[12] <- "PNPLA3_genotype"
final_NAS <- final_NAS %>% mutate_if(is.character, as.numeric)
final_NAS[, c(4:10, 13:43)] <- lapply(final_NAS[, c(4:10, 13:43)], log)
#final1[is.na(final1)] <- 0
final_NAS <- final_NAS[complete.cases(final_NAS), ]
#colSums(is.na(final_NAS))
 

#### Linear Model (r-squared = 37%) - Asterisks near variable row indicate significance
m7 <- lm(final_NAS$`NAS score`~., data = final_NAS)
summary(m7)
 

#### Random Forest Regression (Top 10)
library(randomForest)
m8 <- randomForest(final_NAS$`NAS score`~., data = final_NAS, type="regression")
varImpPlot(m8, type = 2, n.var = 10, main = "NAS Score Linear Model")
 

## Data for Correlation Plots
final_corr <- data[,c(2, 3, 4, 19, 20, 21, 13, 15, 62, 74, 42, 43, 45:91, 37)]
final_corr <- subset(final_corr, select = -c(44, 51))
final_corr <- final_corr[-c(1, 2), ]
final_corr <- final_corr[, c(1:43, 58)]
 

  
#Data Cleaning
colnames(final_corr)[2] <- "Sex"
colnames(final_corr)[7] <- "Total_Cholestrol"
colnames(final_corr)[9] <- "Total_PC_Plasmalogens1"
colnames(final_corr)[10] <- "Total_TG1"
colnames(final_corr)[12] <- "PNPLA3_genotype"
final_corr[, -44] <- final_corr[, -44] %>% mutate_if(is.character, as.numeric)
final_corr[, c(4:10, 13:43)] <- lapply(final_corr[, c(4:10, 13:43)], log)
#final1[is.na(final1)] <- 0
final_corr <- final_corr[complete.cases(final_corr), ]
#colSums(is.na(final_corr))
 

  
final_corr <- final_corr[final_corr$Status_diagnostic == "Control", ]
 

## Correlation Plots
png(filename="Steatosis_Corrplot.png", width=800, height=800)
library(corrplot)
corrplot(cor(final_corr[,2:43]), order = "alphabet")
dev.off()
 

  
png(filename="NASH_Corrplot.png", width=800, height=800)
library(corrplot)
corrplot(cor(final_corr[,2:43]), order = "alphabet")
dev.off()
 

  
png(filename="Uncertain_Corrplot.png", width=800, height=800)
library(corrplot)
corrplot(cor(final_corr[,2:43]), order = "alphabet")
dev.off()
 

  
png(filename="Control_Corrplot.png", width=800, height=800)
library(corrplot)
corrplot(cor(final_corr[,2:43]), order = "alphabet")
dev.off()
 