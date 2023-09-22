
library(tidyverse)
library(shiny)
library(NGLVieweR)

ui <- fluidPage(
    h1(HTML("Purified <i>Sus scrofa</i> Calpain-2")),
    tabsetPanel(
        tabPanel("Malondialdehyde Incubation",
                 mainPanel(
                     h2(HTML("Maldondialdehyde Modifications Only in Malondialdehyde Incubations")),
                     NGLVieweR::NGLVieweROutput("malondialdehyde"),
                     br(),
                     h2(HTML("Maldondialdehyde Modifications Shared Between Control and Malondialdehyde Incubations")),
                     NGLVieweR::NGLVieweROutput("malondialdehyde.shared"))),
        tabPanel("Hexenal Incubation",
                 mainPanel(
                     h2(HTML("Hexenal Modifications Only in Hexenal Incubations")),
                     NGLVieweR::NGLVieweROutput("hexenal"),
                     br(),
                     h2(HTML("Hexenal Modifications Shared Between Control and Hexenal Incubations")),
                     NGLVieweR::NGLVieweROutput("hexenal.shared")))
    ),
    fillPage = TRUE
)

server <- function(input, output) {
    
    calpain_2 <- NGLVieweR::NGLVieweR(data = "./calpain-2.pdb") %>% 
        NGLVieweR::addRepresentation(type = "cartoon", 
                                     param = list(
                                         name = "cartoon_A", 
                                         color = "white",
                                         sele = ":A")) %>%
        NGLVieweR::addRepresentation(type = "cartoon",
                                     param = list(
                                         name = "cartoon_B",
                                         color = "tan",
                                         sele = ":B")) %>% 
        NGLVieweR::addRepresentation(type = "ball+stick",
                                     param = list(
                                         name = "active.site",
                                         sele = ":A and (105, 262, 286)",
                                         color = "gold")) %>% 
        NGLVieweR::setRotation(200, 300, 100) %>% 
        NGLVieweR::stageParameters(backgroundColor = "black") %>%
        NGLVieweR::setQuality("high") %>%
        NGLVieweR::setFocus(0) %>%
        NGLVieweR::setSpin(FALSE)
    
    output$hexenal <- renderNGLVieweR({
        NGLVieweR::addRepresentation(NGLVieweR = calpain_2,
                                     type = "ball+stick",
                                     param = list(
                                         name = "HXL.Treatment",
                                         sele = ":A and (298, 300, 301)",
                                         color = "red")) 
    })
    
    output$hexenal.shared <- renderNGLVieweR({
        NGLVieweR::addRepresentation(NGLVieweR = calpain_2,
                                     type = "ball+stick",
                                     param = list(
                                         name = "HXL.Shared",
                                         sele = ":A and 39",
                                         color = "red"))
    })
    
    output$malondialdehyde <- renderNGLVieweR({
        NGLVieweR::addRepresentation(NGLVieweR = calpain_2,
                                     type = "ball+stick",
                                     param = list(
                                         name = "MDA.Treatment",
                                         sele = ":A and (29, 30, 38, 61, 129, 183, 189, 191, 233, 234, 256, 257, 260, 279, 280, 285, 298, 318, 342, 354, 355, 376, 398, 405, 414, 415, 421, 443, 447, 450, 473, 474, 506, 510, 578, 618, 629)",
                                         color = "red")) %>% 
            NGLVieweR::addRepresentation(type = "ball+stick",
                                         param = list(
                                             name = "MDA.Treatment",
                                             sele = ":B and (27, 101, 105, 120, 128, 142, 153, 214, 221)",
                                             color = "red"))
    })
    
    output$malondialdehyde.shared <- renderNGLVieweR({
        NGLVieweR::addRepresentation(NGLVieweR = calpain_2,
                                     type = "ball+stick",
                                     param = list(
                                         name = "MDA.Treatment",
                                         sele = ":A and (12, 39, 82, 169, 240, 262, 286, 300, 301, 319, 341, 427, 476)",
                                         color = "red")) %>% 
            NGLVieweR::addRepresentation(type = "ball+stick",
                                         param = list(
                                             name = "MDA.Treatment",
                                             sele = ":B and (73, 84, 87)",
                                             color = "red"))
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
