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
plot(g)

