
# Read the collected dataset from CSV file
data <- read.csv("Documents/GitHub/SL - Final project/dataset.csv")

# Split the dataset into training and testing sets
set.seed(123)  # For reproducibility
train_index <- sample(1:nrow(data), 0.75 * nrow(data))  # 75% for training
train_data <- data[train_index, ]
test_data <- data[-train_index, ]

### TRAIN TEST SPLIT => Save to csvs
write.csv(train_data, "Documents/GitHub/SL - Final project/train_data.csv", row.names = FALSE)
write.csv(test_data, "Documents/GitHub/SL - Final project/test_data.csv", row.names = FALSE)
