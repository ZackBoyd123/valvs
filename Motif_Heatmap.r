#!/usr/bin/Rscript
#'''
# First command line input is the file generated from valvs motifs
# Second command line input is what you want to call the output .pdf file
#'''
args = commandArgs(trailingOnly = TRUE)
test_data<- read.csv(args[1], sep = "\t")
colnames(test_data)<- c("Trinucleotide","Percent","Raw","Direction","Dataset")
library(ggplot2)
for_rev<- ggplot(test_data, aes(Direction, Trinucleotide))+ 
  geom_tile(aes(fill= Percent), colour = "Black") +
  scale_fill_gradient(low = "Green", high = "Red") + 
  facet_wrap(~Dataset, strip.position = "right", ncol = 2)

pdf(args[2], width = 20, height = 15)
for_rev
dev.off()
