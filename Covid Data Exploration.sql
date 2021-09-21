--Exploring the inserted table Covid Death

SELECT *
FROM PortfolioProject..[Covid Death]
ORDER BY 3,4



--Excluding continents

SELECT *
FROM PortfolioProject..[Covid Death]
WHERE continent is not null
ORDER BY 3,4

--Selecting Data to be used

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..[Covid Death]
ORDER BY 1,2


--Looking at total cases vs total deaths
--Shows likelihood of dying if you contract covid in your country

SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject..[Covid Death]
WHERE location = 'India'
ORDER BY 1,2


--Looking  at total cases vs population in India
--Shows what percentage of population have covid in India

SELECT location,date,total_cases,population, (total_cases/population)*100 AS percent_of_population_infected
FROM PortfolioProject..[Covid Death]
WHERE location = 'India'
ORDER BY 1,2


--Looking at countries with highest infection rate compared to population

SELECT location,MAX(total_cases) AS highest_infection_count,population, MAX((total_cases/population))*100 AS percent_of_population_infected
FROM PortfolioProject..[Covid Death]
GROUP BY location,population
ORDER BY 1,2

--Ordered according to the percent of population infected in descending order

SELECT location,MAX(total_cases) AS highest_infection_count,population, MAX((total_cases/population))*100 AS percent_of_population_infected
FROM PortfolioProject..[Covid Death]
GROUP BY location,population
ORDER BY percent_of_population_infected DESC

--Excluding continents

SELECT *
FROM PortfolioProject..[Covid Death]
WHERE continent is not null
ORDER BY 3,4

--Showing countries with highest death count per population

SELECT location,MAX(CAST(total_deaths AS int)) AS total_death_count
FROM PortfolioProject..[Covid Death]
WHERE continent is not null
GROUP BY location
ORDER BY total_death_count DESC


--Break things down by continent and world numbers

SELECT location,MAX(CAST(total_deaths AS int)) AS total_death_count
FROM PortfolioProject..[Covid Death]
WHERE continent is null
GROUP BY location
ORDER BY total_death_count DESC

--Global Numbers of covid cases
SELECT date, SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS int)) AS total_deaths,SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS death_percentage
FROM PortfolioProject..[Covid Death]
WHERE continent is not null
GROUP BY date
ORDER BY 1,2


-- Total Global numbers percentage

SELECT  SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS int)) AS total_deaths,SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS death_percentage
FROM PortfolioProject..[Covid Death]
WHERE continent is not null
ORDER BY 1,2


--Covid Vaccinations Table

SELECT *
FROM PortfolioProject..[Covid Vaccination]
ORDER BY 3,4 

--Join 
--Joining the 2 tables

SELECT *
FROM PortfolioProject..[Covid Death] dea
JOIN PortfolioProject..[Covid Vaccination] vac
ON dea.location = vac.location
AND dea.date = vac.date

--Looking at total population vs Vaccinations

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
FROM PortfolioProject..[Covid Death] dea
JOIN PortfolioProject..[Covid Vaccination] vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--Using PARTIION total population vs Vaccinations

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS people_vaccinated
FROM PortfolioProject..[Covid Death] dea
JOIN PortfolioProject..[Covid Vaccination] vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--USE CTE - Common Table Expression

With pop_vs_vac (continent,location,date,population,new_vaccinations,people_vaccinated )
AS
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS people_vaccinated
FROM PortfolioProject..[Covid Death] dea
JOIN PortfolioProject..[Covid Vaccination] vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null

)
SELECT *,(people_vaccinated/population)*100 AS percentage_vaccinated
FROM pop_vs_vac


--TEMP TABLE
--Creating Temp Tables


DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
people_vaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS people_vaccinated
FROM PortfolioProject..[Covid Death] dea
JOIN PortfolioProject..[Covid Vaccination] vac
ON dea.location = vac.location
AND dea.date = vac.date

SELECT *,(people_vaccinated/population)*100 AS percentage_vaccinated
FROM #PercentPopulationVaccinated

--VIEW
--Creating view to store data for later visualisation

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS people_vaccinated
FROM PortfolioProject..[Covid Death] dea
JOIN PortfolioProject..[Covid Vaccination] vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null

SELECT *
FROM PercentPopulationVaccinated
























