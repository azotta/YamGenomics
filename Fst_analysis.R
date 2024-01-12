### Author: Denis Cornet - CIRAD

# Chargement des librairies ------------------------------------------------
packs <- c("tidyverse", "rehh", "fitdistrplus", "gamlss", "logspline")
InstIfNec<-function (pack) {
  if (!do.call(require,as.list(pack))) {
    do.call(install.packages,as.list(pack))  }
  do.call(require,as.list(pack)) }
lapply(packs, InstIfNec)

# Get data
setwd("/shared/home/azotta/Fst/reanalyse/")
fst_distr = read.table("cluster2_x_cluster3.windowed.weir.fst", 
                       header=TRUE, dec = ".")
fst_distr$WEIGHTED_FST[which(fst_distr$WEIGHTED_FST<0)]=0

png(height=10, width=10, res=300, filename="Fst_Histogram_c2c3.png",
    units="in", type="cairo",family="Garamond")
ggplot(fst_distr, aes(WEIGHTED_FST))+
  geom_histogram(alpha=.5, bins = 50)+
  theme_bw(base_size = 20)
dev.off()

# Looking for possible distribution
# adapted from: https://stats.stackexchange.com/questions/132652
png(height=6, width=10, res=300, filename="Cullen_Frey_c2c3.png",
    units="in", type="cairo",family="Garamond")
descdist(fst_distr$WEIGHTED_FST, discrete = FALSE) # beta and gamma seem not so bad
dev.off()

# Testing different distributions
o<-0.00000000000001 # Add small value to avoid 0
fit.weibull <- fitdist(fst_distr$WEIGHTED_FST+o, "weibull")
fit.norm <- fitdist(fst_distr$WEIGHTED_FST+o, "norm")
fit.beta <- fitdist(fst_distr$WEIGHTED_FST+o, "beta", method="mme")
fit.gamma <- fitdist(fst_distr$WEIGHTED_FST+o, "gamma", method="mle")

png(height=6, width=10, res=300, filename="FitDistrib_CDF_c2c3.png",
    units="in", type="cairo",family="Garamond")
cdfcomp(list(fit.weibull, fit.norm, fit.beta,fit.gamma))
dev.off()

res<-data.frame(Model=c("Weibull", "Normal", "Beta", "Gamma"), 
                AIC=c(fit.weibull$aic, fit.norm$aic, fit.beta$aic, fit.gamma$aic))
png(height=3, width=4, res=300, filename="FitDistrib_AIC_c2c3.png",
    units="in", type="cairo",family="Garamond")
ggplot(res, aes(reorder(Model, -AIC), AIC))+
  geom_bar(stat="identity")+
  theme_bw()+
  ylab("AIC")+theme(axis.title.x = element_blank())
dev.off()
# Weibull seems to be the best distribution
# If needed the gamlss library is dedicated to the search of a distribution

# check qqplot
png(height=6, width=10, res=300, filename="Weibull_QQplot_c2c3.png",
    units="in", type="cairo",family="Garamond")
plot(fit.weibull)
dev.off()

# Get the 1% outliers on graph
Quantile<-as.numeric(quantile(fit.weibull, probs = 0.01)[[1]])
(cutof<-qweibull(0.01, shape=fit.weibull$estimate[1],
                 scale=fit.weibull$estimate[2], lower.tail=F))
png(height=5, width=7, res=300, filename="Weibull_Histogram_WithCutof_c2c3.png",
    units="in", type="cairo",family="Garamond")
denscomp(fit.weibull)
abline(v=cutof, col="red", lty="dashed")
text(x=cutof, y=5, paste0("Cutof: ", round(cutof, 4)), pos=4)
dev.off()