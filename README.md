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

Special thanks to [KZ Data Lover](https://www.kaggle.com/kzmontage/datasets), the creator of the "E-commerce Website Log" dataset on Kaggle. Their contribution provides valuable insights for data analysis, and I'm grateful for the opportunity to explore and learn from this dataset.

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
e_commerce_wl <- e_commerce_wl %>% clean_names()
```

2. **Data Type Tweaks:** Convert the data type of the *accessed_date* and *age* columns, currently represented as characters, into more appropriate formats for analysis, such as datetime and numeric types.
``` r
# Convert accessed_date to datetime format
e_commerce_wl$accessed_date <- as.POSIXct(e_commerce_wl$accessed_date, format = "%Y-%m-%d %H:%M:%OS")

# Checking unique values in the age column for data entry errors
unique_age_values <- unique(e_commerce_wl$age)
print(unique_age_values) # Printed data has non-numeric values, such as "--"

# Handling non-numeric values, we want to convert non-numeric values to NA
e_commerce_wl$age <- ifelse(grepl("[^0-9]", e_commerce_wl$age), NA, e_commerce_wl$age)

# Converting age to numeric
e_commerce_wl$age <- as.numeric(e_commerce_wl$age)
```

3. **Sorting Out Categories:**
   - In some columns like *gender*, *country*, *membership*, *language*, *returned*, and *pay_method*, things might be written in different ways. We'll make them all look the same for simplicity.

4. **Checking for Missing Info:**
   - Let's see if there's any information missing. If something's missing, we'll decide what to do – either guess the missing bits or maybe leave out the whole row if we can't figure it out.

5. **Fixing Mistakes:**
   - We'll also look out for any errors in the data. For example, in the *network_protocol* and *age* columns, there might be typos or things that just don't make sense. We'll straighten those out.


