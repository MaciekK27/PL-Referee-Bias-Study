# Load necessary libraries for data manipulation and visualization
library(ggplot2)  # Used for data visualization
library(reshape2) # Used for reshaping data (melting)

# Set working directory where the CSV file is located
setwd("D:/Users/macie/Downloads")

# Load the CSV data into R
data <- read.csv("data-1724424117635.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)

# Preview the first few rows of the data
head(data)

# Exclude sample size columns and melt data for plotting
# We only need 'season', 'hometeam_yc_per_all_yc', and 'hometeam_rc_per_all_rc' columns for the plot
data_for_plotting <- data[, c("season", "hometeam_yc_per_all_yc", "hometeam_rc_per_all_rc")]

# Reshape the data for easier plotting (convert to long format)
data_melted <- melt(data_for_plotting, id.vars = 'season', variable.name = 'card_type', value.name = 'ratio')

# Calculate the mean values of home yellow card and red card percentages for reference in the plot
mean_yc <- mean(data$hometeam_yc_per_all_yc)
mean_rc <- mean(data$hometeam_rc_per_all_rc)

# Create the first plot showing home card percentages over time, with mean lines
plot1 <- ggplot(data_melted, aes(x = season, y = ratio, color = card_type, group = card_type)) +
  geom_line() +  # Add line plot
  geom_point() +  # Add points on the line
  # Add horizontal lines representing the mean values for home yellow and red cards
  geom_hline(data = data.frame(yintercept = mean_yc, linetype = "Mean Home Yellow Cards"), 
             aes(yintercept = yintercept, linetype = linetype), color = "lightblue", size = 1.2) +
  geom_hline(data = data.frame(yintercept = mean_rc, linetype = "Mean Home Red Cards"), 
             aes(yintercept = yintercept, linetype = linetype), color = "pink", size = 1.2) +
  scale_color_manual(
    values = c("hometeam_yc_per_all_yc" = "blue", "hometeam_rc_per_all_rc" = "red"),
    labels = c("Home Yellow Card Share", "Home Red Card Share")
  ) +
  scale_linetype_manual(
    values = c("Mean Home Yellow Cards" = "dashed", "Mean Home Red Cards" = "dashed"),
    labels = c("Mean Home Yellow Cards", "Mean Home Red Cards")
  ) +
  guides(
    color = guide_legend(order = 1),
    linetype = guide_legend(order = 2, override.aes = list(color = c("lightblue", "pink")))
  ) +
  labs(
    title = "Home Cards to All Cards Share",
    x = "Season",
    y = "Percentage (%)",
    color = "Card Types",
    linetype = "Mean Values"
  ) +
  theme_minimal() +  # Use minimal theme
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels for readability
    legend.position = "right" # Position legend on the right
  )

# Display the first plot
plot1

# Prepare trend data for yellow and red cards, adding explicit labels
yellow_trend <- data_melted[data_melted$card_type == "hometeam_yc_per_all_yc", ]
yellow_trend$TrendType <- "Trend For Yellow Cards"
red_trend <- data_melted[data_melted$card_type == "hometeam_rc_per_all_rc", ]
red_trend$TrendType <- "Trend For Red Cards"

# Combine yellow and red trend data into a single dataframe
trend_data <- rbind(yellow_trend, red_trend)
trend_data$TrendType <- factor(trend_data$TrendType, levels = c("Trend For Yellow Cards", "Trend For Red Cards"))

# Create the second plot with linear trend lines for both yellow and red cards
plot2 <- ggplot(data_melted, aes(x = season, y = ratio, group = card_type)) +
  geom_line(aes(color = card_type)) +  # Line plot for card percentages
  geom_point(aes(color = card_type)) +  # Add points on the lines
  geom_smooth(data = subset(trend_data, TrendType == "Trend For Yellow Cards"),
              aes(linetype = TrendType), method = "lm", se = FALSE, color = "blue", size = 1.5) +  # Trend line for yellow cards
  geom_smooth(data = subset(trend_data, TrendType == "Trend For Red Cards"),
              aes(linetype = TrendType), method = "lm", se = FALSE, color = "red", size = 1.5) +  # Trend line for red cards
  scale_color_manual(
    values = c("hometeam_yc_per_all_yc" = "lightblue", "hometeam_rc_per_all_rc" = "pink"),
    labels = c("Home Yellow Card Share", "Home Red Card Share")
  ) +
  scale_linetype_manual(
    values = c("Trend For Yellow Cards" = "dotted", "Trend For Red Cards" = "dotted"),
    labels = c("Trend For Yellow Cards", "Trend For Red Cards")
  ) +
  guides(
    linetype = guide_legend(
      title = "Trend Type",
      order = 1,  # Ensure trend type is displayed before other legends
      override.aes = list(color = c("blue", "red"))
    )
  ) +
  labs(
    title = "Actual Data with Trend Lines",
    x = "Season",
    y = "Percentage (%)",
    color = "Card Type",
    linetype = "Trend Type"
  ) +
  theme_minimal() +  # Use minimal theme for clarity
  theme(axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels for readability
        legend.position = "right")  # Place legend on the right

# Display the second plot
plot2
