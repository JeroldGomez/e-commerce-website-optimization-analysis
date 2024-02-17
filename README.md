# E-commerce Website Optimization Analysis

Hello there! I've recently completed the Google Data Analytics Professional Certificate on Coursera, and I've gained valuable insights and skills that I'm excited to put into practice. Through the course's learning structure: *Ask, Prepare, Process, Analyze, Share & Act*. This learning path serves as my guide as I navigate through the data, ensuring a systematic and insightful approach.

I'll walk you through how I approached the e-commerce website optimization case study. For this project, I've chosen to utilize the powerful combination of RStudio and Tableau, leveraging the strengths of both tools to dive deep into the data.

### Case Study Track B

For Track B, I had the freedom to choose my own questions and dataset. In this case study, I focused on optimizing the conversion rates of an e-commerce website.

### Scenario

You are a junior data analyst working for a business intelligence consultant. You have been at your job for six months, and your boss feels you are ready for more responsibility. He has asked you to lead a project for a brand new client — this will involve everything from defining the business task all the way through presenting your data-driven recommendations. You will choose the topic, ask the right questions, identify a fresh dataset and ensure its integrity, conduct analysis, create compelling data visualizations, and prepare a presentation.

___

### Ask
Learned to formulate meaningful business questions that drive data analysis.

| Questions |
| ----------- |
| What topic are you exploring? |
| What is the problem you are trying to solve? |
| What metrics will you use to measure your data to achieve your objective? |
| Who are the stakeholders? |
|  Who is your audience? |
| How can your insights help your client make decisions? |

**Topic:** E-commerce Website User Behavior Analysis for Optimization

**Problem:** The e-commerce website has been experiencing a decline in conversion rates over the past few months. The company wants to identify the key factors affecting the conversion rates and optimize the website to improve user engagement and increase conversions.

**Metrics to Measure:**

- Conversion Rate: Measure the percentage of website visitors who make a purchase.
- Average Session Duration: Analyze how long users spend on the website.
- Traffic Source: Examine the effectiveness of different platforms in bringing users to the website.
- Demographic Insights: Utilize age, gender, and country data to understand user demographics.
- Membership Influence: Investigate how membership status correlates with conversion rates.

**Stakeholders:**

- Marketing Team: Interested in refining marketing strategies based on effective traffic sources.
- UX/UI Team: Concerned with improving the user experience on the website.
- Executives/Management: Interested in overall business performance and revenue.
- Audience: The primary audience for the case study includes data analysts, marketing professionals, and UX/UI designers within the company.

**How Insights Help:**

- Marketing: Insights will help in refining and targeting marketing strategies based on effective traffic sources and demographic preferences.
- UX/UI Team: Recommendations for improving the user interface and experience to increase session duration and engagement.
- Executives/Management: Make data-driven decisions to allocate resources effectively and prioritize improvements.

**Business Task:**

Enhance the conversion rates of the e-commerce website by conducting a comprehensive analysis of user behavior. The objective is to identify influential factors, including the effectiveness of different traffic sources, user demographics, session duration, and the impact of membership status on conversions. The insights derived from this analysis will guide the optimization of the website, focusing on improving user engagement and tailoring the user experience to maximize the percentage of visitors who make a purchase.

______

### Prepare

Acquired skills to explore and understand datasets and applied techniques for data cleaning and preparation.

**Dataset Overview**

Utilized the "E-commerce Website Log" dataset, sourced from [Kaggle](https://www.kaggle.com/datasets/kzmontage/e-commerce-website-logs), which is licensed under the Open Database License (ODbL). The dataset contains information about user interactions on the e-commerce website, including session duration, traffic sources, user demographics, and membership status.

I organized the dataset by placing it into a folder named "GivenameFolder." Additionally, to ensure consistency and avoid potential errors or confusion, I renamed the file within the folder. The cleaned and organized dataset is available in the repository as [GivenameFolder/e_commerce_website_log_cleaned.csv](link-to-cleaned-dataset).

Special thanks to [KZ Data Lover](https://www.kaggle.com/kzmontage/datasets), the creator of the "E-commerce Website Log" dataset on Kaggle. Their contribution provides valuable insights for data analysis, and I'm grateful for the opportunity to explore and learn from this dataset.

___

### Process

I used RStudio, a handy program for working with data, along with tidyverse and janitor, simple packages that make it easy to understand and clean up data. 

**Data Cleaning Process**

``` r
# Install required packages 
install.packages("tidyverse")
install.packages("janitor")

# Load the necessary packages
library(tidyverse)  # For data manipulation and visualization
library(janitor)   # For data cleaning and tidying

# Load the E-commerce Website Logs dataset
e_commerce_wl <- read.csv("E-commerce Website Logs.csv")

# Inspect its structure
str(e_commerce_wl)
```

Output from `str(e_commerce_wl)`:
```
'data.frame':	172838 obs. of  15 variables:
 $ accessed_date   : chr  "2017-03-14 17:43:57.172" "2017-03-14 17:43:57.172" "2017-03-14 17:43:26.135" "2017-03-14 17:43:26.135" ...
 $ duration_.secs. : int  2533 4034 1525 4572 3652 3847 2090 2793 3396 2064 ...
 $ network_protocol: chr  "TCP  " "TCP  " "TCP  " "TCP  " ...
 $ ip              : chr  "1.10.195.126" "1.1.217.211" "1.115.198.107" "1.121.152.143" ...
 $ bytes           : int  20100 20500 90100 100300 270200 10200 310900 10700 250200 20600 ...
 $ accessed_Ffom   : chr  "Chrome" "Mozilla Firefox" "Mozilla Firefox" "Mozilla Firefox" ...
 $ age             : chr  "28" "21" "20" "66" ...
 $ gender          : chr  "Female" "Male" "Male" "Female" ...
 $ country         : chr  "CA" "AR" "PL" "IN" ...
 $ membership      : chr  "Normal" "Normal" "Normal" "Normal" ...
 $ language        : chr  "English" "English" "English" "Spanish" ...
 $ sales           : num  262 731.9 14.6 957.6 22.4 ...
 $ returned        : chr  "No" "No" "No" "No" ...
 $ returned_amount : num  0 0 0 0 0 ...
 $ pay_method      : chr  "Credit Card" "Debit Card" "Cash" "Credit Card" ...
```
While looking at our data, we noticed a few things that need fixing to make sure it's reliable:

1. **Fixing Column Names:** Address typos and special characters in column names, such as *duration_.secs.* and *accessed_Ffom*, to ensure a standardized and clear naming convention.
``` r
# Use clean_names() to standardize column names
e_commerce_wl <- e_commerce_wl %>% clean_names() # Problems renaming "accessed_Ffom", it became "accessed_ffom".
colnames(e_commerce_wl)[colnames(e_commerce_wl) == "accessed_ffom"] <- "accessed_from" # renaming "accessed_ffom" to "accessed_from"
```

2. **Data Type Tweaks:** Convert the data type of the *accessed_date* and *age* columns, currently represented as characters, into more appropriate formats for analysis, such as datetime and numeric types. Let's also convert the data type of the *duration_secs* and *byte* columns from integer to numeric for the sake of consistency.
``` r
# Convert accessed_date to datetime format
e_commerce_wl$accessed_date <- as.POSIXct(e_commerce_wl$accessed_date, format = "%Y-%m-%d %H:%M:%OS")

# Checking unique values in the age column for data entry errors
unique_age_values <- unique(e_commerce_wl$age)
print(unique_age_values) # Printed data has non-numeric values, such as "--"

# Handling non-numeric values and outliers
e_commerce_wl$age <- ifelse(grepl("[^0-9]", e_commerce_wl$age), NA, e_commerce_wl$age)

# Converting age to numeric
e_commerce_wl$age <- as.numeric(e_commerce_wl$age)

# Change data type of duration_secs and bytes columns to numeric
e_commerce_wl$duration_secs <- as.numeric(e_commerce_wl$duration_secs)
e_commerce_wl$bytes <- as.numeric(e_commerce_wl$bytes)
```

3. **Transforming Country Codes into Full Country Names:** In the country column, values were initially represented using country codes. However, not everyone may be familiar with the meaning of each country code. To enhance clarity and user understanding, the data was transformed into a consistent and standardized format using full country names. This ensures that the dataset is more accessible, especially for individuals who may not be familiar with the specific country codes.
``` r
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
```

4. **Fixing Mistakes:** We'll also look out for any errors in the data. There might be typos or things that just don't make sense. We'll straighten those out.
``` r
# Check for data entry errors in all columns
for (col in colnames(e_commerce_wl)) {
  unique_values <- unique(e_commerce_wl[[col]])
  print(paste("Column:", col))
  print(unique_values)
}
```

After printing the output, I identified some data entry errors that required attention. Here are the issues identified in specific columns and the corrective actions taken:

**Network Protocol Column**

The *network_protocol* column had trailing whitespaces in all of the values. Additionally, the values were not standardized. 

``` r
[1] "Column: network_protocol"
[1] "TCP  "  "ICMP "  "HTTP"   "UDP  "  "HTTP  "
```

To address this, I performed the following corrections:

- Removed trailing whitespaces using the `trimws()` function.
- Standardized values by replacing "TCP" with "TCP/IP."

``` r
# Remove leading/trailing whitespaces and standardize values
e_commerce_wl$network_protocol <- trimws(e_commerce_wl$network_protocol)
e_commerce_wl$network_protocol <- gsub("TCP", "TCP/IP", e_commerce_wl$network_protocol)
```

**Accessed From Column**

The *accessed_from* column contained a typo, where "SafFRi" was used instead of "Safari." The correction involved replacing "SafFRi" with "Safari."

To address this, I performed the following correction:

- Used the `gsub()` function to replace occurrences of "SafFRi" with "Safari"

``` r
# Correcting the typo in accessed_from column
e_commerce_wl$accessed_from <- gsub("SafFRi", "Safari", e_commerce_wl$accessed_from)
```

**Language Column**

The language column shows inconsistency in case (uppercase/lowercase). To ensure consistency,  I converted all values to title case, where the first letter of each word is capitalized.

``` r
[1] "Column: language"
 [1] "English"    "Spanish"    "Chinese"    "Italian"    "persian"    "German"     "Russian"   
 [8] "italian"    "French"     "malayalam"  "romanian"   "polish"     "urdu"       "swedish"   
[15] "Arabic"     "Portuguese" "Thai"       "Japanese"   "nepali"     "Dutch"      "mongolian" 
[22] "swahili"    "tegulu"     "Slovak"     "norwegian"  "marathi"    "malay"      "macedonian"
[29] "serbian"    "slovene" 
```

To address this, I performed the following corrections:

-  Applied the `tools::toTitleCase()` function to convert all values in the language column to title case:

``` r
# Convert values in the language column to title case
e_commerce_wl$language <- tools::toTitleCase(e_commerce_wl$language)
```
After addressing data entry errors and cleaning the dataset, let's inspect the updated structure of the dataset to ensure its cleanliness and readiness for analysis.

**Inspecting Cleaned Dataset Structure**

``` r
# Check the structure of the cleaned dataset
str(e_commerce_wl)
```
Output from `str(e_commerce_wl)`
```
'data.frame':	172838 obs. of  15 variables:
 $ accessed_date   : POSIXct, format: "2017-03-14 17:43:57" "2017-03-14 17:43:57" "2017-03-14 17:43:26" ...
 $ duration_secs   : num  2533 4034 1525 4572 3652 ...
 $ network_protocol: chr  "TCP/IP" "TCP/IP" "TCP/IP" "TCP/IP" ...
 $ ip              : chr  "1.10.195.126" "1.1.217.211" "1.115.198.107" "1.121.152.143" ...
 $ bytes           : num  20100 20500 90100 100300 270200 ...
 $ accessed_from   : chr  "Chrome" "Mozilla Firefox" "Mozilla Firefox" "Mozilla Firefox" ...
 $ age             : num  28 21 20 66 53 28 49 32 69 60 ...
 $ gender          : chr  "Female" "Male" "Male" "Female" ...
 $ country         : chr  "Canada" "Argentina" "Poland" "India" ...
 $ membership      : chr  "Normal" "Normal" "Normal" "Normal" ...
 $ language        : chr  "English" "English" "English" "Spanish" ...
 $ sales           : num  262 731.9 14.6 957.6 22.4 ...
 $ returned        : chr  "No" "No" "No" "No" ...
 $ returned_amount : num  0 0 0 0 0 ...
 $ pay_method      : chr  "Credit Card" "Debit Card" "Cash" "Credit Card" ...
```
The dataset now appears to be well-structured and cleaned, with standardized column names, corrected data types, and consistent values. This sets the stage for the upcoming analysis phase. 

Saving the cleaned dataset to a CSV file named 'cleaned_e_commerce_dataset.csv.' This file is now prepared for further exploration and visualization, particularly in Tableau.

``` r
# Save the cleaned dataset to a CSV file
write.csv(e_commerce_wl, "cleaned_e_commerce_dataset.csv", row.names = FALSE)
```

Now, we're all set to dive into the exciting part, analyzing and visualizing the data!

___

### Analyze & Share

Now that we have a clean dataset in hand, it's time to dive into the numbers and unveil the story they tell. Remember our key metrics identified during the "Ask" phase? We'll be focusing on:

- **Conversion Rate:** Understanding the percentage of website visitors who make a purchase.
- **Average Session Duration:** Analyzing how long users spend on the website.
- **Traffic Source Effectiveness:** Examining the impact of different platforms in bringing users to the website.
- **Demographic Insights:** Understanding user demographics, including age, gender, and country.
- **Membership Influence:** Investigating how membership status correlates with conversion rates.

For the initial part of our analysis, we'll be utilizing RStudio for statistical analysis and visualization. We'll analyze the numbers, create meaningful visualizations, and draw preliminary insights. Later on, we'll transition to Tableau to craft more sophisticated and visually appealing representations that will assist us in the "Share" phase. 

**Conversion Rate Analysis**

To gauge the effectiveness of the e-commerce website in turning visitors into customers, we calculate the conversion rate. Here's a breakdown of the process:

``` r
# Count the number of unique visitors based on the IP column
unique_visitors <- length(unique(e_commerce_wl$ip))
print(unique_visitors) # This prints the total number of unique visitors to the website, which resulted to 137,199 unique visitors

# Identify unique visitors who made a purchase
visitors_with_purchase <- e_commerce_wl %>%
  group_by(ip) %>%
  filter(any(sales > 0)) %>%
  distinct(ip)
  
# Explanation:
# group_by(ip) : Groups the data by unique IP addresses.
# filter(any(sales > 0)): Filters the groups to include only those where at least one sale is greater than 0, which determines that this visitor made a purchase
# distinct(ip): Retains only unique IP addresses in the resulting data frame.

# Count the number of successful conversions (unique visitors who made a purchase)
total_conversions <- nrow(visitors_with_purchase) # 105,661 successful purchases
# Explanation: nrow(visitors_with_purchase) counts the number of rows in the `visitors_with_purchase` data frame, 
# which represents the unique visitors who made a purchase.

# Calculate the conversion rate based on unique visitors
conversion_rate <- round((total_conversions / unique_visitors) * 100, 2)
cat("Conversion Rate:", conversion_rate, "%\n")
# Explanation:
# (total_conversions / unique_visitors) * 100: Calculates the conversion rate as a percentage.
# round(..., 2): Rounds the result to two decimal places for clarity.
# cat("Conversion Rate:", conversion_rate, "%\n"): Prints the conversion rate along with a descriptive message.

```
After analyzing the data, we found that the conversion rate for the e-commerce website is **77.01%**. That's a high conversion rate, it shows that the website is successful in convincing a large percentage of visitors to make a purchase.

While a high conversion rate is positive, it's also essential to continuously analyze and optimize the website's performance. Identifying factors contributing to the conversion rate can help enhance the user experience, refine marketing strategies, and further boost conversion rates.

**Average Session Duration Calculation**

To gain insights into user engagement, we calculated the average session duration on the e-commerce website.

```r
# Calculate the average session duration
average_session_duration <- mean(e_commerce_wl$duration_secs, na.rm = TRUE)

# Explanation:
# mean() function that calculates the average of a numerical vector.
# na.rm = TRUE is an argument used to exclude any missing values from the calculation

# Convert average session duration from seconds to minutes
average_session_duration_minutes <- average_session_duration / 60
```
After calculating the average session duration, which resulted in approximately **3248.032** seconds which is a total of 54.13 minutes.
In our case, the average session duration of around 54 minutes suggests a relatively healthy engagement level, but further analysis and correlation with other metrics will provide a more comprehensive understanding of user interactions and guide optimization strategies for improved website performance.


## Analyzing Traffic Source Distribution

To understand the effectiveness of different traffic sources, I aggregated the data to count the number of visits for each accessed platform. The resulting summary provides insights into the distribution of visits across various traffic sources.
``` r
# Aggregating traffic source data: Counting visits for each accessed platform
traffic_source_summary <- e_commerce_wl %>%
  group_by(accessed_from) %>%
  summarise(Visits = n())
```
### Traffic Source Summary

The table below displays the count of visits for each accessed platform:

| Rank | Traffic Source    | Visits |
|------|-------------------|--------|
| 1    | Android App       | 38,216 |
| 2    | Chrome            | 28,254 |
| 3    | IOS App           | 21,606 |
| 4    | Microsoft Edge    | 14,958 |
| 5    | Mozilla Firefox   | 26,592 |
| 6    | Others            | 26,592 |
| 7    | Safari            | 16,620 |

### Insights

1. **Android App** and **Chrome** are the top two traffic sources with the highest number of visits.
2. **Microsoft Edge** and **Safari** have comparatively lower visit counts, indicating potential areas for improvement or optimization.
3. **Mozilla Firefox** and **Others** also contribute significantly to the overall traffic.

To enhance understanding, I created a bar plot visualizing the distribution of visits across different traffic sources. The plot provides a visual representation of the data, making it easier to identify patterns and trends.






