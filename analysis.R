library("ggplot2")
setwd("/Users/malarcon/Google Drive/CUNY/IS606/collaborative1")
pricing <- read.csv(file="details.csv",head=TRUE,sep=",")

historical_data <- read.csv(file="sales.csv",head=TRUE,sep=",")

# properly format date
historical_data$date_dt <- as.POSIXct(historical_data$date, format="%Y-%m-%d")

# get month, day_of_week and month_day_of_week to see if there is any
# type of variation by any of these variables
historical_data$day_of_week <- weekdays(historical_data$date_dt)
historical_data$month_day_of_week <- paste(historical_data$month, "-" ,historical_data$day_of_week ) 


# calculate Expected value of demand for each sandwich type
historical_data$ham_median <- median(historical_data$demand.ham)
historical_data$turkey_median <- median(historical_data$demand.turkey)
historical_data$veggie_median <- median(historical_data$demand.veggie)

# calculate sold amount of each sandwich

historical_data$ham_sold <- pmin(historical_data$available.ham,historical_data$demand.ham)
historical_data$turkey_sold <- pmin(historical_data$available.turkey,historical_data$demand.turkey)
historical_data$veggie_sold <- pmin(historical_data$available.veggie,historical_data$demand.veggie)


# calculate current profit
historical_data$ham_profit <- historical_data$ham_sold * pricing$price[pricing$type=="ham"] - historical_data$available.ham*pricing$cost[pricing$type=="ham"]
historical_data$turkey_profit <- historical_data$turkey_sold * pricing$price[pricing$type=="turkey"] - historical_data$available.turkey*pricing$cost[pricing$type=="turkey"]
historical_data$veggie_profit <- historical_data$veggie_sold * pricing$price[pricing$type=="veggie"] - historical_data$available.veggie*pricing$cost[pricing$type=="veggie"]


# calculate estimated profit by using median
historical_data$ham_profit_median <- pmin(historical_data$ham_median,historical_data$demand.ham)* pricing$price[pricing$type=="ham"] - historical_data$ham_median*pricing$cost[pricing$type=="ham"]
historical_data$turkey_profit_median <- pmin(historical_data$turkey_median,historical_data$demand.turkey)* pricing$price[pricing$type=="turkey"] - historical_data$turkey_median*pricing$cost[pricing$type=="turkey"]
historical_data$veggie_profit_median <- pmin(historical_data$veggie_median,historical_data$demand.veggie)* pricing$price[pricing$type=="veggie"] - historical_data$veggie_median*pricing$cost[pricing$type=="veggie"]

sum(historical_data$ham_profit)
sum(historical_data$ham_profit_median)
sum(historical_data$turkey_profit)
sum(historical_data$turkey_profit_median)
sum(historical_data$veggie_profit)
sum(historical_data$veggie_profit_median)

qplot(historical_data$date_dt,historical_data$demand.ham)

# pivot the data so we can do a boxplot of all sandwiches in one
historical_pivoted<-data.frame(date=historical_data$date_dt,sandwich="Ham",demand=historical_data$demand.ham,available=historical_data$available.ham)
historical_pivoted<-rbind(historical_pivoted,data.frame(date=historical_data$date_dt,sandwich="Turkey",demand=historical_data$demand.turkey,available=historical_data$available.turkey))
historical_pivoted<-rbind(historical_pivoted,data.frame(date=historical_data$date_dt,sandwich="Veggie",demand=historical_data$demand.veggie,available=historical_data$available.veggie))

p <- qplot(sandwich,demand, data=historical_pivoted, geom=c("boxplot", "jitter"),
      fill=sandwich,
      main="Supply and Demand by Sandwich Type",
      xlab= "Sandwich Type",
      ylab="Demand")
p + geom_hline(yintercept = c(mean(historical_data$available.ham),mean(historical_data$available.turkey),mean(historical_data$available.veggie)),color=c("red","darkgreen","blue"),size=1,linetype=11,label = c("Demand Ham", "Demand Turkey", "Demand Veggie"))
+ 
  annotate("text", c(mean(historical_data$available.ham),mean(historical_data$available.turkey),mean(historical_data$available.veggie)), 1, label = c("Demand Ham", "Demand Turkey", "Demand Veggie"))

#cutoff <- data.frame( x = c(-Inf, Inf), y = 50, cutoff = factor(50) )
#ggplot(the.data, aes( year, value ) ) + 
#  geom_point(aes( colour = source )) + 
#  geom_smooth(aes( group = 1 )) + 
#  geom_line(aes( x, y, linetype = cutoff ), cutoff)

#qplot(demand, data=historical_pivoted, geom=c("density"),
#      facets=sandwich~., fill=sandwich,xlim=c(0,40))

