\name{get_output.GRASS}
\alias{get_output.GRASS}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
GRASS GIS consule output to R
}
\description{
Get console outputs of GRASS GIS into a R data.frame. 
}
\usage{
get_output.GRASS(x, separator = ",", h = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
  object with output of a GRASS function (obtained via execGRASS(function, intern=TRUE))
}
  \item{separator}{
  Separator separating variables in grass output
}
  \item{h}{
  Setting h to FALSE indicates no header (default)
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Paulo van Breugel
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{

}
