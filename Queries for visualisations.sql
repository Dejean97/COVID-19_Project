--Ranking View
 DROP VIEW IF EXISTS Country_Rankings

Create View Country_Rankings as
 With CountryRankings (iso_code, continent, location, Population, Total_Cases, Cases_as_Percent_of_Population, Total_Deaths, Deaths_as_Percent_of_Population, Total_Tests, Tests_as_Percent_of_Population,
	Total_Vaccinations, Vaccinations_as_Percent_of_Population, People_Fully_Vaccinated, Fully_Vaccinated_as_Percent_of_Population)
 as
 (
 Select cd.iso_code, cd.continent, cd.location, MAX(cd.population) as "Population", MAX(Cast(cd.total_cases as bigint)) as "Total_Cases", MAX(Cast(cd.total_cases as bigint))/MAX(cd.population)*100 as "Cases_as_Percent_of_Population"
		, MAX(Cast(cd.total_deaths as bigint)) as "Total_Deaths", MAX(Cast(cd.total_deaths as bigint))/MAX(cd.population)*100 as "Deaths_as_Percent_of_Population"
		, MAX(Cast(cv.total_tests as bigint)) as "Total_Tests", MAX(Cast(cv.total_tests as bigint))/MAX(cd.population)*100 as "Tests_as_Percent_of_Population"
		, MAX(Cast(cv.total_vaccinations as bigint)) as "Total_Vaccinations", MAX(Cast(cv.total_vaccinations as bigint))/MAX(cd.population)*100 as "Vaccinations_as_Percent_of_Population"
		, MAX(Cast(cv.people_fully_vaccinated as bigint)) as "People_Fully_Vaccinated", MAX(Cast(cv.people_fully_vaccinated as bigint))/MAX(cd.population)*100 as "Fully_Vaccinated_as_Percent_of_Population"
 FROM PortfolioProject_COVID1..['CovidDeaths'] cd
 Join PortfolioProject_COVID1..['CovidVaccines'] cv
 ON cd.date = cv.date and cd.location = cv.location
 WHERE cd.continent is not null
 GROUP BY cd.iso_code, cd.continent, cd.location
 )
 Select iso_code, continent, location, Population, Total_Cases, Cases_as_Percent_of_Population, CASE WHEN Cases_as_Percent_of_Population IS NULL THEN NULL
         ELSE RANK() OVER 
               (ORDER BY CASE WHEN Cases_as_Percent_of_Population IS NULL THEN 1 ELSE 0 END, Cases_as_Percent_of_Population ASC) END AS Cases_Rank,
		Total_Deaths, Deaths_as_Percent_of_Population, CASE WHEN Deaths_as_Percent_of_Population IS NULL THEN NULL
         ELSE RANK() OVER 
               (ORDER BY CASE WHEN Deaths_as_Percent_of_Population IS NULL THEN 1 ELSE 0 END, Deaths_as_Percent_of_Population ASC) END AS Deaths_Rank, Total_Tests, Tests_as_Percent_of_Population, CASE WHEN Tests_as_Percent_of_Population IS NULL THEN NULL
         ELSE RANK() OVER 
               (ORDER BY CASE WHEN Tests_as_Percent_of_Population IS NULL THEN 1 ELSE 0 END, Tests_as_Percent_of_Population DESC) END AS Tests_Rank, 
		Total_Vaccinations, Vaccinations_as_Percent_of_Population, CASE WHEN Vaccinations_as_Percent_of_Population IS NULL THEN NULL
         ELSE RANK() OVER 
               (ORDER BY CASE WHEN Vaccinations_as_Percent_of_Population IS NULL THEN 1 ELSE 0 END, Vaccinations_as_Percent_of_Population DESC) END AS Vaccinations_Rank, People_Fully_Vaccinated,
		Fully_Vaccinated_as_Percent_of_Population, CASE WHEN Fully_Vaccinated_as_Percent_of_Population IS NULL THEN NULL
         ELSE RANK() OVER 
               (ORDER BY CASE WHEN Fully_Vaccinated_as_Percent_of_Population IS NULL THEN 1 ELSE 0 END, Fully_Vaccinated_as_Percent_of_Population DESC) END AS Fully_Vaccinated_Rank
 From CountryRankings

		--Query

 SELECT [iso_code]
      ,[continent]
      ,[location]
      ,[Population]
      ,[Total_Cases]
      ,[Cases_as_Percent_of_Population]
      ,[Cases_Rank]
      ,[Total_Deaths]
      ,[Deaths_as_Percent_of_Population]
      ,[Deaths_Rank]
      ,[Total_Tests]
      ,[Tests_as_Percent_of_Population]
      ,[Tests_Rank]
      ,[Total_Vaccinations]
      ,[Vaccinations_as_Percent_of_Population]
      ,[Vaccinations_Rank]
      ,[People_Fully_Vaccinated]
      ,[Fully_Vaccinated_as_Percent_of_Population]
      ,[Fully_Vaccinated_Rank]
	  ,CASE WHEN SUM([Cases_Rank]*1+[Deaths_Rank]*1+[Tests_Rank]*1+[Vaccinations_Rank]*1+[Fully_Vaccinated_Rank]*1) IS NULL THEN NULL
         ELSE RANK() OVER
               (ORDER BY CASE WHEN SUM([Cases_Rank]*1+[Deaths_Rank]*1+[Tests_Rank]*1+[Vaccinations_Rank]*1+[Fully_Vaccinated_Rank]*1) IS NULL THEN 1 ELSE 0 END
			   , SUM([Cases_Rank]*1+[Deaths_Rank]*1+[Tests_Rank]*1+[Vaccinations_Rank]*1+[Fully_Vaccinated_Rank]*1) ASC) 
    END AS Overall_Rank
  FROM PortfolioProject_COVID1..Country_Rankings
  GROUP BY [iso_code]
	  ,[continent]
      ,[location]
      ,[Population]
      ,[Total_Cases]
      ,[Cases_as_Percent_of_Population]
      ,[Cases_Rank]
      ,[Total_Deaths]
      ,[Deaths_as_Percent_of_Population]
      ,[Deaths_Rank]
      ,[Total_Tests]
      ,[Tests_as_Percent_of_Population]
      ,[Tests_Rank]
      ,[Total_Vaccinations]
      ,[Vaccinations_as_Percent_of_Population]
      ,[Vaccinations_Rank]
      ,[People_Fully_Vaccinated]
      ,[Fully_Vaccinated_as_Percent_of_Population]
      ,[Fully_Vaccinated_Rank]

--Global Infection and Death Totals

 Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject_COVID1..['CovidDeaths']
where continent is not null 

--Death Total by Continent

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject_COVID1..['CovidDeaths']
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--Infection Counts and Rates by Country

Select Location, Population, MAX(total_cases) as InfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject_COVID1..['CovidDeaths']
Where continent is not null 
Group by Location, Population
order by PercentPopulationInfected desc

--Rolling Infection Percentage by Country

Select Location, Population,date, MAX(total_cases) as InfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject_COVID1..['CovidDeaths']
Where continent is not null 
Group by Location, Population, date
order by Location, date