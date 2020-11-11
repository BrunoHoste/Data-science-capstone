library(shiny)

ui <- fluidPage( 
    
    titlePanel(
        h1("Data Science Capstone project" , align = "center"),
    ),  
    
    sidebarPanel(
        h4("The goal of this app is to predict the next word."),
        h4("It is trained on plain text from blogs, newsfeeds and tweets."),
        h4("You can test the app by entering some text below. "),
        textInput("predfunct_input", label = h4("Please enter your input below:"), 
                  value = "enter your text here"),
        h4("Press submit to get result"),
        submitButton("Submit"),
        width = 6
        
    ),
    
    mainPanel(
        h3(" The app uses n-grams derived from the training sample to predict the next word."),
        h3("The output of the prediction model based on thes n- grams is:"),
        verbatimTextOutput("predfunct_result"),
        width = 5
    )
)    
    
