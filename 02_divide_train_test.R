
# Read the collected dataset from CSV file
data <- read.csv("./dataset.csv")

# Split the dataset into training and testing sets
set.seed(123)  # For reproducibility
train_index <- sample(1:nrow(data), 0.75 * nrow(data))  # 75% for training
train_data <- data[train_index, ]
test_data <- data[-train_index, ]



### TRAIN TEST SPLIT => Save to csvs

# Get the directory path of the current script
script_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)

# Define the file paths for saving
train_file_path <- file.path(script_dir, "train_data.csv")
test_file_path <- file.path(script_dir, "test_data.csv")

# Save the data frames to CSV in the current directory
write.csv(train_data, file = train_file_path, row.names = FALSE)
write.csv(test_data, file = test_file_path, row.names = FALSE)
