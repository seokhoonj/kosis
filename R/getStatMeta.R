##' KOSIS Statistic Meta
##'
##' @details
##' \preformatted{
##' ## Example
##' getStatMeta(orgId = "101", tblId = "DT_1IN0001")
##' getStatMeta(orgId = "101", tblId = "DT_1IN0001", type = "ORG")
##' }
##'
##' @param orgId A string specifying the organization id
##' @param tblId A string specifying the table id
##' @param type A string specifying the meta type
##' @return A data.frame object containing queried information
##' @export
getStatMeta <- function(orgId, tblId, type = c("TBL", "ORG", "PRD", "ITM", "CMMT", "UNIT", "SOURCE", "WGT", "NCD")) {
  apiKey <- kosis.getKey()
  type <- match.arg(type)
  param <- list(
    method = "getMeta",
    apiKey = apiKey,
    format = "json",
    type = type,
    orgId = orgId,
    tblId = tblId,
    jsonVD = "Y"
  )
  baseurl <- "https://kosis.kr/openapi/statisticsData.do"
  attr(param, "baseurl") <- baseurl
  url <- setURL(param)
  page <- httr::GET(url)
  content <- httr::content(x = page, as = "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content)
  if (!is.null(data$err))
    return(data)
  statMeta <- setStatMetaColOrder(data, type = type)
  return(statMeta)
}
