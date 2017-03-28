\name{readATTRIBUTE}
\alias{readATTRIBUTE}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Import GRASS vector attribute table
}
\description{
Import the attribute table of a GRASS vector layer in R. Only works with dbf or  SQLite as database backend
}
\usage{
readATTRIBUTE(vect, columns = "all", layer = 1)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{vect}{
Vector from which to read the attribute table
}
  \item{columns}{
which columns to read (default is "all")
}
  \item{layer}{
Which layer to read (see GRASS documentation for an explanation of the layer concept. The default is 1, which should in most cases be OK)
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
