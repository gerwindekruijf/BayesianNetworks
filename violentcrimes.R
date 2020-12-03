# Olivier Brahma	    s1061745
# Gerwin de Kruijf	  s1063465
# Dirren van Vlijmen  s1009852

# Read the data
communities <- read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/communities/communities.data", 
                        na.strings = "?", header=FALSE)

# All the vars which have to be kept, these are explained in the README
myvars <- c("V6", "V8", "V9", "V10", "V11", "V14", "V26", "V36",
            "V37", "V38", "V91", "V96", "V111", "V112", "V113",
            "V114", "V128")

# Remove all other vars from data
df_sub <- communities[myvars]

# Change column names
colnames(df_sub) <- c("population", "racePctB", "racePctW", "racePctA", "racePctH", 
                    "agePct16t24", "perCapInc",
                    "pctNotHSGrad", "pctBSorMore", "pctUnemployed", "medRent",
                    "numStreet", "pctPoliceW", "pctPoliceB", 
                    "pctPoliceH", "pctPoliceA", "violentCrimes"
                    )

# Keep the records which don't have missing values
df_final <- df_sub[complete.cases(df_sub),]

# Keep only the records which have missing values
df_na <- df_sub[!complete.cases(df_sub),]

# Import dagitty
library(dagitty)

# Directed Acyclic Graph
g <- dagitty('dag {
  bb="-6.781,-7.29,8.351,9.149"
  agePct16t24 [pos="2.670,-4.006"]
  medRent [pos="-3.560,-3.600"]
  numStreet [pos="-1.121,2.015"]
  pctBSorMore [pos="-1.733,-6.248"]
  pctNotHSGrad [pos="2.638,-6.531"]
  pctPoliceA [pos="7.327,-3.335"]
  pctPoliceB [pos="7.422,2.810"]
  pctPoliceH [pos="7.084,1.062"]
  pctPoliceW [pos="7.158,-1.781"]
  pctUnemployed [pos="-0.498,-0.121"]
  perCapInc [pos="-4.585,1.327"]
  population [pos="-2.958,7.295"]
  racePctA [pos="5.965,-3.388"]
  racePctB [pos="5.869,3.004"]
  racePctH [pos="6.049,1.133"]
  racePctW [pos="5.922,-1.039"]
  violentCrimes [pos="3.494,7.436"]
  agePct16t24 -> medRent
  agePct16t24 -> pctUnemployed
  agePct16t24 -> perCapInc
  agePct16t24 -> violentCrimes
  medRent -> numStreet
  medRent -> pctUnemployed
  numStreet -> violentCrimes
  pctBSorMore -> medRent
  pctBSorMore -> pctPoliceB
  pctBSorMore -> pctPoliceH
  pctBSorMore -> pctPoliceW
  pctBSorMore -> pctUnemployed
  pctBSorMore -> perCapInc
  pctNotHSGrad -> medRent
  pctNotHSGrad -> numStreet
  pctNotHSGrad -> pctPoliceB
  pctNotHSGrad -> pctPoliceH
  pctNotHSGrad -> pctPoliceW
  pctNotHSGrad -> pctUnemployed
  pctNotHSGrad -> perCapInc
  pctPoliceA -> numStreet
  pctPoliceA -> violentCrimes
  pctPoliceB -> pctUnemployed
  pctPoliceB -> perCapInc
  pctPoliceH -> medRent
  pctPoliceW -> perCapInc
  pctUnemployed -> numStreet
  pctUnemployed -> violentCrimes
  perCapInc -> medRent
  perCapInc -> numStreet
  perCapInc -> pctUnemployed
  perCapInc -> violentCrimes
  population -> medRent
  population -> numStreet
  population -> pctPoliceB
  population -> pctPoliceH
  population -> pctPoliceW
  population -> perCapInc
  population -> racePctA
  population -> racePctB
  population -> racePctH
  population -> racePctW
  racePctA -> medRent
  racePctA -> numStreet
  racePctA -> pctBSorMore
  racePctA -> pctNotHSGrad
  racePctA -> pctPoliceA
  racePctA -> pctUnemployed
  racePctA -> perCapInc
  racePctA -> violentCrimes
  racePctB -> medRent
  racePctB -> pctBSorMore
  racePctB -> pctNotHSGrad
  racePctB -> pctPoliceB
  racePctB -> pctUnemployed
  racePctB -> perCapInc
  racePctB -> violentCrimes
  racePctH -> medRent
  racePctH -> pctBSorMore
  racePctH -> pctNotHSGrad
  racePctH -> pctPoliceH
  racePctH -> perCapInc
  racePctH -> violentCrimes
  racePctW -> pctBSorMore
  racePctW -> pctNotHSGrad
  racePctW -> pctPoliceW
  racePctW -> pctUnemployed
  racePctW -> perCapInc
  racePctW -> violentCrimes
}
')

# Plot the DAG
plot(g)
# test_results <- localTests(g, df_final)
# above_p_value <- test_results[test_results$p.value < 0.05,]
# above_p_value <- above_p_value[,1:2]
# print(above_p_value)



# Import bnlearn
library(bnlearn)

# Fit the DAG to the data
net <- model2network(toString(g,"bnlearn"))
fit <- bn.fit(net,as.data.frame(df_final))

# Acquire predicted probabilities
predictions <- predict(fit, node="violentCrimes", 
                       data=subset(df_na, select = 
                       c("numStreet","pctUnemployed", "racePctB", "racePctW")), 
                       method = "bayes-lw")

predictions_forall <- predict(fit, node="violentCrimes", 
                      data = subset(df_na, select = 
                      c("population", "racePctB", "racePctW", "racePctA", "racePctH", 
                      "agePct16t24", "perCapInc", "pctNotHSGrad", "pctBSorMore", 
                      "pctUnemployed", "medRent", "numStreet")), 
                      method = "bayes-lw")

# Calculate RMSE for the predictions; RMSE_4 is only for the 4 main factors
RMSE_4 <- sqrt(sum((df_na$violentCrimes - predictions)**(2)) / nrow(df_na)) 
RMSE <- sqrt(sum((df_na$violentCrimes - predictions_forall)**(2)) / nrow(df_na))

# Predict values for all the nodes without a direct edge to crime rate
seq_0_1 = seq(from = 0, to = 0.99, by = 0.01)
population_pred   <- predict(fit,node="violentCrimes", data=data.frame(population = as.double(seq_0_1)), method = "bayes-lw")
perCapInc_pred    <- predict(fit,node="violentCrimes", data=data.frame(perCapInc = as.double(seq_0_1)), method = "bayes-lw")
pctNotHSGrad_pred <- predict(fit,node="violentCrimes", data=data.frame(pctNotHSGrad = as.double(seq_0_1)), method = "bayes-lw")
pctBsorMore_pred  <- predict(fit,node="violentCrimes", data=data.frame(pctBSorMore = as.double(seq_0_1)), method = "bayes-lw")
medRent_pred      <- predict(fit,node="violentCrimes", data=data.frame(medRent = as.double(seq_0_1)), method = "bayes-lw")
pctPoliceB_pred   <- predict(fit,node="violentCrimes", data=data.frame(pctPoliceB = as.double(seq_0_1)), method = "bayes-lw")
pctPoliceH_pred   <- predict(fit,node="violentCrimes", data=data.frame(pctPoliceH = as.double(seq_0_1)), method = "bayes-lw")
pctPoliceW_pred   <- predict(fit,node="violentCrimes", data=data.frame(pctPoliceW = as.double(seq_0_1)), method = "bayes-lw")

# The 4 variables with "significant" indirect effect on crime rate 
# plot(population_pred) 
# plot(pctNotHSGrad_pred) 
# plot(pctPoliceB_pred)
# plot(pctPoliceW_pred)


pc_graph <- pc.stable(df_final, undirected = FALSE)

plot(pc_graph)

mmhc_graph <- mmhc(df_final)
plot(mmhc_graph)








