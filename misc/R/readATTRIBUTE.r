#---------------------------------------------------------------------------------------------------
# Description:  Import the attribute table of a GRASS vector layer in R. Only works with dbf or 
#               SQLite as database backend
# vect:         vector from which to read the attribute table
# columns:      which columns to read (default is "all")
#---------------------------------------------------------------------------------------------------

readATTRIBUTE <- function(vect, columns="all", layer=1){
    if (nchar(Sys.getenv("GISRC")) > 0) {
        dbl1 <- get_output.GRASS(execGRASS("v.db.connect", flags="g", map=vect, intern=TRUE), separator="|")
        if(layer>dim(dbl1)[1]){stop(paste("there are no", layer, "layers"))}
        if(dbl1[1,5]=="dbf"){
            t2r <- paste(dbl1[layer,4], "/", dbl1[layer,2], ".dbf", sep="")
            t2r <- foreign::read.dbf(t2r)
            if(columns[1]!="all"){
                t2r <- t2r[,columns]
            }
        }
        if(dbl1[1,5]=="sqlite"){
            dbp <-as.character(dbl1[layer,4])
            con <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname=dbp)
            if(columns[1]=="all"){
            t2r <- dbReadTable(conn=con, name=as.character(dbl1[layer,2]))
            }else{
                sqlstat <- paste("SELECT", paste(columns, collapse=","), "FROM", as.character(dbl1[layer,2]))
                t2r <- DBI::dbGetQuery(conn=con, sqlstat)        
            }
        }
        if(dbl1[1,5] !="dbf" && dbl1[1,5] != "sqlite"){stop("ony dbf and sqlite are currently supported")}
    }
    return(t2r)
    dbDisconnect(conn = con)   
}
