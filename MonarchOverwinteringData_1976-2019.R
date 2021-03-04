###################################################################################################################################
#Summarizing data available on monarch overwintering colonies, 1976-2019

#Code written by ER Zylstra
#Last updated: 4 March 2021
###################################################################################################################################

library(plyr)
library(reshape2)
library(ggplot2)

#------------------------------------------------------------#
# Read in data
#------------------------------------------------------------#
  #set working directory...

#Measurements of area occupied, 1976-1991
  #1976-1981 data from Calvert and Brower (1986)
  #1984-1990 data from Mejia (1996)
  #Data were extracted and compiled by ER Zylstra and MI Ramirez. Additional information about which measurements were
  #selected for analyses (when aggregations were measured more than once in a season) can be found in the USGS report.
  dat1 <- read.csv('ColonyData_1976-1991.csv',header=TRUE,stringsAsFactors=FALSE)
    #Yr.Dec: Year (for December of that winter season; eg, for any measurements in winter 1976-1977, Yr.Dec=1976)
    #Supercolony: fundamental spatial unit of overwintering monarchs (may be composed of multiple aggregations in close proximity to each other)
    #n.Aggregations: number of overwintering aggregations measured within the supercolony
    #Area.ha: total area occupied by supercolony in given year, in hectares (ie, sum of areas associated with each aggregation measured)
    #Date.min: earliest date any aggregation was measured (if there's only one aggregation, will be equal to Date.max)
    #Date.max: latest date any aggregtation was measured (if there's only one aggregation, will be equal to Date.min)
  
#Measurements of area occupied, 1993-2003
  #Data from Vidal and Rendon-Salinas (2014)
  dat2 <- read.csv('TotalArea_1993-2003.csv',header=TRUE,stringsAsFactors=FALSE)
    #Yr.Dec: Year (for December of that winter season; eg, for any measurements in winter 1976-1977, Yr.Dec=1976)  
    #TotalArea.ha: Total area occupied by all supercolonies in each year, in hectares

#Measurements of area occupied, 2004-2019
  #Data from Vidal and Rendon-Salinas (2014), Saunders et al. (2019), WWF reports
  dat3 <- read.csv('ColonyData_2004-2019.csv',header=TRUE,stringsAsFactors=FALSE)
    #Supercolony: fundamental spatial unit of overwintering monarchs (may be composed of multiple aggregations in close proximity to each other)
    #Yr.Dec: Year (for December of that winter season; eg, for any measurements in winter 1976-1977, Yr.Dec=1976)    
    #Area.ha: total area occupied by supercolony in given year, in hectares 
  
#------------------------------------------------------------#
# Format and combine supercolony-level data
#------------------------------------------------------------#
  dat1 <- dat1[,c('Supercolony','Yr.Dec','Area.ha')]
  names(dat1) <- c('supercolony','yr','area')
  
  names(dat2) <- c('yr','area.total')
  
  names(dat3) <- c('supercolony','yr','area')
  dat3 <- dat3[with(dat3,order(yr,supercolony,area)),]

  dat <- rbind(dat1,dat3)
  
  #Clean up names of supercolonies:
  dat$supercolony[dat$supercolony=='Chincua'] <- 'Sierra Chincua'
  dat$supercolony[dat$supercolony=='Contepec'] <- 'E Contepec'
  dat$supercolony[dat$supercolony=='Rosario'] <- 'E El Rosario'
  dat$supercolony[dat$supercolony=='La Mesa'] <- 'E La Mesa'
  dat$supercolony[dat$supercolony=='Carpinteros'] <- 'IC Carpinteros'
  dat$supercolony[dat$supercolony=='San Andres'] <- 'PP San Andres'
  # count(dat$supercolony)
  # count(dat$yr)

  #note: there are 0's in the data for 2004-2019, but not earlier
  
#------------------------------------------------------------#
# Calculate mean proportion of the population associated with each supercolony, 2004-2019
#------------------------------------------------------------#
  total0419 <- ddply(dat[dat$yr %in% 2004:2019,],.(yr),summarize,area.total=sum(area))
  dat0419 <- join(dat[dat$yr %in% 2004:2019,],total0419,by='yr',type='left')
  dat0419$prop <- dat0419$area/dat0419$area.total
  sc.props <- ddply(dat0419,.(supercolony),summarize,n=length(prop),
                    min=round(min(prop),4),mn=round(mean(prop),4),med=round(median(prop),4),max=round(max(prop),4))
  sc.props$percent <- sc.props$mn*100
  sc.props$percent.min <- sc.props$min*100
  sc.props$percent.max <- sc.props$max*100
  sc.props[,c('supercolony','percent')]
  
  dat$percent0419 <- sc.props$percent[match(dat$supercolony,sc.props$supercolony)]
  dat$monarchp <- ifelse(dat$area==0,0,1)
  
  early <- dat[dat$yr %in% 1976:1990,]
  early$percentp <- early$percent0419*early$monarchp
  early.annual <- ddply(early,.(yr),summarize,area.meas=sum(area),perc.pop=sum(percentp))
  early.annual$area.total <- early.annual$area.meas*100/early.annual$perc.pop
  early.annual
  
  annual <- rbind(early.annual[,c('yr','area.total')],dat2,total0419)
  annual$area.total <- round(annual$area.total,2)
  plot(area.total~yr,data=annual,type='b')  
  
  #Historical estimates from Fig. 1 of Mawdsley et. al (2020)
  #Extracted values using WebPlotDigitizer (https://apps.automeris.io/wpd/)
  mawdsley <- data.frame(yr=c(1976:1981,1984:1990),
                         area.total=c(1.53,5.79,5.76,2.55,5.21,7.05,
                                      3.05,8.21,3.55,5.82,14.00,9.32,17.79),
                         cat='Mawdsley')
  
  annual$cat <- ifelse(annual$yr<1993,'Estimated','CONANP / WWF')
  annual <- rbind(annual,mawdsley)
  
  mycol <- col2rgb(c('darkseagreen3','steelblue3','salmon1'))
  mycol1 <- rgb(mycol[1,1],mycol[2,1],mycol[3,1],alpha=255*0.6,max=255)
  mycol2 <- rgb(mycol[1,2],mycol[2,2],mycol[3,2],alpha=255,max=255)
  mycol3 <- rgb(mycol[1,3],mycol[2,3],mycol[3,3],alpha=255,max=255)
  
  annual$cat <- factor(annual$cat,levels=c('Estimated','Mawdsley','CONANP / WWF'))
  annual2 <- annual[with(annual,order(cat,yr)),]

  ggplot(annual2,aes(x=yr,y=area.total,fill=cat)) +
    scale_fill_manual(values=c(mycol1,mycol2,mycol3)) +
    geom_col(width=c(rep(0.7,26),rep(1,27)),position=position_dodge2(width=1.1,preserve='single')) +
    theme_classic() +
    labs(y='Area (ha)',x='Year') +
    scale_y_continuous(expand=c(0.01,0.01)) +
    scale_x_continuous(expand=c(0.01,0.01),limits=c(1975.2,2020.5),breaks=seq(1976,2020,1),
                       labels=c(rep('',4),'1980',rep('',9),'1990',rep('',9),'2000',rep('',9),'2010',rep('',9),'2020')) +
    theme(legend.position=c(0.85,0.9),legend.title=element_blank(),text=element_text(size=13))
  #ggsave('TotalPopSize_AllYears.jpg',width=6.5,height=4.5,units='in',dpi=600)

#----------------------------------------------------------------------------#
# Trends in supercolonies that were surveyed more than once between 1976-1990
#----------------------------------------------------------------------------#
  #Cerro Pelon W (1977-), Rosario (1981-), Contepec (1977-), Carpinteros (1981-), Chincua (1976-)  
  #weights (mean percent of total population size, 2004-2019) = 13.4, 41.3, 0.1, 3.0, 13.4
  
  dat <- dat[with(dat,order(supercolony,yr)),]
  
  #Rosario
    rosario <- lm(area~yr,data=dat[dat$supercolony=='E El Rosario',])
    summary(rosario); confint(rosario)
    rosario.yrs <- seq(1981,2019,length=100)
    rosario.preds <- predict(rosario,newdata=data.frame(yr=rosario.yrs),interval='conf')  

  #Sierra Chincua
    chincua <- lm(area~yr,data=dat[dat$supercolony=='Sierra Chincua',])
    summary(chincua); confint(chincua)
    chincua.yrs <- seq(1976,2019,length=100)
    chincua.preds <- predict(chincua,newdata=data.frame(yr=chincua.yrs),interval='conf')
    
  #Cerro Pelon W
    pelon <- lm(area~yr,data=dat[dat$supercolony=='Cerro Pelon W',])
    summary(pelon); confint(pelon)
    pelon.yrs <- seq(1977,2019,length=100)
    pelon.preds <- predict(pelon,newdata=data.frame(yr=pelon.yrs),interval='conf')    
  

  #jpeg('SupercolonyTrends_3panel.jpg',width=4.5,height=6,units='in',res=600)
  par(mfrow=c(3,1),mar=c(3,3.4,0.5,1),mgp=c(1.5,0.5,0),cex=0.8,tcl=-0.25)
  plot(area~yr,data=dat[dat$supercolony=='E El Rosario',],pch=19,xlab='Year',ylab='Area (ha)',
       xlim=c(1976,2019),ylim=c(0,8),las=1,bty='l',col='steelblue4',cex=1.2)
    lines(rosario.preds[,1]~rosario.yrs)
    polygon(c(rosario.yrs,rev(rosario.yrs)),c(rosario.preds[,2],rev(rosario.preds[,3])),col=rgb(0,0,0,alpha=0.2),border=NA)
    text(x=2020,y=par('usr')[3]+0.90*(par('usr')[4]-par('usr')[3]),adj=c(1,0),'El Rosario',cex=1.1)
    text(x=2020,y=par('usr')[3]+0.77*(par('usr')[4]-par('usr')[3]),adj=c(1,0),expression(paste(beta,' = -0.08 (-0.12, -0.03)')))
  plot(area~yr,data=dat[dat$supercolony=='Sierra Chincua',],pch=19,xlab='Year',ylab='Area (ha)',
       xlim=c(1976,2019),ylim=c(0,12),las=1,bty='l',col='steelblue4',cex=1.2)
    lines(chincua.preds[,1]~chincua.yrs)
    polygon(c(chincua.yrs,rev(chincua.yrs)),c(chincua.preds[,2],rev(chincua.preds[,3])),col=rgb(0,0,0,alpha=0.2),border=NA)
    text(x=2020,y=par('usr')[3]+0.90*(par('usr')[4]-par('usr')[3]),adj=c(1,0),'Sierra Chincua',cex=1.1)  
    text(x=2020,y=par('usr')[3]+0.77*(par('usr')[4]-par('usr')[3]),adj=c(1,0),expression(paste(beta,' = -0.08 (-0.14, -0.03)')))
  plot(area~yr,data=dat[dat$supercolony=='Cerro Pelon W',],pch=19,xlab='Year',ylab='Area (ha)',
       xlim=c(1976,2019),ylim=c(0,4),las=1,bty='l',col='steelblue4',cex=1.2)
    lines(pelon.preds[,1]~pelon.yrs)
    polygon(c(pelon.yrs,rev(pelon.yrs)),c(pelon.preds[,2],rev(pelon.preds[,3])),col=rgb(0,0,0,alpha=0.2),border=NA)
    text(x=2020,y=par('usr')[3]+0.90*(par('usr')[4]-par('usr')[3]),adj=c(1,0),'Cerro Pelon W',cex=1.1)  
    text(x=2020,y=par('usr')[3]+0.77*(par('usr')[4]-par('usr')[3]),adj=c(1,0),expression(paste(beta,' = -0.04 (-0.06, -0.01)')))
  #dev.off()  

