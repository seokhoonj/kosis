## kosis package

<!-- badges: start -->

[![R-CMD-check](https://github.com/seokhoonj/kosis/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/seokhoonj/kosis/actions/workflows/R-CMD-check.yaml) [![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/kosis)](https://cran.r-project.org/package=kosis)

<!-- badges: end -->

## Introduction

Korean Statistical Information Service (KOSIS Open API Service)\
(<https://kosis.kr/openapi/index/index.jsp>)

## Installation

``` r
# install dev version
devtools::install_github("seokhoonj/kosis")  
```

## Example

``` r
library(kosis)

# set your api key
kosis.setKey(api_key = "your_api_key")

# or permantly
usethis::edit_r_environ() # add KOSIS_API_KEY=YOUR API KEY in .Renviron

# get stat list
getStatList(vwCd = "MT_ZTITLE", parentListId = "F_29")

# get stat data (Actuarial Life Table)
data <- getStatData(orgId = "101", tblId = "DT_1B41", objL1 = "ALL")
life_table <- castItem(statData = data, itemVar = "ITM_NM")

# or get stat data from URL (recommeded by KOSIS)
url <- "https://kosis.kr/openapi/Param/statisticsParameterData.do?method=getList&apiKey=&itmId=T6+T16+T26+T5+T15+T25+T2+T12+T22+T3+T13+T23+T4+T14+T24+T1+T11+T21+&objL1=ALL&objL2=&objL3=&objL4=&objL5=&objL6=&objL7=&objL8=&format=json&jsonVD=Y&prdSe=Y&newEstPrdCnt=3&prdInterval=1&orgId=101&tblId=DT_1B41"
data <- getStatDataFromURL(url)
life_table <- castItem(statData = data, itemVar = "ITM_NM")
```
