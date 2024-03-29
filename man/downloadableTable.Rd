% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/downloadableTable.R
\name{downloadableTable}
\alias{downloadableTable}
\title{downloadableTable Module}
\usage{
downloadableTable(
  ...,
  logger,
  filenameroot,
  downloaddatafxns = list(),
  tabledata,
  selection = NULL
)
}
\arguments{
\item{...}{free parameters list to pass table customization options. See example below.
\emph{Note}: The first argument of this function must be the ID of the Module's UI element}

\item{logger}{logger to use}

\item{filenameroot}{the base text used for user-downloaded file - can be
either a character string or a reactive expression returning a character
string}

\item{downloaddatafxns}{a \strong{named} list of functions providing the data as
return values.  The names for the list should be the same names that were used
when the table UI was created.}

\item{tabledata}{function or reactive expression providing the table display
data as a return value. This function should require no input parameters.}

\item{selection}{function or reactive expression providing the row_ids of the
rows that should be selected}
}
\value{
Reactive expression containing the currently selected rows in the
display table
}
\description{
Server-side function for the downloadableTableUI.  This is a custom
high-functionality table paired with a linked downloadFile
button.
}
\details{
Generated table can highly customized using function \code{?DT::datatable} same arguments
 except for `options` and `selection` parameters. 
 
For `options` user can pass the same \code{?DT::datatable} options using the same names and 
values one by one separated by comma.
 
For `selection` parameter it can be either a function or reactive expression providing the row_ids of the
rows that should be selected.

Also, user can apply the same provided \code{?DT::formatCurrency} columns formats on passed
dataset using format functions names as keys and their options as a list.
}
\section{Notes}{

 \itemize{
  \item When there are no rows to download in any of the linked downloaddatafxns 
  the button will be hidden as there is nothing to download.
  \item \code{selection} parameter has different usage than DT::datatable \code{selection} option. 
  See parameters usage section.
  \item DT::datatable options \code{editable}, \code{width} and \code{height} are not supported
}
}

\section{Shiny Usage}{

This function is not called directly by consumers - it is accessed in
server.R using the same id provided in \code{downloadableTableUI}:

\strong{\code{downloadableTable(id, logger, filenameroot,
downloaddatafxns, tabledata, rownames, caption, selection)}}

\emph{Note}: calling module server returns the reactive expression containing the
currently selected rows in the display table.
}

\examples{
# Inside server_local.R

# selectedrows <- downloadableTable(
#     "object_id1", 
#     logger = ss_userAction.Log,
#     filenameroot = "mydownload1",
#     downloaddatafxns = list(csv = mydatafxn1, tsv = mydatafxn2),
#     tabledata = mydatafxn3,
#     rownames = FALSE,
#     caption = "This is a great table!  By: Me",
#     selection = mydataRowIds,
#     colnames = c("Area", "Delta", "Increase"),
#     filter = "bottom",
#     width = "150px",
#     height = "50px",
#     extensions = 'Buttons',
#     plugins = 'natural',
#     editable = TRUE, 
#     dom = 'Bfrtip', 
#     buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
#     formatStyle = list(columns = c('Area'),  color = 'red'),
#     formatStyle = list(columns = c('Increase'), color = DT::styleInterval(0, c('red', 'green'))), 
#     formatCurrency = list(columns = c('Delta')))

# selectedrows is the reactive return value, captured for later use

}
\seealso{
\link[periscope]{downloadableTableUI}
}
