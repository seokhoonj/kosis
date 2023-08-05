##' KOSIS Statistic List
##'
##' @details
##' \preformatted{
##' ## Example
##' getStatList(vwCd = "MT_ZTITLE", parentListId = "")
##' getStatList(vwCd = "MT_ZTITLE", parentListId = "F")
##' getStatList(vwCd = "MT_ZTITLE", parentListId = "F_29")
##' }
##'
##' @param vwCd A string specifying the view code
##' @param parentListId A string specifying the parent list id
##' @return A data.frame object containing queried information
##' @export
getStatList <- function(vwCd = "MT_ZTITLE", parentListId = "") {
  apiKey <- kosis.getKey()
  param <- list(
    method = "getList",
    apiKey = apiKey,
    format = "json",
    vwCd = vwCd,
    parentListId = parentListId,
    jsonVD = "Y"
  )
  baseurl <- "https://kosis.kr/openapi/statisticsList.do"
  attr(param, "baseurl") <- baseurl
  url <- setURL(param)
  page <- httr::GET(url)
  data <- jsonlite::fromJSON(content(x = page, as = "text", encoding = "UTF-8"))
  if (!is.null(data$err))
    return(data)
  statList <- setStatListColOrder(data)
  return(statList)
}
