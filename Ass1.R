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
g <- dagitty('dag {
bb="-6.781,-7.29,8.351,9.149"
agePct16t24 [pos="-1.343,-0.789"]
medRent [pos="-2.884,-2.649"]
numStreet [pos="-1.290,0.876"]
pctBSorMore [pos="-0.878,-4.491"]
pctNotHSGrad [pos="0.759,-4.562"]
pctPoliceA [pos="2.902,-3.499"]
pctPoliceB [pos="2.966,0.345"]
pctPoliceH [pos="2.913,-1.001"]
pctPoliceW [pos="2.913,-2.330"]
pctUnemployed [pos="0.062,-1.232"]
perCapInc [pos="-1.364,-2.684"]
pop [pos="-2.884,0.859"]
racePctA [pos="1.857,-3.481"]
racePctB [pos="1.878,0.363"]
racePctH [pos="1.867,-1.037"]
racePctW [pos="1.846,-2.295"]
violentCrimes [pos="0.241,1.992"]
agePct16t24 -> pctUnemployed
agePct16t24 -> perCapInc
agePct16t24 -> violentCrimes
medRent -> numStreet
numStreet -> violentCrimes
pctBSorMore -> pctUnemployed
pctBSorMore -> perCapInc
pctNotHSGrad -> pctUnemployed
pctNotHSGrad -> perCapInc
pctUnemployed -> numStreet
pctUnemployed -> violentCrimes
perCapInc -> medRent
perCapInc -> violentCrimes
pop -> medRent
pop -> numStreet
racePctA -> pctBSorMore
racePctA -> pctNotHSGrad
racePctA -> pctPoliceA
racePctA -> violentCrimes
racePctB -> pctBSorMore
racePctB -> pctNotHSGrad
racePctB -> pctPoliceB
racePctB -> violentCrimes
racePctH -> pctBSorMore
racePctH -> pctNotHSGrad
racePctH -> pctPoliceH
racePctH -> violentCrimes
racePctW -> pctBSorMore
racePctW -> pctNotHSGrad
racePctW -> pctPoliceW
racePctW -> violentCrimes
}

')

plot(g)
# ici <- impliedConditionalIndependencies(g)
test_results <- localTests(g, df_3)
above_p_value <- test_results[test_results$p.value < 0.05,]
print(above_p_value)
plotLocalTestResults(test_results)

