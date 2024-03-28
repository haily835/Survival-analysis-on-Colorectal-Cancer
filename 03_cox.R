# Install and load required packages
install.packages(c("survival", "randomForestSRC", 
                   "lubridate", "ggsurvfit", "gtsummary", "tidycmprsk", 
                   "ggplot2", "mlr3benchmark", "mlr3pipelines", "mlr3proba", "mlr3tuning", 
                   "survivalmodels", "mlr3extralearners",
                   "survminer", "ggfortify", "prodlim", "pec"))

library(lubridate)
library(ggsurvfit)
library(gtsummary)
library(tidycmprsk)
library(survminer)
library(pec)
library(prodlim)
library(survival)
library(ranger)
library(ggplot2)
library(dplyr)
library(ggfortify)
# devtools::install_github("zabore/condsurv")
library(condsurv)


# Read the Top Feature CSV file
top_features_df <- read.csv("Documents/GitHub/SL - Final project/top_features.csv")

# Extract the list of feature names
top_features <- top_features_df$Variable

# Print or use the feature names as needed
print(top_features)


############ Train Cox model on Train set #########
cox_model = coxph(Surv(OS_MONTHS, OS_STATUS) ~ ., data = train_data[, c("OS_MONTHS", "OS_STATUS", top_features)], x=TRUE)
print(cox_model)


##### C - index ######
concordance(cox_model, newdata = test_data[, c("OS_MONTHS", "OS_STATUS", top_features)])


########## Plot K-M Curves for low risk, high risk ###############
# Step 1: Calculate Risk Score
risk_scores <- -predict(cox_model, newdata = test_data[, c("OS_MONTHS", "OS_STATUS", top_features)], type = "lp")

# Step 2: Determine Threshold
threshold <- median(risk_scores)  # You can adjust this as needed

# Step 3: Assign Group Labels
risk_groups <- ifelse(risk_scores > threshold, "High Risk", "Low Risk")

# Example: Display distribution of risk groups
table(risk_groups)

# Convert risk_groups to a factor for easier plotting
risk_groups <- factor(risk_groups, levels = c("High Risk", "Low Risk"))

# Combine survival data with risk groups
survival_data <- data.frame(time = test_data$OS_MONTHS, status = test_data$OS_STATUS, group = risk_groups, score=risk_scores)
print(survival_data)
# Fit Kaplan-Meier survival curves for each group
km_fit <- survfit(Surv(time, status) ~ group, data = survival_data)
autoplot(km_fit)

# Sort samples by risk scores
sorted_indices <- order(risk_scores)
sorted_risk_scores <- risk_scores[sorted_indices]


################ Plot risk scores against samples using a scatter plot ####################
plot(sorted_risk_scores, pch = 16, col = c("#C70039", "#96DED1")[risk_groups[sorted_indices]], 
     xlab = "Patients", ylab = "Risk Scores", 
     main = "Risk Scores of Samples")
legend("topright", legend = levels(risk_groups), col = c("#C70039", "#96DED1"), pch = 16)

# Sort patients by risk scores
sorted_indices <- order(risk_scores)
sorted_survival_times <- test_data$OS_MONTH[sorted_indices]
sorted_survival_status <- test_data$OS_STATUS[sorted_indices]

# Define colors for survival status (1 = event occurred, 0 = censored)
colors <- c("#96DED1", "#C70039")[sorted_survival_status + 1]

# Plot scatter plot for survival time against patients
plot(sorted_indices, sorted_survival_times, pch = 16, col = colors,
     xlab = "Patient (Sorted by Risk Score)", ylab = "Survival Time In Months",
     main = "Survival Time by Patient (Sorted by Risk Score)")

# Add legend
legend("topright", legend = c("Censored", "Event Occurred"), col = c("#96DED1", "#C70039"), pch = 16)

