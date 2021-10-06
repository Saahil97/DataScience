/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

-- Select Data which we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..Covid_Deaths
order by 1,2 

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in a country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..Covid_Deaths
where location like 'India'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select Location, date, total_cases, Population, (total_cases/population)*100 as DeathPercentage
From PortfolioProject..Covid_Deaths
--Where location like 'India'
order by 1,2

-- Looking ar Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..Covid_Deaths
--Where location like 'India'
Group by Location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..Covid_Deaths
--where location like 'India'
Group by Location 
order by TotalDeathCount desc

-- Lets break down by continents

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..Covid_Deaths
--where location like 'India'
where continent is not null
group by continent
order by TotalDeathCount desc

-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingDeep
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2