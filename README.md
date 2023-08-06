# kosis package

<!-- badges: start -->

[![R-CMD-check](https://github.com/seokhoonj/kosis/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/seokhoonj/kosis/actions/workflows/R-CMD-check.yaml) [![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/kosis)](https://cran.r-project.org/package=kosis)

<!-- badges: end -->

## Introduction

Korean Statistical Information Service (KOSIS Open API Service)\
(<https://kosis.kr/openapi/index/index.jsp>)

| Service View Code | Service View Name        |
|:------------------|:-------------------------|
| MT_ZTITLE         | 국내통계 주제별          |
| MT_OTITLE         | 국내통계 기관별          |
| MT_GTITLE01       | e-지방지표(주제별)       |
| MT_GTITLE02       | e-지방지표(지역별)       |
| MT_CHOSUN_TITLE   | 광복이전통계(1908\~1943) |
| MT_HANKUK_TITLE   | 대한민국통계연감         |
| MT_STOP_TITLE     | 작성중지통계             |
| MT_RTITLE         | 국제통계                 |
| MT_BUKHAN         | 북한통계                 |
| MT_TM1_TITLE      | 대상별통계               |
| MT_TM2_TITLE      | 이슈별통계               |
| MT_ETITLE         | 영문 KOSIS               |

## Installation

``` r
# install dev version
devtools::install_github("seokhoonj/kosis")  
```

## Example

``` r
library(kosis)

# set your api key
kosis.setKey(apiKey = "your_api_key")

# or permantly
usethis::edit_r_environ() # add KOSIS_API_KEY="your_api_key" in .Renviron

# get stat list
getStatList(vwCd = "MT_ZTITLE")
getStatList(vwCd = "MT_ZTITLE", parentListId = "F_29") # life tables

# get stat data (Actuarial Life Table)
data <- getStatData(orgId = "101", tblId = "DT_1B41", objL1 = "ALL")
life_table <- castItem(statData = data, itemVar = "ITM_NM")

# or get stat data from URL (recommeded by KOSIS)
browseKosis() # open a webpage where you can find the url to download the data
url <- "https://kosis.kr/openapi/Param/statisticsParameterData.do?method=getList&apiKey=&itmId=T6+T16+T26+T5+T15+T25+T2+T12+T22+T3+T13+T23+T4+T14+T24+T1+T11+T21+&objL1=ALL&objL2=&objL3=&objL4=&objL5=&objL6=&objL7=&objL8=&format=json&jsonVD=Y&prdSe=Y&newEstPrdCnt=3&prdInterval=1&orgId=101&tblId=DT_1B41"
data <- getStatDataFromURL(url)
life_table <- castItem(statData = data, itemVar = "ITM_NM")
```

## Error

``` r
# The method using orgId and tblId is relatively easy but not recommended by KOSIS
# Need to manage some errors to use this method.

# default arguments: objL1 = "ALL", objL2 = "", objL3 = "", objL4 = "", ...
getStatData(orgId = "117", tblId = "DT_117N_A00124")
# If the error code is 20, change the objL2 variable
getStatData(orgId = "117", tblId = "DT_117N_A00124", objL2 = "ALL")
# If the error code is 20 again, change the objL3 variable
getStatData(orgId = "117", tblId = "DT_117N_A00124", objL2 = "ALL", objL3 = "ALL")
```
