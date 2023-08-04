##' KOSIS Statistic Data
##'
##' @details
##' \preformatted{
##' ## Example
##' getStatData(orgId = "101", tblId = "DT_1B41")
##' }
##'
##' @param orgId A string specifying the organization id
##' @param tblId A string specifying the table id
##' @param prdSe A string specifying the period symbol (Y, H, Q, M, D, IR: Irregularly)
##' @param startPrdDe A string specifying start period
##' (format: YYYY, YYYYMM(MM:01~12), YYYYHH(HH:01,02), YYYYQQ(QQ:01~04), YYYYMMDD)
##' @param endPrdDe A string specifying end period
##' (format: YYYY, YYYYMM(MM:01~12), YYYYHH(HH:01,02), YYYYQQ(QQ:01~04), YYYYMMDD)
##' @param newEstPrdCnt A string specifying newest period count
##' @param prdInterval A string specifying period interval
##' @param itmId A string item id
##' @param objL1 A string specifying object level 1
##' @param objL2 A string specifying object level 2
##' @param objL3 A string specifying object level 3
##' @param objL4 A string specifying object level 4
##' @param ... A string specifying object level 5, 6, 7, 8 (objL5, objL6, objL7, objL8)
##' @return A data.frame object containing queried information
##' @export
getStatData <- function(orgId, tblId,
                        prdSe = c("Y", "H", "Q", "M", "D", "IR"),
                        startPrdDe, endPrdDe, newEstPrdCnt = 3,
                        prdInterval = 1, itmId = "ALL",
                        objL1 = "ALL", objL2 = "", objL3 = "", objL4 = "",
                        ...) {
  apiKey <- kosis.getKey()
  prdSe <- match.arg(prdSe)
  if (missing(startPrdDe)) {
    param <- list(
      method = "getList",
      apiKey = apiKey,
      format = "json",
      jsonVD = "Y",
      prdSe = prdSe,
      newEstPrdCnt = newEstPrdCnt,
      prdInterval = prdInterval,
      orgId = orgId,
      tblId = tblId,
      itmId = itmId,
      objL1 = objL1,
      objL2 = objL2,
      objL3 = objL3,
      objL4 = objL4,
      ...
    )
  } else {
    param <- list(
      method = "getList",
      apiKey = apiKey,
      format = "json",
      jsonVD = "Y",
      prdSe = prdSe,
      startPrdDe = startPrdDe,
      endPrdDe = endPrdDe,
      orgId = orgId,
      tblId = tblId,
      itmId = itmId,
      objL1 = objL1,
      objL2 = objL2,
      objL3 = objL3,
      objL4 = objL4,
      ...
    )
  }
  baseurl <- "https://kosis.kr/openapi/Param/statisticsParameterData.do"
  attr(param, "baseurl") <- baseurl
  url <- setURL(param)
  page <- httr::GET(url)
  content <- httr::content(x = page, as = "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content)
  if (!is.null(data$err))
    return(data)
  statData <- setStatDataColOrder(data)
  return(statData)
}

##' KOSIS Statistic Data from URL
##'
##' @details
##' \preformatted{
##' ## Example
##' url <- "https://kosis.kr/openapi/Param/statisticsParameterData.do?
##' method=getList&apiKey=&
##' itmId=T6+T16+T26+T5+T15+T25+T2+T12+T22+T3+T13+T23+T4+T14+T24+T1+T11+T21+&
##' objL1=ALL&objL2=&objL3=&objL4=&objL5=&objL6=&objL7=&objL8=&
##' format=json&jsonVD=Y&
##' prdSe=Y&newEstPrdCnt=3&prdInterval=1&
##' orgId=101&tblId=DT_1B41"
##' getStatDataFromURL(url = url)
##' }
##'
##' @param url A string specifying the KOSIS URL
##' @return A data.frame object containing queried information
##' @export
getStatDataFromURL <- function(url) {
  apiKey <- kosis.getKey()
  param <- getParam(url)
  url <- setURL(param)
  page <- httr::GET(url)
  content <- httr::content(x = page, as = "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content)
  if (!is.null(data$err))
    return(data)
  statData <- setStatDataColOrder(data)
  return(statData)
}
