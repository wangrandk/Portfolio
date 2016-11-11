
#Try load packages ("this should fail first time as they're not installedd)
packages_needed = c("forestFloor",  #this is my package
                    "rfFC",         #a similar package to mine which is used for multi-classification
                    "foreach",      #a package with a new kind of for-loops with parallel backend
                    "doParallel")   #package to allow paralell computation
repositories =      c("rForge","rForge","CRAN","CRAN") #the servers who offer the packages
packages_succeeded = sapply(packages_needed, function(this.package) {
  require(package=this.package,char=TRUE)
})

#trying to install any missing packages
number_missing = sum(!packages_succeeded)
if(number_missing>0) {
  packages_missing = packages_needed[!packages_succeeded]
  repos = repositories[!packages_succeeded]
  answer = readline("type y and press 'enter' to install missing packages.  Type here:")
  if(answer!="y") stop("missing packages was not installed") else {
    for(i in 1:number_missing) {
      if(repos[i]=="CRAN")   install.packages(packages_missing[i])
      if(repos[i]=="rForge") install.packages("rfFC", repos="http://R-Forge.R-project.org")
    }
  }
}
#and lastly for some linux/OSx users who failed to install rfFC, should try run the following run this following
if(!require(rfFC)) { #will only run if package still cannot be loaded
  answer = readline("type y and press 'enter' to install rfFC manually.  Type here:")
  if(answer!="y") stop("missing packages was not installed") else {
    download.file(url="http://download.r-forge.r-project.org/src/contrib/rfFC_1.0.tar.gz",
                destfile="rfFC_1.0.tar.gz",
                mode="wb")
    install.packages("rfFC_1.0.tar.gz",repos=NULL)
    #line above do not work for windows, if it still don't work
  }
}

