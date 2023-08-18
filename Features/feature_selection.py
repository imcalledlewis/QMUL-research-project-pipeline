import pandas as pd
from sklearn.linear_model import Lasso
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.utils import resample
from sklearn.feature_selection import RFECV
from boruta import BorutaPy

# Load the data
df = pd.read_csv('/data/home/bt22880/WGBS_TE_pipeline/TensorFlow/filter_betas.csv', sep=',', index_col=0) # for classification problem

# Separate the feature data (X) and binary group labels (y)
X = df.iloc[:, :-1]  # All columns except the last one
y = df.iloc[:, -1]   # Last column (binary group labels)

# Set seed
import numpy as np
np.random.seed(42)

# Split the data into training and testing sets using a 70/30 split
X_train_rf, X_test_rf, y_train_rf, y_test_rf = train_test_split(X, y, test_size=0.3, random_state=42, stratify=y)

# Perform hyperimputation on the training data (only needed for Boruta)
from hyperimpute.plugins.imputers import Imputers
imputers = Imputers()
method = "hyperimpute"
plugin = imputers.get(method)
X_train_rf = plugin.fit_transform(X_train_rf.copy())

# Initialize the DataFrames to count the occurrences of selected features for each method
selected_features_df_rfecv = pd.DataFrame(0, columns=X_train_rf.columns, index=[0])
selected_features_df_boruta = pd.DataFrame(0, columns=X_train_rf.columns, index=[0])
selected_features_df_lasso = pd.DataFrame(0, columns=X_train_rf.columns, index=[0])

num_iterations = 100

for i in range(num_iterations):
    # Resample the data (bootstrapping)
    X_resampled, y_resampled = resample(X_train_rf, y_train_rf, random_state=i)

    # Initialize the RFECV with the desired classifier
    rfecv = RFECV(estimator=RandomForestClassifier(n_jobs=-1), step=1, cv=5)

    # Fit the RFECV on the resampled data
    rfecv.fit(X_resampled, y_resampled)

    # Get the indices of the selected features for RFECV
    selected_indices_rfecv = rfecv.support_

    # Get the names of the selected features for RFECV
    selected_features_rfecv = X_train_rf.columns[selected_indices_rfecv]

    # Update the counts of selected features for RFECV in the DataFrame
    selected_features_df_rfecv.loc[0, selected_features_rfecv] += 1

    # Initialize the Boruta feature selector
    boruta_selector = BorutaPy(estimator=RandomForestClassifier(n_jobs=-1), n_estimators='auto', verbose=1)

    # Fit the Boruta feature selector on the resampled data
    boruta_selector.fit(X_resampled.values, y_resampled.values)

    # Get the selected features from the Boruta feature selector
    selected_indices_boruta = boruta_selector.support_

    # Get the names of the selected features for Boruta
    selected_features_boruta = X_train_rf.columns[selected_indices_boruta]

    # Update the counts of selected features for Boruta in the DataFrame
    selected_features_df_boruta.loc[0, selected_features_boruta] += 1

    # Initialize the Lasso regression model
    lasso_model = Lasso(alpha=0.01)  # You can adjust the regularization strength (alpha) as needed

    # Fit the Lasso model on the resampled data
    lasso_model.fit(X_resampled, y_resampled)

    # Get the coefficients and select features with non-zero coefficients for LASSO
    selected_features_lasso = X_train_rf.columns[lasso_model.coef_ != 0]

    # Update the counts of selected features for LASSO in the DataFrame
    selected_features_df_lasso.loc[0, selected_features_lasso] += 1

    # Print the current iteration number
    print(f"Iteration {i + 1}/{num_iterations} completed.")

# Sort the DataFrames based on the occurrences of selected features
selected_features_df_rfecv = selected_features_df_rfecv.T.sort_values(by=0, ascending=False)
selected_features_df_boruta = selected_features_df_boruta.T.sort_values(by=0, ascending=False)
selected_features_df_lasso = selected_features_df_lasso.T.sort_values(by=0, ascending=False)

# Merge the three DataFrames based on the feature names
merged_feature_counts = pd.merge(selected_features_df_rfecv, selected_features_df_boruta, left_index=True, right_index=True, suffixes=('_RFECV', '_Boruta'))
merged_feature_counts = pd.merge(merged_feature_counts, selected_features_df_lasso, left_index=True, right_index=True, suffixes=(None, '_LASSO'))

# Print the selected features DataFrame
print("Selected features occurrences:")
print(merged_feature_counts)

# Write the merged feature counts to a CSV file
merged_feature_counts.to_csv('feature_counts_rfecv_boruta_lasso.csv', index=True)