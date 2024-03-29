% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/downloadablePlot.R
\name{downloadablePlot}
\alias{downloadablePlot}
\title{downloadablePlot Module}
\usage{
downloadablePlot(
  ...,
  logger,
  filenameroot,
  aspectratio = 1,
  downloadfxns = list(),
  visibleplot
)
}
\arguments{
\item{...}{free parameters list for shiny to pass session variables based on the module call(session, input, output)
variables. \emph{Note}: The first argument of this function must be the ID of the Module's UI element}

\item{logger}{logger to use}

\item{filenameroot}{the base text used for user-downloaded file - can be
either a character string or a reactive expression returning a character
string}

\item{aspectratio}{the downloaded chart image width:height ratio (ex:
1 = square, 1.3 = 4:3, 0.5 = 1:2).  Where not applicable for a download type
it is ignored (e.g. data, html downloads)}

\item{downloadfxns}{a \strong{named} list of functions providing download
images or data tables as return values.  The names for the list should be
the same names that were used when the plot UI was created.}

\item{visibleplot}{function or reactive expression providing the plot to
display as a return value.  This function should require no input parameters.}
}
\description{
Server-side function for the downloadablePlotUI.  This is a custom
plot output paired with a linked downloadFile button.
}
\section{Notes}{

When there are no values to download in any of the linked downloadfxns the
button will be hidden as there is nothing to download.
}

\section{Shiny Usage}{

This function is not called directly by consumers - it is accessed in
server.R using the same id provided in \code{downloadablePlotUI}:

\strong{\code{downloadablePlot(id, logger, filenameroot,
downloadfxns, visibleplot)}}
}

\examples{
# Inside server_local.R

# downloadablePlot("object_id1", 
#                  logger = ss_userAction.Log,
#                  filenameroot = "mydownload1",
#                  aspectratio = 1.33,
#                  downloadfxns = list(png = myplotfxn, tsv = mydatafxn),
#                  visibleplot = myplotfxn)

}
\seealso{
\link[periscope]{downloadablePlotUI}
}
