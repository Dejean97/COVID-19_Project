# COVID_Project

This aim of this project was to take some 'real-life' data and draw insight to get an overview of the COVID-19 situation globally. This involved the use of SQL and Power BI.

Inspiration for this project came from [Alex The Analyst's](https://www.youtube.com/channel/UC7cs8q-gJRlGwj4A8OmCmXg) Youtube channel.

The data used for this project came from the Our World in Data blog [post](https://ourworldindata.org/covid-deaths) that tracks and visualises COVID-19 related data.

## Project Summary

Having downloaded the data of interest, the data was split into two sets (one containing data relating to cases, deaths and hospital admissions and the other relating to testing and vaccinations). There is no real reason to do this other than to practice JOINS in SQL.

### Steps in SQL

- From here the data was explored before building queries and views for easy visualisation.
- Most notable examples are:
  -  The query tho produce a rolling percentage of infected as a portion of the population by location.
  -  A view to create a ranking system for how each country "dealt" with COVID-19. 
    1. This created figures based on the countries total cases, deaths, tests, vaccinations and fully vaccinated people as a percentage of their total population (as of the end of August '21).
    2. Cases and deaths as a percentage of total population were ranked in ascending order whilst tests, vaccinations and fully vaccinated people as a percentage of total population were ranked in descending order (meaning overall a lower rank was better in all measures).
    3. Using percentages of total population meant that countries of varying sizes could be reasonably compared.
    4. These ranks were them summed and countries were ranked by this sum to produce an overall rank.

### Steps in Power BI
