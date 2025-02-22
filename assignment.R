# Part One - Data Preparation and Exploration
data <- movies

firstSubset <- subset(data, select = c(title, rating, budget, votes, length, year, Action))
filteredSubset <- firstSubset[firstSubset$votes >= 1000, ]
cleanSubset <- na.omit(filteredSubset)

cleanSubset$length <- cleanSubset$length / 60  
cleanSubset$budget <- cleanSubset$budget / 1e6  

highestRatingMovie <- cleanSubset$title[which.max(cleanSubset$rating)]
highestBudgetMovie <- cleanSubset$title[which.max(cleanSubset$budget)]

# Part Two - Descriptive Analysis
numMovies <- nrow(cleanSubset)

avgRating <- mean(cleanSubset$rating)  
avgBudget <- mean(cleanSubset$budget)

actionMovies <- cleanSubset[cleanSubset$Action == 1, ]
nonActionMovies <- cleanSubset[cleanSubset$Action == 0, ]

avgRatingAction <- mean(actionMovies$rating)
avgBudgetAction <- mean(actionMovies$budget)

avgRatingNonAction <- mean(nonActionMovies$rating)
avgBudgetNonAction <- mean(nonActionMovies$budget)

# Part Three - Visualization
hist(cleanSubset$rating, col = "orange",
     main = "Distribution of Movies Ratings", xlab = "Rating")

plot(cleanSubset$budget, cleanSubset$rating, 
     main = "Movies - Rating vs. Budget",
     xlab = "Budget (in millions of dollars)", ylab = "Rating",
     pch = 19, col = "blue")

abline(lm(rating ~ budget, data = cleanSubset), col = "red", lwd = 2) 

avgRatingsByYear <- aggregate(cleanSubset$rating, by = list(cleanSubset$year), FUN = mean)
colnames(avgRatingsByYear) <- c("year", "avgRating")

avgRatingsFiltered <- avgRatingsByYear[avgRatingsByYear$year >= 1975 & avgRatingsByYear$year <= 2005, ]

plot(avgRatingsFiltered$year, avgRatingsFiltered$avgRating, type = "l", col = "red",
     main = "Average Movie Rating Over Time (1975-2005)", xlab = "Year", ylab = "Average Rating")

# Part Four - Regression Analysis
actionRegression <- lm(rating ~ year + length + budget, data = actionMovies)
summary(actionRegression)

writeLines(capture.output(stargazer(actionRegression, type = "text")), "regressionResults.txt")

newMovie <- data.frame(year = 2000, length = 2, budget = 1)
predictedRating <- predict(actionRegression, newdata = newMovie)
predictedRating <- as.numeric(predictedRating)


