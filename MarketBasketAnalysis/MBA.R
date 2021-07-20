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

#Frequency of having a milk product in the basket
itemFrequency(txn)[grep('milk', itemLabels(txn))]

#We will use the Apriori algorithm to create the associations
### Support - fraction of which the item occurs in the data
### Confidence - probability that a rule is correct for new transactions with items on the left
### Lift - Ratio by which the confidence of the rule exceeds the expected confidence
basket_rules <- apriori(txn, parameter = list(minlen=2, maxlen=4, sup = 0.001, conf = 0.75, target="rules"))

print(length(basket_rules))
summary(basket_rules)
inspect(basket_rules[1:10])
############## How to interpret results #############
# If a cart has ____ | => | it may have #
#Support-fraction of baskets that satisfy rule
#Confidence- probability that cart has item on RHS given it has all items on LHS
#Coverage - fraction of baskets that have all items in LHS of rule
#Lift- How many times more likely that item on RHS appears in cart when it contains all items in LHS

#How confidence is calculated
itemFrequency(txn)['bottled beer'] * 11.2

#Sort by measure
inspect(sort(basket_rules, by= 'lift', decreasing=TRUE)[1:5])
inspect(sort(basket_rules, by= 'confidence', decreasing=TRUE)[1:5])
inspect(sort(basket_rules, by= 'support', decreasing=TRUE)[1:5])

#Visualizations
simplerules <- apriori(txn, parameter=list(supp=0.001, conf=.7,maxlen=3))
simplerules <- sort(simplerules, by='lift')[c(1:13,22:23,98)]
plot(simplerules, method='graph', edgeCol='black', cex=.7, alpha=1)
plot(simplerules, method='graph', engine='htmlwidget')
