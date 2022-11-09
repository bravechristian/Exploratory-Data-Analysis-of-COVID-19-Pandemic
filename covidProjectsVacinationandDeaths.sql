USE projectCovid;
SELECT * FROM covidDeaths
WHERE continent IS NOT NULL;


-- SELECT the useful data for this analysis

SELECT location, date, total_cases, new_cases, 
total_deaths, population FROM covidDeaths 
WHERE continent IS NOT NULL;

--Comparing Ratio of Total Cases Vs Total Deaths: to show the ratio of cases to deaths 

SELECT location, date, total_cases, new_cases, 
total_deaths, population, (total_cases/total_deaths) As ratio
FROM covidDeaths WHERE continent IS NOT NULL ORDER BY 1,2;


--Looking at the percentage of Total Cases Vs Total Deaths in Percentage

SELECT location, date, total_cases, new_cases, 
total_deaths, population, 
ROUND((total_deaths/CAST(total_cases AS float) * 100),2) AS percent_deaths
FROM covidDeaths WHERE continent IS NOT NULL;

--Comparing Ratio of Total Cases Vs Population

SELECT location, population, MAX(total_cases) AS InfectionCount,
ROUND(MAX(CAST(total_cases AS FLOAT)/population) * 100,2) AS percentPopulationInfected
FROM covidDeaths WHERE continent IS NOT NULL
GROUP BY location, population ORDER BY 3 DESC;


--Showing Countries with the Highest Death Count per Population

SELECT location, MAX(total_deaths) AS totalDeathCount
FROM covidDeaths WHERE continent IS NOT NULL
GROUP BY location 
ORDER BY totalDeathCount DESC;


--Showing the Continent with the highest Death Count 

SELECT continent, MAX(total_deaths) AS totalDeathCount
FROM covidDeaths WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY totalDeathCount DESC;

--Global Analysis

SELECT date, SUM(new_cases) AS sum_of_newcases, SUM(new_deaths) AS sum_of_deaths, 
ROUND(SUM(CAST(new_deaths AS float))/SUM(new_cases) * 100, 2) AS global_percent_death
FROM covidDeaths WHERE continent IS NOT NULL GROUP BY date 
ORDER BY date;


--Death Percent Across the Globe As Compared to New Cases

SELECT SUM(new_cases) AS sum_of_newcases, SUM(new_deaths) AS sum_of_deaths, 
ROUND(SUM(CAST(new_deaths AS float))/SUM(new_cases) * 100, 2) AS global_percent_death
FROM covidDeaths WHERE continent IS NOT NULL --GROUP BY date 
--ORDER BY date;


--SELECT location, date, total_cases, new_cases, 
--total_deaths, population, (total_cases/total_deaths) As percent_deaths
--FROM covidDeaths ORDER BY 1,2;


--Data from Vaccination Table
SELECT * FROM covidVaccinations;

--Combining both tables covidDeaths & CovidVaccinations together

SELECT * FROM covidDeaths cdt
JOIN covidVaccinations cvs
ON cdt.location = cvs.location
and cdt.date = cvs.date;


--Comparing Total Population vs Vaccinations

SELECT cdt.continent, cdt.location, cdt.date, 
cdt.population, cvs.new_vaccinations 
FROM covidDeaths cdt
JOIN covidVaccinations cvs
ON cdt.location = cvs.location
and cdt.date = cvs.date  WHERE cdt.continent IS NOT NULL 
ORDER BY cdt.date;

--Accessing the cumulative figure of vaccinations per day

SELECT cdt.continent, cdt.location, cdt.date, 
cdt.population, cvs.new_vaccinations, 
SUM(CONVERT(INT,cvs.new_vaccinations)) OVER (PARTITION BY cdt.location, cdt.date) AS cumulative_vaccinations
FROM covidDeaths cdt
JOIN covidVaccinations cvs
ON cdt.location = cvs.location
and cdt.date = cvs.date  WHERE cdt.continent IS NOT NULL 
ORDER BY cdt.date;


--Using CTE to calculate  percentage population vaccinated per day

WITH popVac (continent, location, date, population, new_vaccinations, cumulative_vaccinations) AS
(
SELECT cdt.continent, cdt.location, cdt.date, 
cdt.population, cvs.new_vaccinations, 
SUM(CONVERT(INT,cvs.new_vaccinations)) OVER (PARTITION BY cdt.location, cdt.date) AS cumulative_vaccinations
FROM covidDeaths cdt
JOIN covidVaccinations cvs
ON cdt.location = cvs.location
and cdt.date = cvs.date  WHERE cdt.continent IS NOT NULL 
--ORDER BY cdt.date;
)
SELECT *, 
ROUND((CONVERT(float,cumulative_vaccinations)/population) * 100,2) 
AS percent_cumulative
FROM popVac;


--Using Temp Table to Calculate the Same Parameter 

DROP TABLE IF EXISTS percentCumulativeVaccinated
CREATE TABLE percentCumulativeVaccinated(
continent NVARCHAR(255),
location NVARCHAR(255),
date DATETIME,
new_vaccinations INT,
population INT,
cumulative_vaccinations INT 
)
INSERT INTO  percentCumulativeVaccinated
SELECT cdt.continent, cdt.location, cdt.date, 
cdt.population, cvs.new_vaccinations, 
SUM(CONVERT(INT,cvs.new_vaccinations)) OVER (PARTITION BY cdt.location, cdt.date) AS cumulative_vaccinations
FROM covidDeaths cdt
JOIN covidVaccinations cvs
ON cdt.location = cvs.location
and cdt.date = cvs.date  WHERE cdt.continent IS NOT NULL 
ORDER BY cdt.date;

SELECT *, (CAST(cumulative_vaccinations AS float)/population) * 100
FROM percentCumulativeVaccinated;


--Creating Data For Data Visualizations

CREATE VIEW CumulativeVaccinatedPercent AS 
SELECT cdt.continent, cdt.location, cdt.date, 
cdt.population, cvs.new_vaccinations, 
SUM(CONVERT(INT,cvs.new_vaccinations)) OVER (PARTITION BY cdt.location, cdt.date) AS cumulative_vaccinations
FROM covidDeaths cdt
JOIN covidVaccinations cvs
ON cdt.location = cvs.location
and cdt.date = cvs.date  WHERE cdt.continent IS NOT NULL
--ORDER BY cdt.date;

SELECT * FROM CumulativeVaccinatedPercent;


-- Creating Views for global data

CREATE VIEW globalData AS
SELECT date, SUM(new_cases) AS sum_of_newcases, SUM(new_deaths) AS sum_of_deaths, 
ROUND(SUM(CAST(new_deaths AS float))/SUM(new_cases) * 100, 2) AS global_percent_death
FROM covidDeaths WHERE continent IS NOT NULL GROUP BY date 
--ORDER BY date;