#  Exploratory Data Analysis of COVID-19 Pandemic
<br/><br/>

### Overview
This COVID-19 data analysis project aims to explore and analyze various aspects of the pandemic using available data sources, such as official reports, and datasets from the World Health Organization. The project typically involves several key steps, including data collection, preprocessing, exploratory data analysis (EDA), visualization, and interpretation of findings.
<br/><br/>

### Data Collection
The first step involves gathering relevant data related to COVID-19, including information on confirmed cases, deaths, recoveries, testing, demographics, and geographical distribution. The data source was the World Health Organisation's official website(WHO) - https://www.who.int
<br/><br/>

### Tools
- Excel for data cleaning
- Azure Data Studio (SQL) for analysis
- Microsoft Power BI for data visualization
<br/><br/>

### Data Preprocessing & Transformations
Once the data was collected, I preprocessed it by removing columns I didn't need, and handling blank and null values to prepare for analysis.
<br/><br/>

### Exploratory Data Analysis (EDA)
In the EDA I explored the data to identify patterns, trends, and relationships - Answering the following questions:
- What are the temporal trends in COVID-19 metrics (daily new cases, deaths) 
- What are the geographical variations in case distribution, investigating demographic factors (e.g., age, gender)
- What and the correlations between COVID-19 indicators and other variables (e.g., population density, healthcare capacity)
<br/><br/>

### Data Analysis
I used statistical measures to calculate daily new cases and estimate the cumulative average new cases of the pandemic in specific regions. A snippet of some codes below:
~~~ SQL
--Comparing Ratio of Total Cases Vs Population

SELECT location, population, MAX(total_cases) AS InfectionCount,
ROUND(MAX(CAST(total_cases AS FLOAT)/population) * 100,2) AS percentPopulationInfected
FROM covidDeaths WHERE continent IS NOT NULL
GROUP BY location, population ORDER BY 3 DESC;







~~~









