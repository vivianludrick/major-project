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
    *_Prof. Heena Pendhari, Mark Lopes, Aryan Daripkar, Pratyay Koley, Vivian Ludrick_* \
    _Department of Computer Engineering_ \
    _Fr. Conceicao Rodrigues College of Engineering, Mumbai_
  ]
]

#v(1.5em)

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

More than 50% of the seafood consumed around the world today is produced through aquaculture, and shrimp farming is one of the largest contributors to aquaculture's economic value and environmental impact. The current method of raising shrimp in ponds requires the use of dry feeds (which are typically very high in protein content), aerators to oxygenate the water for the shrimp, and using very high-density stocking cycles; all contribute to aquaculture being responsible for approximately 263 million metric tons  CO#sub[2] produced annually @alam2024. Integrated multi-trophic aquaculture (IMTA) provides a way to help mitigate this environmental impact through the use of co-cultured plants such as seaweeds along with shrimp; the seaweeds provide a sink for the dissolved CO#sub[2], nitrogen and phosphorus that are produced in the shrimp monoculture; thus allowing for reductions of 20-50% in these environmental impacts from the use of IMTA @hala2024.

A barrier to continually estimating the carbon footprint of aquaculture facilities is the quality of the measurement process. The LCA and carbon assessments conducted in these systems rely on periodic manual sampling, which does not capture the daily variations of dissolved oxygen and pH that are responsible for regulating CO#sub[2] flux @liu2022. This paper describes an IoT-based system that effectively fills this gap: an ESP32 microcontroller combined with five types of sensors sends data every ten minutes via Wi-Fi to a MongoDB cloud database where the PSO-BiGRU and Random Forest models each can produce predictions about water quality, detect anomalies, and make assessments of shrimp health. At the same time, the multi-source CO#sub[2] emission model and the cradle-to-farm LCA are generated continuously using this same data stream, replacing static snapshots with time-based data that describes the evolving nature of the carbon footprint throughout the grow-out period.


= Research Gap

The core problem is a mismatch between the temporal resolution of the data and the temporal resolution of the process. Carbon dynamics in a shrimp–seaweed pond change hour by hour — respiration peaks before dawn, photosynthesis kicks in at sunrise, a feeding event shifts the DO curve within minutes. Static LCA built on a handful of field samples averaged into a single inventory entry can identify that feed and energy are the dominant emission hotspots @hala2024, but it cannot say anything about how emissions behave across a day, or how seaweed sequestration responds to temperature and light variation, or when a DO crash is imminent. The time resolution simply is not there.

Machine learning has been applied to water quality prediction in aquaculture with solid results. Ye @ye2024 used PSO-BiGRU to predict carbon emissions in marine fisheries; Vinay et al. @vinay2025 achieved 93.26% accuracy on prawn water quality with PCA and Random Forest; Guo @guo2024 demonstrated hybrid CNN-LSTM models for water quality forecasting. But these studies treat the prediction problem in isolation — none of them connect continuous sensor monitoring directly to a live LCA, and none make the joint outputs available to farm operators in real time.

That connection is what this paper provides. Every 10-minute sensor reading flows through an emission model and sequestration estimate, updating the cumulative carbon balance as the grow-out cycle progresses. LCA is no longer a post-harvest calculation done in a spreadsheet; it runs alongside the farm. That shift from static to continuous carbon accounting, coupled with predictive models that give operators early warning of adverse conditions, is the central contribution of this work.

= Proposed System Framework

== IMTA System Overview

In an integrated multi-trophic aquaculture (IMTA) system, _Litopenaeus vannamei_ shrimp are raised on the bottom of a shared pond and _Ulva lactuca_ seaweed is grown in the top layer, as shown in @fig-imta-flow. As the shrimp eat the feed given to them, they produce excretions (metabolites) that contain high levels of nitrogen and phosphorus. The excreted dissolved nutrients then vertically migrate from the bottom to the top of the pond, where the seaweed can use them as direct nutrients. By using photosynthesis to convert carbon dioxide into oxygen, the seaweed provides supplemental oxygen to the shrimp by increasing dissolved oxygen levels at the bottom. Constant flowing water moves all animals through the same nutrient pool. Upon harvesting, the seaweed is harvested as a secondary crop while the entire cycle of nutrient and carbon transfer is monitored by the IoT network of sensors described below.

#figure(
  image("assets/IMTA_flow.png", width: 100%),
  caption: [IMTA System: Shrimp & Ulva Shared Pond Flow Diagram],
) <fig-imta-flow>

== Architecture

The monitoring system is organized into five layers, each with a specific role in moving data from the pond to actionable outputs on a dashboard.

*Layer 1 Sensor (IMTA Pond):* The IMTA pond will utilize five distinct sensors to assess the conditions for raising shrimp and seaweed: temperature (C), pH, dissolved oxygen (mg/L), CO#sub[2] (ppm), and salinity (ppt). Together, the data from these five sensors will determine the equilibrium of carbonate ions in water. Temperature and salinity establish the maximum amount of carbonate ions soluble in water, and pH and dissolved oxygen levels indicate the amount of carbon produced from photosynthesis and consumed through respiration. Furthermore, CO#sub[2] measurements will directly tell us what pH does not reveal about the status of carbonate ions.

*Layer 2: Edge (ESP32):* The ESP32 microcontroller collects all sensor data using both UART and analog-to-digital interfacing. The ESP32 has been chosen as it combines Wi-Fi, sufficient GPIO for connecting five sensors, and local flash memory for buffering (less than \$5). The ESP manages basic signal conditioning (for noise), local timing, and packages data for upload. As such, the ESP32 will eliminate the need for long-range radio infrastructure or gateway hardware to provide sensor data to each of the stakeholders.

*Layer 3: Cloud Storage (MongoDB)* Sensor packets are stored in a MongoDB document database. Each document contains a timestamp and the five sensor readings (temperature, pH, DO, CO#sub[2], salinity); the schema-flexible document model allows derived fields (respiration estimates, sequestration values, LCA outputs) to be added incrementally as the analysis pipeline grows.

*Layer 4: Processing and Analytics (PSO-BiGRU + Random Forest)* Sensor time series are processed by two complementary models: a BiGRU for temporal forecasting and a Random Forest for feature-ranked cross-validation. Their ensemble outputs populate the dashboard.

*Layer 5 — Dashboard:* This layer of interface allows users to see live readouts from sensors, historical trends in chart form, and outputs created by AI. A web-based dashboard was chosen because farmers can access the system from any computer (without needing to install software), which is extremely important in a coastal farming setting where most of the technology available to users is via laptop or smartphone.

#figure(
  image("assets/architecture_diagram.jpg", width: 100%),
  caption: [System Architecture]
)

== Data Preprocessing and Feature Engineering

To convert raw sensor data (sensor stream) to usable data the sensor data must be cleaned. The sensor data is collected every 10 minutes, and for short gaps (generally 1-2 missed cycles) the missing data will be filled using linear interpolation. For long gaps, a multivariate regression-functioning method will be used that looks at the correlation between the different variables (i.e., the inverse relationship of DO & CO#sub[2] during photosynthesis, as well as the correlation of temperature and pH in the chemistry of carbonates @robinson2020). To identify spikes and drift in the sensors, Median Absolute Deviation (MAD) filtering will be utilized to identify/readings that significantly differ from previous readings.

Derived features will be calculated from a cleansed copy of the sensor record. The CO#sub[2] Uptake Index combines chlorophyll-a, the rate of seaweed growth, and the change in DO to determine the of photosynthesizing carbon uptake @massocato2022. The CO#sub[2] Uptake Index provides an indirect measure of the levels of dissolved inorganic carbon (DIC) taken from the water, and a rise in DO, a decrease in CO#sub[2], and a positive growth rate indicates that the seaweed is conducting photosynthesis. The CO#sub[2] Uptake Index provides a single data point that other models can use without calculating the full chemistry of the carbonates in seawater. The Feed-based Carbon Input equals the feed rate measured multiplied by the emission factor for feed production @chen2022. The Energy-based Emission equals the amount of electricity consumed.

== CO#sub[2] Emission Modeling

CO#sub[2] emissions from an aquaculture operation are created through several different sources of emission and will be handled separately through the use of a four-term model rather than using one single aggregate emission factor. The four terms in the emission model are representative of the actual functions of the aquaculture system: The shrimp consume feed (the feed costs energy to produce), and the aerators that operate in the pond run on electricity supplied through the grid. The shrimp also respire continuously, and there is settled organic matter in the pond that will eventually decompose; therefore there are multiple parts of the overall system that each have their own influencing factors and have different time constants as well as responses to changes in management — which are the reasons that having one single emission coefficient for every kilogram of shrimp produced in an aquaculture operation is not appropriate.

The total carbon emission from the system is the sum of these four component sources:

$ "CO"_2^"total" = "CO"_2^"feed" + "CO"_2^"energy" + "CO"_2^"resp" + "CO"_2^"decomp" $ <eq-total>

where $"CO"_2^"feed"$ covers emissions from feed production and transport, $"CO"_2^"energy"$ covers the electricity used for aeration, $"CO"_2^"resp"$ captures shrimp metabolic respiration, and $"CO"_2^"decomp"$ accounts for organic matter breakdown in the sediment.

Emissions from aeration energy are calculated from electricity consumption and the regional grid emission factor.

Feed-related emissions are estimated from the quantity of feed used and the corresponding feed production emission factor.

Respiration emissions scale with biomass and a temperature-dependent rate:

$ "CO"_2^"resp" = B times R $ <eq-resp>

where $B$ is shrimp biomass (kg) and $R$ is the respiration rate (g CO#sub[2]/kg/h), estimated from real-time temperature and DO readings rather than a fixed literature value.

Using live sensor data for $R$, $E$, and $F$ rather than static assumptions is what makes continuous monitoring worth the effort — these values vary substantially across a 24-hour period and across the grow-out cycle.

== Seaweed Carbon Sequestration

Seaweed fixes dissolved CO#sub[2] through photosynthesis. The sequestration estimate is:

$ C_"seq" = B_s times C_c $ <eq-seq>

where $B_s$ is seaweed dry biomass (kg) and $C_c$ is the carbon content fraction of the seaweed tissue (0.25–0.35 for the macroalgae species typically used in IMTA @edf2022).

Periodic tissue samples are used to update the carbon fraction $C_c$ based on total organic carbon analysis and the carbon fraction $C_c$ is held constant between sampling events. The carbon fraction $C_c$ changes slowly so the biomass $B_s$ is the variable that continuous IoT monitoring is monitoring; real-time biomass estimates will provide an up-to-date estimate of the sequestration term even if tissue sampling has not been performed again yet.

Net carbon balance is then:

$ C_"net" = "CO"_2^"total" - C_"seq" $ <eq-net>

A negative $C_"net"$ means the system is absorbing more carbon than it emits — carbon sink territory, and the basis for any carbon credit calculation.

== Life Cycle Assessment

The Life Cycle Assessment (LCA) follows ISO 14040/14044 standards. The functional unit is *1 kg of shrimp produced*. Shrimp is what has value economically for the farm. The seaweed from the farm is used in order to help reduce the environmental impact of how shrimp are produced. Using 1 kg of shrimp will allow results to be comparable to previous published LCA reports for Integrated Multi-Trophic Aquaculture (IMTA) and conventional shrimp farming from @hala2024 and reassure that an IoT-based inventory system will yield comparable results.

A full cradle-to-farm-gate system boundary will include all the necessary inputs required to develop feeds (feed), electricity use for production and end use, as well as growing both the shrimp (shrimps) and the seaweed (seaweed of this method) used in this method, including all of the IoT items necessary to produce the ITA. The term cradle-to-farm-gate symbols all of the items that exist from the extraction of raw materials to the production of feeds and the removal of the end product for the use of the shrimp.

The inventory is populated directly from the IoT data logs supplemented by standard LCA databases for upstream processes @hala2024. Environmental indicators reported are Global Warming Potential (GWP in kg CO#sub[2]eq/kg shrimp), energy consumption (MJ/kg), and nutrient discharge (g N-eq, g P-eq). Using continuous IoT records for the inventory removes the main source of uncertainty in static LCA — the assumption that snapshot measurements represent steady-state conditions.

= Predictive Models

== PSO-BiGRU

The PSO-BiGRU model couples a swarm-based hyperparameter optimizer with a bidirectional recurrent architecture for sequence prediction. PSO searches the space of learning rate, hidden-unit count, and dropout by running a population of candidate configurations ("particles") that converge toward the global optimum, eliminating manual grid search.

The BiGRU architecture processes the time series in both forward and backward directions, which is useful here because carbon dynamics at any given hour are influenced by both preceding conditions (cumulative respiration since the last feeding) and patterns that follow (the overnight respiration peak that reliably builds toward dawn) @ye2024. PSO tunes the hyperparameters — specifically learning rate, hidden units, and dropout — by minimizing validation-set error without manual grid search.

#figure(
  image("assets/lstm.png", width: 100%),
  caption: [PSO-BiGRU Model Architecture]
)

The engineered features for this model will be in a 24-step sliding window as the input to the model's architecture, which is comprised of an Input ← a bidirectional GRU layer with 128 units for each direction followed by a Dropout layer with 0.2 after which Dense output will be produced. Adam will be used for training the optimizer using Mean Squared Error (MSE) and will produce three different types of output; predictions for water quality at approximately one week, shrimp health risks (numerically) and an anomaly flag (i.e., an indicator for out of bounds values). The evaluation metrics will be root mean square error (RMSE), mean absolute error (AE) and percentage of absolute error (APE).


== Random Forest

The Random Forest complements the PSO-BiGRU framework instead of competing with it. The BiGRU is good at identifying temporal patterns, or how carbon-related dynamics unfold over time (in hours), but it is a black box meaning you cannot easily determine what input variables are most important and if it makes an incorrect prediction, it can be difficult to establish why. The Random Forest model is the opposite — it does not naturally model the temporal structure, but it provides a ranked feature importance list, and it accounts for potential sensor gaps and changes in data distribution; characteristics that can cause difficulties for recurrent models. By combining both models, we can achieve temporal fidelity through BiGRU and interpretability and robustness through Random Forest. As such, the combination of both models leads to better calibration than either model alone @khan2024.

Three hundred bootstrap trees are trained on the same input features (pH, temperature, salinity, DO, seaweed growth, chlorophyll-a, shrimp biomass, feed rate, emission features derived from other features). The model will output estimates for CO#sub[2] emissions and feature importances will be ranked in accordance with their relative importance to CO#sub[2] emissions. This model also serves as a cross-check on the predictions of the PSO-BiGRU, particularly under conditions where the sequential aspects of the recurrent model (e.g., after a sensor gap) fail @khan2024.

Performance evaluation is done using R#super[2], RMSE, and MAE on a held-out chronological test set.

== Validation Strategy

Data is split 70/20/10 for training, validation, and test respectively, in time order; to reflect genuine forward prediction rather than interpolation. Rolling forecast evaluation then re-fits on an expanding window to assess how performance degrades over longer prediction horizons. The final output used by the dashboard is a weighted ensemble of PSO-BiGRU and Random Forest predictions, with weights set by inverse validation-set RMSE.

== LSTM

LSTM (long short term memory) networks are to be implemented as an additional sequential model as the technology develops. An LSTM network will be well suited for modeling long-term dependencies over the grow-out cycle of an organism, such as the typical circadian cycle of carbon dioxide (CO#sub[2] ) concentrations driven by both photosynthesis and respiration, because these relationships may last anywhere from 48 hours to much longer, and also due to the gating mechanism of LSTM networks will allow the model to retain this context much more effectively compared to typical RNNs @hao2024. The intended architecture will consist of an LSTM with 128 units fed by a 48-hour sliding window, followed by a Dropout with a probability of 0.3 and a single Dense output. To avoid overfitting, an early stopping scheme with a patience of 10 epochs will be implemented after deploying the LSTM. Upon deployment, the predictive performance of the LSTM will be directly compared against the PSO-BiGRU to assess the accuracy and temporal stability and will be included in the ensemble if it provides a complementary signal.

#figure(
  image("assets/time_series_forecasting.png", width: 100%),
  caption: [LSTM Architecture]
)

== ARIMA / Prophet

ARIMA and Prophet have been maintained as baseline models that can be used to interpret periodic and management-driven variations in CO#sub[2] emissions, according to @jiang2022. The univariate ARIMA model that was trained on the net CO#sub[2] flux time series (calibrated according to the AIC/BIC criteria), will act as a classical reference model that does not require feature engineering or extensive auditing. The Prophet model, on the other hand, adds explicit trend and seasonality decomposition to the CO#sub[2] flux time series, which can be helpful in isolating the daily photosynthesis and respiration cycle from longer term grow-out trends. Therefore, both models will serve primarily as a point of reference for sanity checking, as if a more complex model is coming up with the same prediction accuracy as ARIMA within a given forecast horizon then it will be worthwhile to consider why this is the case.

= Results

== Dataset Overview

The dataset includes a complete grow-out cycle of the shrimp-seaweed IMTA system and is sampled every ten minutes with an ESP32 sensor. The primary difference before and after pre-processing is there was 21 columns of time series organized into five groups after its collection.

- *Temporal index:* A datetime column that anchors all other series.

- *Water quality (7 columns):* temperature, pH, dissolved oxygen, salinity, alkalinity, hardness, and turbidity represent the dominant environmental variables that dictate whether or not shrimp will be able to survive and also drive the carbonate-equilibrium processes.

- *Biological state (3 columns):* shrimp weight. The three biological state variables are used to derive the emission and sequestration models.

- *Carbon Accounting (6 columns):* The six carbon accounting variables are used to derive the final outputs of the emission model and include: carbon percent (columns), carbon mass (columns), CO#sub[2] equivalent (mass basis), and three carbon flux variables (shrimp respiration CO#sub[2], seaweed sequestration CO#sub[2], and net CO#sub[2] flux).

#figure(image("assets/Dataset.png", width: 100%), caption: [Time-Series Overview of Key Dataset Parameters])


The diurnal cycle of net CO#sub[2] flux is the most significant pattern shown in the dataset. It continuously builds throughout the night due to shrimp respiration accumulating with no photosynthetic offset, then decreases across the morning as seaweed begins to fix CO#sub[2], often to the point of becoming net negative during the early afternoon hours when sunny. This can be found consistently across the grow-out period for which predictive modeling needs to monitor for future predictions.

== Emission Modeling Results

Applying @eq-total and @eq-resp to the IoT record shows feed and electricity together accounting for roughly 60–65% of total CO#sub[2] output, in line with what LCA reviews of IMTA have reported @hala2024. The respiration term ($"CO"_2^"resp"$) tracked closely with biomass and temperature, and using live-estimated respiration rates from sensor data rather than a fixed coefficient reduced the error in the net flux estimate noticeably compared to a static baseline.

Seaweed sequestration (@eq-seq) can offset between 10 to 30% of emissions during their different phases of growth, and the net balance of eq-net has fallen below zero multiple times during peak seaweed growth, demonstrating that the system behaves like a functional carbon sink. From the perspective of a farm operator, the net-negative periods (i.e., when the net balance of eq-net goes below zero) are important for two reasons: one, they show that the density of the seaweed stands and conditions for growth are sufficient to provide meaningful amounts of carbon offsetting; and two, the total net balance from the outset of the grow-out cycle will determine whether the system is eligible for certification to receive carbon credits, given that the framework requires showing a net amount of carbon sequestration over a defined period of time.

== Prediction Performance

Both of the models have effectively modeled daily fluctuations in the amount of CO#sub[2] produced by the organisms assessed. The PSO-BiGRU performed best at modeling the data where there were rapid changes and forecasted future values multiple steps ahead while the Random Forest provided more consistent results with respect to estimating features and making sense of what variables were being used as learning basis. When modeled together PSO-BiGRU, and Random Forest produced an overall higher prediction than either of the individual models based on test dataset.

Random Forest generates estimates of variable importance [Feature Importance] to outline how a model was trained based on variable. Feed Input Rate (quantity of feed fed to the shrimp), Dissolved Oxygen and Temperature ranked as the three most important variables in estimating total respiration on the shrimp-side. For estimating carbon sequestration on seaweed, the three most important variables were: Chlorophyll-a, Daylight Hours and DO, all of which are consistent with the physical principles of photosynthesis.

#figure(image("assets/Random_Forest_Feature_Importance.jpeg", width: 85%), caption: [Random Forest Feature Importance])

#figure(image("assets/Random_Forest_Results.jpeg", width: 84%), caption: [Random Forest: Predicted vs. Observed CO#sub[2] Flux])

#figure(image("assets/Respiration_model_performance.jpeg", width: 100%), caption: [Shrimp Respiration Model Performance])

#figure(image("assets/Sequestration_model_performance.jpeg", width: 100%), caption: [Seaweed Sequestration Model Performance])

#figure(image("assets/BiGRU_Results.png", width: 100%), caption: [PSO-BiGRU Prediction Results])

#figure(image("assets/BiGRU_Performance.png", width: 100%), caption: [PSO-BiGRU Performance Metrics])

== Web Dashboard

#figure(image("assets/web-dashboard.png", width: 100%), caption: [Web Dashboard — CO#sub[2] Input Collection Interface])

The current dashboard collects the farm-level inputs that drive the emission model: farm size, stocking density, culture duration, feed types, and electricity sources with their consumption and grid-mix breakdown. Each entry maps directly to a term in @eq-total. The interface is web-based so operators can access it from any device without installation. Additional panels — live sensor readouts, CO#sub[2] flux trends, PSO-BiGRU forecasts, and anomaly alerts — will be added as the system matures.


= Discussion

Continuous monitoring changes what LCA can say. When inventory data comes from periodic manual samples, the assessment captures an average — it misses nocturnal respiration peaks, feeding-event spikes, and the diurnal sequestration cycle entirely. Driving the LCA from the IoT record gives a temporally resolved picture that snapshot methods cannot produce.

The emission data backs up those previously identified hotspots: feed plus power account for 60-65% of total output, and seaweed sequestration (also affected by stocking density) where 20% less biomass equals approximately 18% less sequestration than a 100% biomass condition. The use of PSO-BiGRU in concert with Random Forest produces complementary results; specifically, the recurrent model captures the temporal changes well while the tree captures good rankings of features (that we can verify are being learned by the model). The results from the anomaly detection used by the system have immediate operational benefit; specifically, a DO crash can be detected within ~10 minutes vs. having to wait until the next scheduled manual sampling.

The system can operate successfully on low end hardware (e.g., ESP32 and free service from MongoDB) and provides usable solutions for the coastal communities where approx 90% of the world's shrimp production is located.

= Conclusion

The motivation for this work was a specific limitation: aquaculture carbon assessments have relied on periodic manual sampling, and that means the LCA is built on snapshots that cannot represent the dynamics of the system they are supposed to characterize. A pond's carbon balance changes hour by hour — feeding events, diurnal photosynthesis, overnight respiration accumulation — and none of that shows up in a few weekly grab samples. This paper set out to close that gap by replacing manual snapshot data with continuous IoT monitoring and connecting it directly to a live carbon model.

The findings support that method. Feed and electricity dominate system emissions (60–65%), seaweed sequestration offsets 10–30% during peak growth and can push the net balance below zero — an outcome invisible to static LCA. The PSO-BiGRU and Random Forest ensemble accurately tracks the diurnal CO#sub[2] cycle, detects anomalies with low latency, and produces interpretable feature rankings. Live-sensor inventory via @eq-total and @eq-net yields a temporally resolved carbon footprint that periodic sampling cannot provide.

What remains to be done is broader. Testing the system across different climates and seasonal conditions would establish how robust the PSO-BiGRU model is outside the conditions it was trained on. Adding methane and nitrous oxide sensors would close the GHG accounting gap that this paper leaves open. And an economic analysis connecting the carbon credit potential (estimated at 0.5–1.5 t C/ha/year from comparable IMTA operations @guo2024) to the cost of deploying the IoT infrastructure would help farmers and policymakers decide whether the investment makes sense. Those are the natural next steps from here.

#bibliography("bibliography.yaml", style: "ieee", full: true, title: "References")
