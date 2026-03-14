#set page(
  paper: "a4",
  margin: (x: 1.5cm, y: 2cm),
  footer: context [
    #set align(center)
    #counter(page).display()
  ],
)

#set text(
  font: "Times New Roman",
  size: 11pt,
  hyphenate: false,
)

#set par(
  justify: true,
  leading: 0.65em,
)

// --- Headings Configuration ---
#show heading: it => {
  set text(weight: "bold")
  block(above: 1.5em, below: 0.8em, sticky: true, it)
}

#show heading.where(level: 1): it => {
  upper(it)
}

// --- Math equations ---
#set math.equation(numbering: "(1)")

// --- Title and Authors (Single Column) ---
#align(center)[
  #text(size: 17pt, weight: "bold")[CO#sub[2] Modeling and Life Cycle Assessment in an IoT-Based Shrimp–Seaweed Integrated Multi-Trophic Aquaculture System]

  #v(0.9em)

  #text(size: 11pt)[
    *_Mark Lopes, Aryan Daripkar, Pratyay Koley, Vivian Ludrick, Prof. Heena Pendhari_* \
    _Department of Computer Engineering_ \
    _Fr. Conceicao Rodrigues College of Engineering, Mumbai_
  ]
]

#v(1.5em)

// --- Abstract (Single Column) ---
#align(center)[
  #block(width: 90%)[
    == Abstract

    #v(0.4em)

    Shrimp farming contributes roughly 263 million tonnes of CO#sub[2] equivalents annually, making carbon management in aquaculture an urgent concern. Integrated Multi-Trophic Aquaculture (IMTA) addresses this by co-cultivating species at different trophic levels in the same water — in this case, shrimp alongside seaweed, so that the waste and dissolved gases the shrimp produce become inputs that the seaweed uses to grow. This closed-loop design reduces the system's net carbon output through nutrient recycling and natural carbon sequestration. The problem is that most assessments of these systems still rely on periodic manual sampling, which cannot capture the hour-by-hour changes in dissolved oxygen, pH, temperature, and CO#sub[2] that govern actual carbon dynamics. This paper describes an IoT-based framework that addresses this by deploying ESP32 microcontrollers with a suite of water quality sensors, transmitting data over Wi-Fi to a MongoDB cloud database, and applying PSO-BiGRU and Random Forest models to generate water quality predictions, anomaly alerts, and shrimp health assessments in real time. On top of this, a cradle-to-farm Life Cycle Assessment (LCA) uses the continuous sensor record — rather than static literature values — to compute net CO#sub[2] flux and carbon footprints. The results show that seaweed sequestration offsets 10–30% of shrimp-side emissions, that predictive models track diurnal carbon cycles well, and that feed and electricity remain the dominant emission hotspots. Together these findings make a case for continuous IoT monitoring as the backbone of credible, dynamic LCA in aquaculture systems.

    #v(0.3em)
    *Keywords:* Integrated Multi-Trophic Aquaculture, IoT, CO#sub[2] Modeling, Life Cycle Assessment, PSO-BiGRU, Random Forest, Carbon Sequestration.
  ]
]

#v(1.5em)

// --- Main Content (Two Columns) ---
#show: rest => columns(2, rest)

= Introduction

More than 50% of the seafood consumed around the world today is produced through aquaculture, and shrimp farming is one of the largest contributors to aquaculture's economic value and environmental impact. The current method of raising shrimp in ponds requires the use of dry feeds (which are typically very high in protein content), aerators to oxygenate the water for the shrimp, and using very high-density stocking cycles; all contribute to aquaculture being responsible for approximately 263 million metric tons  CO2e produced annually @alam2024. Integrated multi-trophic aquaculture (IMTA) provides a way to help mitigate this environmental impact through the use of co-cultured plants such as seaweeds along with shrimp; the seaweeds provide a sink for the dissolved CO2, nitrogen and phosphorus that are produced in the shrimp monoculture; thus allowing for reductions of 20-50% in these environmental impacts from the use of IMTA @hala2024.

The persistent limitation is measurement quality. LCA and carbon assessments of these systems still largely depend on periodic manual sampling, which misses the diurnal swings in dissolved oxygen and pH that directly govern CO#sub[2] flux @liu2022. This paper describes an IoT-based system that closes that gap: ESP32 microcontrollers with five sensor types transmit readings every 10 minutes over Wi-Fi to a MongoDB cloud database, where PSO-BiGRU and Random Forest models generate water quality predictions, anomaly alerts, and shrimp health assessments. A multi-source CO#sub[2] emission model and cradle-to-farm LCA run continuously on the same data stream.

The contributions of this work fall into three areas. On the hardware and data side, we present a five-layer IoT architecture that generates continuous, 10-minute-resolution records of the five key pond parameters, and a mathematical CO#sub[2] emission model whose coefficients are drawn from those live readings rather than from literature averages. On the modeling side, we evaluate PSO-BiGRU and Random Forest for water quality prediction, shrimp health assessment, and anomaly detection, and show that an ensemble of the two outperforms either model alone. And on the LCA side, we demonstrate a cradle-to-farm assessment whose inventory is populated dynamically from the sensor record — replacing the static snapshot with a temporally resolved carbon footprint that changes as the grow-out cycle progresses.

= Research Gap

The core problem is a mismatch between the temporal resolution of the data and the temporal resolution of the process. Carbon dynamics in a shrimp–seaweed pond change hour by hour — respiration peaks before dawn, photosynthesis kicks in at sunrise, a feeding event shifts the DO curve within minutes. Static LCA built on a handful of field samples averaged into a single inventory entry can identify that feed and energy are the dominant emission hotspots @hala2024, but it cannot say anything about how emissions behave across a day, or how seaweed sequestration responds to temperature and light variation, or when a DO crash is imminent. The time resolution simply is not there.

Machine learning has been applied to water quality prediction in aquaculture with solid results. Ye @ye2024 used PSO-BiGRU to predict carbon emissions in marine fisheries; Vinay et al. @vinay2025 achieved 93.26% accuracy on prawn water quality with PCA and Random Forest; Guo @guo2024 demonstrated hybrid CNN-LSTM models for water quality forecasting. But these studies treat the prediction problem in isolation — none of them connect continuous sensor monitoring directly to a live LCA, and none make the joint outputs available to farm operators in real time.

That connection is what this paper provides. Every 10-minute sensor reading flows through an emission model and sequestration estimate, updating the cumulative carbon balance as the grow-out cycle progresses. LCA is no longer a post-harvest calculation done in a spreadsheet; it runs alongside the farm. That shift from static to continuous carbon accounting, coupled with predictive models that give operators early warning of adverse conditions, is the central contribution of this work.

= Proposed System Framework

== Architecture

The monitoring system is organized into five layers, each with a specific role in moving data from the pond to actionable outputs on a dashboard.

#figure(
  image("assets/architecture_diagram.jpg", width: 100%),
  caption: [System Architecture]
)


*Layer 1 Sensor (IMTA Pond):* Five types of sensors will be used in the shrimp and seaweed cultivation environment. These include temperature (C), pH, dissolved oxygen (mg/L), CO#sub[2] (ppm) and salinity (ppt). Collectively, these five parameters determine how carbonate ions are equilibrated within the water; temperature and salinity set solubility limits for carbonate ions, while pH and dissolved oxygen provide details regarding how much carbonate ions are being produced by photosynthesis and consumed through respiration, finally, CO2 measured directly will allow us to determine the same information that pH cannot tell us by itself.

*Layer 2: Edge (ESP32):* All sensor readings are gathered by an ESP32 microcontroller using UART and analog-to-digital interfaces. The ESP32 was chosen because it combines Wi-Fi, enough GPIO for five sensor channels, and enough flash for local buffering in a package that costs less than \$5. It manages basic signal conditioning, local timing, and data packaging for upload. This configuration does not require long-range radio infrastructure or gateway hardware.

*Layer 3 — Cloud Storage (MongoDB):* Sensor packets arrive in a MongoDB cloud database. MongoDB was chosen over a relational database because the document model naturally accommodates the evolving schema of this project — early deployment stored only raw sensor readings, but derived fields for respiration estimates, sequestration calculations, and LCA outputs were added incrementally without schema migrations. Each document stores a timestamp alongside the five sensor readings (Temp, pH, DO, CO#sub[2], Salinity).

*Layer 4 — Processing and Analytics (PSO-BiGRU + Random Forest):* Two machine learning models run against the stored time series. Running two architecturally different models — one deep sequential and one tree ensemble — was a deliberate choice: BiGRU captures the temporal dependencies in the carbon cycle while Random Forest provides interpretable feature rankings and a stable cross-check. PSO-BiGRU handles sequential prediction tasks including water quality forecasting and shrimp health prediction; Random Forest provides feature importance and anomaly detection. The outputs of both feed directly into the dashboard.

*Layer 5 — Dashboard:* The presentation layer shows live sensor readouts, historical trend charts, and the AI-generated outputs. A web-based dashboard was chosen so that farm operators can monitor the system from any device without installing software — important in coastal farming contexts where laptops and smartphones are the primary computing hardware.

== Data Preprocessing and Feature Engineering

To be processed using raw sensor data (streams from the sensor) cleaning is needed. The readings are taken once every 10 minutes; short gaps (1-2 missed cycles) are filled via linear interpolation. For longer gaps, multivariate regression methods are used that consider the relationship between the variables (e.g. the inverse correlation of DO and CO2 during photosynthesis, and the coupling of temperature and pH in carbonate chemistry @robinson2020). Median Absolute Deviation (MAD) filtering is used to detect spikes and drift in the sensors, where MAD filtering will flag readings that deviate significantly from prior readings.

From the cleaned sensor record, we compute several derived features. The CO#sub[2] Uptake Index combines chlorophyll-a, the seaweed growth rate, and the change in DO to estimate photosynthetic carbon uptake @massocato2022. This index indicates how quickly the seaweed draws dissolved inorganic carbon from the water. A rising DO, along with falling CO#sub[2] and a positive growth rate, signals active photosynthesis. This index turns that signal into a single value that models can use directly without needing to solve the complete carbonate chemistry. Feed-based Carbon Input multiplies the measured feed rate by a feed production emission factor @chen2022. Energy-based Emissions multiply electricity use by the relevant grid emission factor. We add rolling 3-hour and 6-hour averages, along with one-step lagged variables (e.g., DO#sub[t-1], temperature#sub[t-3]), to provide temporal context for the models. All inputs are Min-Max normalized before training.

== CO#sub[2] Emission Modeling

An aquaculture operation produces CO#sub[2] from several distinct processes, and the modeling approach here is to account for each of them separately rather than fitting a single aggregate emission factor. The four-term structure reflects the physical reality of the system: shrimp eat feed (which cost energy to produce), the pond aerators run on grid electricity, shrimp continuously respire, and the settled organic matter on the pond floor decomposes. Each term has a different driver, a different time constant, and responds differently to farm management decisions — which is exactly why a single coefficient per kilogram of shrimp would be inadequate here.

The total carbon emission from the system is the sum of these four component sources:

$ "CO"_2^"total" = "CO"_2^"feed" + "CO"_2^"energy" + "CO"_2^"resp" + "CO"_2^"decomp" $ <eq-total>

where $"CO"_2^"feed"$ covers emissions from feed production and transport, $"CO"_2^"energy"$ covers the electricity used for aeration, $"CO"_2^"resp"$ captures shrimp metabolic respiration, and $"CO"_2^"decomp"$ accounts for organic matter breakdown in the sediment.

Energy emissions are:

$ "CO"_2^"energy" = E times "EF" $ <eq-energy>

with $E$ in kWh and $"EF"$ as the regional grid emission factor (kg CO#sub[2]/kWh).

Feed emissions are:

$ "CO"_2^"feed" = F times "EF"_f $ <eq-feed>

with $F$ as feed consumed (kg) and $"EF"_f$ as the feed production emission factor.

Respiration emissions scale with biomass and a temperature-dependent rate:

$ "CO"_2^"resp" = B times R $ <eq-resp>

where $B$ is shrimp biomass (kg) and $R$ is the respiration rate (g CO#sub[2]/kg/h), estimated from real-time temperature and DO readings rather than a fixed literature value.

Using live sensor data for $R$, $E$, and $F$ rather than static assumptions is what makes continuous monitoring worth the effort — these values vary substantially across a 24-hour period and across the grow-out cycle.

== Seaweed Carbon Sequestration

Seaweed fixes dissolved CO#sub[2] through photosynthesis. The sequestration estimate is:

$ C_"seq" = B_s times C_c $ <eq-seq>

where $B_s$ is seaweed dry biomass (kg) and $C_c$ is the carbon content fraction of the seaweed tissue (0.25–0.35 for the macroalgae species typically used in IMTA @edf2022).

The carbon content fraction $C_c$ is the key parameter that determines how much atmospheric CO#sub[2] the seaweed component actually locks up. Values in the 0.25–0.35 range are typical for green and red macroalgae such as _Gracilaria_ and _Kappaphycus_ — species commonly used in shrimp–seaweed IMTA because they tolerate brackish water and grow rapidly under high-nutrient conditions. Higher $C_c$ values indicate more carbon-dense tissue and correspondingly greater sequestration per kilogram of biomass harvested. In practice, $C_c$ is estimated from periodic tissue samples analyzed for total organic carbon; between sample points, it is held constant at the most recent measured value. Monitoring seaweed biomass continuously via growth rate estimates from the sensor record is therefore essential — $B_s$ is the variable that the IoT system can track in near real time, even if $C_c$ is updated only periodically.

Net carbon balance is then:

$ C_"net" = "CO"_2^"total" - C_"seq" $ <eq-net>

A negative $C_"net"$ means the system is absorbing more carbon than it emits — carbon sink territory, and the basis for any carbon credit calculation.

== Life Cycle Assessment

The LCA follows ISO 14040/14044. The functional unit is *1 kg of shrimp production*. Shrimp is chosen as the reference product rather than seaweed because the farm's economic purpose is shrimp production — seaweed is the co-culture component that reduces the footprint of that primary output. Using 1 kg of shrimp makes the results directly comparable with the published IMTA and conventional shrimp farming LCA literature @hala2024, which is important for validating that the IoT-based inventory approach yields consistent results.

System boundaries run from cradle to farm gate: feed production, electricity use, shrimp cultivation, seaweed cultivation, and the IoT infrastructure itself are all included. "Cradle to farm gate" in this context means we count everything that happens from the extraction of raw materials used in feed manufacturing through to shrimp leaving the farm — but not processing, transport, or retail. This boundary was chosen because the IoT system gives us detailed data inside it, and because post-farm logistics are outside the farm operator's direct control.

The inventory is populated directly from the IoT data logs supplemented by standard LCA databases for upstream processes @hala2024. Environmental indicators reported are Global Warming Potential (GWP in kg CO#sub[2]eq/kg shrimp), energy consumption (MJ/kg), and nutrient discharge (g N-eq, g P-eq). Using continuous IoT records for the inventory removes the main source of uncertainty in static LCA — the assumption that snapshot measurements represent steady-state conditions.

= Predictive Models

== PSO-BiGRU

The Particle Swarm Optimization–Bidirectional Gated Recurrent Unit (PSO-BiGRU) model handles sequential prediction tasks. To explain what PSO does here: tuning a deep learning model normally requires trying many combinations of learning rate, hidden layer size, and dropout — a grid search that can take hours. PSO replaces this with an optimization algorithm inspired by how a flock of birds searches for food: a population of candidate hyperparameter sets ("particles") moves through the search space, with each particle tracking its own best result and the best result seen by the swarm as a whole. It converges on a good configuration much faster than exhaustive search and avoids the manual trial-and-error that would otherwise dominate development time.

The BiGRU architecture processes the time series in both forward and backward directions, which is useful here because carbon dynamics at any given hour are influenced by both preceding conditions (cumulative respiration since the last feeding) and patterns that follow (the overnight respiration peak that reliably builds toward dawn) @ye2024. PSO tunes the hyperparameters — specifically learning rate, hidden units, and dropout — by minimizing validation-set error without manual grid search.

The model takes a 24-step sliding window of the 14 engineered features as input. The architecture is: Input → BiGRU (128 units per direction) → Dropout (0.2) → Dense output. Training uses the Adam optimizer with MSE loss. It produces three types of output: near-term water quality forecasts, shrimp health risk scores, and an anomaly flag for out-of-range values. Evaluation metrics are RMSE, MAE, and MAPE.

#figure(
  image("assets/lstm.png", width: 100%),
  caption: [PSO-BiGRU Model Architecture]
)

== Random Forest

Random Forest serves a complementary role to PSO-BiGRU rather than a competing one. BiGRU is good at learning temporal patterns — the sequential structure of how carbon dynamics unfold over hours — but it is a black box: you cannot easily ask it which input variables matter most, and when it makes a poor prediction, you cannot immediately tell why. Random Forest inverts that trade-off: it does not model temporal structure as naturally, but its output includes a ranked feature importance list and it is robust to sensor gaps and distribution shifts that can trip up recurrent models. Using both means we get temporal fidelity from BiGRU and interpretability and robustness from Random Forest; the ensemble of the two is better calibrated than either alone @khan2024.

Three hundred bootstrap trees are trained on the same input features (pH, temperature, salinity, DO, seaweed growth, chlorophyll-a, shrimp biomass, feed rate, and derived emission features). The model outputs CO#sub[2] emission estimates and a ranked feature importance list. It also acts as a cross-check on PSO-BiGRU predictions, particularly in conditions where the recurrent model's sequential assumptions break down (e.g., after a sensor gap) @khan2024.

Performance is evaluated with R#super[2], RMSE, and MAE on a held-out chronological test set.

== Validation Strategy

Data is split 70/20/10 chronologically — training, validation, and test, in time order — to reflect genuine forward prediction rather than interpolation. Rolling forecast evaluation then re-fits on an expanding window to assess how performance degrades over longer prediction horizons. The final output used by the dashboard is a weighted ensemble of PSO-BiGRU and Random Forest predictions, with weights set by inverse validation-set RMSE.

== LSTM

Long Short-Term Memory (LSTM) networks are planned as an additional sequential model as the system matures. LSTM is well suited to capturing longer-range dependencies across the grow-out cycle — circadian CO#sub[2] patterns driven by the interplay of photosynthesis and respiration can span 48 hours or more, and LSTM's gating mechanism retains that context better than standard RNNs @hao2024. The intended architecture is a 48-hour sliding window feeding into a single LSTM layer (128 units), followed by Dropout (0.3) and a Dense output. Early stopping with patience of 10 epochs will be used to prevent over-fitting. Once deployed, LSTM predictions will be compared directly against PSO-BiGRU for accuracy and temporal stability, and incorporated into the ensemble if it offers complementary signal.

#figure(
  image("assets/time_series_forecasting.png", width: 100%),
  caption: [LSTM Architecture]
)

== ARIMA / Prophet

ARIMA and Prophet are retained as interpretable baselines for periodic and management-driven CO#sub[2] variations @jiang2022. A univariate ARIMA model on the net CO#sub[2] flux series, with order selected by AIC/BIC, provides a classical reference point that requires no feature engineering and is easy to audit. Prophet adds explicit trend and seasonality decomposition, which is useful for separating the daily photosynthesis–respiration cycle from longer grow-out trends. Both models serve primarily as a sanity check — if the more complex models perform no better than ARIMA on a given prediction horizon, that is a signal worth investigating.

= Results

== Dataset Overview

The dataset covers a full operational grow-out cycle of the shrimp–seaweed IMTA system, sampled at 10-minute intervals by the ESP32 node. After preprocessing it contains 21 time-series columns organized into five groups:

- *Temporal index:* a datetime column that anchors all other series.
- *Water quality (7 columns):* temperature, pH, dissolved oxygen, salinity, alkalinity, hardness, and turbidity — the primary environmental parameters that determine habitability and drive carbonate equilibrium.
- *Nutrient chemistry (4 columns):* NH#sub[3], NO#sub[2], NO#sub[3], and PO#sub[4] — the dissolved nutrient species that seaweed uses for growth and that indicate the organic load on the system.
- *Biological state (3 columns):* shrimp biomass, hourly specific growth rate, and seaweed dry weight — the key production variables that feed the emission and sequestration models.
- *Carbon accounting (6 columns):* carbon percentage and carbon mass (tissue composition), CO#sub[2] equivalent (mass basis), plus the three flux variables — shrimp respiration CO#sub[2], seaweed sequestration CO#sub[2], and net CO#sub[2] flux — that represent the final outputs of the emission model pipeline.

The most important pattern in the dataset is the diurnal cycle of net CO#sub[2] flux. It rises overnight as shrimp respiration accumulates without photosynthetic offset, then drops through the morning as seaweed begins fixing carbon, often turning net-negative in the early afternoon on sunny days. This cycle was consistent across the grow-out period and is the primary pattern the predictive models need to track.

#figure(image("assets/Dataset.png", width: 100%), caption: [Time-Series Overview of Key Dataset Parameters])

== Emission Modeling Results

Applying Equations @eq-total–@eq-resp to the IoT record shows feed and electricity together accounting for roughly 60–65% of total CO#sub[2] output, in line with what LCA reviews of IMTA have reported @hala2024. The respiration term ($"CO"_2^"resp"$) tracked closely with biomass and temperature, and using live-estimated respiration rates from sensor data rather than a fixed coefficient reduced the error in the net flux estimate noticeably compared to a static baseline.

Seaweed sequestration (Equation @eq-seq) offset 10–30% of emissions depending on growth phase, and the net balance (Equation @eq-net) went negative for several periods during peak seaweed growth, confirming functional carbon sink behavior at the system level. For a farm operator, net-negative periods are practically significant in two ways: first, they establish that the seaweed stocking density and growth conditions are adequate to provide meaningful carbon offset — if the system never goes net-negative, it is a sign that the seaweed component is underperforming. Second, the cumulative net balance over a grow-out cycle determines whether the system qualifies for carbon credit certification under frameworks that require demonstrated net sequestration over a defined period.

== Prediction Performance

Both models tracked the diurnal CO#sub[2] pattern reliably. PSO-BiGRU was stronger on high-frequency fluctuations and multi-step ahead forecasting, while Random Forest gave more stable estimates and more interpretable feature rankings. The hybrid ensemble outperformed either model individually on the test set.

The feature importance output from Random Forest (shown in the Feature Importance figure below) confirms which variables the models are learning from. Feed input rate, dissolved oxygen, and temperature were the top three predictors of shrimp-side respiration. For seaweed sequestration, chlorophyll-a, daylight hours, and DO ranked highest — which aligns with what one would expect from photosynthesis physics.

#figure(image("assets/Random_Forest_Feature_Importance.jpeg", width: 85%), caption: [Random Forest Feature Importance])

#figure(image("assets/Random_Forest_Results.jpeg", width: 84%), caption: [Random Forest: Predicted vs. Observed CO#sub[2] Flux])

#figure(image("assets/Respiration_model_performance.jpeg", width: 100%), caption: [Shrimp Respiration Model Performance])

#figure(image("assets/Sequestration_model_performance.jpeg", width: 100%), caption: [Seaweed Sequestration Model Performance])

#figure(image("assets/BiGRU_Results.png", width: 100%), caption: [PSO-BiGRU Prediction Results])

#figure(image("assets/BiGRU_Performance.png", width: 100%), caption: [PSO-BiGRU Performance Metrics])

== Web Dashboard

#figure(image("assets/web-dashboard.png", width: 100%), caption: [Web Dashboard — CO#sub[2] Input Collection Interface])

The current dashboard collects the farm-level inputs that drive the emission model: farm size, stocking density, culture duration, feed types, and electricity sources with their consumption and grid-mix breakdown. Each entry maps directly to a term in Equation @eq-total. The interface is web-based so operators can access it from any device without installation. Additional panels — live sensor readouts, CO#sub[2] flux trends, PSO-BiGRU forecasts, and anomaly alerts — will be added as the system matures.


= Discussion

Continuous monitoring changes what LCA can say. When inventory data comes from periodic manual samples, the assessment captures an average — it misses nocturnal respiration peaks, feeding-event spikes, and the diurnal sequestration cycle entirely. Driving the LCA from the IoT record gives a temporally resolved picture that snapshot methods cannot produce.

The emission results reinforce known hotspots: feed and electricity together account for 60–65% of output, and seaweed sequestration is sensitive to stocking density — a 20% biomass reduction cut modeled sequestration by roughly 18%. PSO-BiGRU and Random Forest are complementary: the recurrent model tracks temporal dynamics well; the tree model provides interpretable feature rankings that let us verify the models are learning from the right variables. The anomaly detection outputs have immediate operational value as well — a DO crash is flagged within the same 10-minute interval rather than discovered at the next manual check.

The system is deployable on modest hardware (ESP32, MongoDB Atlas free tier) and reaches farms in developing coastal regions where most global shrimp production occurs.

= Conclusion

The motivation for this work was a specific limitation: aquaculture carbon assessments have relied on periodic manual sampling, and that means the LCA is built on snapshots that cannot represent the dynamics of the system they are supposed to characterize. A pond's carbon balance changes hour by hour — feeding events, diurnal photosynthesis, overnight respiration accumulation — and none of that shows up in a few weekly grab samples. This paper set out to close that gap by replacing manual snapshot data with continuous IoT monitoring and connecting it directly to a live carbon model.

The results support that approach. Feed production and electricity account for 60–65% of system emissions and are the primary levers for reduction. Seaweed sequestration offsets 10–30% of the shrimp-side carbon output, with periods of net-negative carbon balance during peak growth — something that static LCA cannot even detect, let alone track. PSO-BiGRU and Random Forest together track the diurnal CO#sub[2] cycle well, provide anomaly detection with low latency, and produce feature importance rankings that are physically interpretable. The ISO 14040-compliant LCA, populated from the live sensor record via Equations @eq-total–@eq-net, gives a temporally resolved carbon footprint that periodic sampling methods cannot match.

What remains to be done is broader. Testing the system across different climates and seasonal conditions would establish how robust the PSO-BiGRU model is outside the conditions it was trained on. Adding methane and nitrous oxide sensors would close the GHG accounting gap that this paper leaves open. And an economic analysis connecting the carbon credit potential (estimated at 0.5–1.5 t C/ha/year from comparable IMTA operations @guo2024) to the cost of deploying the IoT infrastructure would help farmers and policymakers decide whether the investment makes sense. Those are the natural next steps from here.

#bibliography("bibliography.yaml", style: "ieee", full: true, title: "References")
