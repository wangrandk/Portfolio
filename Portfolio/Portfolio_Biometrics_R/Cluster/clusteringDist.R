rm(list=ls())
library(ape)
library(phangorn)
simpledat = read.phyDat("Simple.txt", type="DNA", format="fasta")
View(simpledat)

#Compute distance matrix from alignment
dm = dist.hamming(simpledat, ratio=FALSE)
#dm=dist.logDet(simpledat)
#dm=dist.ml(simpledat, model="JC69", exclude="none", bf=NULL, Q=NULL)
print(dm)

#Compute phylogenetic tree
simpletree = NJ(dm) #Neighbor-Joining
plot(simpletree, type="unrooted", rotate.tree=90, lab4ut="axial")

print(simpletree$edge.length)
brlens = as.character(simpletree$edge.length)
edgelabels(brlens, bg="white", frame="circle")


##Step 1: Align protein sequences####
##Step 2: Read alignment into R####
pol21 = read.phyDat("pol21_aligned.txt", type="AA", format="fasta")
dm = dist.hamming(pol21, exclude="pairwise")

##Step 4: Compute tree from distance matrix####
hivtree = NJ(dm)
plot(hivtree, type="unrooted", lab4ut="axial", cex=0.8)

##Step 5: Root tree using outgroup####
# lineage leading to HTLV branched off before any of the remaining viruses diverged from each other
hivtreerooted = root(hivtree, "HTLV")
plot(hivtreerooted, type="phylogram", cex=0.8)

##Step 6: Add labels to two major clusters####
nodelabels(cex=0.8)
plot(hivtreerooted, type="phylogram", cex=0.8)
nodelabels(c("HIV-1", "HIV-2"), c(23,32), bg="white", cex=0.8)

##Step 7: Consider evolutionary origin of HIV-1 and HIV-2####

##Step 8: Optional: Save tree and inspect tree in external viewer####
write.tree(hivtreerooted, file="hivtree_root.txt")


