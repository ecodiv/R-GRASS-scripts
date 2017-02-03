#---------------------------------------------------------------------------------------------------
# Description:  Create strip evaluation plots
#---------------------------------------------------------------------------------------------------
# TODO: Use outer + persp to plot 3d plots
# (see e.g., http://statisticsr.blogspot.de/2008/10/some-r-functions.html)


eval.strip.GRASS <- function(models=list(), weight=1, layers, steps=50, smooth=0, fixval="mean", plot=TRUE, minmax=NULL, vs=NULL, plot.param=""){ 
    
    # Note
    # does not work with gam, need to resolve conflict with mgcv first

    if(is.null(minmax) || !is.list(minmax)){
        minmax <- list()
    }
        
    # Check if models is list and length weight vector
    if(!is.list(models)){
        stop("models should be a list with one or more models")
    }
    if(length(weight) != length(models)){
        if(weight!=1){
            stop("number of weights should be same as number of models or weight should be 1")
        }else{
            w <- rep(weight, length(models))
        }
    }else{
        w <- weight
    }
    
    # names
    variables <- as.vector(sapply(layers, function(x) unlist(strsplit(x, split='@'))[1]))
    
    # Get value ranges of input variables
    variseq <- list()
    varifix <- list()
    
    if(is.numeric(fixval)){
        thv <- rep(fixval, ceiling(length(layers)/length(fixval)))
        for(i in 1:length(layers)){
            a <- execGRASS("r.univar", flags="g", map=layers[i], intern=TRUE)
            a <- get_output.GRASS(a, separator="=")
            if(variables[i] %in% names(minmax)){
                minval <- minmax[[variables[i]]][1]
                maxval <- minmax[[variables[i]]][2]
                stps <- (maxval-minval)/steps
            }else{
                minval <- a[a$V1=="min",2]
                maxval <- a[a$V1=="max",2]
                stps <- a[a$V1=="range",2]/steps
            }
            variseq[[i]] <- seq(from=minval, to=maxval, by=stps)
            varifix[[i]] <- rep(fixval[i], steps+1)
        }
    }
    if(length(grep("p", fixval, value=TRUE))>0){
        fixval <- as.numeric(gsub("p", "", fixval))
        thv <- rep(fixval, ceiling(length(layers)/length(fixval)))
        for(i in 1:length(layers)){
            a <- execGRASS("r.univar", flags=c("g", "e"), map=layers[i], percentile=thv[i], intern=TRUE)
            a <- get_output.GRASS(a, separator="=")
            if(variables[i] %in% names(minmax)){
                minval <- minmax[[variables[i]]][1]
                maxval <- minmax[[variables[i]]][2]
                stps <- (maxval-minval)/steps
            }else{
                minval <- a[a$V1=="min",2]
                maxval <- a[a$V1=="max",2]
                stps <- a[a$V1=="range",2]/steps
            }
            variseq[[i]] <- seq(from=minval, to=maxval, by=stps)
            varifix[[i]] <- rep(a[a$V1==paste("percentile", thv[i], sep="_"),2], steps+1)
        }
    }
    if(fixval=="mean" || fixval=="median" || fixval=="min" || fixval=="max"){
        for(i in 1:length(layers)){
            a <- execGRASS("r.univar", flags=c("g", "e"), map=layers[i], intern=TRUE)
            a <- get_output.GRASS(a, separator="=")
            if(variables[i] %in% names(minmax)){
                minval <- minmax[[variables[i]]][1]
                maxval <- minmax[[variables[i]]][2]
                stps <- (maxval-minval)/steps
            }else{
                minval <- a[a$V1=="min",2]
                maxval <- a[a$V1=="max",2]
                stps <- a[a$V1=="range",2]/steps
            }            
            variseq[[i]] <- seq(from=minval, to=maxval, by=stps)
            varifix[[i]] <- rep(a[a$V1==fixval,2], steps+1)
        }
    }
    varifix <- do.call("cbind", varifix)
    colnames(varifix) <- variables
    names(variseq) <- variables

    # Function to run the models (writing it as a function rather then running directly makes
    # it easier to run this in a loop in case vs !=NULL
    run.preddat <- function(tmp.l=layers, tmp.v=variseq, tmp.f=varifix){
        preddat <- list()
        for(k in 1:length(tmp.l)){
            indat <- tmp.f
            indat[,k] <- tmp.v[[k]]
            indat <- as.data.frame(indat)
            tmpdat <- list()
            for(q in 1:length(models)){
                mymodel <- models[[q]]
                modtype <- class(mymodel)
                if("gbm" %in% modtype){
                    if(!"gbm" %in% rownames(installed.packages())){
                        stop("Please install the gbm package")
                    }
                    tmpdat[[q]] <- gbm::predict.gbm(mymodel, newdata=indat, type="response", n.trees=mymodel$n.trees)
                }
                if("randomForest" %in% modtype){
                    if(!"randomForest" %in% rownames(installed.packages())){
                        stop("Please install the randomForest package")
                        tmpdat <- predict(mymodel, newdata=indat, type="response")
                    }
                    tmpdat[[q]] <- predict(mymodel, newdata=indat, type="response")
                }
                if("MaxEnt" %in% modtype){
                    jar <- paste(system.file(package = "dismo"), "/java/maxent.jar", sep = "")
                    if (!file.exists(jar)) {
                        stop("maxent program is missing: ", jar, "\nPlease download it here: http://www.cs.princeton.edu/~schapire/maxent/")
                    }
                    tmpdat[[q]] <- predict(mymodel, x=indat)
                }
                if("glm" %in% modtype && !("gam" %in% modtype)){
                    tmpdat[[q]] <- predict.glm(mymodel, newdata=indat, type="response")
                }            
                if("gam" %in% modtype){
                    if("package:gam" %in% search()){
                        detach("package:gam", unload=TRUE)
                    }
                    if(!"mgcv" %in% rownames(installed.packages())){
                        stop("Please install the mgcv package")
                    }
                    indat2 <- as.data.frame(indat)
                    tmpdat[[q]] <- predict(mymodel, newdata=indat2, type="response")
                }
                if("earth" %in% modtype){
                    if(!"earth" %in% rownames(installed.packages())){
                       stop("Please install the earth package")
                    }
                    tmpdat[[q]] <- predict(mymodel, newdata=indat, type="response")
                }
                if("rpart" %in% modtype){
                    if(!"rpart" %in% rownames(installed.packages())){
                        stop("Please install the rpart package")
                    }
                    tmpdat[[q]] <- predict(mymodel, newdata=indat, type="prob")[,"present"]
                }
                if("nnet.formula" %in% modtype){
                    if(!"nnet" %in% rownames(installed.packages())){
                        stop("Please install the nnet package")
                    }
                    tmpdat[[q]] <- predict(mymodel, newdata=indat, type="raw")
                }
                if("ksvm" %in% modtype){
                    if(!"kernlab" %in% rownames(installed.packages())){
                        stop("Please install the kernlab package")
                    }
                    if(mymodel@type %in% c("C-svc", "nu-svc", "C-bsvm", "spoc-svc")){
                        tmpdat[[q]] <- predict(mymodel, newdata=indat, type="probability")[,"1"]
                    }else{
                        if(mymodel@type %in% c("eps-svr", "eps-bsvr", "nu-svr")){
                            tmpdat[[q]] <- predict(mymodel, newdata=indat, type="response")
                        }
                    }
                }
                if("Bioclim" %in% modtype){
                    if(!"dismo" %in% rownames(installed.packages())){
                        stop("Please install the dismo package")
                    }
                    tmpdat[[q]] <- predict(mymodel, x=indat)
                }
            }
            tmpdat <- do.call("cbind", tmpdat)
            tmpdat <- apply(tmpdat, 1, function(x) weighted.mean(x, w))
            
            # smooth data
            if(smooth>0){
                for(q in 1:smooth){
                    tmpdat  <- as.vector(smooth(tmpdat))
                }
            }
            preddat[[k]] <- data.frame(steps=tmp.v[[k]], value=tmpdat)
        }
        names(preddat) <- variables
        return(preddat)
    }
    
    # Run the function defined above
    if(is.null(vs)){
        predval <- run.preddat()
        pv <- list(predval)
        mm <- list(); i=0
        for(df in predval){
            i=i+1
            mm[[i]] <- as.data.frame(rbind(apply(df, 2, min), apply(df, 2, max)))
        }  
    }else{
        pv <- list()
        varifx2 <- as.data.frame(varifix)
        cn <- which(colnames(varifix) == names(vs)[1])
        rn <- dim(varifix)[1]
        mm <- list()
        for(z in 1:length(vs[[1]])){     
            varifx2[,cn] <- rep(vs[[1]][z], rn)
            pv[[z]] <- run.preddat(tmp.f=varifx2)
            i=0
            for(df in pv[[z]]){
                i=i+1
                if(z==1){
                    mm[[i]] <- as.data.frame(rbind(apply(df, 2, min), apply(df, 2, max)))
                }else{
                    nn <- rbind(apply(df, 2, min), apply(df, 2, max))
                    mxv <- apply(rbind(nn, as.matrix(mm[[i]])), 2, max)
                    miv <- apply(rbind(nn, as.matrix(mm[[i]])), 2, min)
                    mm[[i]] <- as.data.frame(rbind(miv, mxv))
                }
            }
        }
        predval <- pv
    }   
    
    if(plot){
        svs <- grep("vs", names(plot.param))
        vs.plot <- plot.param[grep("vs", names(plot.param))]
        plotpar <- plot.param[grep("vs", names(plot.param), invert=TRUE)]
        if(length(vs.plot)>0){
            for(k in 1:length(vs.plot)){
                vs.plot[[k]] <- rep(vs.plot[[k]], ceiling(length(pv)/length(vs.plot[[k]])))
            }
        }
        names(vs.plot) <- gsub("vs.", "", names(vs.plot))
        dim1 <- ceiling(sqrt(length(layers)))
        dim2 <- ceiling(length(layers)/dim1)
        opar <- par()      
        par(mfrow=c(dim1, dim2), mar=c(3,3,1,1))
        for(k in 1:length(variables)){   
            ipp <- list(x=mm[[k]]$steps, y=mm[[k]]$value, xlab="", ylab="", main=variables[k],type="n")
            do.call(plot.default, c(ipp, plotpar))
            for(y in 1:length(pv)){
                pvt <- pv[[y]]
                param <- c(plotpar, lapply(vs.plot, "[", y))
                do.call(points, c(list(x=pvt[[k]]$steps, y=pvt[[k]]$value), param))
                do.call(lines, c(list(x=pvt[[k]]$steps, y=pvt[[k]]$value), param))
           }
        }
    }
    par <- opar
    return(list(predicted_values=predval, fixed_values=varifix[1,]))
}
