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
#      "D:/Documents/Github/BayesianNetworks/communities.csv", na.strings = "?",
#      header = FALSE)

# All the vars which have to be kept
myvars <- c("V6", "V8", "V9", "V10", "V11", "V13", "V18", "V26", "V35", "V36",
            "V37", "V38", "V91", "V95", "V96", "V111", "V112", "V113",
            "V114", "V123", "V128")

# Remove all other vars from data
df_2 <- initial_df[myvars]

# Change column names
colnames(df_2) <- c("pop", "racePctB", "racePctW", "racePctA", "racePctH", 
                    "agePct12t29", "medIncome", "perCapInc", "pctLess9thGrade",
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

# Our DAG
g <- dagitty('dag 
{
agePct12t29 [pos="-0.018,0.771"]
medRent [pos="-0.249,-0.185"]
numStreet [pos="0.002,-0.177"]
pctBSorMore [pos="-0.133,-0.389"]
pctLess9thGrade [pos="0.171,-1.181"]
pctNotHSGrad [pos="-0.393,-1.106"]
pctPoliceA [pos="-0.815,-0.223"]
pctPoliceB [pos="-0.649,-0.098"]
pctPoliceH [pos="-1.038,-0.109"]
pctPoliceW [pos="-1.226,-0.245"]
pctUnemployed [pos="0.230,-0.284"]
perCapInc [pos="-0.463,-0.386"]
policeOperBudg [pos="-0.860,0.786"]
racePctA [pos="-0.815,0.164"]
racePctB [pos="-0.634,0.201"]
racePctH [pos="-1.040,0.176"]
racePctW [pos="-1.218,0.196"]
violentCrimes [pos="-0.404,0.788"]
agePct12t29 -> violentCrimes
medRent -> numStreet
medRent -> perCapInc
medRent -> violentCrimes
pctBSorMore -> medRent
pctLess9thGrade -> medRent
pctLess9thGrade -> pctNotHSGrad
pctNotHSGrad -> medRent
pctNotHSGrad -> pctBSorMore
pctUnemployed -> violentCrimes
policeOperBudg -> violentCrimes
racePctA -> violentCrimes
racePctB -> violentCrimes
racePctH -> violentCrimes
racePctW -> violentCrimes
pctLess9thGrade -> numStreet
pctBSorMore -> numStreet
pctNotHSGrad -> numStreet
pctLess9thGrade -> perCapInc
pctBSorMore -> perCapInc
pctNotHSGrad -> perCapInc
pctLess9thGrade -> pctBSorMore
} 
')

# pctLess9thGrade -> perCapInc
# pctBSorMore -> perCapInc
# pctNotHSGrad -> perCapInc
# numStreet -> violentCrimes
# pctUnemployed -> numStreet

# Homeless = numStreet and numInShelters


plot(g)
# ici <- impliedConditionalIndependencies(g)
test_results <- localTests(g, df_3, type = "cis.chisq")
# plotLocalTestResults(test_results[1,])

threshold <- 0.06
results_above_thres <- test_results[test_results$rmsea > threshold, ]
print(results_above_thres)

