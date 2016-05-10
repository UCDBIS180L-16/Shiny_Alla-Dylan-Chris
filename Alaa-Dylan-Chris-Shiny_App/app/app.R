# This is a Shiny web application.
# Alaa, Dylan, Chris

# Load UI and Server
if(!exists("ui")) source("ui.R")
if(!exists("server")) source("server.R")

# runGitHub(repo="UCDBIS180L-16/Shiny_Alla-Dylan-Chris", username="cacampbell", subdir="Alaa-Dylan-Chris-Shiny_App")
# rsconnect::deployApp('/Users/chris/Desktop/Classes/Spring2016/BIS180L/Shiny_Alla-Dylan-Chris/Alaa-Dylan-Chris-Shiny_App')
# https://cacampbell.shinyapps.io/Alaa-Dylan-Chris-Shiny_App/

#library(shinyapps)
#shinyapps::deployApp("Shinyapp_Alaa/")
#https://alaahussein.shinyapps.io/Shinyapp_Alaa/
  
# Dylan -- please add your deployment code as a comment here if you want



library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage( #create the overall page
  
  # Application title
  titlePanel("RICE SNP DATA"),
  
  # Some helpful information
  helpText("This application creates a different plots  to show difference between",
           "rice plants across different regions.  Please use the radio box below to choose a trait",
           "for plotting"),
  
  # Sidebar with a radio box to input which trait will be plotted
  sidebarLayout(
    sidebarPanel(
      radioButtons("Trait", #the input variable that the value will go into
                   "Choose a trait to display:",
                   c("Amylose.content",
                     "Alu.Tol",
                     "Protein.content")),
      radioButtons("Plot type", 
                   "choose the desired plot:",
                   c("histogram",
                     "boxplot",
                     "violin")),
      
      # Show a plot of the generated distribution
      mainPanel(plotOutput("histogram"),
                plotOutput("boxplot"),
                plotOutput("violin")
      )
    )
  )))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  
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

# Run the application
shinyApp(ui = ui, server = server)