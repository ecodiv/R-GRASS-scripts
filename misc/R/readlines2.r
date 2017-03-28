#-------------------------------------------------------------------------------
# readLines2()
# Import text files
# from: http://mlt-thinks.blogspot.nl/2011/08/faster-files-in-r.html
#-------------------------------------------------------------------------------

readLines2 <- function(fname) {
 s = file.info( fname )$size 
 buf = readChar( fname, s, useBytes=T)
 strsplit( buf,"\n",fixed=T,useBytes=T)[[1]]
}
