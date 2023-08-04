##' KOSIS Statistic Search
##'
##' @details
##' \preformatted{
##' ## Example
##' getStatSearch(searchNm = "CPI")
##' }
##'
##' @param searchNm A string specifying a name you search
##' @param startCount A nuemeric specifying a page number
##' @param resultCount A numeric specifying counts of result
##' (resultCount = 20, startCount = 2 : 21~40 Result)
##' @param sort A string specifying the sorting (RANK: accuracy, DATE: newest)
##' @return A data.frame object containing queried information
##' @export
getStatSearch <- function(searchNm, startCount = 1, resultCount = 20, sort = c("RANK", "DATE")) {
  apiKey <- kosis.getKey()
  param <- list(
    method = "getList",
    apiKey = apiKey,
    format = "json",
    jsonVD = "Y",
    searchNm = searchNm,
    startCount = startCount,
    resultCount = resultCount,
    sort = sort
  )
  baseurl <- "https://kosis.kr/openapi/statisticsSearch.do"
  attr(param, "baseurl") <- baseurl
  url <- setURL(param)
  page <- httr::GET(url)
  content <- httr::content(x = page, as = "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content)
  if (!is.null(data$err))
    return(data)
  statSearch <- setStatSearchColOrder(data)
  return(statSearch)
}
