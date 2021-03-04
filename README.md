# Summary of available data from the monarch overwintering colonies in central Mexico, 1976-1991

### Erin R. Zylstra, Wayne E. Thogmartin, M. Isabel Ramírez, and Elise F. Zipkin

### USGS Open-File Report 2020-1150 [10.3133/ofr20201150]( https://doi.org/10.3133/ofr20201150)
_______________________________________________________________________________________________________________________________________

## Overview:
Historical estimates of the area occupied by overwintering *Danaus plexippus* (monarchs) in central Mexico (between winters of 1976 and 1991) were published in García-Serrano and others (2004) and more recently in Mawdsley and others (2020). Our primary objectives were to identify the specific data that informed those estimates and, importantly, determine the degree to which the reported estimates reflect the total size of the overwintering monarch population during that period. Understanding how historical estimates of the overwintering area relate to total population size is necessary to ensure that inferences about population abundance and temporal trends are reliable, particularly as the U.S. Fish and Wildlife Service is in the process of determining if the species should be listed under the U.S. Endangered Species Act.
## Code 
1. [MonarchOverwinteringData_1976-2019.R]( MonarchOverwinteringData_1976-2019.R): R code used to summarize data on the overwintering colonies between 1976 and 2019. 

## Data
1. [ColonyData_1976-1991.csv]( ColonyData_1976-1991.csv): Measurements of the area occupied by monarch butterflies at overwintering sites, 1976-1991. Data from 1976-1981 from Calvert and Brower (1986). Data from 1984-1990 from Mejía (1996). Data were extracted and compiled by ER Zylstra and MI Ramirez. Additional information about which measurements were selected for analyses (when aggregations were measured more than once in a season) can be found in the USGS report. The columns are:
    - Yr.Dec: Year (for December of that winter season; eg, for any measurements in winter 1976-1977, Yr.Dec=1976)
    - Supercolony: fundamental spatial unit of overwintering monarchs (may be composed of multiple aggregations in close proximity to each other)
    - n.Aggregations: number of overwintering aggregations measured within the supercolony
    - Area.ha: total area occupied by supercolony in given year, in hectares (ie, sum of areas associated with each aggregation measured)
    - Date.min: earliest date any aggregation was measured (if there's only one aggregation, will be equal to Date.max)
    - Date.max: latest date any aggregtation was measured (if there's only one aggregation, will be equal to Date.min)
2. [TotalArea_1993-2003.csv]( TotalArea_1993-2003.csv): Measurements of the total area occupied by monarch butterflies at overwintering sites, 1993-2003. Data from Vidal and Rendón-Salinas(2014). The columns are:
    - Yr.Dec: Year (for December of that winter season; eg, for any measurements in winter 1976-1977, Yr.Dec=1976)
    - TotalArea.ha: Total area occupied by all supercolonies in each year, in hectares
3. [ColonyData_2004-2019.csv]( ColonyData_2004-2019.csv): Measurements of the area occupied by monarch butterflies at overwintering sites, 2004-2019. Data from Vidal and Rendón-Salinas(2014), Saunders et al. (2019), and WWF reports. The columns are:
    - Supercolony: fundamental spatial unit of overwintering monarchs (may be composed of multiple aggregations in close proximity to each other)
    - Yr.Dec: Year (for December of that winter season; eg, for any measurements in winter 1976-1977, Yr.Dec=1976)
    - Area.ha: total area occupied by supercolony in given year, in hectares
