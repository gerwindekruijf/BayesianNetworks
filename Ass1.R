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
"Violent Crimes" [pos="-0.404,0.788"]
agePct12t29 [pos="-0.018,0.771"]
medRent [pos="-0.249,-0.185"]
pctBSorMore [pos="-0.133,-0.389"]
pctHomeless [pos="0.002,-0.177"]
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
agePct12t29 -> "Violent Crimes"
medRent -> pctHomeless
pctBSorMore -> pctUnemployed
pctBSorMore -> perCapInc
pctHomeless -> "Violent Crimes"
pctLess9thGrade -> pctNotHSGrad
pctLess9thGrade -> pctUnemployed
pctLess9thGrade -> perCapInc
pctNotHSGrad -> pctBSorMore
pctNotHSGrad -> pctUnemployed
pctNotHSGrad -> perCapInc
pctUnemployed -> "Violent Crimes"
pctUnemployed -> pctHomeless
perCapInc -> "Violent Crimes"
perCapInc -> medRent
policeOperBudg -> "Violent Crimes"
racePctA -> "Violent Crimes"
racePctA -> pctPoliceA
racePctB -> "Violent Crimes"
racePctB -> pctPoliceB
racePctH -> "Violent Crimes"
racePctH -> pctPoliceH
racePctW -> "Violent Crimes"
racePctW -> pctPoliceW
}
')

#plot(g)

