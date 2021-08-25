--Deaths and cases exploration
SELECT *
  FROM PortfolioProject_COVID1..['CovidDeaths']
  WHERE continent is not null
  ORDER BY 3,4


SELECT location, date, total_cases, new_cases, total_deaths, population
  FROM PortfolioProject_COVID1..['CovidDeaths']
  WHERE continent is not null
  Order By 1,2

--Total cases vs total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as "DeathRate(Percentage)"
  FROM PortfolioProject_COVID1..['CovidDeaths']
  WHERE location like '%united kingdom%'
  AND continent is not null
  Order By 1,2

  --Peak day
  SELECT top 1 location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as "DeathRate(Percentage)"
  FROM PortfolioProject_COVID1..['CovidDeaths']
  WHERE location like '%united kingdom%'
  AND continent is not null
  Order By 5 desc


--Population vs total cases
SELECT location, date, population, total_cases,(total_cases/population)*100 as "infected(percentage)"
  FROM PortfolioProject_COVID1..['CovidDeaths']
  WHERE location like '%united kingdom%'
  AND continent is not null
  Order By 1,2

  --Infection count by continent
  SELECT location, MAX(population) as "total population", MAX(total_cases) as "infection count", MAX((total_cases/population)*100) as "infected(percentage)"
  FROM PortfolioProject_COVID1..['CovidDeaths']
  WHERE continent is null
  GROUP By location
  Order By 3 desc

--Infection count by country
  SELECT location, population, MAX(total_cases) as "infection count", MAX((total_cases/population)*100) as "infected(percentage)"
  FROM PortfolioProject_COVID1..['CovidDeaths']
  WHERE continent is not null
  GROUP By location, population
  Order By 4 desc

  --Death count by continent
  SELECT location, MAX(population) as "total population",MAX(Cast(total_deaths as int)) as "death count", MAX((total_deaths/population)*100) as "deceased(percentage)"
  FROM PortfolioProject_COVID1..['CovidDeaths']
  WHERE continent is null
  GROUP By location
  Order By 3 desc

  --"World" count is weird/wrong

  --Death count by country
  SELECT location, population, MAX(Cast(total_deaths as int)) as "death count", MAX((total_deaths/population)*100) as "deceased(percentage)"
  FROM PortfolioProject_COVID1..['CovidDeaths']
  WHERE continent is not null
  GROUP By location, population
  Order By 3 desc

  --Global numbers
  SELECT date, SUM(new_cases) as "total cases", SUM(cast(new_deaths as int)) as "total deaths", (SUM(cast(new_deaths as int))/SUM(new_cases)*100) as "DailyDeathRate(Percentage)"
  FROM PortfolioProject_COVID1..['CovidDeaths']
  WHERE continent is not null
  GROUP BY date
  Order By 1

  SELECT SUM(new_cases) as "total cases", SUM(cast(new_deaths as int)) as "total deaths", (SUM(cast(new_deaths as int))/SUM(new_cases)*100) as "DeathRate(Percentage)"
  FROM PortfolioProject_COVID1..['CovidDeaths']
  WHERE continent is not null
  Order By 1

