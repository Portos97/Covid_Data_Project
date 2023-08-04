Select *
From CovidDeaths$
order by 3,4

--Select *
--From CovidVaccinations$
--order by 3,4

-- Show chance of dying of covid in Poland

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths$
where location = 'Poland'
order by 1, 2

-- Percentage of population that got covid in Poland
Select location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From CovidDeaths$
where location = 'Poland'
order by 1, 2

-- Countries with the highest percentage of population infected
 
Select location, population, max(total_cases) as HighestInfection, MAX(total_cases/population)*100 as PercentagePopulationInfected
From CovidDeaths$
--where location = 'Poland'
group by location, population
order by PercentagePopulationInfected desc

-- Countries with the highest death count per population

Select location, max(cast(total_deaths as int)) as TotalDeathcount
From CovidDeaths$
--where location = 'Poland'
group by location
order by TotalDeathcount desc

-- Total death count by continent

Select continent, max(cast(total_deaths as int)) as TotalDeathcount
From CovidDeaths$
where continent is not NULL
group by continent
order by TotalDeathcount desc

--Global new cases per day and death percentage

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,  SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From CovidDeaths$
where continent is not null
group by date
order by date, total_cases

-- Total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as SumofPeopleVaccinated
From CovidDeaths$ dea
join CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--view to store data for visualization

Create View PercentPeopleVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as SumofPeopleVaccinated
From CovidDeaths$ dea
join CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3