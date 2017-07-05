## dir <- "/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/journals"
dir <- "/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/txtOutput/20170705"
plotDir <- '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/plots/20170705/'
## setwd(paste(getwd(),'/exploratorio',sep='')
setwd(dir)

loc_and_stormphase <- "dayside_ns"

## dataStrings <- c('magC','IntgUp','pF','eNumFl','eF_LC_intg','Max')
dataStrings <- c('IntgUp','pF','eNumFl','eF_LC_intg','Max')

library(fitdistrplus)

## fitType <- "norm"
## fitType <- "exp"
fitTypes <- c('weibull',"lnorm")

## OR, instead of fitType, define your own function:
## NOTE that this uses fitdistr from library(MASS) instead of fitdist!
## library(MASS)
## inverseGammaF <- function(x, rho, a, s)
##   1/(a*gamma(rho)) * (a / (x-s))^(rho+1) * exp( - a/(x-s) )
## fitdistr( x, inverseGammaF, list(rho=1, a=1, s=0) ) 

for ( dStr in dataStrings) {
## for ( dStr in dataStrings[[1]]) {

    dfile <- paste('width_t_and_',dStr,'_',loc_and_stormphase,'.txt',sep='')

    printf("Opening %s ...",dfile)
    data <- read.csv(paste(dir,dfile,sep='/'))

    if(dStr == dataStrings[[1]]) {
        v <- 3:5
    } else {
        v <- 4:5
    }

    for ( fitType in fitTypes ) {

        for ( i in v) {


            fPref <- paste(loc_and_stormphase,fitType,'_',sep='_')


            tmpName <- (names(data))[[i]]
            printf("Fitting %s with %s ...",tmpName,fitType)

            X <- data[[i]]
            fitted <- fitdist(X,fitType)

            ## plot(fitted,main=tmpName)


            ## Make that png!
            fname <- paste(fPref,tmpName,'.png',sep='')
            printf("Making %s ...",fname

            png(paste(plotDir,fname,sep=''),width=800,height=800)

            plot(fitted,cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)
            title(main=tmpName)

            dev.off()

        }

    }



}
