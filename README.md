# bnschg

Ecological Species Evaluation According to § 30 BNatSchG / Art. 23 BayNatSchG

##	Description

The identification key for protected areas according to § 30 BNatSchG / Art. 23 BayNatSchG serves as a tool for the identification of legally protected biotopes in Germany, including the Free State of Bavaria ([cp. Bayerisches Landesamt für Umwelt](https://www.lfu.bayern.de/natur/doc/kartieranleitungen/bestimmungsschluessel_30.pdf)). The identification key provides detailed criteria for the recognition of protected areas. It categorises different biotope types on the basis of specific site conditions and vegetation characteristics (lists of typical species). The BayNatSchG adds additional biotope types such as orchard meadows or species-rich grasslands. This package builds on the vegsoup package and provides tools to automatically categorise vegetation plot data of grassland types (tables 34, 35 , and 36).


## Installation
------------

You may directly install the package from GitHub using the below set of commands.

```R
# if not already installed
install.packages("devtools")
library(devtools)

devtools::install_github("rforge/vegsoup/pkg")

devtools::install_github("kardinal-eros/bnschg")
```
<!--
Maintenance
setwd("/Users/roli/Documents/bnschg")
devtools::document()
devtools::load_all()
-->
