Create an environmental response plots
================

# Description

R function to create a response plot to evaluate the relationship between environmental variables and the fitted probability of occurrence of individual or ensemble suitability modelling algorithms. If more than one model is provided, the weighted average scores over all models will be used, with the weight determined by the user-defined weight vector. 

The biomod2 and the biodiversityR packages provide alternative implementation of this approach (response.plot2 and evaluation.strip.plot respectively). The main difference is that the present function uses as input GRASS raster layers to determine the range of values over which the variables need to be evaluated. 

# Status

This addon was written for personal use, and underwent only some very limited testing using R and GRASS 7.0 on Linux. It currenty is a R function that depends on GRASS GIS, i.e., you will need to run R from within GRASS GIS (see http://grasswiki.osgeo.org/wiki/R_statistics). It only works with a limited set of models, but more can be added easily.

The objective is to create an GRASS addon, initially just a wrapper to the R code. In the longer run, the idea is to replace the R code by python to simplify installing and running the addon in GRASS GIS.

# Usage

For the most up to date list of arguments, see the .Rd file

## Function
eval.strip.GRASS(models=list(), weight=1, layers, variables="", steps=50, smooth=0, fixval="mean", plot=TRUE, ...)
}

## Arguments

**models**: list with models (currently, the following models are supported: gbm{gbm}, randomForest{randomForest}, maxent{dismo}, glm, gam{mgcv}, earth{earth}, rpart{rpart}, nnet{nnet}, and ksvm{kernlab})

**weight**: vector of same length as number of models with per model the weight used to combine the individual models (if 1, all individual models get the same weight)

**layers**: the GRASS raster layers used as input in the model. Names of the raster layers should normally be the same as the variable names used to create the model, but this is not checked by the function (because the function will use the variable.names parameter to match the model variables). The number of layers should match the number of variables (next argument))

**variables**: the names of the variables used to create the model(s). If left empty (""), the layer names will be used to create the variable names (by removing the @mapset, if any). If you want to create a plot for part of the variables, provide only those variable names here (but layers should contain the full list of names of the variables used to create the model)

**steps**: number of steps within the range of a continuous explanatory variable

**smooth**: number of times the probability scores should be smoothed

**fixval**: the statistic used to keep the non-selected variables constant. Options are mean, median, minimum, maximum, a percentile or exact value. The percentile should be a numerical value between 0-100 preceded by p, e.g., p40 means the 40 percentile. One can also provide a vector with percentiles or exact values. This allows you to use different thresholds for the different variables. Be careful, if the lengtht of the vector is shorter as the number of variables, values will be recycled without further warning.

**plot**: if true the evaluation strip plots will be created

**minmax**: list with named vectors with the range over which a variable needs to be evaluated. The name of the vector should correspond to the variables. If not, or if not a list, this argument will silently be ignored

**vs**: list with one named vector. The name must be the same as one of the variables (exclude the @mapset), and the values represent one or more fixed values for that variable. If it includes X fixed values, the model will be run X times, keeping the fixed values of all other variables as defined by fixval, except the variable defined by this parameter, for which each of the fixed values in the vs vector will be used.

**plot.param**: List with arguments passed to plot (e.g., plot.param=list(col="grey")). For parameters to be set for different lines in the plots (i.e., if vs parameter is set)lines / points ), use the suffix vs. before the plot parameter. For example, use plot.param=list(sv.col="grey"). Note that if the lenght of these parameter is not the same as the lenght of 'vs', the vector will be recycled silently.

## value
List with for each variable a dataframe that gives the model outputs for each step value of that variable (and with all other variables held constant). In addition, a plot is created if plot=TRUE

## References

Elith J, Ferrier S, Huettmann F & Leathwick J. 2005. The evaluation strip: A new and robust method for plotting predicted responses from species distribution models. Ecological Modelling 186: 280-289

## Note
Both the gam and mgcv packages create gam objects. I am not sure how to determine which package was used to create the gam model (if there is, one can detach the other package using e.g., detach("package:mgcv", unload=TRUE). Therefore, for now this function is only compatible with the mgcv package
