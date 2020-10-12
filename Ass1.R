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
initial_df <- communities

# Our data did not come with the attribute names
# instead of adding the attribute names, we manually delete Vx for every
# x we do not want, then we change Vx to the right name

# V8 = racePctBlack
# V9 = racePctWhite
# V10 = racePctAsian
# V11 = racePctHisp
# V13 = agePct12t29
# V18 = medIncome
# V26 = perCapInc
# V35 = PctLess9thGrade
# V36 = PctNotHSGrad
# V37 = PctBSorMore
# V38 = PctUnemployed
# V91 = MedRent
# V95 = NumInShelters (homeless in shelters)
# V96 = NumStreet (homeless on street)
# V111 = PctPoliceWhite
# V112 = PctPoliceBlack
# V113 = PctPoliceHisp
# V114 = PctPoliceAsian
# V123 = PoliceOperBudg
# V128 = ViolentCrimesPerPop

# All the vars which have to be kept
myvars <- c("V8", "V9", "V10", "V11", "V13", "V18", "V26", "V35", "V36",
            "V37", "V38", "V91", "V95", "V96", "V111", "V112", "V113",
            "V114", "V123", "V128")

# Remove all other vars from data
df_2 <- initial_df[myvars]

# Change column names
colnames(df_2) <- c("racePctB", "racePctW", "racePctA", "racePctH", 
                    "agePct12t29", "medIncome", "perCapInc", "pctLess9thGrade",
                    "pctNotHSGrad", "pctBSorMore", "pctUnemployed", "medRent",
                    "numInShelters", "numStreet", "pctPoliceW", "pctPoliceB", 
                    "pctPoliceH", "pctPoliceA", "policeOperBudg", "violentCrimes"
                    )

# Change '?' with NA
df_2[df_2 == "?"] <- NA
# Line above can be skipped if this is done from beginning:
# df <- read.csv("file.csv", na.strings = "?")

# Keep the records which don't have NA
df_3 <- df_2[complete.cases(df_2),]


# Import dagitty
library(dagitty)

g <- dagitty('
dag {
  "#Homeless People" [pos="0.002,-0.177"]
  "% 12-29" [pos="0.394,0.622"]
  "% Afr. American" [pos="-0.727,0.171"]
  "% Bachelor" [pos="-0.189,-0.576"]
  "% Caucasian" [pos="-1.732,0.104"]
  "% Police Afr. American" [pos="-0.649,-0.098"]
  "% Police Asian" [pos="-1.041,-0.208"]
  "% Police Caucasian" [pos="-1.737,-0.232"]
  "% asian" [pos="-1.049,0.143"]
  "% hispanic" [pos="-1.377,0.104"]
  "% no HS" [pos="-0.393,-1.106"]
  "% unemployed" [pos="0.230,-0.284"]
  "%< 9th grade" [pos="0.171,-1.181"]
  "& Police Hispanic" [pos="-1.374,-0.220"]
  "Median Gross Rent" [pos="-0.251,-0.007"]
  "Violent Crimes" [pos="-0.404,0.788"]
  "income per capita" [pos="-0.463,-0.386"]
  "#Homeless People" -> "Violent Crimes"
  "% 12-29" -> "Violent Crimes"
  "% Afr. American" -> "% Police Afr. American"
  "% Afr. American" -> "Violent Crimes"
  "% Bachelor" -> "% unemployed"
  "% Bachelor" -> "income per capita"
  "% Caucasian" -> "% Police Caucasian"
  "% Caucasian" -> "Violent Crimes"
  "% asian" -> "% Police Asian"
  "% asian" -> "Violent Crimes"
  "% hispanic" -> "& Police Hispanic"
  "% hispanic" -> "Violent Crimes"
  "% no HS" -> "% Bachelor"
  "% no HS" -> "% unemployed"
  "% no HS" -> "income per capita"
  "% unemployed" -> "#Homeless People"
  "% unemployed" -> "Violent Crimes"
  "%< 9th grade" -> "% no HS"
  "%< 9th grade" -> "% unemployed"
  "%< 9th grade" -> "income per capita"
  "Median Gross Rent" -> "#Homeless People"
  "income per capita" -> "Median Gross Rent"
  "income per capita" -> "Violent Crimes"
}
')

# plot(g)

