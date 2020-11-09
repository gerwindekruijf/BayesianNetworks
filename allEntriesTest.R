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
initial_df <- read.csv(
  "D:/Documents/Github/BayesianNetworks/communities.csv", na.strings = "?",
  header = FALSE)

# All the vars which have to be kept
myvars <- c("V6", "V8", "V9", "V10", "V11", "V13", "V18", "V26", "V35", "V36",
            "V37", "V38", "V91", "V95", "V96", "V128")

# Remove all other vars from data
df_2 <- initial_df[myvars]


# Change column names
colnames(df_2) <- c("pop", "racePctB", "racePctW", "racePctA", "racePctH", 
                    "agePct12t29", "medIncome", "perCapInc", "pctLess9thGrade",
                    "pctNotHSGrad", "pctBSorMore", "pctUnemployed", "medRent",
                    "numInShelters", "numStreet", "violentCrimes")

df_half  <- df_2[1:(dim(df_2)[1]-1800),] 

# Import dagitty
library(dagitty)

# Our DAG
g <- dagitty('dag 
{
agePct12t29 [pos="-0.018,0.771"]
medRent [pos="-0.249,-0.185"]
numStreet [pos="0.002,-0.177"]
pctBSorMore [pos="-0.133,-0.389"]
pctUnemployed [pos="0.230,-0.484"]
perCapInc [pos="-0.463,-0.386"]
racePctB [pos="-0.634,0.201"]
violentCrimes [pos="-0.404,0.788"]
} 
')
# 
# pctBSorMore -> perCapInc
# pctBSorMore -> numStreet
# racePctB -> pctUnemployed
# racePctB -> perCapInc
# pctUnemployed -> violentCrimes
# pctUnemployed -> numStreet
# perCapInc -> medRent
# medRent -> numStreet
# violentCrimes -> medRent
# agePct12t29 -> violentCrimes

# racePctA [pos="-0.815,0.164"]
# racePctH [pos="-1.040,0.176"]
# racePctW [pos="-1.218,0.196"]
# racePctA -> pctUnemployed
# racePctH -> pctUnemployed
# racePctW -> pctUnemployed
# racePctA -> perCapInc
# racePctH -> perCapInc
# racePctW -> perCapInc

# pctLess9thGrade [pos="0.171,-1.181"]
# pctNotHSGrad [pos="-0.393,-1.106"]
# pctLess9thGrade -> pctBSorMore
# pctLess9thGrade -> perCapInc
# pctLess9thGrade -> pctNotHSGrad
# pctNotHSGrad -> pctBSorMore
# pctNotHSGrad -> perCapInc
# pctLess9thGrade -> numStreet
# pctNotHSGrad -> numStreet

# medRent -> numStreet
# medRent -> perCapInc
# pctLess9thGrade -> perCapInc
# pctBSorMore -> perCapInc
# pctNotHSGrad -> perCapInc
# numStreet -> violentCrimes
# pctUnemployed -> numStreet

# Homeless = numStreet and numInShelters


plot(g)
# ici <- impliedConditionalIndependencies(g)
test_results <- localTests(g, df_2, type = "cis.chisq")
# plotLocalTestResults(test_results[1,])
threshold <- 0.06
#results_above_thres <- test_results[test_results$rmsea > threshold, ]
results_above_thres <- test_results[test_results$rmsea > threshold,]
print(results_above_thres)