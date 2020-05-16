setwd("~/Documents/rexpense/")
roundDown <- function(x) floor(x / 1000) * 1000

this_month = as.character(cut(Sys.Date(), "month"))

# Import transactions
transactions = read.csv(file = '../pytink/transactions_2020-04-27_2014.csv', na.strings = "None", fileEncoding = "UTF-8-BOM")
transactions$Date = as.Date(transactions$Date, "%Y-%m-%d")
income   = transactions[transactions$Balance > 0, ]
expense = transactions[transactions$Balance < 0, ] 

# Filter out incomplete months
income = income[(income$Date > '2017-11-01') & (income$Date < this_month), ]
expense = expense[(expense$Date > '2017-11-01') & (expense$Date < this_month), ]

# Aggregate over month
library(zoo)
income_month  = aggregate(Balance ~ zoo::as.yearmon(Date), income, sum) 
expense_month = aggregate(Balance ~ zoo::as.yearmon(Date), expense, sum)
names(income_month)[names(income_month) == 'zoo::as.yearmon(Date)'] <- 'Date'   # Change name of variable
names(expense_month)[names(expense_month) == 'zoo::as.yearmon(Date)'] <- 'Date' # Change name of variable

#tss$Date = as.Date(tss$Date, '%Y-%m-%d', frac=1)            # Converts datatype to Date

library(ggplot2)

#### Expense vs Savings Bar Charts
category = c(rep('Saving', nrow(income_month)),
             rep('TExpense', nrow(expense_month)))
dates = c(income_month$Date,
          expense_month$Date)
balance = c(income_month$Balance - abs(expense_month$Balance),
            abs(expense_month$Balance))
data = data.frame(category, dates, balance)

ggplot(data, aes(fill=category, x=dates, y=balance)) +
  geom_bar(position="stack", stat="identity")

ggplot(data, aes(fill=category, x=dates, y=balance)) +
  geom_bar(position="fill", stat="identity")


#### Histogram plot

data = data.frame(Saving = roundDown(income_month$Balance + expense_month$Balance), Expense = roundDown(abs(expense_month$Balance)))

ggplot(data, aes(x=x) ) +
  geom_histogram( aes(x = Saving), fill="#69b3a2", binwidth=1000, alpha=0.6) +
  geom_label( aes(x=25000, y=5, label="Saving"), color="#69b3a2") +
  geom_histogram( aes(x = Expense), fill= "#404080", binwidth=1000, alpha=0.6) +
  geom_label( aes(x=5000, y=5, label="Expense"), color="#404080") +
  xlab("Kr")

