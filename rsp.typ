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

    Shrimp farming contributes roughly 263 million tonnes of CO#sub[2] equivalents annually, making carbon management in aquaculture an urgent concern. Integrated Multi-Trophic Aquaculture (IMTA) — where shrimp are co-cultivated with seaweed — offers a practical path to reduce this footprint through nutrient recycling and natural carbon sequestration. The problem is that most assessments of these systems still rely on periodic manual sampling, which cannot capture the hour-by-hour changes in dissolved oxygen, pH, temperature, and CO#sub[2] that govern actual carbon dynamics. This paper describes an IoT-based framework that addresses this by deploying ESP32 microcontrollers with a suite of water quality sensors, transmitting data over Wi-Fi to a MongoDB cloud database, and applying PSO-BiGRU and Random Forest models to generate water quality predictions, anomaly alerts, and shrimp health assessments in real time. On top of this, a cradle-to-farm Life Cycle Assessment (LCA) uses the continuous sensor record — rather than static literature values — to compute net CO#sub[2] flux and carbon footprints. The results show that seaweed sequestration offsets 10–30% of shrimp-side emissions, that predictive models track diurnal carbon cycles well, and that feed and electricity remain the dominant emission hotspots. Together these findings make a case for continuous IoT monitoring as the backbone of credible, dynamic LCA in aquaculture systems.

    #v(0.3em)
    *Keywords:* Integrated Multi-Trophic Aquaculture, IoT, CO#sub[2] Modeling, Life Cycle Assessment, PSO-BiGRU, Random Forest, Carbon Sequestration.
  ]
]

#v(1.5em)

// --- Main Content (Two Columns) ---
#show: rest => columns(2, rest)

= Introduction

Aquaculture now supplies more than half of all seafood consumed globally, and demand keeps rising. Shrimp farming in particular has grown into one of the most economically important sectors, but it comes with a disproportionate environmental cost. Aerating ponds around the clock, manufacturing high-protein feeds, and managing dense stocking densities all drive significant greenhouse gas emissions — aquaculture as a whole produces around 263 million tonnes of CO#sub[2] equivalents per year, and shrimp sits near the top of that figure @alam2024.

One of the more practical responses to this problem is Integrated Multi-Trophic Aquaculture (IMTA). The idea is straightforward: instead of growing one species in isolation, you combine species from different trophic levels so that the waste from one becomes a resource for another. In shrimp–seaweed IMTA, seaweed absorbs the dissolved CO#sub[2], nitrogen, and phosphorus that shrimp metabolic activity releases, reducing both the nutrient discharge and the carbon footprint of the system @hala2024. Studies have found that IMTA can cut environmental impacts by 20–50% relative to conventional monoculture, and that seaweed alone can sequester 10–30% of the CO#sub[2] produced on the shrimp side @hala2024.

The persistent limitation is measurement. Most published assessments of IMTA carbon dynamics still rely on infrequent manual sampling — someone goes out to the pond a few times a week, collects water, and sends it to a lab. That approach misses the diurnal swings in dissolved oxygen and pH that directly govern CO#sub[2] flux, and it means any Life Cycle Assessment (LCA) built on that data is working with averages that may not reflect what is actually happening in the water @liu2022. Real-time continuous monitoring would solve this, but translating raw sensor streams into reliable carbon estimates requires more than just hardware.

This paper describes a system that puts those pieces together. An ESP32-based sensor network collects temperature, pH, dissolved oxygen, CO#sub[2], and salinity readings continuously from a shrimp–seaweed IMTA pond. The data moves over Wi-Fi to a MongoDB cloud database, where PSO-optimized BiGRU and Random Forest models produce water quality predictions, anomaly alerts, and shrimp health assessments. A mathematical CO#sub[2] emission model and ISO 14040-compliant LCA run on top of the same data stream, giving operators a live view of net carbon balance.

The specific contributions of this work are as follows. First, we deploy and characterize a five-layer IoT monitoring architecture tuned to the needs of an IMTA environment. Second, we formulate a multi-source CO#sub[2] emission model with terms for feed, energy, respiration, and decomposition, calibrated from continuous sensor data rather than static assumptions. Third, we quantify seaweed sequestration using IoT-tracked biomass, and compute net carbon balance from Equations that directly reference sensor outputs. Fourth, we implement PSO-BiGRU and Random Forest models and compare their performance on water quality prediction and anomaly detection. Fifth, we conduct a cradle-to-farm LCA whose inventory is populated from the live IoT record.

= Research Gap

The core limitation in existing IMTA sustainability work is the reliance on static, infrequent measurements as inputs to otherwise sophisticated models. LCA studies of IMTA have done a good job identifying feed and energy as the dominant emission hotspots @hala2024, and machine learning has been applied to water quality prediction with solid results @ye2024 @guo2024. What has not been done is to bring these two threads together into a single operational system — one where continuous IoT data feeds both a predictive model and a live LCA, and where the outputs are visible to farm operators in real time. That is the gap this paper targets.

= Proposed System Framework

== Architecture

The monitoring system is organized into five layers, each with a specific role in moving data from the pond to actionable outputs on a dashboard.

*Layer 1 — Sensors (IMTA Pond):* Five sensor types are deployed directly in the shrimp–seaweed cultivation environment: temperature (°C), pH, dissolved oxygen (mg/L), CO#sub[2] (ppm), and salinity (ppt). These cover the parameters most directly linked to carbon dynamics and shrimp health.

*Layer 2 — Edge (ESP32):* An ESP32 microcontroller collects readings from all sensors via UART and analog-to-digital interfaces. The ESP32 handles local timing, basic signal conditioning, and packages the data for upload. Wi-Fi is used for transmission — no gateway hardware or long-range radio infrastructure is required in this setup.

*Layer 3 — Cloud Storage (MongoDB):* Sensor packets arrive in a MongoDB cloud database. Each document stores a timestamp alongside the five sensor readings (Temp, pH, DO, CO#sub[2], Salinity). MongoDB's flexible schema made it straightforward to add derived fields — respiration estimates, sequestration calculations, LCA outputs — as the processing pipeline evolved.

*Layer 4 — Processing and Analytics (PSO-BiGRU + Random Forest):* Two machine learning models run against the stored time series. PSO-BiGRU handles sequential prediction tasks, including water quality forecasting and shrimp health prediction. Random Forest provides feature importance and anomaly detection. The outputs of both models — water quality predictions, anomaly flags, and shrimp health assessments — feed directly into the dashboard.

*Layer 5 — Dashboard:* The presentation layer shows live sensor readouts, historical trend charts, and the AI-generated outputs. Operators can see current conditions, projected near-term values, and any active anomaly alerts from a single interface.

#figure(
  image("assets/architecture_diagram.jpg", width: 100%),
  caption: [System Architecture: IMTA Pond → ESP32 → MongoDB → PSO-BiGRU/RF → Dashboard]
)

== Data Preprocessing and Feature Engineering

Raw sensor streams require cleaning before use. Short gaps in the time series (\<3 hours) are filled by linear interpolation; longer gaps use multivariate regression that respects known relationships between variables — for instance the inverse correlation between DO and CO#sub[2] under photosynthesis, or the temperature-pH coupling in carbonate chemistry @robinson2020. Spikes and sensor drift are caught by Median Absolute Deviation (MAD) filtering, which flags readings that deviate abnormally from their local window.

From the cleaned sensor record, several derived features are computed. The CO#sub[2] Uptake Index combines chlorophyll-a, seaweed growth rate, and the change in DO to approximate photosynthetic carbon uptake @massocato2022. Feed-based Carbon Input multiplies the measured feed rate by a feed production emission factor @chen2022. Energy-based Emissions multiply electricity draw by the applicable grid emission factor. Rolling 3-hour and 6-hour averages and one-step lagged variables (e.g., DO#sub[t-1], temperature#sub[t-3]) are added to give the models temporal context. All inputs are Min-Max normalized before training.

== CO#sub[2] Emission Modeling

The total carbon emission from the system is the sum of four component sources:

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

Net carbon balance is then:

$ C_"net" = "CO"_2^"total" - C_"seq" $ <eq-net>

A negative $C_"net"$ means the system is absorbing more carbon than it emits — carbon sink territory, and the basis for any carbon credit calculation.

== Life Cycle Assessment

The LCA follows ISO 14040/14044 and uses *1 kg of shrimp production* as the functional unit. System boundaries run from cradle to farm gate, covering feed production, electricity use, shrimp cultivation, seaweed cultivation, and the IoT infrastructure itself. The inventory is populated directly from the IoT data logs supplemented by standard LCA databases for upstream processes @hala2024. Environmental indicators reported are Global Warming Potential (GWP in kg CO#sub[2]eq/kg shrimp), energy consumption (MJ/kg), and nutrient discharge (g N-eq, g P-eq). Using continuous IoT records for the inventory removes the main source of uncertainty in static LCA — the assumption that snapshot measurements represent steady-state conditions.

= Predictive Models

== PSO-BiGRU

The Particle Swarm Optimization–Bidirectional Gated Recurrent Unit (PSO-BiGRU) model handles sequential prediction tasks. The BiGRU architecture processes the time series in both forward and backward directions, which is useful here because carbon dynamics at any given hour are influenced by both preceding conditions (cumulative respiration since the last feeding) and patterns that follow (the overnight respiration peak that reliably builds toward dawn) @ye2024. PSO tunes the hyperparameters — specifically learning rate, hidden units, and dropout — by minimizing validation-set error without manual grid search.

The model takes a 24-step sliding window of the 14 engineered features as input. The architecture is: Input → BiGRU (128 units per direction) → Dropout (0.2) → Dense output. Training uses the Adam optimizer with MSE loss. It produces three types of output: near-term water quality forecasts, shrimp health risk scores, and an anomaly flag for out-of-range values. Evaluation metrics are RMSE, MAE, and MAPE.

#figure(
  image("assets/lstm.png", width: 100%),
  caption: [PSO-BiGRU Model Architecture]
)

== Random Forest

Random Forest serves a different role: it is better suited for interpreting which variables matter most and for flagging anomalous readings through isolation-based outlier detection. Three hundred bootstrap trees are trained on the same input features (pH, temperature, salinity, DO, seaweed growth, chlorophyll-a, shrimp biomass, feed rate, and derived emission features). The model outputs CO#sub[2] emission estimates and a ranked feature importance list. It also acts as a cross-check on PSO-BiGRU predictions, particularly in conditions where the recurrent model's sequential assumptions break down (e.g., after a sensor gap) @khan2024.

Performance is evaluated with R#super[2], RMSE, and MAE on a held-out chronological test set.

== Validation Strategy

Data is split 70/20/10 chronologically — training, validation, and test, in time order — to reflect genuine forward prediction rather than interpolation. Rolling forecast evaluation then re-fits on an expanding window to assess how performance degrades over longer prediction horizons. The final output used by the dashboard is a weighted ensemble of PSO-BiGRU and Random Forest predictions, with weights set by inverse validation-set RMSE.

= Results

== Dataset Overview

The dataset covers a full operational grow-out cycle of the shrimp–seaweed IMTA system, sampled at 1–5 minute intervals by the ESP32 node. After preprocessing it contains 21 time-series columns: a datetime index, seven water quality parameters (temperature, pH, DO, salinity, alkalinity, hardness, turbidity), four nutrient parameters (NH#sub[3], NO#sub[2], NO#sub[3], PO#sub[4]), three biological parameters (shrimp biomass, hourly specific growth rate, seaweed dry weight), three carbon composition fields (carbon percentage, carbon mass, CO#sub[2] equivalent), and three carbon flux variables (shrimp respiration CO#sub[2], seaweed sequestration CO#sub[2], net CO#sub[2] flux).

The most important pattern in the dataset is the diurnal cycle of net CO#sub[2] flux. It rises overnight as shrimp respiration accumulates without photosynthetic offset, then drops through the morning as seaweed begins fixing carbon, often turning net-negative in the early afternoon on sunny days. This cycle was consistent across the grow-out period and is the primary pattern the predictive models need to track.

#figure(image("assets/Dataset.png", width: 100%), caption: [Time-Series Overview of Key Dataset Parameters])

== Emission Modeling Results

Applying Equations @eq-total–@eq-resp to the IoT record shows feed and electricity together accounting for roughly 60–65% of total CO#sub[2] output, in line with what LCA reviews of IMTA have reported @hala2024. The respiration term ($"CO"_2^"resp"$) tracked closely with biomass and temperature, and using live-estimated respiration rates from sensor data rather than a fixed coefficient reduced the error in the net flux estimate noticeably compared to a static baseline.

Seaweed sequestration (Equation @eq-seq) offset 10–30% of emissions depending on growth phase, and the net balance (Equation @eq-net) went negative for several periods during peak seaweed growth, confirming functional carbon sink behavior at the system level.

== Prediction Performance

Both models tracked the diurnal CO#sub[2] pattern reliably. PSO-BiGRU was stronger on high-frequency fluctuations and multi-step ahead forecasting, while Random Forest gave more stable estimates and more interpretable feature rankings. The hybrid ensemble outperformed either model individually on the test set.

The feature importance output from Random Forest is shown in Figure 4. Feed input rate, dissolved oxygen, and temperature were the top three predictors of shrimp-side respiration. For seaweed sequestration, chlorophyll-a, daylight hours, and DO ranked highest — which aligns with what one would expect from photosynthesis physics.

#figure(image("assets/Random_Forest_Feature_Importance.jpeg", width: 100%), caption: [Random Forest Feature Importance])

#figure(image("assets/Random_Forest_Results.jpeg", width: 100%), caption: [Random Forest: Predicted vs. Observed CO#sub[2] Flux])

#figure(image("assets/Respiration_model_performance.jpeg", width: 100%), caption: [Shrimp Respiration Model Performance])

#figure(image("assets/Sequestration_model_performance.jpeg", width: 100%), caption: [Seaweed Sequestration Model Performance])

#figure(image("assets/BiGRU_Results.png", width: 100%), caption: [PSO-BiGRU Prediction Results])

#figure(image("assets/BiGRU_Performance.png", width: 100%), caption: [PSO-BiGRU Performance Metrics])

= Discussion

The most practically useful finding here is that continuous monitoring changes what LCA can say about aquaculture systems. When inventory data comes from a handful of manual samples, the LCA is really just an average — it cannot tell you what happens at night, or during a feeding event, or when water temperature spikes. Feeding the LCA from the IoT record instead gives you a distribution of carbon outcomes across real operating conditions, and that is a more honest picture of system performance.

On the sequestration side, seaweed worked as expected during daylight hours under normal growth conditions, but its contribution was sensitive to seaweed density and light availability. A 20% reduction in seaweed biomass reduced modeled sequestration by roughly 18%, which suggests that maintaining adequate stocking of the seaweed component is not just ecologically important but critical to the carbon accounting of the system. Feed management is the other high-leverage point — variation in feed quality and sourcing drove the largest shifts in total CO#sub[2] output, which is consistent with what @hala2024 found in their LCA review (40–60% of emissions attributable to feed).

The PSO-BiGRU model handled the sequential structure of the data well, particularly the overnight respiration buildup that resets each morning with the onset of photosynthesis. Random Forest's contribution was less about temporal accuracy and more about transparency — its feature importance output gave us a way to check that the models were learning from the right variables rather than from spurious correlations. Both are necessary: one for performance, one for trust.

One aspect worth noting is that the anomaly detection outputs from the system have direct operational value. When DO drops sharply — a common precursor to shrimp stress or mortality events — the model flags it within the same sampling interval rather than waiting for a manual check. That kind of fast response is difficult to achieve without continuous monitoring, and its value goes beyond carbon accounting into day-to-day farm management.

The framework described here is scalable to small and medium farms without substantial infrastructure investment. The ESP32 is inexpensive and widely available; MongoDB Atlas has a free tier adequate for a single-pond deployment; and the models are lightweight enough to be retrained periodically on a standard cloud instance. Farms in developing coastal regions — where most global shrimp production occurs — are therefore reachable with this approach, which matters if the goal is any kind of broad uptake.

= Conclusion

This paper set out to show that IoT-based continuous monitoring, combined with PSO-BiGRU and Random Forest models and a dynamic LCA, can provide a more accurate and operationally useful picture of carbon dynamics in shrimp–seaweed IMTA than conventional static assessment methods.

The results support that claim. Feed production and electricity account for 60–65% of system emissions and are the primary levers for reduction. Seaweed sequestration offsets 10–30% of the shrimp-side carbon output, with periods of net-negative carbon balance during peak growth. PSO-BiGRU and Random Forest together track the diurnal CO#sub[2] cycle well, provide anomaly detection with low latency, and produce feature importance rankings that are physically interpretable. The ISO 14040-compliant LCA, populated from the live sensor record via Equations @eq-total–@eq-net, gives a temporally resolved carbon footprint that static snapshot methods cannot match.

What remains to be done is broader. Testing the system across different climates and seasonal conditions would establish how robust the PSO-BiGRU model is outside the conditions it was trained on. Adding methane and nitrous oxide sensors would close the GHG accounting gap that this paper leaves open. And an economic analysis connecting the carbon credit potential (estimated at 0.5–1.5 t C/ha/year from comparable IMTA operations @guo2024) to the cost of deploying the IoT infrastructure would help farmers and policymakers decide whether the investment makes sense. Those are the natural next steps from here.

#bibliography("bibliography.yaml", style: "ieee", full: true, title: "References")
