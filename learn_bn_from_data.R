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
df_na <- df_sub


manual_graph <- dagitty('dag {
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


net <- model2network(toString(manual_graph,"bnlearn"))

# Import dagitty
library(dagitty)
library(bnlearn)

complexity <- function(network){
  x <- (length(network$arcs) / 2) / length(network$nodes)
  y <- 0
  
  for (n in network$nodes){
    y <- y + (x - (length(n[["parents"]]) + length(n[["children"]])) / 2)^2
  }
  
  return(y)
}

# PC scoring -------------------------------------------------------------------

ordering <- c("population","racePctW", "racePctB",  "racePctA", "racePctH", 
              "agePct16t24", "perCapInc", "pctBSorMore",
              "pctNotHSGrad", "pctUnemployed", "medRent",
              "numStreet", "pctPoliceW", "pctPoliceB", 
              "pctPoliceH", "pctPoliceA", "violentCrimes"
)

score_list <- as.data.frame(matrix(,0,3))
names(score_list) <- c("Complexity", "RMSE", "Label")
# nominal type 1 error rate
for (a in seq(0,0.95,by = 0.05)){
  tryCatch(
    {
      pc_graph_alpha <- pc.stable(df_final, alpha = a)
      pc_graph_alpha <- pdag2dag(pc_graph_alpha, ordering = ordering)
      pc_graph_fit_alpha <- bn.fit(pc_graph_alpha,as.data.frame(df_final))

      predictions_forall <- predict(pc_graph_fit_alpha, node="violentCrimes", 
                                    data = subset(df_na, select = 
                                                    c("population", "racePctB", "racePctW", "racePctA", "racePctH", 
                                                      "agePct16t24", "perCapInc", "pctNotHSGrad", "pctBSorMore", 
                                                      "pctUnemployed", "medRent", "numStreet")), 
                                    method = "bayes-lw")
      RMSE <- sqrt(sum((df_na$violentCrimes - predictions_forall)**(2)) / nrow(df_na))
      
      score <- data.frame(complexity(pc_graph_alpha), RMSE, a) #length(pc_graph_alpha$arcs) / 2
      names(score) <- c("Complexity", "RMSE", "Label")
      score_list <- rbind(score_list, score)
    },
    error = function(cond){
      message(paste("The graph cannot be directed for alpha = ", a))
      
    }
  )
}

plot(RMSE ~Edges, col="lightblue", pch=19, cex=2,data=score_list)
text(RMSE ~Edges, labels=score_list$Label,data=score_list, cex=0.9, font=2)

# Tabu scoring -------------------------------------------------------------------

score_list <- as.data.frame(matrix(,0,3))
names(score_list) <- c("Complexity", "RMSE", "Label")
# score value k
for (k in seq(1, 10, by = 1)){
  tryCatch(
    {
      tabu_graph <- tabu(df_final, k = k)
      tabu_graph_fit <- bn.fit(tabu_graph,as.data.frame(df_final))

      predictions_forall <- predict(tabu_graph_fit, node="violentCrimes", 
                                    data = subset(df_na, select = 
                                                    c("population", "racePctB", "racePctW", "racePctA", "racePctH", 
                                                      "agePct16t24", "perCapInc", "pctNotHSGrad", "pctBSorMore", 
                                                      "pctUnemployed", "medRent", "numStreet")), 
                                    method = "bayes-lw")
      
      RMSE <- sqrt(sum((df_na$violentCrimes - predictions_forall)**(2)) / nrow(df_na))
      score <- data.frame(complexity(tabu_graph), RMSE, k)
      names(score) <- c("Complexity", "RMSE", "Label")
      score_list <- rbind(score_list, score)
    },
    error = function(cond){
      message(paste("The graph cannot be directed for score = ", k))
    }
  )
}

plot(RMSE ~Edges, col="lightblue", pch=19, cex=2,data=score_list)
text(RMSE ~Edges, labels=score_list$Label,data=score_list, cex=0.9, font=2)
