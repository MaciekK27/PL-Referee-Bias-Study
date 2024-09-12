## Premier League Referee Bias Analysis
### Overview
##### This project aims to analyze whether being the home team in a Premier League match influences referee decisions, specifically in the awarding of yellow and red cards. The analysis leverages both SQL for data extraction and R for visualization and further analysis.
### Files in this Repository
-	sql_code.sql: Contains SQL queries used to extract and analyze data from the Premier League matches database.
-	r_code.R: R script used for data analysis and visualization, based on the results obtained from the SQL queries.
-	data.csv: Dataset containing the results of the SQL queries, used in the R script for further analysis and visualization.
-	project.pdf: A detailed report explaining the methodology, findings, and conclusions drawn from the analysis.
### How to Run the Analysis
##### Step 1: Set Up the Database
- Database: Ensure you have a PostgreSQL database set up and running. Modify the connection details in the SQL file if necessary.
- Load Data: Import the Premier League dataset into your database. If you don’t have the dataset, you can find similar datasets on Kaggle or other sources.
##### Step 2: Execute SQL Queries
- Open the SQL File: Open sql_code.sql in your preferred SQL editor or the PostgreSQL command line.
- Run Queries: Execute the SQL queries to extract and analyze data. The results can be saved to a file or a table in the database, depending on your workflow.
- Save the Results: Export the results from the SQL queries as a CSV file, which will be used in the R script for further analysis.
##### Step 3: Run the R Script
1.	Install Required Packages: Make sure you have the following R packages installed:
- install.packages("ggplot2")
- install.packages("reshape2")
- install.packages("DBI")
2.	Run the Script: Open r_code.R in RStudio or any R environment. The script will:
-	Load the data from the CSV file.
-	Perform the analysis and generate visualizations.
-	The visualizations will show trends in yellow and red cards awarded to home teams.
##### Step 4: Review the Findings
- Review the Report: Open the project.pdf file for a detailed explanation of the methodology, findings, and conclusions.
- Visualizations: The R script generates plots that visualize the trends in referee decisions for home teams versus away teams.
### Key Findings
-	Less than 46% of yellow cards per foul were shown to the home team, based on a sample size of nearly 30,000 yellow cards.
-	For red cards, the percentage was even lower, with around 43% shown to the home team.
-	The findings suggest that being the home team does influence referee decisions, although this bias appears to be decreasing over time.
### Future Work
- Incorporatate additional variables such as specific referee tendencies or game context (e.g., scoreline, match importance). 
-	Apply machine learning models (e.g., classification) to predict yellow and red card occurrences.
-	Cluster referees based on their decision-making patterns.
### License
##### This project is licensed under the MIT License - see the LICENSE file for details.
##### Explanation of Changes:
- **File names**: I've used the exact names you provided, such as `sql_code.sql`, `r_code.R`, and `project.pdf`, to fit the desired structure.
- **Markdown structure**: The README provides clear steps on how to run the analysis, install necessary dependencies, and review findings.
- **Future Work & License**: Included sections for future enhancements and licensing, which are good practices for any GitHub project.
