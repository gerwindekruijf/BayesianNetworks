README

Our data did not come with the attribute names
instead of adding the attribute names, we manually delete Vx for every
x we do not want, then we change Vx to the right name
Attributes with "--" behind it are removed throughout the iterations

V6 = population
V8 = racePctBlack
V9 = racePctWhite
V10 = racePctAsian
V11 = racePctHisp
V14 = agePct16t24   (was agePct12t29)
V18 = medIncome --
V26 = perCapInc
V35 = PctLess9thGrade --
V36 = PctNotHSGrad
V37 = PctBSorMore
V38 = PctUnemployed
V91 = MedRent
V95 = NumInShelters (homeless in shelters) --
V96 = NumStreet (homeless on street)
V111 = PctPoliceWhite
V112 = PctPoliceBlack
V113 = PctPoliceHisp
V114 = PctPoliceAsian
V123 = PoliceOperBudg --
V128 = ViolentCrimesPerPop


Iterations for building the final DAG:
1:
- Initial graph

2:
- Add edges from Education to Race (all variables belonging to the set of Education and Race) pct12t29 changed to pct16t24
- Add edge from pct16t24 to [Income per capita, Unemployed]

3:
- Police operating budget changed to Population
- Add edge from Population to [Homeless people, Race]

4:
- Add edge from pct16t24 to Median Rent

5:
- Add edge from Education to Median Rent

6:
- Add edge from Median rent to Percentage unemployed

7:
- Add edge from Asian people to Homeless people
- Add edges from Median Rent to all Races (excluding white)

8:
- Add edge from Percentage police asian to Homeless people in the street
- Add edge from all Races (excluding asian) to Per capita income
- Add edge from all Races (excluding hispanic) to Percentage unemployed
- Add edge from Percentage police african american and caucasian to income per capita

9:
- Add edges from Races to Income
- Add edge from Population to Income
- Add edge from Income to Unemployed

10:
- Add edge from Income per capita to Homeless people
- Add edge from Police Hispanic to Mediant Rent (bias?)
- Add edges from Population to Police african american and Hispanic (diversification of police force? Asians have their own community)
- Asian police edge disconnected from Homeless
- BSM to B,H,W police: minorities have to try harder.
- NHS to H police

11:
- Add edge from Police percentage asian to Homeless people and violent crimes
- Add edge from Percentage no high school graduate to Percentage police african american and caucasian

12:
- Add edge from Population to Police White (diversification of police force negative for caucasian)
- Add edge from Percentage no high school graduate to Homeless people