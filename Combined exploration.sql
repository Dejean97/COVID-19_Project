-- Exploring both together

Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
FROM PortfolioProject_COVID1..['CovidDeaths'] cd
JOIN PortfolioProject_COVID1..['CovidVaccines'] cv
ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent is not null
ORDER BY 2,3 ASC

--Rolling country vaccine count
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(cast(cv.new_vaccinations as int)) OVER (partition by cd.location ORDER BY cd.location, cd.date) as rolling_vaccine_count
FROM PortfolioProject_COVID1..['CovidDeaths'] cd
JOIN PortfolioProject_COVID1..['CovidVaccines'] cv
ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent is not null
ORDER BY 2,3 ASC

--Rolling global vaccine count
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(cast(cv.new_vaccinations as int)) OVER (partition by cd.date ORDER BY cd.date, cd.location) as rolling_vaccine_count
FROM PortfolioProject_COVID1..['CovidDeaths'] cd
JOIN PortfolioProject_COVID1..['CovidVaccines'] cv
ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent is not null
ORDER BY 3 ASC

-- Use CTE for rolling vaccinated population percentage

With POPvsVAC (Continent, Location, Date, Population, new_vaccinations, rolling_vaccine_count)
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(cast(cv.new_vaccinations as int)) OVER (partition by cd.location ORDER BY cd.location, cd.date) as rolling_vaccine_count
FROM PortfolioProject_COVID1..['CovidDeaths'] cd
JOIN PortfolioProject_COVID1..['CovidVaccines'] cv
ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent is not null
)
SELECT *, ((rolling_vaccine_count/Population)*100) AS "Rolling_Vaccinated%" FROM POPvsVAC

-- Create TEMP table for rolling vaccinated population percentage

DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
rolling_vaccine_count numeric
)

Insert Into #PercentPopulationVaccinated
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(cast(cv.new_vaccinations as int)) OVER (partition by cd.location ORDER BY cd.location, cd.date) as rolling_vaccine_count
FROM PortfolioProject_COVID1..['CovidDeaths'] cd
JOIN PortfolioProject_COVID1..['CovidVaccines'] cv
ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent is not null

SELECT *, ((rolling_vaccine_count/Population)*100) AS "Rolling_Vaccinated%" FROM #PercentPopulationVaccinated

--Creating view for visualisation

Create View PercentVaccinatedPopulation as
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(cast(cv.new_vaccinations as int)) OVER (partition by cd.date ORDER BY cd.date, cd.location) as rolling_vaccine_count
FROM PortfolioProject_COVID1..['CovidDeaths'] cd
JOIN PortfolioProject_COVID1..['CovidVaccines'] cv
ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent is not null