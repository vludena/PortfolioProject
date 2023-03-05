Select * From PortfolioProject..CovidDeaths
Where continent is not null 
order by 3,4


SELECT LOCATION, DATE, TOTAL_CASES, NEW_CASES, TOTAL_DEATHS, POPULATION
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

---Look at totla cases vs. Total Deaths
--Shows likelyhood of dying if you contract covid in your country 

SELECT LOCATION, DATE, TOTAL_CASES,  TOTAL_DEATHS, (Total_Deaths/total_cases)*100 as DeathPercentages
FROM PortfolioProject..CovidDeaths
WHERE location like '%peru%' and
continent is not null
order by 1,2

-- Looking at the total cases vs Population 
-- Show what percentage of population got covid

SELECT LOCATION, DATE,population, TOTAL_CASES, (Total_cases/population)*100 as DeathPercentages
FROM PortfolioProject..CovidDeaths
--WHERE location like '%peru%'
Where continent is not null
order by 1,2

--Looking countries with highest infection rate compared to population

SELECT LOCATION,population, MAX(TOTAL_CASES) AS HighestInfectionCount , Max(Total_cases/population)*100 as PecerntPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%peru%'
Where continent is not null
Group by location, population
order by PecerntPopulationInfected Desc

--- Showing the countries with highest death count per population 

SELECT LOCATION, Max(cast(Total_deaths as int)) as TotalDeathscount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%peru%
Where continent is not null
Group by location
order by TotalDeathsCount Desc

--LET'S BREAK THINGS  DOWN BY CONTINENT 

SELECT continent, Max(cast(Total_deaths as int)) as TotalDeathscount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%peru%
Where continent is not null
Group by continent
order by TotalDeathsCount Desc

---This is showing the conitents with highest count per population 

SELECT continent, Max(cast(Total_deaths as int)) as TotalDeathscount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%peru%
Where continent is not null
Group by continent
order by TotalDeathsCount Desc


--Breaking global numbers

SELECT  SUM(New_CASES) As Total_Cases, sum(cast(new_deaths as int))as total_deaths, sum(cast
(new_deaths as int)) /sum(New_Cases) * 100 as DeathPercentages
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%' and
where continent is not null
--group by date
order by 1,2 

--Looking at Total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(Int, vac.new_vaccinations)) OVER (Partition by  dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,( RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea

Join  PortfolioProject..Covidvaccinations vac
	On dea.location= vac.location
	and dea.date =vac.date
	where dea.continent is not null
	order by 2,3 

	--USE CTE

	With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
	as 
	(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by  dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,( RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea

Join  PortfolioProject..Covidvaccinations vac
	On dea.location= vac.location
	and dea.date =vac.date
	--where dea.continent is not null
	--order by 2,3 
	)
	Select * ,(RollingPeopleVaccinated/Population ) *100
	From PopvsVac

	-- TEMP TABLE 

DROP Table if exists #PercentPopulationVaccinated 
Create Table #PercentPopulationVaccinated 
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric, 
New_Vaccinations numeric, 
RollingPeopleVaccinated numeric
)


Insert Into #PercentPopulationVaccinated 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by  dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
--,( RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea

Join  PortfolioProject..Covidvaccinations vac
	On dea.location= vac.location
	and dea.date =vac.date
	where dea.continent is not null
	order by 2,3 

	Select * ,(RollingPeopleVaccinated/Population )*100
	From #PercentPopulationVaccinated 

	--Creating View to store date for later visualizatons 


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by  dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
--,( RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea

Join  PortfolioProject..Covidvaccinations vac
	On dea.location= vac.location
	and dea.date =vac.date
	where dea.continent is not null
	--order by 2,3 

Create View Breakingglobalnumbers as
	SELECT  SUM(New_CASES) As Total_Cases, sum(cast(new_deaths as int))as total_deaths, sum(cast
(new_deaths as int)) /sum(New_Cases) * 100 as DeathPercentages
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%' and
where continent is not null
--group by date
---order by 1,2 

Select * from PercentPopulationVaccinated;

Select * from Breakingglobalnumbers;
