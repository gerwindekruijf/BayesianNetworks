# Useful stuff:
# Command all lines, select and then : Ctrl + Shift + C

# Read file data instructions because 
# 1. file might be corrupted
# 2. everyone has a different path name

# Steps
# 1. Click "import dataset" right below "Environment" on the right side
# 2. Select "from text (base)"
# 3. Open "communities" file
# 4. Click import
# 5. R will do the magic for you

# Import for Gerwin
# initial_df <- read.csv(
#   "/Users/gerwindekruijf/Documents/Github/BayesianNetworks/communities.csv", na.strings = "?",
#   header = FALSE)

# Import for Olivier

# Import for Dirren
# initial_df <- read.csv(
#     "D:/Documents/Github/BayesianNetworks/communities.csv", na.strings = "?",
#     header = FALSE)

# All the vars which have to be kept
myvars <- c("V6", "V8", "V9", "V10", "V11", "V14", "V18", "V26", "V35", "V36",
            "V37", "V38", "V91", "V95", "V96", "V111", "V112", "V113",
            "V114", "V123", "V128")
# "V123" "policeOperBudg"
# Remove all other vars from data
df_2 <- initial_df[myvars]

# Change column names
colnames(df_2) <- c("population", "racePctB", "racePctW", "racePctA", "racePctH", 
                    "agePct16t24", "medIncome", "perCapInc", "pctLess9thGrade",
                    "pctNotHSGrad", "pctBSorMore", "pctUnemployed", "medRent",
                    "numInShelters", "numStreet", "pctPoliceW", "pctPoliceB", 
                    "pctPoliceH", "pctPoliceA", "policeOperBudg", "violentCrimes"
                    )

# Change '?' with NA
df_2[df_2 == "?"] <- NA
# Line above can be skipped if this is done from beginning:

# Keep the records which don't have NA
df_3 <- df_2[complete.cases(df_2),]


# Import dagitty
library(dagitty)
library(bnlearn)

# Our DAG
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

plot(g)
# ici <- impliedConditionalIndependencies(g)
test_results <- localTests(g, df_3)
above_p_value <- test_results[test_results$p.value < 0.05,]
above_p_value <- above_p_value[,1:2]
print(above_p_value)
plotLocalTestResults(test_results)




# summary(lm( numStreet~pctNotHSGrad+medRent + pctUnemployed + perCapInc + population + racePctA,as.data.frame(scale(df_3))))
# nmSt _||_ pNHS | mdRn, pctU, prCI, pplt, rcPA


