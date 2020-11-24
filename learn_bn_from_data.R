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