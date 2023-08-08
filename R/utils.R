
# global variables --------------------------------------------------------

utils::globalVariables()

# set column order --------------------------------------------------------

matchCols <- function(df, cols)
  colnames(df)[match(cols, colnames(df), 0L)]

setStatListColOrder <- function(df) {
  .statListCols <- c(
    "VW_CD", "VW_NM", "LIST_ID", "LIST_NM",
    "ORG_ID", "TBL_ID", "TBL_NM", "STAT_ID",
    "SEND_DE", "REC_TBL_SE"
  )
  cols <- matchCols(df, .statListCols)
  return(df[, cols, drop = FALSE])
}

setStatDataColOrder <- function(df) {
  .statDataCols <- c(
    "ORG_ID",
    "TBL_ID", "TBL_NM",
    "C1", "C1_NM", "C1_OBJ_NM",
    "C2", "C2_NM", "C2_OBJ_NM",
    "C3", "C3_NM", "C3_OBJ_NM",
    "C4", "C4_NM", "C4_OBJ_NM",
    "C5", "C5_NM", "C5_OBJ_NM",
    "C6", "C6_NM", "C6_OBJ_NM",
    "C7", "C7_NM", "C7_OBJ_NM",
    "C8", "C8_NM", "C8_OBJ_NM",
    "ITM_ID", "ITM_NM", "ITM_NM_ENG",
    "UNIT_ID", "UNIT_NM", "UNIT_NM_ENG",
    "PRD_SE", "PRD_DE",
    "DT"
  )
  cols <- matchCols(df, .statDataCols)
  return(df[, cols, drop = FALSE])
}

setStatExplColOrder <- function(df) {
  .statExplCols <- c(
    "statsNm", "statsKind", "statsContinue",
    "basisLaw", "writingPurps", "statsPeriod",
    "writingSystem", "writingTel", "statsField",
    "examinObjrange", "examinObjArea",
    "josaUnit", "applyGroup", "josaItm",
    "pubPeriod", "pubExtent", "publictMth",
    "examinTrgetPd", "dataUserNote", "mainTermExpl",
    "dataCollectMth", "examinHistory",
    "confmNo", "confmDt", "statsEnd"
  )
  cols <- matchCols(df, .statExplCols)
  return(df[, cols, drop = FALSE])
}

setStatMetaColOrder <- function(df, type =  c("TBL", "ORG", "PRD", "ITM", "CMMT", "UNIT", "SOURCE", "WGT", "NCD")) {
  .statMetaCols <- list(
    TBL = c("TBL_NM", "TBL_NM_ENG"),
    ORG = c("ORG_NM", "ORG_NM_ENG"),
    PRD = c("PRD_SE", "PRD_DE"),
    ITM = c("OBJ_ID", "OBJ_NM", "OBJ_NM_ENG",
            "ITM_ID", "ITM_NM", "ITM_NM_ENG",
            "UP_ITM_ID", "OBJ_ID_SN",
            "UNIT_ID", "UNIT_NM", "UNIT_ENG_NM"),
    CMMT = c("CMMT_NM", "CMMT_DC", "OBJ_ID", "OBJ_NM", "ITM_ID", "ITM_NM"),
    UNIT = c("UNIT_NM", "UNIT_NM_ENG"),
    SOURCE = c("JOSA_NM", "DEPT_NM", "DEPT_PHONE", "STAT_ID"),
    WGT = c("C1", "C1_NM", "C1_OBJ_NM",
            "C2", "C2_NM", "C2_OBJ_NM",
            "C3", "C3_NM", "C3_OBJ_NM",
            "C4", "C4_NM", "C4_OBJ_NM",
            "C5", "C5_NM", "C5_OBJ_NM",
            "C6", "C6_NM", "C6_OBJ_NM",
            "C7", "C7_NM", "C7_OBJ_NM",
            "C8", "C8_NM", "C8_OBJ_NM",
            "ITM_ID", "ITM_NM", "WGT_CO"),
    NCD = c("ORG_NM", "TBL_NM", "PRD_SE", "PRD_DE", "SEND_DE")
  )
  cols <- matchCols(df, .statMetaCols[[type]])
  return(df[, cols, drop = FALSE])
}

setStatSearchColOrder <- function(df) {
  .statSearchCols <- c(
    "ORG_ID", "ORG_NM",
    "TBL_ID", "TBL_NM",
    "STAT_ID", "STAT_NM",
    "VW_CD", "MT_ATITLE",
    "FULL_PATH_ID", "CONTENTS",
    "STRT_PRD_DE", "END_PRD_DE",
    "ITEM03", "REC_TBL_SE",
    "TBL_VIEW_URL", "LINK_URL",
    "STAT_DB_CNT", "QUERY"
  )
  cols <- matchCols(df, .statSearchCols)
  return(df[, cols, drop = FALSE])
}


pullCode <- function(code, x, ignore.case = TRUE) {
  r <- regexpr(code, x, ignore.case = ignore.case, perl = TRUE)
  z <- rep(NA, length(x))
  z[r != -1] <- regmatches(x, r)
  return(z)
}

getParam <- function(url) {
  config <- strsplit(url, split = "\\?|&")[[1L]]
  baseurl <- config[1L]
  param <- config[-1L]
  names <- pullCode("[0-9a-zA-Z_]+", param)
  values <- gsub("^=", "", pullCode("=[0-9a-zA-Z+=_]+", param), perl = TRUE)
  param <- as.list(values)
  names(param) <- names
  param$apiKey <- ""
  param <- param[!is.na(param)]
  attr(param, "baseurl") <- baseurl
  param
}

setURL <- function(param) {
  if (param$apiKey == "")
    param$apiKey <- kosis.getKey()
  names <- names(param)
  values <- unname(unlist(param))
  paramurl <- paste0(names, "=", values, collapse = "&")
  baseurl <- attr(param, "baseurl")
  url <- paste0(baseurl, "?", paramurl)
  return(url)
}

# cast stat data ----------------------------------------------------------

checkNum <- function(x) all(grepl("^[0-9.,]+$|^-[0-9.,]+|^-$", x))

guessNumCols <- function(df) names(df[complete.cases(df),])[sapply(df[complete.cases(df),], checkNum) == TRUE]

setCharToNumCols <- function(df, exceptCols) {
  cols <- guessNumCols(df)
  if (!missing(exceptCols))
    cols <- cols[!cols %in% exceptCols]
  if (is.null(cols))
    return(df)
  if (!data.table::is.data.table(df)) {
    df[, cols] <- lapply(df[, cols, drop = FALSE],
                         function(x) as.numeric(gsub("^-$", "", x)))
    return(df)
  }
  df[, (cols) := lapply(.SD, function(x) as.numeric(gsub("^-$", "", x))),
     .SDcols = cols]
  return(df[])
}

##' Cast Item variable from the stat data downloaded from getStatData function
##'
##' @details
##' \preformatted{
##' ## Example
##' statData <- getStatData(orgId = "101", tblId = "DT_1B41", objL1 = "ALL")
##' castItem(statData = statData, itemVar = "ITM_NM")
##' }
##'
##' @param statData A data.frame downloaded from getStatData function
##' @param itemVar A string specifying item variable
##' @return A data.frame object containing queried information
##' @export
castItem <- function(statData, itemVar = c("ITM_NM", "ITM_ID", "ITM_NM_ENG")) {
  itemVar <- match.arg(itemVar)
  statDataSplit <- split(statData, statData[[itemVar]])
  statDataSplit <- lapply(statDataSplit, function(x)
    setNames(x, c(names(x)[which(names(x) != "DT")], x[[itemVar]][1L])))
  exceptCols <- c("ITM_ID", "ITM_NM", "ITM_NM_ENG", "UNIT_ID", "UNIT_NM", "UNIT_NM_ENG")
  if (data.table::is.data.table(statData)) {
    statDataSplit <- lapply(statDataSplit, function(x) {
      cols <- names(x)[!names(x) %in% exceptCols]
      x[, .SD, .SDcols = cols]
    })
  } else {
    statDataSplit <- lapply(statDataSplit, function(x) {
      cols <- names(x)[!names(x) %in% exceptCols]
      x[, cols, drop = FALSE]
    })
  }
  by <- matchCols(statData, c(
    "ORG_ID", "TBL_ID", "TBL_NM",
    "C1", "C1_NM", "C1_OBJ_NM",
    "C2", "C2_NM", "C2_OBJ_NM",
    "C3", "C3_NM", "C3_OBJ_NM",
    "C4", "C4_NM", "C4_OBJ_NM",
    "C5", "C5_NM", "C5_OBJ_NM",
    "C6", "C6_NM", "C6_OBJ_NM",
    "C7", "C7_NM", "C7_OBJ_NM",
    "C8", "C8_NM", "C8_OBJ_NM",
    "PRD_DE", "PRD_SE"
  ))
  statDataItem <- Reduce(
    function(...) merge(..., by = by, all = TRUE, sort = TRUE), statDataSplit
  )
  if (tibble::is_tibble(statData))
    statDataItem <- tibble::as_tibble(statDataItem)
  return(setCharToNumCols(statDataItem, exceptCols = "PRD_DE"))
}

# checkGroupUnique <- function(data, colSuffix = c("_NM", "_NM_ENG", "")) {
#   colSuffix <- match.arg(colSuffix)
#   .statDataCols <- c(
#     "ORG_ID", "TBL_ID", "TBL_NM",
#     paste0(c("C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8"), colSuffix),
#     if (colSuffix == "") "ITM_ID" else paste0("ITM", colSuffix),
#     "PRD_DE"
#   )
#   cols <- matchCols(data, .statDataCols)
#   if (data.table::is.data.table(data)) {
#     ndata <- data[, list(n = .N), keyby = cols]
#   } else {
#     ndata <- data %>% group_by_at(.vars = cols) %>%
#       summarise(n = n(), .groups = "drop")
#     if (!is_tibble(data))
#       ndata <- as.data.frame(ndata)
#   }
#   check <- all(ndata$n == 1)
#   cat("all group variables are unique:", check, "\n")
#   invisible(ndata)
# }

# setParamTable <- function(param) {
#   param_table <- data.frame(param)
#   param_table$objL3 <- ""
#   param_table$objL4 <- ""
#   param_table$objL5 <- ""
#   param_table$objL6 <- ""
#   param_table$objL7 <- ""
#   param_table$objL8 <- ""
#   param_table$startPrdDe <- ""
#   param_table$endPrdDe   <- ""
#   param_table[, c("method", "apiKey", "orgId", "tblId", "objL1", "objL2", "objL3", "objL4", "objL5", "objL6", "objL7", "objL8", "itmId", "prdSe", "startPrdDe", "endPrdDe", "newEstPrdCnt", "prdInterval", "format", "jsonVD", "outputFields")]
# }
