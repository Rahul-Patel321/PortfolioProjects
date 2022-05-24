select * 
from PortfolioProject..CovidDeaths
order by 3,4


--select * 
--from PortfolioProject..CovidVaccination
--order by 3,4


--Selecting data to be used in this project

select location,date, total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2

--Comparing the total_Cases and the Total Deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2


--Finding the percentage of the total case to the total population

select location,date,total_cases,population, (total_cases/population)*100 as total_case_Percenatge
from PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2


-- figure out the countries with the highest infection rate as compared to the population


select location,population,MAX(total_cases) as highestinfectedcount,
max(total_cases/population)*100 as highestInfectionRate 
from PortfolioProject..CovidDeaths
group by location,population
order by highestinfectedcount desc


--Figure out the countries with the highest death rate as compared to the population


select location,MAX(cast(total_deaths as int)) as highestDeathcounts
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by highestDeathcounts desc


--Looking at the continents with the highest deathcounts

select continent,MAX(cast(total_deaths as int)) as highestDeathcounts
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by highestDeathcounts desc


--Checking out the cases and deaths globally

select date,sum(new_cases) as global_daily_cases,
sum(cast(new_deaths as int)) as global_daily_deaths,
(sum(cast(new_deaths as int))/sum(new_cases))*100 as  deathRateGlobally                                                      --total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null 
group by date
order by 1,2


select sum(new_cases) as global_daily_cases,
sum(cast(new_deaths as int)) as global_daily_deaths,
(sum(cast(new_deaths as int))/sum(new_cases))*100 as  deathRateGlobally                                                      --total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null 
--group by date
order by 1,2


--Joining the both CovidDeaths and CovidVaccination Table 

select * 
from PortfolioProject..CovidVaccination as dea
Join PortfolioProject..CovidVaccination as vac
on dea.location = vac.location and 
dea.date = vac.date

--Looking at total population vs new_vaccination per day

select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths as dea 
Join PortfolioProject..CovidVaccination as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--Adding the new_vaccination and partitioning by location


select dea.continent, dea.location,dea.date, dea.population, 
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) 
over (Partition by dea.Location order by dea.location,dea.date) 
as Rolling_people_vaccinated
from PortfolioProject..CovidDeaths as dea 
Join PortfolioProject..CovidVaccination as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Going to look at percentage of population got vaccinated 
--using a temporary table.

--USE CTE 
with PopvsVac(continent, location,date ,population, new_vaccination, Rolling_people_vaccinated)
as

(select dea.continent, dea.location,dea.date, dea.population, 
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) 
over (Partition by dea.Location order by dea.location,dea.date) 
as Rolling_people_vaccinated
from PortfolioProject..CovidDeaths as dea 
Join PortfolioProject..CovidVaccination as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select *,(Rolling_people_vaccinated/population)*100 as 
percentage_people_vaccinated
from
PopvsVac



--TEMP TABLE 

drop table if exists PercantagePopulationVaccinated
create table PercantagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_people_vaccinated numeric 
)


insert into PercantagePopulationVaccinated
select dea.continent, dea.location,dea.date, dea.population, 
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) 
over (Partition by dea.Location order by dea.location,dea.date) 
as Rolling_people_vaccinated
from PortfolioProject..CovidDeaths as dea 
Join PortfolioProject..CovidVaccination as vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


select *,(Rolling_people_vaccinated/population)*100
from
PercantagePopulationVaccinated



--creating a view for visualization

create view per_vacc_pop
as 
select dea.continent, dea.location,dea.date, dea.population, 
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) 
over (Partition by dea.Location order by dea.location,dea.date) 
as Rolling_people_vaccinated
from PortfolioProject..CovidDeaths as dea 
Join PortfolioProject..CovidVaccination as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
from per_vacc_pop







