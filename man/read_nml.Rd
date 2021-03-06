% Generated by roxygen2 (4.0.2): do not edit by hand
\name{read_nml}
\alias{read_nml}
\title{read in a GLM simulation *.nml file}
\usage{
read_nml(file = "template")
}
\arguments{
\item{file}{a string with the path to the GLM glm.nml file, or
\code{'template'} for loading the GLM template nml file with GLMr (default)}
}
\value{
glm_nml a nml (a list) for GLM config
}
\description{
read in a GLM simulation *.nml file and create a list.  \cr
}
\examples{
glm_nml <- read_nml()
print(glm_nml)
}
\author{
Jordan S. Read
}
\seealso{
\link{get_nml_value}
}
\keyword{methods}

