##' @details
##'
##' To use this package, you will first need to get your API key from the
##' website \url{https://kosis.kr/openapi/index/index.jsp}. Once you have your
##' key, you can save it as an environment variable for the current session
##' using the \code{\link{kosis.setKey}} function. Alternatively, you can set it
##' permanently by adding the following line to your .Renviron file:
##'
##' KOSIS_API_KEY = PASTE YOUR API KEY
##'
##' Any functions that require your API key try to retrieve it via
##' \code{Sys.getenv("KOSIS_API_KEY")} (unless API key is explicitly specified as
##' a function argument).
##'
##' @importFrom data.table .SD `:=` is.data.table
##' @importFrom httr content GET
##' @importFrom jsonlite fromJSON
##' @importFrom stats complete.cases setNames
##' @importFrom tibble as_tibble is_tibble
##' @importFrom utils browseURL head tail
"_PACKAGE"
