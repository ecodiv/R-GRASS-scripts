\name{sdm.formulae}
\alias{sdm.formulae}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Suggest formulae for species distribution models
}
\description{
Function ensemble.formulae provides suggestions for formulae that can be used for ensemble.test and ensemble.raster. This is the function ensemble.formulae from BiodiversityR, with a small change to allow to define the polynomial degree of the glm formulae
}
\usage{
sdm.formulae(vars, factors = NULL, dummy.vars = NULL, poly = 3)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{vars}{
vector with variable names
}
  \item{factors}{
vector that indicates which variables are factors. These variables need to be included in the vars vector too.
}
  \item{dummy.vars}{
vector that indicates which variables are dummy variables, These variables need to be included in the vars vector too.
}
  \item{poly}{
number of polynomials in glm formulae
}
}
\details{
This function is a slightly adapted version from the ensemble.formulae function in the biodiversityR package. The difference is that you can set the number of polynomials for the glm and glm-step function and as input you need  a vector with layer (Variable) names rather than a raster stack
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
Roeland Kindt, with adaptations by Paulo van Breugel
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
test <- sdm.formulae(c("var1","var2"), poly=2)
test
}
