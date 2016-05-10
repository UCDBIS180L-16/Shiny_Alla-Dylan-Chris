library(shiny)
library(ggplot2)
library(PSMix)

load_data <- function() {
    data.geno <- read.csv("RiceSNPData/Rice_44K_genotypes.csv.gz",
                          row.names=1,
                          na.strings=c("NA", "00"))
    data.pheno <- read.csv("RiceSNPData/RiceDiversity.44K.MSU6.Phenotypes.csv",
                           row.names=1,
                           na.strings=c("NA", "00"))
    tryCatch({
        load("RiceSNPData/ps4.2500.RData")
    }, error=function(e) {
        print("Generating PSMix data and saving to .RData...")
        ps4 <- PSMix(K = 4, data.geno.2500, eps = 1e-05)
        save(ps4, file="RiceSNPData/ps4.2500.RData")
    })

    data.geno.2500 <- data.geno[, sample(1:dim(data.geno)[2], 2500)]
    geno.numeric <- data.matrix(data.geno.2500)
    genDist <- as.matrix(dist(geno.numeric))
    geno.mds <- as.data.frame(cmdscale(genDist))
    data.all <- merge(data.pheno, geno.mds, by='row.names', all=TRUE)
}

shinyServer(function(input, output) {
    load_data()

    output$histogram <- renderPlot({
        pl2 <- ggplot(data=data.pheno.mds,aes_string(x = "Region",
                                                     y = input$trait,
                                                     fill = "Region"))
        #Use aes_string below so that input$trait is interpreted
        #correctly.  The other variables need to be quoted
        # set up the plot
        pl2 <- pl2 + geom_histogram(binwidth=3) #tell R that we want a histogram, with binwidth of 3
        pl2 <- pl2 + facet_wrap(facets = ~ Region, ncol = 3) # a separate plot ("facet") for each region, arranged in 3 columns
        pl2 <- pl2 + ggtitle("Amylose Content") #add a title
        pl2 #display the plot
    })

    output$violin <- renderPlot({

        #set up the plot
        pl3 <- qplot(data=data.pheno.mds,
                     #Use aes_string below so that input$trait is interpreted
                     #correctly.  The other variables need to be quoted
                     aes_string(x="Amylose.content",
                                y=input$Amylose.content,
                                fill="Region"
                     )
        )
        #draw the boxplot for the specified trait
        pl3 + geom_violin()
    })
})