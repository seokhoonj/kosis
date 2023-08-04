##' KOSIS Statistic Explanation
##'
##' @details
##' \preformatted{
##' ## Example
##' getStatExpl(orgId = "101", tblId = "DT_1L9V054")
##' getStatExpl(statId = "1962009")
##' }
##'
##' @param orgId A string specifying the organization id
##' @param tblId A string specifying the table id
##' @param statId A string specifying the stat id
##' @param metaItm A string specifying the meta item
##' @return A data.frame object containing queried information
##' @export
getStatExpl <- function(orgId, tblId, statId, metaItm = "ALL") {
  apiKey <- kosis.getKey()
  if (missing(statId)) {
    param <- list(
      method = "getList",
      apiKey = apiKey,
      orgId = orgId,
      tblId = tblId,
      format = "json",
      jsonVD = "Y",
      jsonMVD = "Y",
      metaItm = metaItm
    )
  } else {
    param <- list(
      method = "getList",
      apiKey = apiKey,
      statId = statId,
      format = "json",
      jsonVD = "Y",
      jsonMVD = "Y",
      metaItm = metaItm
    )
  }
  baseurl <- "https://kosis.kr/openapi/statisticsExplData.do"
  attr(param, "baseurl") <- baseurl
  url <- setURL(param)
  page <- httr::GET(url)
  content <- httr::content(x = page, as = "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content)
  if (!is.null(data$err))
    return(data)
  statExpl <- setStatExplColOrder(data)
  return(statExpl)
}

