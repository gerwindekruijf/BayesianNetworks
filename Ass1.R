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

# Remove all other vars from data
df_2 <- initial_df[myvars]

# Change column names
colnames(df_2) <- c("pop", "racePctB", "racePctW", "racePctA", "racePctH", 
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

# Our DAG
g <- dagitty('dag 
{
violentCrimes [pos="-0.404,0.788"]
agePct16t24 [pos="-0.018,0.771"]
medRent [pos="-0.249,-0.185"]
pctBSorMore [pos="-0.133,-0.389"]
numStreet [pos="0.002,-0.177"]
pctLess9thGrade [pos="0.171,-1.181"]
pctNotHSGrad [pos="-0.393,-1.106"]
pctPoliceA [pos="-0.815,-0.223"]
pctPoliceB [pos="-0.634,-0.223"]
pctPoliceH [pos="-1.040,-0.223"]
pctPoliceW [pos="-1.218,-0.223"]
racePctA [pos="-0.815,0.164"]
racePctB [pos="-0.634,0.201"]
racePctH [pos="-1.040,0.176"]
racePctW [pos="-1.218,0.196"]
agePct16t24 -> violentCrimes
medRent -> numStreet
pctBSorMore -> pctUnemployed
pctBSorMore -> perCapInc
numStreet -> violentCrimes
pctLess9thGrade -> pctNotHSGrad
pctLess9thGrade -> pctUnemployed
pctLess9thGrade -> perCapInc
pctNotHSGrad -> pctBSorMore
pctNotHSGrad -> pctUnemployed
pctNotHSGrad -> perCapInc
pctUnemployed -> violentCrimes
pctUnemployed -> numStreet
perCapInc -> violentCrimes
perCapInc -> medRent
policeOperBudg -> violentCrimes
racePctA -> violentCrimes
racePctA -> pctPoliceA
racePctB -> violentCrimes
racePctB -> pctPoliceB
racePctH -> violentCrimes
racePctH -> pctPoliceH
racePctW -> violentCrimes
racePctW -> pctPoliceW
}
')

 
# racePctA -> pctUnemployed
# racePctB -> pctUnemployed
# racePctH -> pctUnemployed
# racePctW -> pctUnemployed

# medRent -> numStreet
# medRent -> perCapInc
# pctLess9thGrade -> perCapInc
# pctBSorMore -> perCapInc
# pctNotHSGrad -> perCapInc
# numStreet -> violentCrimes
# pctUnemployed -> numStreet


plot(g)
# ici <- impliedConditionalIndependencies(g)
test_results <- localTests(g, df_3)
#above_p_value <- test_results[test_results$p.value < 0.05,]
#print(above_p_value)
#plotLocalTestResults(test_results)

