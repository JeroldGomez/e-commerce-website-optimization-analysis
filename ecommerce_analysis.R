install.packages("tidyverse")
install.packages("janitor")

library(tidyverse)
library(janitor)

# Load the E-commerce Website Logs dataset
ecommerce_wl <- read.csv("E-commerce Website Logs.csv")

# Inspect its structure
str(e_commerce_wl)

# Use clean_names() to standardize column names
e_commerce_wl <- e_commerce_wl %>% clean_names() # Problems renaming "accessed_Ffom", it became "accessed_ffom".
colnames(e_commerce_wl)[colnames(e_commerce_wl) == "accessed_ffom"] <- "accessed_from"

# Convert accessed_date to datetime format
e_commerce_wl$accessed_date <- as.POSIXct(e_commerce_wl$accessed_date, format = "%Y-%m-%d %H:%M:%OS")

# Checking unique values in the age column for data entry errors
unique_age_values <- unique(e_commerce_wl$age)
print(unique_age_values) # Printed data has non-numeric values, such as "--"

# Handling non-numeric values, we want to convert non-numeric values to NA
e_commerce_wl$age <- ifelse(grepl("[^0-9]", e_commerce_wl$age), NA, e_commerce_wl$age)

# Converting age to numeric
e_commerce_wl$age <- as.numeric(e_commerce_wl$age)

# Change data type of duration_secs and bytes columns to numeric
e_commerce_wl$duration_secs <- as.numeric(e_commerce_wl$duration_secs)
e_commerce_wl$bytes <- as.numeric(e_commerce_wl$bytes)

# Checking values for data entry errors
unique_country <- unique(e_commerce_wl$country)
print(unique_country)# Printed data verified, all values are correct

# Function to convert country codes to full names
convert_country <- function(country_code) {
  country_code <- toupper(country_code)
  case_when(
    country_code %in% c("CA", "CANADA") ~ "Canada",
    country_code %in% c("AR", "ARGENTINA") ~ "Argentina",
    country_code %in% c("PL", "POLAND") ~ "Poland",
    country_code %in% c("IN", "INDIA") ~ "India",
    country_code %in% c("KR", "SOUTH KOREA") ~ "South Korea",
    country_code %in% c("CN", "CHINA") ~ "China",
    country_code %in% c("AT", "AUSTRIA") ~ "Austria",
    country_code %in% c("US", "UNITED STATES") ~ "United States",
    country_code %in% c("SE", "SWEDEN") ~ "Sweden",
    country_code %in% c("CH", "SWITZERLAND") ~ "Switzerland",
    country_code %in% c("NO", "NORWAY") ~ "Norway",
    country_code %in% c("JP", "JAPAN") ~ "Japan",
    country_code %in% c("GB", "UNITED KINGDOM") ~ "United Kingdom",
    country_code %in% c("MX", "MEXICO") ~ "Mexico",
    country_code %in% c("IT", "ITALY") ~ "Italy",
    country_code %in% c("RU", "RUSSIA") ~ "Russia",
    country_code %in% c("DE", "GERMANY") ~ "Germany",
    country_code %in% c("AU", "AUSTRALIA") ~ "Australia",
    country_code %in% c("FI", "FINLAND") ~ "Finland",
    country_code %in% c("PR", "PUERTO RICO") ~ "Puerto Rico",
    country_code %in% c("DK", "DENMARK") ~ "Denmark",
    country_code %in% c("CO", "COLOMBIA") ~ "Colombia",
    country_code %in% c("AE", "UNITED ARAB EMIRATES") ~ "United Arab Emirates",
    country_code %in% c("IE", "IRELAND") ~ "Ireland",
    country_code %in% c("PE", "PERU") ~ "Peru",
    country_code %in% c("ZA", "SOUTH AFRICA") ~ "South Africa",
    country_code %in% c("FR", "FRANCE") ~ "France",
    TRUE ~ as.character(country_code)  # Keep other values unchanged
  )
}

# Standardize values in the country column
e_commerce_wl <- e_commerce_wl %>%
  mutate(
    country = convert_country(country)
  )

# Check for data entry errors in all columns
for (col in colnames(e_commerce_wl)) {
  unique_values <- unique(e_commerce_wl[[col]])
  print(paste("Column:", col))
  print(unique_values)
}

# Remove leading/trailing whitespaces and standardize values
e_commerce_wl$network_protocol <- trimws(e_commerce_wl$network_protocol)
e_commerce_wl$network_protocol <- gsub("TCP", "TCP/IP", e_commerce_wl$network_protocol)

# Correcting the typo in accessed_from column
e_commerce_wl$accessed_from <- gsub("SafFRi", "Safari", e_commerce_wl$accessed_from)

# Convert values in the language column to title case
e_commerce_wl$language <- tools::toTitleCase(e_commerce_wl$language)

# Check the structure of the cleaned dataset
str(e_commerce_wl)

# Save the cleaned dataset to a CSV file
write.csv(e_commerce_wl, "cleaned_e_commerce_dataset.csv", row.names = FALSE)

# Calculating Conversion Rate

# Count the number of unique visitors based on the IP column
unique_visitors <- length(unique(e_commerce_wl$ip))
print(unique_visitors) # total of 137,199 unique visitors

visitors_with_purchase <- e_commerce_wl %>%
  group_by(ip) %>%
  filter(any(sales > 0)) %>%
  distinct(ip)

# Count the number of successful conversions (unique visitors who made a purchase)
total_conversions <- nrow(visitors_with_purchase) # 105,661 successful purchases

# Calculate the conversion rate based on unique visitors
conversion_rate <- round((total_conversions / unique_visitors) * 100, 2)
cat("Conversion Rate:", conversion_rate, "%\n")

# Calculating Average Session Duration

# Calculate the average session duration
average_session_duration <- mean(e_commerce_wl$duration_secs, na.rm = TRUE)
# Convert average session duration from seconds to minutes
average_session_duration_minutes <- average_session_duration / 60

# Traffic Source Effectiveness

# Aggregating traffic source data: Counting visits for each accessed platform
traffic_source_summary <- e_commerce_wl %>%
  group_by(accessed_from) %>%
  summarise(Visits = n())

# Create a bar plot for traffic source distribution
traffic_plot <- ggplot(traffic_source_summary, aes(x = accessed_from, y = Visits, fill = accessed_from)) +
  geom_bar(stat = "identity") +
  labs(title = "Traffic Source Distribution",
       x = "Traffic Source",
       y = "Number of Visits") +
  theme_minimal() +
  theme(
    axis.text = element_text(color = "white"),   # Text color on axes
    axis.title = element_text(color = "white"),  # Text color of axis titles
    legend.text = element_text(color = "white"), # Text color in the legend
    legend.title = element_text(color = "white"), # Legend title color
    plot.title = element_text(color = "white") # Text color on plot title
  )

# Save the plot as a PNG file
ggsave("traffic_source_distribution.png")

# to get the statistical information about the 'age' column
summary(e_commerce_wl$age)

# Counting non NA values
count_non_na_age <- sum(!is.na(e_commerce_wl$age))
print(count_non_na_age) # 84,714 users with available age information.

# Grouping by gender and summarizing the count of users
age_summary <- e_commerce_wl %>%
  group_by(age) %>% # groups by the 'gender' column, enabling us to perform operations on each unique gender category.
  summarise(Users = n()) # counts the number of users (count of rows) for each gender category, and the result is stored in the 'Users' column.

# A histogram to visualize the distribution of ages
hist(e_commerce_wl$age, main = "Age Distribution", xlab = "Age", col = "lightblue")
ggsave("age_distribution.png")

# Grouping by gender and summarizing the count of users
gender_summary <- e_commerce_wl %>%
  group_by(gender) %>% # groups by the 'gender' column, enabling us to perform operations on each unique gender category.
  summarise(Users = n()) # counts the number of users (count of rows) for each gender category, and the result is stored in the 'Users' column.

# Grouping by country and summarizing the count of users
country_summary <- e_commerce_wl %>%
  group_by(country) %>%
  summarise(Users = n()) %>%
  arrange(desc(Users)) # arrange the result in descending order based on the User Column


# Calculate the conversion rate for each membership type
conversion_rate_by_membership <- e_commerce_wl %>%
  group_by(membership) %>%
  summarise(Conversion_Rate = round(sum(sales > 0) / n() * 100, 2))

# Print the summary table
print(conversion_rate_by_membership)

# Summarize sales based on membership type
sales_by_membership <- e_commerce_wl %>%
  group_by(membership) %>%
  summarise(Total_Sales = sum(sales))

# Print the summary table
print(sales_by_membership)
