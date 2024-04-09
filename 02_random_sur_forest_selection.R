install.packages(c("randomForestSRC"))
install.packages(c("ggplot2"))
library(randomForestSRC)
library(ggplot2)

train_data  <- read.csv("./train_data.csv")
test_data  <- read.csv("./test_data.csv")

# Perform feature selection using randomForestSRC
rfsrc_model <- rfsrc.fast(Surv(OS_MONTHS, OS_STATUS) ~ ., 
                          data = train_data, ntree = 1000, nsplit = 20,
                          importance=TRUE, seed=-123,  forest=TRUE)

# Plot a tree in the forest
plot(get.tree(rfsrc_model, 5))

# calc c-index on test set of Randome survival tree
predicted_model <- predict(rfsrc_model, test_data)
get.cindex(predicted_model$yvar[,1], predicted_model$yvar[,2], predicted_model$predicted)
print(rfsrc_model$predicted.oob)

# Get variable importance from tree
var_importance <- rfsrc_model$importance
variable_names <- names(var_importance)
importance_values <- as.numeric(var_importance)

# Combine variable names and importance values into a data frame
importance_df <- data.frame(Variable = variable_names, Importance = importance_values)
# Remove any rows with missing or invalid importance values
importance_df <- importance_df[!is.na(importance_df$Importance), ]


top_count = 20
# Plot top 20 feature
sorted_importance <- sort(var_importance, decreasing = TRUE)
top_features <- names(sorted_importance)[1:top_count]
print(top_features)
top_features_impt <- sorted_importance[1:top_count]

# Create a data frame for plotting
top_features_df <- data.frame(Variable = top_features, Importance = top_features_impt)

# Get the directory path of the current script
script_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
# Define the file path for saving
file_path <- file.path(script_dir, "top_features.csv")
# Save the data frame to CSV in the current directory
write.csv(top_features_df, file = file_path, row.names = FALSE)


# Plot the top variables
ggplot(top_features_df, aes(x = reorder(Variable, Importance), y = Importance)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(x = "Variable", y = "Importance") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 14))  # Adjust text size for better visibility

