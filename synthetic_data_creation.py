import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from xgboost import XGBRegressor
from sklearn.metrics import r2_score, mean_absolute_error

np.random.seed(42)

# ===============================
# 1. LOAD SYNTHETIC DATA
# ===============================
syn = pd.read_csv("IMTA_V6.csv")
syn['datetime'] = pd.to_datetime(syn['datetime'])

syn['co2_proxy'] = syn['net_CO2_flux_gCO2']
syn_min = syn['co2_proxy'].min()
syn_max = syn['co2_proxy'].max()

# ===============================
# 2. FEATURE ENGINEERING
# ===============================
def create_features(df, col):
    df = df.copy()

    df['lag1'] = df[col].shift(1)
    df['lag2'] = df[col].shift(2)
    df['lag3'] = df[col].shift(3)
    df['lag6'] = df[col].shift(6)

    df['roll_mean'] = df[col].rolling(3).mean()
    df['roll_mean_long'] = df[col].rolling(6).mean()

    df['co2_diff'] = df[col].diff()

    df['hour'] = df['datetime'].dt.hour
    df['sin_hour'] = np.sin(2*np.pi*df['hour']/24)
    df['cos_hour'] = np.cos(2*np.pi*df['hour']/24)

    return df

# ===============================
# 3. TRAIN MODELS + RESIDUALS
# ===============================
syn['co2_scaled'] = syn['co2_proxy']
syn_feat = create_features(syn, 'co2_scaled').dropna()

features = [
    'co2_scaled',
    'lag1','lag2','lag3','lag6',
    'roll_mean','roll_mean_long',
    'co2_diff',
    'sin_hour','cos_hour'
]

X_syn = syn_feat[features]

target_columns = [
    'respiration_gCO2',
    'sequestration_gCO2',
    'DO_mgL',
    'NH3_mgL',
    'NO2_mgL',
    'NO3_mgL',
    'pH'
]

models = {}
residuals_dict = {}

for target in target_columns:
    model = XGBRegressor(n_estimators=400, max_depth=5, learning_rate=0.05)
    model.fit(X_syn, syn_feat[target])

    pred_syn = model.predict(X_syn)
    residuals = syn_feat[target] - pred_syn

    models[target] = model
    residuals_dict[target] = residuals.values

print("✅ Models trained")

# ===============================
# 4. LOAD REAL DATA
# ===============================
real = pd.read_csv("real_sensor_values.csv")

real['datetime'] = pd.to_datetime(real['timestamp'], format="%d-%m-%Y %H:%M")
real = real[['datetime','dissolved_co2']]
real = real.rename(columns={'dissolved_co2':'co2_proxy'})

# ===============================
# 5. CLEAN
# ===============================
real['co2_proxy'] = real['co2_proxy'].clip(
    lower=real['co2_proxy'].quantile(0.01),
    upper=real['co2_proxy'].quantile(0.99)
)

real['co2_proxy'] = real['co2_proxy'].rolling(2).mean()

# 🔥 reduced jitter (less artificial noise)
real['co2_proxy'] += np.random.normal(0, 1.2, len(real))

# ===============================
# 6. SCALE CO2
# ===============================
real_min = real['co2_proxy'].min()
real_max = real['co2_proxy'].max()

scaled = (real['co2_proxy'] - real_min) / (real_max - real_min)
real['co2_scaled'] = scaled * (syn_max - syn_min) + syn_min

# ===============================
# 7. FEATURES
# ===============================
real_feat = create_features(real, 'co2_scaled').dropna()

# ===============================
# 8. PREDICT + FIXED STOCHASTIC SYSTEM
# ===============================
X_real = real_feat[features]

alpha_base = 0.55  # reduced smoothing

for target in target_columns:
    base_pred = models[target].predict(X_real)

    # 🔥 centered residual noise (fix bias)
    noise = np.random.choice(residuals_dict[target], size=len(base_pred), replace=True)
    noise = noise - np.mean(noise)

    # 🔥 state-dependent scaling
    scale = 0.12 + 0.08 * (base_pred / (np.max(base_pred)+1e-6))
    noise = noise * scale

    # 🔥 mild non-linearity (NO new column)
    nonlinear = 0.02 * (base_pred**2) / (np.max(base_pred)**2 + 1e-6)

    series = base_pred + 0.12 * noise + nonlinear

    # 🔥 stochastic temporal memory
    for i in range(1, len(series)):
        alpha = alpha_base + np.random.normal(0, 0.04)
        alpha = np.clip(alpha, 0.35, 0.75)

        series[i] = alpha * series[i-1] + (1 - alpha) * series[i]

    # small independent noise
    series += np.random.normal(0, 0.008, len(series))

    real_feat[target] = series

# ===============================
# 9. BALANCED DRIFT (NO BIAS)
# ===============================
t = np.arange(len(real_feat))

trend = 0.04 * np.sin(2 * np.pi * t / 200)

rw = np.cumsum(np.random.normal(0, 0.0015, len(real_feat)))
rw = rw - np.mean(rw)

real_feat['respiration_gCO2'] += trend + rw
real_feat['sequestration_gCO2'] += 0.5 * (trend + rw)

# ===============================
# 10. CONSTRAINTS
# ===============================
real_feat['NH3_mgL'] = real_feat['NH3_mgL'].clip(0)
real_feat['NO2_mgL'] = real_feat['NO2_mgL'].clip(0)
real_feat['NO3_mgL'] = real_feat['NO3_mgL'].clip(0)
real_feat['DO_mgL'] = real_feat['DO_mgL'].clip(0)
real_feat['pH'] = real_feat['pH'].clip(6.5, 9)

real_feat['NH3_mgL'] = real_feat['NH3_mgL'].rolling(3).mean()

# ===============================
# 11. FINAL DATASET
# ===============================
final_df = real_feat[[
    'datetime','co2_proxy',
    'respiration_gCO2','sequestration_gCO2',
    'DO_mgL','NH3_mgL','NO2_mgL','NO3_mgL','pH'
]].dropna()

final_df.to_csv("hybrid_dataset_FINAL_FIXED.csv", index=False)

print("✅ FINAL DATASET CREATED")

# ===============================
# 12. VALIDATION (STRICT)
# ===============================
final_df['lag1'] = final_df['co2_proxy'].shift(1)
final_df['lag3'] = final_df['co2_proxy'].shift(3)

ml_df = final_df.dropna()

split = int(len(ml_df)*0.8)
gap = 12

train = ml_df.iloc[:split-gap].copy()
test  = ml_df.iloc[split:].copy()

# RESPIRATION
X_train = train[['co2_proxy','lag1','lag3']]
y_train = train['respiration_gCO2']

X_test = test[['co2_proxy','lag1','lag3']]
y_test = test['respiration_gCO2']

model = XGBRegressor(n_estimators=300)
model.fit(X_train, y_train)

pred = model.predict(X_test)

print("\n=== RESPIRATION MODEL ===")
print("R2:", r2_score(y_test, pred))
print("MAE:", mean_absolute_error(y_test, pred))

# SEQUESTRATION
train['light'] = (np.sin(2*np.pi*(train['datetime'].dt.hour-6)/24)+1)/2
test['light'] = (np.sin(2*np.pi*(test['datetime'].dt.hour-6)/24)+1)/2

train['co2_light'] = train['co2_proxy'] * train['light']
test['co2_light'] = test['co2_proxy'] * test['light']

train['co2_light_lag'] = train['co2_light'].shift(2)
test['co2_light_lag'] = test['co2_light'].shift(2)

train = train.dropna()
test = test.dropna()

X_train = train[['co2_proxy','lag1','lag3','co2_light','co2_light_lag']]
y_train = train['sequestration_gCO2']

X_test = test[['co2_proxy','lag1','lag3','co2_light','co2_light_lag']]
y_test = test['sequestration_gCO2']

model = XGBRegressor(n_estimators=400)
model.fit(X_train, y_train)

pred = model.predict(X_test)

print("\n=== SEQUESTRATION MODEL ===")
print("R2:", r2_score(y_test, pred))
print("MAE:", mean_absolute_error(y_test, pred))