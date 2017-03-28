#-------------------------------------------------------------------------------
# Degree to meter at given latitude (default latitude = 0 = equator)
#-------------------------------------------------------------------------------

d2m <- function(degree, latitude=0){
    lat.rad <- latitude/180*pi # Latitude in radians
    circumf <- cos(lat.rad) # circumference of the earth at given latitude
    dim <- degree * (1/360) *  12756276 * pi * circumf
    return(dim)
}
