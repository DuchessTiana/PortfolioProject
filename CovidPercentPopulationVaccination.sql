select *
from portfolioProject..CovidDeaths
where continent is not null
order by 3,4


select *
from portfolioProject..CovidVaccinations
order by 3,4


select Location, date, total_cases, new_cases, total_deaths, population
from portfolioProject..CovidDeaths
where continent is not null
order by 1,2


select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from portfolioProject..CovidDeaths
where location like '%Brazil%'
and continent is not null
order by 1,2



select Location, date, population, total_cases, (total_cases/population)*100 as percentPopulationInfected
from portfolioProject..CovidDeaths
--where location like '%Brazil%'
order by 1,2



select Location, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as 
PercentPopulationInfected
from portfolioProject..CovidDeaths
--where location like '%Brazil%'
Group by Location, Population
order by PercentPopulationInfected desc



select Location, MAX(cast(Total_Deaths as int)) TotalDeathCount
from portfolioProject..CovidDeaths
--where location like '%Brazil%'
where continent is not null
Group by Location 
order by TotalDeathCount desc



select continent, MAX(cast(Total_Deaths as int)) TotalDeathCount
from portfolioProject..CovidDeaths
--where location like '%Brazil%'
where continent is not null
Group by continent
order by TotalDeathCount desc



select continent, date, sum(new_cases)as TotalContinentCases, sum(new_deaths) as TotalContinentDeaths
from portfolioProject..CovidDeaths
--where location like '%Brazil%'
where continent is not null
Group by continent, date
order by 1,2



select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,dea.Date)as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by 2,3



with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.Date)as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac



Drop Table if exists #PercentPopulationVaccinations
Create Table #PercentPopulationVaccinations
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.Date)as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
select *, (RollingPeopleVaccinated/Population)*100 as PercentRollingPeopleVaccinated
from #PercentPopulationVaccinations


--Creating views to store data for later visualizations

create view PercentPopulationVaccinations as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.Date)as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinations







