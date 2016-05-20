library(choroplethr)
library(choroplethrMaps)
library(ggplot2);library(classInt)
setwd("/Users/rachel_wilkerson/Box Sync/RLW THI Projects/breakfast_heat_map/")
load("map_ze_breakfast.RData")
df=read.csv("heatmap.csv",strip.white=T,stringsAsFactors = F)
df$perc=as.numeric(substr(df$X..FRP.Breakfast.Participation,1,nchar(df$X..FRP.Breakfast.Participation)-1))
df=df[-c(253,252),]
df[is.na(df)]=0
classIntervals(df$perc, 6,"jenks")
data(county.regions)
county.regions.tx=county.regions[which(county.regions$state.name=="texas"),]
df$County=tolower(df$County)
df=merge(df,county.regions.tx,by.x="County",by.y="county.name",all=T)
df$perc[which(is.na(df$perc)==T)]<-0
df$value=cut(df$perc,breaks=c(0,10,20,30,40,50,60,70,80,90),include.lowest = T)

#df$region=county.regions.tx$region[match(tolower(df$County),county.regions.tx$county.name)]
#df$check=county.regions.tx$county.name[match(tolower(df$County),county.regions.tx$county.name)]
#length(unique(df$region))
#df=df[-c(252,253),]
df$region.y<-NULL
colnames(df)[6]<-"region"
county_choropleth(df,
                  title      = "Participation",
                  legend     = "Participation",
                  num_colors = 1,
                  state_zoom = "texas")

df$value[which(is.na(df$value)==T)]<-0
choro = CountyChoropleth$new(df)
choro$ggplot_scale = scale_fill_brewer(name="Participation",palette=7, drop=FALSE)
choro$set_zoom("texas")
choro$render()

ggsave("map_me_some_breakfast_orangeCUTS.pdf",height=7,width=7,units="in")
