import pandas as pd

# ─────────────────────────────────────────
# STEP 1: LOAD THE DATA
# ─────────────────────────────────────────
df = pd.read_csv("C:/Users/vanit/OneDrive/Desktop/healthcare_raw.csv")

print("Shape:", df.shape)
print("\nColumns:\n", df.columns.tolist())
print("\nFirst 3 rows:\n", df.head(3))
print("\nData Types:\n", df.dtypes)
print("\nNull Values:\n", df.isnull().sum())


# ─────────────────────────────────────────
# STEP 2: DATA CLEANING
# ─────────────────────────────────────────

# Fix name casing (Bobby JacksOn → Bobby Jackson)
df['Name'] = df['Name'].str.title()

# Convert date columns to datetime
df['Date of Admission'] = pd.to_datetime(df['Date of Admission'])
df['Discharge Date'] = pd.to_datetime(df['Discharge Date'])

# Calculate Length of Stay (in days)
df['Length of Stay'] = (df['Discharge Date'] - df['Date of Admission']).dt.days

# Round Billing Amount to 2 decimals
df['Billing Amount'] = df['Billing Amount'].round(2)

# Standardize text columns
df['Gender'] = df['Gender'].str.strip().str.title()
df['Medical Condition'] = df['Medical Condition'].str.strip().str.title()
df['Admission Type'] = df['Admission Type'].str.strip().str.title()
df['Test Results'] = df['Test Results'].str.strip().str.title()
df['Medication'] = df['Medication'].str.strip().str.title()

print("\n Cleaning Done. Sample:\n", df[['Name','Length of Stay','Billing Amount']].head())


# ─────────────────────────────────────────
# STEP 3: EXPLORATORY DATA ANALYSIS (EDA)
# ─────────────────────────────────────────

# --- 3.1 Age Distribution Summary ---
print("\n  Age Summary:")
print(df['Age'].describe())

# Age Groups
df['Age Group'] = pd.cut(df['Age'],
                          bins=[0, 18, 35, 50, 65, 100],
                          labels=['Child', 'Young Adult', 'Middle Age', 'Senior', 'Elderly'])

print("\nAge Group Distribution:")
print(df['Age Group'].value_counts())


# --- 3.2 Most Common Medical Conditions ---
print("\n Top Medical Conditions:")
print(df['Medical Condition'].value_counts())


# --- 3.3 Admission Type Breakdown ---
print("\n Admission Type Counts:")
print(df['Admission Type'].value_counts())


# --- 3.4 Average Billing by Medical Condition ---
print("\n Avg Billing Amount by Condition:")
print(df.groupby('Medical Condition')['Billing Amount'].mean().sort_values(ascending=False).round(2))


# --- 3.5 Average Length of Stay by Admission Type ---
print("\n Avg Length of Stay by Admission Type:")
print(df.groupby('Admission Type')['Length of Stay'].mean().round(2))


# --- 3.6 Test Results Distribution ---
print("\n🔬 Test Results:")
print(df['Test Results'].value_counts())


# --- 3.7 Most Used Medications ---
print("\n Medication Frequency:")
print(df['Medication'].value_counts())


# --- 3.8 Insurance Provider vs Avg Billing ---
print("\n Avg Billing by Insurance Provider:")
print(df.groupby('Insurance Provider')['Billing Amount'].mean().sort_values(ascending=False).round(2))


# --- 3.9 Gender split ---
print("\n Gender Distribution:")
print(df['Gender'].value_counts())


# --- 3.10 Top 5 Hospitals by Patient Volume ---
print("\n Top 5 Hospitals by Patient Count:")
print(df['Hospital'].value_counts().head(5))


# ─────────────────────────────────────────
# STEP 4: EXPORT CLEAN DATA FOR SQL
# ─────────────────────────────────────────
df.to_csv("healthcare_cleaned.csv", index=False)
print("\n Clean CSV exported: healthcare_cleaned.csv")
