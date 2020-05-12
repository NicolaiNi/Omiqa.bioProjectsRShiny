library(shiny)
library(d3heatmap)
library(shinyjs)

website <- "www.DEBUG.bio" #has to be changed to www.omiqa.bio

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    observe({
        if("Select All" %in% input$gene_select)
            selected_choices_Genes=setdiff(choices_genes, selectAll) # choose all the choices _except_ "Select All"
        else
            selected_choices_Genes=input$gene_select # update the select input with choice selected by user
        
        updateSelectInput(session, "gene_select", selected = selected_choices_Genes)
        output$gene_select <- renderText(selected_choices_Genes, sep = ",")
        
        if("Select All" %in% input$condition_select)
            selected_choices_Conditions=setdiff(choices_conditions, selectAll) # choose all the choices _except_ "Select All"
        else
            selected_choices_Conditions=input$condition_select # update the select input with choice selected by user
        
        updateSelectInput(session, "condition_select", selected = selected_choices_Conditions)
        
        })

    dataSelect <- eventReactive(input$apply_selection,{
        if(is.null(input$gene_select) && is.null(input$condition_select)){
            return(dat)
        }
        #select data 
        dat_select <- subset(dat, rownames(dat) %in% input$gene_select, colnames(dat) %in% input$condition_select)
        return(dat_select)
    })
    
    output$heatmap <- renderD3heatmap({

                    d3heatmap(dataSelect(),
                            scale = "none",
                            dendrogram = "none",
                            anim_duration = 0,
                            colors = "Blues",
                            cexCol = input$heatmapFontSizeY,
                            cexRow = input$heatmapFontSizeX,
                            xaxis_height = 150)
    })
    
    output$dynamic <- renderUI({
        d3heatmapOutput("heatmap", height = paste0(input$heatmapHeight, "px"))
    })
    
    onclick("button", {
        genesInputSTRING <- paste(input$gene_select, collapse = "\r")
        js$loadStringData(genesInputSTRING,website)
    })
    
    onclick("buttonTest", {
        js$changeSizeNetwork(1000)
    })
}) 
