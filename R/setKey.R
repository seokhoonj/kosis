##' Set KOSIS API Key
##'
##' @description
##' Save KOSIS API key for the current session. To set it permanently, please add
##' the following line to your .Renvrion file:
##'
##' KOSIS_API_KEY = "YOUR API KEY"
##'
##' @param apiKey A string specifying KOSIS API key
##' @return No return value, called to set api key
##' @examples
##'
##' ## Set API Key for the current session
##' \donttest{kosis.setKey("your_api_key")}
##'
##' ## Check API key
##' kosis.printKey()
##'
##' @export
kosis.setKey <- function(apiKey) {
  Sys.setenv(KOSIS_API_KEY = apiKey)
}

##' @export
##' @rdname kosis.setKey
kosis.printKey <- function() {
  Sys.getenv("KOSIS_API_KEY")
}

kosis.getKey <- function() {
  apiKey <- Sys.getenv("KOSIS_API_KEY")
  if (apiKey == "") {
    stop("Please run this code to provide your KOSIS API Key: kosis.setKey('your_api_key').", call. = FALSE)
  }
  return(apiKey)
}
