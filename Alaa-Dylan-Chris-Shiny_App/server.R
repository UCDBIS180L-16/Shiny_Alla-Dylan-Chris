library(shiny)
library(ggplot2)

# Define server logic required to draw a boxplot
shinyServer(function(input, output) {
  
  # Expression that generates a boxplot. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot

  
  data.geno <- read.csv("RiceSNPData/Rice_44K_genotypes.csv.gz",
                        row.names=1, #this tells R to use the first column as row names
                        na.strings=c("NA","00")) #this tells R that missing data is denoted as "NA" or "00"
  data.geno.2500<-data.geno[ , sample(1: ncol(data.geno), 2500)]
  geno.numeric <- data.matrix(data.geno.2500)
  genDist <- as.matrix(dist(geno.numeric))
  geno.mds <- as.data.frame(cmdscale(genDist))
  data.pheno <- read.csv("RiceSNPData/RiceDiversity.44K.MSU6.Phenotypes.csv", row.names = 1, na.strings=c("NA", "00"))
  data.pheno.geno.mds<- merge(geno.mds,data.pheno, by = "row.names", all = TRUE)
  library(PSMix)
  load("RiceSNPData/ps4.2500.RData")
  ps4.df <- as.data.frame(cbind(round(ps4$AmPr,3),ps4$AmId))
  colnames(ps4.df) <- c(paste("pop",1:(ncol(ps4.df)-1),sep=""),"popID")
  maxGenome <- apply(ps4$AmPr,1,max) 
  ps4.df <- ps4.df[order(ps4.df$popID,-maxGenome),]
  ps4.df$sampleID <- factor(1:413)
  library(reshape2)
  ps4.df.melt <- melt(ps4.df,id.vars=c("popID","sampleID"))
  geno.mds$popID <- factor(ps4$AmId)
  colnames(ps4$AmPr) <- paste("pr",1:4,sep="")
  geno.mds <- cbind(geno.mds,ps4$AmPr)
  temp <- geno.mds[, !duplicated(colnames(pr1))]
  geno.mds$pr1 <-round(geno.mds$pr1,3)
  geno.mds$pr2 <-round(geno.mds$pr2,3) 
  geno.mds$pr3 <-round(geno.mds$pr3,3)
  geno.mds$pr4 <-round(geno.mds$pr4,3)
  save(data.pheno,geno.mds,file="data_from_SNP_lab.Rdata")
  load("RiceSNPData/data_from_SNP_lab.Rdata")
  geno.mds$popID <- factor(ps4$AmId) 
  colnames(ps4$AmPr) <- paste("pr",1:4,sep="")
  geno.mds <- cbind(geno.mds,ps4$AmPr)
  temp <- geno.mds[, !duplicated(colnames(pr1))]
  data.pheno.mds <- merge(geno.mds,data.pheno,by="row.names",all=T) 
  
  output$boxplot <- renderPlot({
    
    # set up the plot
    pl <- qplot(data=data.pheno.mds,
                 #Use aes_string below so that input$trait is interpreted
                 #correctly.  The other variables need to be quoted
                 aes_string(x="Amylose.content",
                            y=input$Amylose.content,
                            fill="Region"
                 )
    )
    # draw the boxplot for the specified trait
    pl + geom_boxplot()
  })
  
  output$histogram <- renderPlot({
    pl2 <- ggplot(data=data.pheno.mds,aes_string(x="Amylose.content",
                                                 y=input$Amylose.content, 
                                                 fill="Region"))
                  #Use aes_string below so that input$trait is interpreted
                  #correctly.  The other variables need to be quoted
    # set up the plot
    pl2 <- pl2 + geom_histogram(binwidth=3) #tell R that we want a histogram, with binwidth of 3
    pl2 <- pl2 + facet_wrap(facets= ~ Region, ncol=3) # a separate plot ("facet") for each region, arranged in 3 columns
    pl2 <- pl2 + ggtitle("Amylose Content") #add a title
    pl2 #display the plot
    
  })
  
  output$violin <- renderPlot({
    
    # set up the plot
    pl3 <- qplot(data=data.pheno.mds,
                #Use aes_string below so that input$trait is interpreted
                #correctly.  The other variables need to be quoted
                aes_string(x="Amylose.content",
                           y=input$Amylose.content,
                           fill="Region"
                )
    )
    # draw the boxplot for the specified trait
    pl3 + geom_violin()
  })
  
})

