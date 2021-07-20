# Market Basket Analysis
library(plyr)
library(arules)
library(arulesv)

setwd('C:/Users/student/Desktop')
groceries <- read.csv('MBAPractice.csv', header=F)


txn = read.transactions(file="MBAPractice.csv", rm.duplicates= TRUE, format="basket",sep=",")
print(txn)
inspect(head(txn,5))

#Most Frequently Purchased Items
itemFrequencyPlot(txn, topN=10, type='absolute')
itemFrequencyPlot(txn, topN=10, type='relative')



basket_rules <- apriori(txn, parameter = list(minlen=2, sup = 0.001, conf = 0.05, target="rules"))

print(length(basket_rules))
summary(basket_rules)
inspect(basket_rules[1:20])

plot(basket_rules[1:10], method="graph")
