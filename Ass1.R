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

# Our DAG
g <- dagitty('dag {
bb="-6.781,-7.29,8.351,9.149"
agePct16t24 [pos="1.339,-2.611"]
medRent [pos="-2.768,-2.523"]
numStreet [pos="-0.530,2.369"]
pctBSorMore [pos="-1.733,-6.248"]
pctNotHSGrad [pos="1.170,-5.701"]
pctPoliceA [pos="6.693,-5.312"]
pctPoliceB [pos="6.936,0.250"]
pctPoliceH [pos="6.841,-1.428"]
pctPoliceW [pos="6.683,-3.193"]
pctUnemployed [pos="-0.498,-0.121"]
perCapInc [pos="-0.857,-3.970"]
population [pos="-2.958,7.295"]
racePctA [pos="4.919,-5.754"]
racePctB [pos="5.225,0.550"]
racePctH [pos="5.341,-1.657"]
racePctW [pos="5.246,-3.317"]
violentCrimes [pos="3.494,7.436"]
agePct16t24 -> medRent
agePct16t24 -> pctUnemployed
agePct16t24 -> perCapInc
agePct16t24 -> violentCrimes
medRent -> numStreet
medRent -> pctUnemployed
numStreet -> violentCrimes
pctBSorMore -> medRent
pctBSorMore -> pctUnemployed
pctBSorMore -> perCapInc
pctNotHSGrad -> medRent
pctNotHSGrad -> pctUnemployed
pctNotHSGrad -> perCapInc
pctUnemployed -> numStreet
pctUnemployed -> violentCrimes
perCapInc -> medRent
perCapInc -> violentCrimes
population -> medRent
population -> numStreet
population -> racePctA
population -> racePctB
population -> racePctH
population -> racePctW
racePctA -> medRent
racePctA -> numStreet
racePctA -> pctBSorMore
racePctA -> pctNotHSGrad
racePctA -> pctPoliceA
racePctA -> violentCrimes
racePctB -> medRent
racePctB -> pctBSorMore
racePctB -> pctNotHSGrad
racePctB -> pctPoliceB
racePctB -> violentCrimes
racePctH -> medRent
racePctH -> pctBSorMore
racePctH -> pctNotHSGrad
racePctH -> pctPoliceH
racePctH -> violentCrimes
racePctW -> medRent
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

