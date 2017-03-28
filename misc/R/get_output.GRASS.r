#---------------------------------------------------------------------------------------------------
# Name:         get_ouput.GRASS()
# Description:  Import console outputs of GRASS GIS into a R data.frame
# separator:    Separator separating variables in grass output
# h:            Setting h to FALSE indicates no header (default)
#---------------------------------------------------------------------------------------------------

get_output.GRASS <- function(x, separator=",", h=FALSE){
      con <- textConnection(x)
      MyVar <- read.table(con, header=h, sep=separator, comment.char="")
      close(con)
      return(MyVar)
}
