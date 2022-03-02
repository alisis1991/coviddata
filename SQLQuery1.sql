/****** Script for SelectTopNRows command from SSMS  ******/

--SELECT *
--FROM dbo.CovidVacinations
--ORDER BY 3,4
-- SELECT *
-- FROM dbo.CovidDeaths
-- ORDER BY 3,4

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM dbo.CovidDeaths
ORDER BY 1,2

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.CovidDeaths
WHERE location= 'Latvia'
ORDER BY 1,2


SELECT location,MAX(total_cases) AS Highest,population, MAX((total_cases / population)) *100 as CasesperPopulation
FROM dbo.CovidDeaths
--WHERE location = 'Latvia'
GROUP BY population,location
ORDER BY CasesperPopulation DESC

SELECT location,MAX(CAST(total_deaths AS int)) AS MaxTotal
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY MaxTotal DESC

SELECT continent,MAX(CAST(total_deaths AS int)) AS MaxTotal
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY MaxTotal DESC

SELECT location,MAX(CAST(total_deaths AS int)) AS MaxTotal
FROM dbo.CovidDeaths
WHERE continent IS NULL AND location NOT LIKE '%income'
GROUP BY location
ORDER BY MaxTotal DESC

--GLOBAL
CREATE VIEW GlobalInfo AS
SELECT continent,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int )) as total_deaths, SUM(cast(new_deaths as int )) / SUM(new_cases)* 100 as DeathPercentage --total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL 
GROUP  BY continent
--ORDER BY 1,2

--USE CTE
WITH POPVSVAC (Continent, Location, Date, Population,New_Vacinations, total_newvac)
AS 
(
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) as total_newvac
-- ,total_newvac/population)*100
FROM dbo.CovidDeaths as deaths
JOIN dbo.CovidVacinations as vac
	ON deaths.location=vac.location AND
	deaths.date = vac.date
)
SELECT * , (total_newvac/Population) *100 AS VacPercentage
FROM POPVSVAC


CREATE VIEW MAXtotal AS
SELECT continent,MAX(CAST(total_deaths AS int)) AS MaxTotal
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
--ORDER BY MaxTotal DESC