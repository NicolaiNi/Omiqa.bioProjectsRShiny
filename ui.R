library(shiny)
library(d3heatmap)
library(shinyjs)
library(V8)
library(htmlwidgets)

#gene_select ~ 
css_select <- "
.selectize-control .selectize-input {
  max-height: 100px;
  overflow-y: auto;
}
.selectize-dropdown-content {
    max-height: 100px;
    overflow-y: auto;
}
"


css_network <- "
.notselectable {
    width: 100%;
}
"

jsCode <- "
    shinyjs.loadStringData = function(gene, website) {
        getSTRING('https://string-db.org', {
            'species':'9606',
            'identifiers': gene,
            'network_flavor':'confidence',
            'hide_disconnected_nodes': '0',
            'block_structure_pics_in_bubbles': '1',
            'caller_identity': website
            })
    }
  "

## here i could add D3 functionality --> setting of width not working properly, better implemenation of zoom function
jsCodeD3 <- "
    shinyjs.changeSizeNetwork = function (width){
        var svg_network_image = d3.select('#svg_network_image');
        svg_network_image.attr('width', width);
        console.log(svg_network_image);
}
"
# https://github.com/anvaka/panzoom
#(shinyjs.loadPanZoom = )
jsPanZoom <- "
   shinyjs.loadPanZoom = function (){
        var element = document.querySelector('#svg_network_image')
        panzoom(element, {
            bounds: true,
        });
  }
"

##################################
##############UI##################
##################################
# Define UI for application that draws a histogram
shinyUI(fluidPage(
    titlePanel("Omiqa.bio Test Visualization"),
    
    sidebarPanel(
      tags$head(
        tags$style(css_select),
        #tags$style(css_network)
      ),
        
        # select Genes
        selectInput("gene_select", "Select genes", choices=choices_genes, multiple = TRUE, selected = ""),
        # select Conditions
        selectInput("condition_select", "Select conditions", choices=choices_conditions, multiple = TRUE, selected = ""),
        checkboxInput("dendrogram", "display dendrogram"),
        radioButtons("sortByGenes", label = "Sort Genes", choices = c("ascending" = "asc", "descending" = "desc"), inline = TRUE),
        radioButtons("sortBySum", label = "Sort by Sum", choices = c("none", "row", "column"), inline = TRUE),
        actionButton("apply_selection", "Apply"),
        # slider to adopt size of heatmap
        hr(),
        sliderInput("heatmapHeight", "Change height", value = 700, min = 100, max = 2000, step = 50),
        sliderInput("heatmapFontSizeY", "yAxis font size", value = 0.5, min = 0.1, max = 1.0, step = 0.05),
        sliderInput("heatmapFontSizeX", "xAxis font size", value = 0.8, min = 0.1, max = 1.0, step = 0.05)
    ),
    
        # Show a plot of the generated distribution
        mainPanel(
            uiOutput("dynamic"),
            hr(),
            tags$script(src = "https://d3js.org/d3.v5.min.js"), #so far not needed
            tags$script(src = "https://unpkg.com/panzoom@9.2.4/dist/panzoom.min.js"),
            useShinyjs(),
            extendShinyjs(text = jsCode),
            tags$head(tags$script(src = "http://string-db.org/javascript/combined_embedded_network_v2.0.2.js")),
            actionButton("button", "Show Network for the selected gene(s)"),
            verbatimTextOutput("gene_select"),
            tags$div(id = "stringEmbedded"),
            extendShinyjs(text = jsPanZoom),
            
        ),
))