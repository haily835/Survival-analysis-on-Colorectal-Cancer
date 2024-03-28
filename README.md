# Survival-analysis-on-Colorectal-Cancer

Feature selection, Survival analysis on Colorectal Dataset

Gene expression from a cancer tumour can be a prognosis factor, however, the number of features is large in terms of thousands. We aim to select the gene expression that can contain more information about the patient's survival. 

We perform both survival analysis and also classification techniques on the selected features to demonstrate their prediction powers:

- Survival analysis task : Cox’s Proportional Hazard, DeepSurv to predict the risk of patients

- Classification task: (SVM, LDA, RF, DT) for Status (death/living)

1. Dataset:

   - Download and extract the zipped file from: https://www.cbioportal.org/study/summary?id=coadread_tcga_pan_can_atlas_2018
   - The extracted folder should be coadread_tcga and contain the following 3 files to perform data collection:
     - data_clinical_patient.txt: for survival status and survival months
     - data_clinical_sample.txt
     - data_linear_cna.txt: gene expression data
2. Data collection:
   Notebook: 01_data_collection_colorectal.ipynb
   This notebook will create the dataset.csv which has all gene expression columns from data_linear_cna.txt and addition OS_MONTHS, OS_STATUS for survival analysis.
   **NOTE: Can skip step 1,2 if you download dataset.csv directly**
3. Train test split:
   02_divide_train_test.R: this R code will split dataset.csv into train_data.csv and test_data.csv
   **NOTE: Can skip step 1,2,3 if you download train_data.csv, test_data.csv directly**
4. Feature selection:
   02_random_sur_forest_selection.R: Perform feature selection and store the top features to top_features.csv
5. Survival analysis with Cox:
   03_cox.R:

   - Train Cox model on Train data and calculate the C-index on Test data
   - Draw KM curve of Low & High risk patient on Test data
6. Survival analysis with DeepSurv: 03_deepsurv-mrna.ipynb
   Applied DeepSurv model from pycox for survival analysis. Also calculate C-index, KM curves on Test data
7. Survival analysis with DeepHit (OPTIONAL): 03_deephit-mrna.ipynb, 03_deephit_clinical:
   Applied DeepHit to both gene expression and clinical data.
8. Classification task: 04_classification.ipynb
   Apply SVM, LDA, RF, DT on train_data.txt
   Calculate Accuracy, Precision, F1, Recall on test_data.txt
