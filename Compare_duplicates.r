#!/usr/bin/Rscript
args = commandArgs(trailingOnly = TRUE)
mydata<- read.csv(args[1], sep = ",")
library(ggplot2)
plot<- ggplot(mydata, aes(x=Allele_Frequency_Sample_1, y=Allele_Frequency_Sample_2, colour=Description)) +
  geom_point(shape=1) +
  theme_bw() +
  geom_abline(intercept = 0, slope = 1, size=0.15)

pdf(args[2], width = 20, height = 15)
plot + facet_wrap(~Sample, strip.position = "right", scales = "free", ncol = 4)
dev.off()
