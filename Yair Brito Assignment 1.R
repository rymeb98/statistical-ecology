#I obtained the data used for this assignment from Dr. Maitner's github page url: https://github.com/bmaitner/Statistical_ecology_course/blob/main/data/BBS/FL_BBS.csv
#To get more specific, the data originated from the USGS website url: https://www.sciencebase.gov/catalog/item/625f151ed34e85fa62b7f926 
#Description: This data is from the Florida breeding bird survey from 1996 to 2019. it contains data of each individual species sighted and their frequency, and factors partaining to each count such as start and end temperature of the environment the count was done in, the time they started and ended, the coordinates of the locations, and subsequent data such as total sightings of each species, total species at each count, mean annual temperature and precipitation etc. Something to note is the data in this file only has 1 day from each year.

library(reshape)
library(tidyr)


#read.csv("C:/Users/yairb/Desktop/R related softwares/Assignment 1/FL_BBS.csv", header = TRUE)
fl_bbs <- read.csv("C:/Users/yairb/Desktop/R related softwares/Assignment 1/FL_BBS.csv", header = TRUE)
#fl_bbs
#class(fl_bbs)

#class is a data frame

#potential variables to look at: total spp in a given year across Routes, total spp across years, total spp against mean annual precip
#total species against footprint, look at a specific spp total sightings across years, a specific spp against footprint
#This means the variables of interest are: Route, Year, ORDER/Family/Genus/Scientific_Name (specifically the species name), total_sightings, TotalSpp, mean_annual_precip, and footprint

sapply(fl_bbs, class)

class(fl_bbs$Route)
#class for Route is integer however it should be a character so the following code changes it to that
fl_bbs$Route<-as.character(fl_bbs$Route)
class(fl_bbs$Route)

class(fl_bbs$Year)
#class for Year is integer

class(fl_bbs$ORDER)
#class for ORDER is character

class(fl_bbs$Family)
#class for Family is character

class(fl_bbs$Genus)
#class for Genus is character

class(fl_bbs$Scientific_Name)
#class for Scientific_Name is character

class(fl_bbs$total_sightings)
#class for total_sightings is integer

class(fl_bbs$TotalSpp)
#class for TotalSpp is integer

class(fl_bbs$footprint)
#class for footprint is integer

#summary stats

summary(fl_bbs$Year)
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#  1996    2002    2007    2008    2013    2019
table(fl_bbs$Year)
# Year: 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 
#count:   57 3219 3603 3803 3702 3656 3957 3789 3773 3497 3554 3549 3499 3707 4073 4158 2717 3007 3046 2902 3195
#Year:  2017 2018 2019 
#count: 3019 3326 3183 

table(fl_bbs$ORDER)
# Accipitriformes     Anseriformes    Apodiformes  Caprimulgiformes   Cathartiformes  Charadriiformes 
# 4046                1017             1140             2171             2684             1958 
# Ciconiiformes    Columbiformes    Coraciiformes     Cuculiformes    Falconiformes      Galliformes 
# 445               4552               66              910              333             1779 
# Gruiformes    Passeriformes   Pelecaniformes       Piciformes Podicipediformes   Psittaciformes 
# 1501            41585             7922             6010               72               48 
# Strigiformes       Suliformes 
# 771                 981 

table(fl_bbs$Family)
# Accipitridae   Alcedinidae          Anatidae        Anhingidae          Apodidae 
# 3310                66              1017               557               983 
# Aramidae        Ardeidae     Caprimulgidae      Cardinalidae       Cathartidae 
# 172              6365              2171              3703              2684 
# Charadriidae     Ciconiidae        Columbidae       Corvidae         Cuculidae 
# 798                445              4552              4663               910 
# Falconidae        Fregatidae      Fringillidae       Gruidae    Haematopodidae 
# 333                  43               246               639                23 
# Hirundinidae      Icteridae      Icteriidae          Laniidae           Laridae 
# 1715               6088               278               769               862 
# Mimidae    Odontophoridae       Pandionidae           Paridae         Parulidae 
# 2899              1360               736              2155              5151 
# Passerellidae    Passeridae       Pelecanidae   Phalacrocoracidae       Phasianidae 
# 2183               505               190               380               419 
# Picidae     Podicipedidae     Polioptilidae       Psittacidae     Psittaculidae 
# 6010             72                1152                46                 2 
# Rallidae  Recurvirostridae      Scolopacidae          Sittidae         Strigidae 
# 690               177                98               481               754 
# Sturnidae       Sulidae     Threskiornithidae       Trochilidae     Troglodytidae 
# 948                 1              1367               157              1654 
# Turdidae        Tyrannidae         Tytonidae        Vireonidae 
# 1265              2662                17              3068 

table(fl_bbs$Genus)
# Accipiter            Acridotheres             Agelaius                Aix 
# 161                       9                    1389                   307 
# Alopochen           Ammospiza                Anas                 Anhinga 
# 2                      41                     410                     557 
# Antigone             Antrostomus              Aphelocoma              Aramus 
# 638                    1037                     109                     172 
# Aratinga             Archilochus             Ardea                  Ardeid 
# 3                     157                    2039                       3 
# Athene              Baeolophus                Botaurus                  Branta 
# 38                    1287                       2                      33 
# Brotogeris             Bubo                Bubulcus                   Buteo 
# 3                      197                    1287                    2036 
# Butorides             Cairina                Caracara              Cardinalis 
# 736                      34                     145                    1739 
# Cathartes                Chaetura              Charadrius              Chordeiles 
# 1456                     983                     798                    1134 
# Cistothoru            Coccyzus                Colaptes             Colinus 
# 2                     905                     725                    1360 
# Columba               Columbina                Contopus                Coragyps 
# 340                    1182                     119                    1226 
# Coragyps / Cathartes      Corvus              Crotophaga              Cyanocitta 
# 2                         2945                     5                    1609 
# Dendrocygna           Dryobates               Dryocopus               Dumetella 
# 229                    1561                    1295                     100 
# Egretta               Elanoides                  Elanus               Empidonax 
# 1915                     642                       4                     207 
# Eudocimus               Falco                 Fregata                  Fulica 
# 943                     188                      43                      45 
# Gallinula            Gelochelidon              Geothlypis               Grus 
# 464                      31                    1369                       1 
# Gull              Haematopus              Haemorhous              Haliaeetus 
# 1                      23                     246                     253 
# Himantopus             Hirundo             Hydroprogne              Hylocichla 
# 177                     460                      57                     151 
# Icteria                 Icterus                 Ictinia              Ixobrychus 
# 278                     439                     192                      97 
# Lanius                   Larus              Laterallus             Leucophaeus 
# 769                      46                       3                     369 
# Limnothlypis          Megaceryle               Megascops              Melanerpes 
# 64                      66                      44                    2426 
# Meleagris           Melopsittacus             Mimus               Molothrus 
# 419                       2                    1650                     827 
# Mycteria               Myiarchus              Myiopsitta              Nyctanassa 
# 445                    1669                      40                     107 
# Nycticorax     Nycticorax / Nyctanassa        Pandion                Parkesia 
# 174                       5                     736                       5 
# Passer               Passerina             Patagioenas               Pelecanus 
# 505                    1137                      52                     190 
# Petrochelidon         Peucaea           Phalacrocorax                Pipilo 
# 19                     577                     380                    1545 
# Piranga                Platalea                Plegadis              Podilymbus 
# 827                     100                     324                      72 
# Poecile              Polioptila               Porphyrio                  Progne 
# 868                    1152                      43                     982 
# Protonotaria          Quiscalus                 Rallus              Rostrhamus 
# 339                    2430                     135                      22 
# Rynchops                Sayornis                Scolopax               Setophaga 
# 46                       3                      10                    3374 
# Sialia                   Sitta                 Spatula                Spizella 
# 1106                     481                       2                      20 
# Stelgidopteryx         Sterna                Sternula            Streptopelia 
# 239                      28                     157                     977 
# Strix               Sturnella                 Sturnus                    Sula 
# 475                    1003                     939                       1 
# Tachycineta            Tern              Thalasseus             Thryothorus 
# 15                      25                     102                    1652 
# Toxostoma              Tringa                  Turdus                Tyrannus 
# 1149                      88                       8                     664 
# Tyto             Vireo              Woodpecker             Zenaida 
# 17                3068                   3                    2001 

table(fl_bbs$Scientific_Name)
# Accipiter cooperii                          Acridotheres tristis 
# 161                                             9 
# Agelaius phoeniceus                                    Aix sponsa 
# 1389                                           307 
# Alopochen aegyptiaca                            Ammospiza maritima 
# 2                                            41 
# Anas fulvigula                            Anas platyrhynchos 
# 314                                            81 
# Anas platyrhynchos x rubripes or fulvigula                               Anhinga anhinga 
# 15                                           557 
# Antigone canadensis                      Antrostomus carolinensis 
# 638                                          1037 
# Aphelocoma coerulescens                               Aramus guarauna 
# 109                                           172 
# Aratinga nenday                          Archilochus colubris 
# 3                                           157 
# Ardea alba                                Ardea herodias 
# 1165                                           848 
# Ardea herodias occidentalis                                    Ardeid sp. 
# 26                                             3 
# Athene cunicularia                            Baeolophus bicolor 
# 38                                          1287 
# Botaurus lentiginosus                             Branta canadensis 
# 2                                            33 
# Brotogeris chiriri             Brotogeris versicolurus / chiriri 
# 2                                             1 
# Bubo virginianus                                 Bubulcus ibis 
# 197                                          1287 
# Buteo brachyurus                             Buteo jamaicensis 
# 11                                           474 
# Buteo lineatus                             Buteo platypterus 
# 1461                                            89 
# Buteo sp.                           Butorides virescens 
# 1                                           736 
# Cairina moschata                             Caracara cheriway 
# 34                                           145 
# Cardinalis cardinalis                                Cathartes aura 
# 1739                                          1456 
# Chaetura pelagica                            Charadrius nivosus 
# 983                                             8 
# Charadrius vociferus                           Charadrius wilsonia 
# 780                                            10 
# Chordeiles minor                 Chordeiles minor / gundlachii 
# 1133                                             1 
# Cistothorus palustris                           Coccyzus americanus 
# 2                                           871 
# Coccyzus minor                      Colaptes auratus auratus 
# 34                                           725 
# Colinus virginianus                                 Columba livia 
# 1360                                           340 
# Columbina passerina                               Contopus virens 
# 1182                                           119 
# Coragyps / Cathartes atratus / aura                              Coragyps atratus 
# 2                                          1226 
# Corvus brachyrhynchos            Corvus brachyrhynchos / ossifragus 
# 1449                                           291 
# Corvus ossifragus                                Crotophaga ani 
# 1205                                             5 
# Cyanocitta cristata                        Dendrocygna autumnalis 
# 1609                                           212 
# Dendrocygna bicolor                            Dryobates borealis 
# 17                                           158 
# Dryobates pubescens                            Dryobates villosus 
# 1353                                            50 
# Dryocopus pileatus                        Dumetella carolinensis 
# 1295                                           100 
# Egretta caerulea                             Egretta rufescens 
# 926                                            53 
# Egretta thula                              Egretta tricolor 
# 454                                           482 
# Elanoides forficatus                               Elanus leucurus 
# 642                                             4 
# Empidonax virescens                               Eudocimus albus 
# 207                                           943 
# Falco sparverius                           Fregata magnificens 
# 188                                            43 
# Fulica americana                             Gallinula galeata 
# 45                                           464 
# Gelochelidon nilotica                            Geothlypis formosa 
# 31                                            51 
# Geothlypis trichas                                Grus americana 
# 1318                                             1 
# Gull sp.                          Haematopus palliatus 
# 1                                            23 
# Haemorhous mexicanus                      Haliaeetus leucocephalus 
# 246                                           253 
# Himantopus mexicanus                               Hirundo rustica 
# 177                                           460 
# Hydroprogne caspia                          Hylocichla mustelina 
# 57                                           151 
# Icteria virens                            Icterus pectoralis 
# 278                                             3 
# Icterus spurius                      Ictinia mississippiensis 
# 436                                           192 
# Ixobrychus exilis                           Lanius ludovicianus 
# 97                                           769 
# Larus argentatus                            Larus delawarensis 
# 16                                            30 
# Laterallus jamaicensis                         Leucophaeus atricilla 
# 3                                           369 
# Limnothlypis swainsonii                             Megaceryle alcyon 
# 64                                            66 
# Megascops asio                          Melanerpes carolinus 
# 44                                          1729 
# Melanerpes erythrocephalus                           Meleagris gallopavo 
#697                                           419 
# Melopsittacus undulatus                              Mimus gundlachii 
# 2                                             1 
# Mimus polyglottos                              Molothrus aeneus 
# 1649                                             7 
# Molothrus ater                         Molothrus bonariensis 
# 813                                             7 
# Mycteria americana                            Myiarchus crinitus 
# 445                                          1669 
# Myiopsitta monachus                           Nyctanassa violacea 
# 40                                           107 
# Nycticorax / Nyctanassa nycticorax / violacea                         Nycticorax nycticorax 
# 5                                           174 
# Pandion haliaetus                            Parkesia motacilla 
# 736                                             5 
# Passer domesticus                            Passerina caerulea 
# 505                                           645 
# Passerina ciris                              Passerina cyanea 
# 22                                           470 
# Patagioenas leucocephala                        Pelecanus occidentalis 
# 52                                           190 
# Petrochelidon pyrrhonota                            Peucaea aestivalis 
# 19                                           577 
# Phalacrocorax auritus                       Pipilo erythrophthalmus 
# 380                                          1545 
# Piranga rubra                                Platalea ajaja 
# 827                                           100 
# Plegadis falcinellus                           Podilymbus podiceps 
# 324                                            72 
# Poecile carolinensis                           Polioptila caerulea 
# 868                                          1152 
# Porphyrio martinicus                           Porphyrio porphyrio 
# 42                                             1 
# Progne subis                           Protonotaria citrea 
# 982                                           339 
# Quiscalus major                            Quiscalus quiscula 
# 992                                          1438 
# Rallus crepitans                                Rallus elegans 
# 86                                            49 
# Rostrhamus sociabilis                                Rynchops niger 
# 22                                            46 
# Sayornis phoebe                                Scolopax minor 
# 3                                            10 
# Setophaga americana                             Setophaga citrina 
# 1274                                           302 
# Setophaga discolor                            Setophaga dominica 
# 133                                           395 
# Setophaga petechia                               Setophaga pinus 
# 6                                          1264 
# Sialia sialis                            Sitta carolinensis 
# 1106                                            24 
# Sitta pusilla                               Spatula discors 
# 457                                             2 
# Spizella passerina                              Spizella pusilla 
# 3                                            17 
# Stelgidopteryx serripennis                               Sterna forsteri 
# 239                                            25 
# Sterna hirundo                           Sternula antillarum 
# 3                                           157 
# Streptopelia decaocto                      Streptopelia roseogrisea 
# 974                                             3 
# Strix varia                               Sturnella magna 
# 475                                          1003 
# Sturnus vulgaris                              Sula leucogaster 
# 939                                             1 
# Tachycineta bicolor                                      Tern sp. 
# 15                                            25 
# Thalasseus maximus                       Thalasseus sandvicensis 
# 99                                             3 
# Thryothorus ludovicianus                               Toxostoma rufum 
# 1652                                          1149 
# Tringa semipalmata                            Turdus migratorius 
# 88                                             8 
# Tyrannus dominicensis                             Tyrannus tyrannus 
# 91                                           573 
# Tyto alba                              Vireo altiloquus 
# 17                                            82 
# Vireo flavifrons                                 Vireo griseus 
# 655                                          1587 
# Vireo olivaceus                                Woodpecker sp. 
# 744                                             3 
# Zenaida asiatica                              Zenaida macroura 
# 297                                          1704 

summary(fl_bbs$total_sightings)
# Min.   1st Qu.  Median   Mean   3rd Qu.    Max. 
# 1.00    2.00    5.00     14.26   16.00    3166.00 

summary(fl_bbs$TotalSpp)
#  Min.   1st Qu.  Median   Mean  3rd Qu.   Max. 
# 19.00   42.00    48.00   48.13   54.00   79.00 

summary(fl_bbs$mean_annual_precip)
#  Min.   1st Qu.  Median  Mean   3rd Qu.  Max.    NA's 
#  1099    1279    1318    1364    1439    1669    4154

summary(fl_bbs$footprint)
# Min.  1st Qu.  Median  Mean   3rd Qu.  Max.    NA's 
# 0.00  4.00     10.00   12.98   18.00   42.00   541

library(gplots)
library(plotrix)
library(dplyr)

unique(fl_bbs$Year)
length(unique(fl_bbs$Year))
str(fl_bbs)

fl_bbs.1 <- cbind(fl_bbs$Route, fl_bbs$Year, fl_bbs$Scientific_Name, fl_bbs$TotalSpp, fl_bbs$total_sightings)
fl_bbs.1
colnames(fl_bbs.1) <- c("Route", "Year", "Scientific_Name", "TotalSpp", "total_sightings")
class(fl_bbs.1)
fl_bbs.1 <- data.frame(fl_bbs.1)

#I wanted to try to plot how the TotalSpp in 1997 changes over location (Route). So I ran the following code. Note: this did not yield me valuable info bc of the amount of Routes and more specifically bc of the fact that there are a lot of gaps in Route #

bbs_1997 <- fl_bbs.1 %>% filter(Year == 1997)
bbs_1997
class(bbs_1997)
summary(bbs_1997)
class(bbs_1997$Route)
class(bbs_1997$TotalSpp)
bbs_1997$Year <- as.numeric(bbs_1997$Year)
class(bbs_1997$Year)
bbs_1997$TotalSpp <- as.numeric(bbs_1997$TotalSpp)
class(bbs_1997$TotalSpp)
bbs_1997$total_sightings <- as.numeric(bbs_1997$total_sightings)
class(bbs_1997$total_sightings)

plot(bbs_1997$Route, bbs_1997$TotalSpp)


#Figure 1: Scatterplot showing how the TotalSpp in Route 1 changes over time (Year). 
#Note: this showed what seems to be a relative up trend in total spp over time; however 2015 and 2016 had notably less total spp.
#which begs the questions of what happened those years to yield notably less total spp in that Route.

#^ in a paper I would edo this for each route to see if I can spot trends.

#had to start by reshaping the data to only include the Route I cared about (Route 1) 
bbs_r1 <- fl_bbs.1 %>% filter(Route == 1)
bbs_r1
class(bbs_r1)
summary(bbs_r1)
# Route                Year      Scientific_Name       TotalSpp     total_sightings 
#Length:1072        Min.   :1997   Length:1072        Min.   :43.00   Min.   :  1.00  
#Class :character   1st Qu.:2001   Class :character   1st Qu.:63.00   1st Qu.:  2.00  
#Mode  :character   Median :2005   Mode  :character   Median :66.00   Median :  9.00  
#                   Mean   :2005                      Mean   :63.96   Mean   : 26.01  
#                   3rd Qu.:2009                      3rd Qu.:67.00   3rd Qu.: 33.00  
#                   Max.   :2016                      Max.   :71.00   Max.   :219.00 
class(bbs_r1$Route)
class(bbs_r1$TotalSpp)
bbs_r1$Year <- as.numeric(bbs_r1$Year)
class(bbs_r1$Year)
bbs_r1$TotalSpp <- as.numeric(bbs_r1$TotalSpp)
class(bbs_r1$TotalSpp)
bbs_r1$total_sightings <- as.numeric(bbs_r1$total_sightings)
class(bbs_r1$total_sightings)
#Finally the code for the scatterplot
plot(bbs_r1$Year, bbs_r1$TotalSpp)

#Figure 2: Bar Plot looking at the distribution of different orders of birds in Route 1 in 1997. 
#Shows that the Order Passeriformes made up the vast majority of total birds seen at Route 1 in 1997. 
#This makes sense considering Passeriform birds make up the majority of birds on Earth.

#first have to reshape the data so that it only has the collumns of interest.
fl_bbs.2 <- cbind(fl_bbs$Route, fl_bbs$Year, fl_bbs$ORDER, fl_bbs$total_sightings)
fl_bbs.2
colnames(fl_bbs.2) <- c("Route", "Year", "ORDER", "total_sightings")
class(fl_bbs.2)
fl_bbs.2 <- data.frame(fl_bbs.2)

#then have to filter out for only Route 1 and only the Year 1997
bbs_m1997 <- fl_bbs.2 %>% filter(Route == 1, Year == 1997)
bbs_m1997
class(bbs_m1997)
summary(bbs_m1997)
class(bbs_m1997$Route)
class(bbs_m1997$total_sightings)
bbs_m1997$Year <- as.numeric(bbs_m1997$Year)
class(bbs_m1997$Year)
bbs_m1997$total_sightings <- as.numeric(bbs_m1997$total_sightings)
class(bbs_m1997$total_sightings)


#because the rows in the original data set is split up by individual spp at each route at each year, we get a lot of rows for each order that have their own total_sightings values, I chose to group them together since for this figure I just care about the Order distribution
order_totals.f2 <- bbs_m1997 %>% group_by(ORDER) %>% summarise(total_sightings = sum(total_sightings), .groups = "drop")
order_totals.f2

#Now to make the barplot
install.packages("ggplot2")
library(ggplot2)

#Note: I know that this is not the string of code used in Chapter 2 for the barplot, I tried that code and it did not work/gave me errors
#code that did not work (below): gave me the following error: Error: unexpected '=' in "barplot(order_totals.f2, beside = TRUE, + xlab ="
barplot(order_totals.f2, beside = TRUE, + xlab = "Order", ylab = "Total Sightings")

#So I used the following code to yield me my bar graph

ggplot(order_totals.f2, aes(x = reorder(ORDER, -total_sightings), y = total_sightings)) +
  geom_col(fill = "steelblue") +
  geom_text(aes(label = total_sightings), 
            vjust = -0.5,     # To move label slightly above the bar
            size = 3.5) +     # To adjust text size
  labs(title = "Total Bird Sightings by Order (1997)",
       x = "Order",
       y = "Total Sightings") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#Figure 3: Histogram of Temperature Change (EndTemp - StartTemp) in Route 1 from 1997 to 2016.
#This shows the frequency distribution of the change in temperature at Route one over the years. 3 years had a temp change between 0-5 F and 5-10 F, 
#5 years had a temp change of 10-15 F and 2 years had a temp change of 15-20 F. This shows a relatively even distribution of temperature changes on any given year.

bbs.bw <- cbind(fl_bbs$Route, fl_bbs$Year, fl_bbs$TotalSpp, fl_bbs$total_sightings, fl_bbs$StartTemp, fl_bbs$EndTemp, fl_bbs$mean_annual_precip)
colnames(bbs.bw) <- c("Route", "Year", "TotalSpp", "total_sightings", "StartTemp", "EndTemp", "mean_annual_precip")
class(bbs.bw)
bbs.bw <- data.frame(bbs.bw)
class(bbs.bw)

summary(bbs.bw)
bbs.bw$Year <- as.numeric(bbs.bw$Year)
bbs.bw$TotalSpp <- as.numeric(bbs.bw$TotalSpp)
bbs.bw$total_sightings <- as.numeric(bbs.bw$total_sightings)
bbs.bw$StartTemp <- as.numeric(bbs.bw$StartTemp)
bbs.bw$EndTemp <- as.numeric(bbs.bw$EndTemp)
bbs.bw$mean_annual_precip <- as.numeric(bbs.bw$mean_annual_precip)
summary(bbs.bw)

bbs.bwr1 <- bbs.bw %>% filter(Route == 1)
bbs.bwr1
bbs.bwr1$temp_change <- bbs.bwr1$EndTemp - bbs.bwr1$StartTemp
class(bbs.bwr1$temp_change)

summary(bbs.bwr1$temp_change)

install.packages("lattice")
library(lattice)
bwplot(Year ~ temp_change, horizontal = FALSE, data = bbs.bwr1)

unique(bbs.bwr1$temp_change)
bbs.r1tcu <- unique(bbs.bwr1$temp_change)
length(unique(bbs.bwr1$temp_change))
str(bbs.bwr1$temp_change)
mean(bbs.bwr1$temp_change)
sd(bbs.bwr1$temp_change)
summary(bbs.r1tcu)
#Min.  1st Qu.  Median   Mean    3rd Qu   Max. 
#2.00  6.00     11.00    10.38   14.00    20.00 
class(bbs.r1tcu)

#Finally, the code for the histogram figure is below
hist(bbs.r1tcu,
     breaks = 4,           
     col = "skyblue",
     border = "black",
     main = "Histogram of Temperature Change in Route 1 from 1997 to 2016",
     xlab = "Temperature Change (End - Start)")

hist(unique(bbs.bwr1$temp_change), breaks = 6)
#^note both hist() codes above yeild a similar graph.


#Originally I wanted to do a boxplot of temperature change in Route 1, however the code below did not yeild me the figure I was looking for.
#it does however mirror a scatterplot, which although  I already did a scatterplot for Figure 1, i do find this one interesting because it seems to show a trend of high temperature differences from 2005 and earlier
#and lower temperature changes from 2006 and onward. It might be interesting to see what in Route 1 changed over time to potentially yield these results.
#if I had more time I would try to get the summary statistics of those two year brackets (1997-2005 & 2006-2016) and see if there is a statistical difference between the means (most likely a t test)
ggplot(bbs.bwr1, aes(x = factor(Year), y = temp_change)) +
  geom_boxplot(fill = "skyblue") +
  labs(
    title = "Temperature Change per Year on Route 1",
    x = "Year",
    y = "Temperature Change (End - Start)"
  ) +
  theme_minimal()


#----------------- The following codes were just done for my own practice to see how I can reshape the data to tell me different things

bbs_m1 <- fl_bbs.1 %>% filter(Route == 1, Year == 1997)
bbs_m1


bbs_1997_summary <- bbs_1997 %>%
  group_by(Scientific_Name, Route) %>%
  summarise(total_sightings = sum(total_sightings), .groups = "drop")


#the code blow with hash tags in front of it yielding a bar graph that looked at bird sightings for each spp at each route specifically in 1997. 
#The graph is way too cluttered to be viable, but I am keeping the code here in case I want to modify it in the future. so do not count this code as one of my figures 
#(especially considering I did a bar graph already for figure 2)

#ggplot(bbs_1997_summary, aes(x = Scientific_Name, y = total_sightings, fill = as.factor(Route))) +
#  geom_col(position = "dodge") +
#  labs(
#    title = "Bird Sightings by Species and Route (1997)",
#    x = "Scientific_Name",
#    y = "total_sightings",
#    fill = "Route"
#  ) +
#  theme_minimal() +
#  theme(
#    axis.text.x = element_text(angle = 45, hjust = 1))
