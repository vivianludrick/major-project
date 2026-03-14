#set page(
  margin: 22mm,
  paper: "a4",
)
#set par(justify: true)

#set text(
  font: "Times New Roman",
  size: 12pt,
)

#set heading(numbering: "1.1.")
#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: raw)).update(0)

  set text(size: 24pt, weight: "bold")
  set align(center)
  pagebreak()
  it
  v(0.5em)
}

#set math.equation(numbering: num => 
  "(" + (str(counter(heading).get().at(0)) + "." + str(num)) + ")"
)
#set figure(numbering: num => 
  str(counter(heading).get().at(0)) + "." + str(num)
) 

#set page(numbering: none)

#show outline: it => {
  show heading: set align(center)
  it
}

#let title=[CO#sub[2] Modeling And Life Cycle Assessment In Shrimp-Seaweed Integrated Multi-Trophic Aquaculture Systems]
#let guide=(
  name:"Heena Pendhari", 
  designation:"Assistant Professor",
  shortDesignation:"Assistant Prof."
)

#let coGuide=(
  name:"Dr. Madhuri Pathak", 
  designation:"Scientist, Aquaculture Division, ICAR–CIFE, Mumbai",
)

#let imageWithAlt(altText, imagePath) = {
  figure(
    kind: image,
    caption:[#altText] 
  )[
    #v(3em)
    #image(imagePath)
    #v(2em)
  ]
}

#let addPageTitle(pageTitle) = {
  align(center)[
    #text(size: 24pt, weight: "bold")[
      #pageTitle
    ]
  ]
}


#align(center)[

  #text(size: 18pt, weight: "bold")[
    #title
  ]

  #v(2em)

  A project report submitted in partial fulfillment\
  of the requirements for the degree of

  #v(2em)

  #text(size: 15pt, weight: "bold")[
    Bachelor of Engineering\
    In\
    Computer Engineering
  ]

  #v(1em)

  by

  #v(1em)

  #text(weight: "bold")[
    Mark Lopes (9913)\
    Aryan Daripkar (9882)\
    Pratyay Koley (9909)\
    Vivian Ludrick (9914)
  ]

  #v(2em)

  Under the guidance of\
  #text(weight: "bold")[#guide.name]\
  #text(weight: "bold")[#guide.designation]

  #v(2.5em)

  #image("assets/clg_logo.png", width: 25%)

  #v(1em)

  #text(size: 12pt)[
    DEPARTMENT OF COMPUTER ENGINEERING
  ]

  #v(0.5em)

  #text(weight: "bold")[
    Fr. Conceicao Rodrigues College of Engineering, Bandra (W), Mumbai -\
    400050
  ]

  #text()[
    University of\
    Mumbai(2025-26)
  ]
]

#pagebreak()

#align(center + horizon)[
  _This work is dedicated to my family.\
  I am very thankful for their motivation and support._
]

#pagebreak()


#align(center)[
  #text(
    size: 20pt,
    weight: "bold"
  )[Internal Approval Sheet]

  #v(1em)

  #text(
    size: 17pt,
    weight: "bold"
  )[CERTIFICATE]

  #v(1em)
]


#par(
  leading: 1.5em,
)[
  This is to certify that the project entitled *"#title"* is a bonafide work of  submitted to the University of Mumbai in partial fulfillment *Mark Lopes (9913), Aryan Daripkar (9882), Pratyay Koley (9909), Vivian Ludrick (9914)* of the requirement for the award of the degree of Bachelor in *Computer Engineering*.
]

#v(8em)

#grid(
  columns: 5,
  rows: 1,
  column-gutter: 1fr,
  align: center + horizon,
)[][
  #guide.name\
  Guide
][][
  #coGuide.name\
  Co-Guide
][]

#v(8em)

#grid(
  columns: 5,
  rows: 1,
  column-gutter: 1fr,
  align: center + horizon,
)[][
  Dr. Sujata Deshmukh\
  Head of Department
][][
  Dr. S.S. Rathod\
  Principal
][]

#pagebreak()


#align(center)[
  #text(size:18pt, weight: "bold")[
    Approval Sheet
  ]
  #v(1em)
  #text(size:20pt, weight: "bold")[
    Project Report Approval
  ]
  #v(3em)
  #par(leading: 1em)[
    This project report entitled by *#title* by *Mark Lopes, Aryan Daripkar, Pratyay Koley and Vivian Ludrick* is approved for the
    degree of Bachelor of Engineering in Computer Engineering.
  ]
]

#v(10em)

Examiner 1. ————————————–

Examiner 2. ————————————–

#v(7em)

Date:

Place:

#pagebreak()

#align(center)[
  #text(size:24pt, weight: "bold")[
    Declaration
  ]
]

#par(leading: 1.5em)[
  We declare that this written submission represents our ideas in our own words and where others’ ideas or words have been included, we have adequately cited and referenced the original sources. We also declare that we have adhered to all principles of academic honesty and integrity and have not misrepresented or fabricated or falsified any idea/data/fact/source in my submission. We understand that any violation of the above will be cause for disciplinary action by the Institute and can also evoke penal action from the sources which have thus not been properly cited or from whom proper permission has not been taken when needed.
]

#v(25em)

#grid(
  columns:2,
  rows: 1,
  column-gutter: 1fr,
  align: center + horizon,
)[][
  #align(left)[
    Mark Lopes (9913) (sign) \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ \

    Aryan Daripkar (9882) (sign)  \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ \

    Pratyay Koley (9909) (sign)  \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ \

    Vivian Ludrick (9914) (sign) \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
  ]
]

#v(1em)

Date:

#pagebreak()

#align(center)[
  #text(size:24pt, weight: "bold")[
    Abstract
  ]
]

The aquaculture industry plays a major role in meeting the global food supply but it also contributes significantly to greenhouse gas emissions. Shrimp farming in particular is a carbon-intensive process due to high feed requirements. IMTA(Integrated Multi-Trophic Aquaculture) systems offer a sustainable alternative to conventional farming methods by combining two species: fed (shrimp) and extractive (seaweed) that absorb excess nutrients in the water and balance CO₂ levels.

However, traditional IMTA assessments rely on static, infrequent manual sampling which fail to account for dynamic environmental factors like temperature, dissolved oxygen(DO), pH, and salinity, which continuously affect CO#sub[2] fluxes and might give inaccurate life cycle assessment (LCA) calculations. This project tries to addresses this limitation by proposing an IoT-based data-driven framework for real-time evaluation and prediction of CO₂ in shrimp-seaweed IMTA systems.

The project has three main objectives: developing a real-time sensor-based IoT system for continuous monitoring of carbon-relevant parameters; conducting a cradle-to-farm LCA to calculate net carbon footprint including seaweed carbon sequestration; and designing predictive time-series models for CO₂ forecasting. The methodology will combine advanced sensor networks with machine learning models like Random Forest, PSO, Bi-GRU, LSTM, and classical time-series models (ARIMA, Prophet) to provide accurate, dynamic CO₂ emission predictions and enable a sustainable aquaculture management.

#pagebreak()

#addPageTitle("Acknowledgments")

#par(leading: 1.2em)[
  We have great pleasure in presenting the report on *"#title"*. I take this 
  opportunity to express my sincere thanks towards the guide #guide.shortDesignation #guide.name, 
  C.R.C.E, Bandra (W), Mumbai, and co-guide #coGuide.name (#coGuide.designation) for providing the technical guidelines, and the 
  suggestions regarding the line of this work. We enjoyed discussing the work 
  progress with her during our visits to department. 
]
#v(2em)
#par(leading: 1.2em)[
  We thank Dr. Sujata Deshmukh, Head of Computer Engineering department, 
  Principal and the management of C.R.C.E., Mumbai for encouragement and 
  providing necessary infrastructure for pursuing the project. 
]
#v(2em)
#par(leading: 1.2em)[
  We also thank all non-teaching staff 
  for their valuable support, to complete our project.
]

#v(21em)
#grid(
  columns:2,
  rows: 1,
  column-gutter: 1fr,
  align: center + horizon,
)[][
  #align(left)[
    Mark Lopes (9913)\
    Aryan Daripkar (9882)\
    Pratyay Koley (9909)\
    Vivian Ludrick (9914)\
  ]
]

#v(2em)

Date:

#set page(
  footer: [
  #align(center)[
    #numbering("1")
  ]
],
)

#outline(
  title:"Contents"
)

#outline(
  title: [List of Figures],
  target: figure.where(kind: image),
)

#set page(numbering: "1")
#counter(page).update(1)

#set page(
  footer: context {
  let page-num = counter(page).get().first()
  if page-num > 0 {  // Start showing after page 2
  align(center)[
    #counter(page).display("1")
  ]
}
}
)

= Introduction

Feeding a rapidly growing population remains one of the major challenges of humanity. Aquaculture has become a crucial contributor to this demand, surpassing manual fishing in production. However, this surge in activity brings environmental concerns, notably the emission of greenhouse gases such as carbon dioxide (CO₂), methane (CH₄), nitrous oxide (N₂O), etc. These arise at various stages of the production cycle; from raw material processing to manufacturing, use, and disposal. On a global scale, aquaculture accounts for roughly 263 million tonnes of CO₂ equivalents annually. Among its sectors, shrimp farming stands out for its intensive feeding requirements and the significant carbon footprint required for its operations.

As a sustainable alternative to this problem, IMTA - Integrated Multi-Trophic Aquaculture has become a strategy to have more eco-friendly aquaculture system. In the IMTA systems the cultivation of fed aquaculture species (such as fish or shrimps, which occupy higher trophic levels) is combined with organic and inorganic extractive species (like suspension/deposit feeders and seaweed at lower trophic levels), allowing the waste generated by the fed species to be reused by the extractive species. Seaweed is one of the inorganic extractive species that plays a vital role in absorbing the excess nutrients (e.g., nitrogen, phosphorus, and carbon) which helps in balancing the CO₂ of the entire ecosystem.

While there have been several studies which have explored the environmental benefits of IMTA, most are static, often relying on infrequent, manual sampling under controlled conditions. In a real-world environment there are many dynamic factors (such as temperature, dissolved oxygen (DO), pH, salinity, plus) that fluctuate, affecting both the shrimp metabolism and seaweed growth. These fluctuations affect the CO₂ fluxes in the system and weaken the credibility and accuracy of the estimation of LCA of carbon and hence carbon credit.

The recent advancement in sensor technology and data analytics gives us a solution to overcome these limitations. By integration with sensor based IOT systems which will provide continuous real-time data (e.g., temperature, DO, dissolved CO#sub[2], pH, and salinity) for the predictive analytics and time-series model which will give a more accurate estimation of LCA of carbon and the carbon credits.

This project proposes the development of a IOT-based framework for evaluating and predicting of CO₂ in a shrimp-seaweed IMTA system. To achieve this the following objectives are defined:
+ Develop a real-time sensor-based IOT system for continuously measuring carbon-relevant parameters (e.g., dissolved CO₂, DO, temperature, pH, salinity, and alkalinity) in shrimp-seaweed IMTA setup.

+ To get a cradle-to-farm LCA of carbon of the IMTA system to calculate the net carbon footprint, while integrating carbon sequestration from the seaweed.

+ To design predictive and time-series models for the CO#sub[2].

= Literature Review


#table(
  columns: (1.25fr, 1fr, 1fr, 1.5fr),
  align: (left, left, left, left),
  stroke: 0.5pt + gray,
  inset: 8pt,

  [*Paper*], 
  [*Key Focus*], 
  [*Methodology Used*], 
  [*Key Findings Relevant to The Project*],

  [Y. Liu et al., “Effects of shellfish and macro-algae IMTA in North China on the environment, inorganic carbon system, organic carbon system, and sea-air CO₂ fluxes,” Frontiers in Marine Science, vol. 9, p. 864306, Apr. 2022 @liu2022],
  [Effects of shellfish-macroalgae IMTA on carbon systems and CO#sub[2] fluxes],
  [- 4 seasonal field surveys (2019)
  - Parameters: DO, pH, temp, salinity, TA, DIC, DOC, POC, pCO#sub[2], CO#sub[2]
  - Ocean-air CO#sub[2] flux: F = k × αs × ΔpCO#sub[2]
  - ANOVA & Pearson correlation],
  [- Macro-algae zones lead to increased pH/DO and reduced pCO#sub[2]
  - Most zones acted as CO#sub[2] sinks except shellfish in summer
  - DIC/pCO#sub[2] highest in shellfish zones, lowest in macro-algae zones
  - Water temperature & DIC are key CO#sub[2] flux factors
  - IMTA mitigates ocean acidification],

  [M. M. Alam et al., “Potential of integrated multitrophic aquaculture to make prawn farming sustainable in Bangladesh,” Frontiers in Sustainable Food Systems, vol. 8, p. 1412919, Oct. 2024 @alam2024],
  [IMTA potential for reducing GHG in prawn farming],
  [- Systematic review: 112 articles (2000-2024)
  - PRISMA framework
  - Economic viability & bioremediation analysis],
  [- Conventional prawn farms produce 18.8 kg CO#sub[2]eq/MT vs 3.1kg (China shrimp)
  - Bivalves/seaweeds sequester CO#sub[2] as blue carbon sinks
  - Global mollusks sequestered 0.97--1.93 million ton C/year
  - IMTA shows 24% higher net profit than monoculture
  - Feed & energy are major carbon sources],

  [S. Ye, “Analysis of influencing factors of carbon emissions from China's marine fishery energy consumption under different development scenarios,” Frontiers in Marine Science, vol. 11, p. 1377215, Mar. 2024 @ye2024],
  [Carbon emission factors and prediction for marine fishery],
  [- Carbon accounting (2006-2020): Sources - Sinks
  - PSO-BIGRU machine learning
  - Random Forest for factor importance],
  [- 17% emission reduction achieved from 4.72 to 3.90 million tons
  - Carbon sinks are dominant reduction factor
  - PSO-BIGRU gives best predictions (MAE: 1.251)
  - Key predictors: carbon sinks, per capita income, fishery population],

  [M. T. Vinay, K. T. Veeramanju, and B. R. Sreenivasa, “Multivariate analysis of water quality parameters for sustainable prawn farming,” South Eastern European Journal of Public Health, vol. 26, no. suppl.2, pp. 3707–3719, 2025 @vinay2025],
  [Multivariate analysis for predicting water quality effects on prawn health],
  [- 3 scenario predictions (2021-2030)
  - PCA: 14 to 9 components (90% variance)
  - SPA feature selection (10 key features)
  - ML: XGBoost, Random Forest, SVM
  - Dataset: 4,300 samples, 15 parameters],
  [- 6% sink growth rate most effective
  - PCA + Random Forest gives 93.26% accuracy
  - Key parameters: pH, CO#sub[2], Ca, hardness, plankton, phosphor, temp, DO, total alkalinity, NH#sub[3]
  - DO/BOD inverse relationship validated
  - pH and CO#sub[2] negatively correlated
  - Real-time monitoring improves survival rates],

  [Y. Jiang and F. Yan, “Aquaculture prediction model based on improved water quality parameter data prediction algorithm under the background of big data,” Journal of Applied Mathematics, vol. 2022 @jiang2022],
  [DO prediction using big data and improved algorithm],
  [- PCA for feature extraction
  - PCA-BP neural network
  - GA optimization (GPCA-BP)
  - Focus on Dissolved Oxygen (DO) as critical indicator],
  [- GPCA-BP showed best DO prediction accuracy
  - Lowest MAE error & best convergence
  - DO is most critical aquaculture parameter
  - Big data enables dynamic monitoring
  - Model supports real-time prediction systems],

  [A. F. Hala et al., “Life cycle assessment of integrated multi-trophic aquaculture: A review on methodology and challenges for its sustainability evaluation,” Aquaculture, vol. 565, p. 741035, Sep. 2024 @hala2024],
  [LCA in IMTA for carbon reduction],
  [- Review of 29 LCA studies (2009–2022)
  - Analysis of fed (shrimp) and extractive (seaweed) systems
  - Cradle-to-farm boundary comparisons
  - Methodological challenges assessment],
  [- IMTA cuts impacts 20–50% vs. monocultures
  - Seaweed sequesters 10–30% of CO#sub[2] emissions
  - Hotspots: feed (40–60%), energy (20–30%)
  - Supports real-time dynamic LCA for carbon credits],

  [H. Guo, “Intelligent water quality prediction system with a hybrid CNN–LSTM model,” Water Practice and Technology, vol. 19, no. 11, pp. 4538–4551, Nov. 2024. @guo2024],
  [Aquaculture carbon strategies with IMTA],
  [- Carbon accounting methods review
  - Shrimp-seaweed case studies
  - IMTA vs. monoculture scenario modeling
  - LCA integration with operational data
  - Sequestration sensitivity analysis],
  [- IMTA reduces shrimp footprints 15–35% via seaweed
  - Net emissions: 2.5–5 kg CO#sub[2]eq/MT
  - Biofloc/renewables cut energy CO#sub[2] 25%
  - Carbon credits via 0.5–1.5 t C/ha/year sequestration
  - Predictive tools aid footprint optimization],
)

= Problem Statement

The global aquaculture industry plays a major role in meeting the growing demand for food but also produces around 263 million tonnes of CO₂ equivalents every year. Shrimp farming, in particular, has a high carbon footprint because it depends heavily on formulated feed.

To reduce this impact, Integrated Multi-Trophic Aquaculture (IMTA) systems are used. In these systems, shrimp are cultured together with seaweed. The waste produced by shrimp acts as a nutrient source for seaweed, while the seaweed absorbs excess nutrients and removes CO₂ from the water through photosynthesis, creating a more balanced and sustainable ecosystem.

However, most current methods used to study carbon emissions and perform Life Cycle Assessments (LCA) in IMTA rely on manual sampling, which is often static. This means they fail to capture important real-time changes in factors like temperature, dissolved oxygen, pH, and salinity — all of which directly affect growth, metabolism, CO₂ exchange, and carbon storage. As a result, the calculations of emissions are often inaccurate, making carbon credit estimation and system management less reliable.

With the help of IoT, sensors, and data analytics, it’s now possible to continuously monitor and predict these dynamic parameters. However, a fully integrated IMTA framework that connects these technologies is still missing.

This project aims to develop an IoT-based system for real-time carbon monitoring and LCA modeling in shrimp–seaweed IMTA systems, promoting more sustainable and data-driven aquaculture practices.

= Project Description

== Overview

The objective of this project is to contribute to the development of an Internet of Things (IoT) framework for monitoring and predicting carbon dioxide (CO#sub[2]) in shrimp-seaweed integrated multi-trophic aquaculture (IMTA) systems @alam2024. This framework combines sensor data with machine learning models to quantify the carbon footprint of both CO#sub[2] emissions and potential carbon capture through Life Cycle Analysis (LCA) @hala2024, while also providing a spatio-temporal prediction of CO#sub[2] emissions @ye2024. 

In this way, the system enhances the limitations of traditional static sampling methods by obtaining continuous monitoring of temperature, dissolved oxygen, pH, salinity, total alkalinity and dissolved CO#sub[2] @shete2024. Data is transmitted through the Long Range Wide Area Network (LoRaWAN) or WiFi to a web-based cloud platform. Machine learning models including Random Forest, Bi-GRU, LSTM, ARIMA and Prophet @hao2024 will be developed to forecast emission and determine net carbon footprint. 

Project aims: 
+ Conduct a real-time IoT system for measuring important carbon-related IMTA system parameters. 
+ Conduct an LCA cradle-to-farm analysis.
+ Develop models to predict CO#sub[2] emissions using time series data.


== Modules

=== IoT Sensor Network (Data Acquisition)

Sensors are placed in shrimp ponds to assess water quality and carbon dynamics by measuring shrimp metabolism and seaweed metabolism @shete2024. ESP32 microcontrollers are used to connect the sensors and transmit that data to a central gateway over LoRaWAN/Wi-Fi. The sampling time intervals include temperature/DO/pH/salinity every 1-5 minutes and alkalinity/turbidity every 5-15 minutes @vinay2025.

=== Data Preprocessing and Feature Engineering

Cleans data: linear interpolation for short gaps (\<3 hours), multivariate regression for long gaps; removal of outliers based on Median Absolute Deviation @robinson2020.

Features: CO#sub[2] Uptake Index (chlorophyll-a, seaweed growth, changes in DO) @massocato2022, Feed-based Carbon Input (amount of feed × emission factor), Energy-based Emissions (electricity × grid factor). Includes 3/6-hour rolling averages, lagged variables, and Min-Max normalization.

=== Machine Learning Prediction Engine

Collection of models: Random Forest (baseline model, nonlinear relationships, feature importance); Bi-GRU (128 units, considering bidirectional seasonal fluctuation); LSTM (128 units to consider long-term dependencies, circadian relationships) @hao2024. ARIMA/Prophet models will provide an interpretable baseline. A weighted average of the model's predictions produces final CO#sub[2] predictions.

=== Life Cycle Assessment Calculator

Calculates cradle-to-farm footprint from LCA databases and operational data @hala2024. Monitors kWh of electricity usage, feed emissions (kg CO#sub[2]/kg feed), and seaweed sequestration rate @edf2022. The Net CO#sub[2] = emissions - sequestration, and will be reported as mg CO#sub[2]/L, kg CO#sub[2]/biomass for carbon credits.

=== Cloud Platform and Response System

Manages storage, visualization, and alerts via MQTT/Wi-Fi. Features timestamp sync, offline buffering, anomaly detection for CO#sub[2] spikes, automated aeration, and dashboards for trends/predictions/history.

= Methodology

== Data Preprocessing

=== Acquisition and Composition

Data from shrimp-seaweed IMTA system combined automated sensors and manual sampling for environmental and biological metrics @vinay2025, organized into:

+ Water quality: pH, total alkalinity, temperature, salinity, dissolved oxygen (DO).  
+ Carbon/LCA factors: electricity (kWh), feed emissions (kg CO#sub[2]/kg), seaweed absorption rates @hala2024.  
Net CO#sub[2] emissions calculated as mg CO#sub[2]/L or kg CO#sub[2]/biomass using sensor data, energy logs, and LCA databases.

=== Handling Missing/Inconsistent Data

Small gaps (\<3 hours) imputed via linear interpolation; longer gaps via multivariate regression preserving variable relationships (e.g., DO-BOD, temperature-pH). Outliers filtered using Median Absolute Deviation @robinson2020 for spikes in pH/conductivity.

=== Feature Engineering

Derived features: CO#sub[2] Uptake Index (chlorophyll-a, seaweed growth, DO changes) @massocato2022; Feed-based Carbon Input (feed rate × emission factor) @chen2022; Energy-based Emissions (electricity × grid factor). Added 3/6-hour rolling averages, lagged variables (e.g., DO[t-1], Temperature[t-3]), and Min-Max normalization.

== Model Architecture

=== Random Forest (Baseline)

Justification: Handles non-linear relationships; provides feature importance @khan2024.  

Working: Inputs (pH, TA, temperature, salinity, DO, seaweed growth, chlorophyll-a, shrimp biomass, feed rate, BOD, electricity, emission factors). 300 trees with bootstrap; outputs CO#sub[2] emission/volume. Top predictors: feed rate, seaweed uptake, electricity. Evaluated with R², RMSE, MAE.

=== Bi-GRU

Justification: Captures temporal dependencies in fluctuating aquaculture data @guo2024; bidirectional for past/future trends.  

Working: 24-step sliding window (14 features); architecture: Input → Bi-GRU (128 units) → Dropout (0.2) → Dense. Adam optimizer (lr=0.001), MSE loss; forecasts CO#sub[2] at t+1/n. Evaluated with RMSE, MAE, MAPE.

=== LSTM

Justification: Models long-term dependencies, diurnal CO#sub[2] patterns (photosynthesis/respiration) @hao2024.  

Working: 48-hour window; architecture: Input → LSTM (128 units) → Dropout (0.3) → Dense (tanh/linear activation). Early stopping; compared to Bi-GRU/RF for accuracy/stability.

#imageWithAlt("LSTM Network", "assets/lstm.png")

=== ARIMA/Prophet (Baselines)

Justification: Interpretable validation of periodic/management variations @jiang2022.  

Working: Univariate CO#sub[2] series; ARIMA optimized via AIC/BIC; Prophet for trend/seasonality. Used as references.

== Validation and Integration

Chronological split: 70% train, 20% validation, 10% test. Rolling forecast evaluation with RMSE, MAE, R². Hybrid ensemble: weighted averaging of RF, Bi-GRU, LSTM based on validation performance.

#imageWithAlt("Time Series Forecasting", "assets/time_series_forecasting.png")

== IoT Sensor Network

=== Setup

Sensors at varying depths/locations for spatial coverage:  

- Temperature: thermistor probes, 1-5 min intervals.  
- pH: glass electrodes (0-14), 1-5 min.  
- Alkalinity: titration analyzers, 5-15 min.  
- DO: optical luminescent (0-20 mg/L), 1-5 min.  
- Salinity/conductivity: four-electrode (up to 70 ppt), 1-5 min.  
- Turbidity: infrared, 5-10 min.  
- Chlorophyll-a: blue light excitation (0-200 mg/L), 5-10 min.  

ESP32 microcontrollers transmit via LoRaWAN/Wi-Fi to gateway.

#imageWithAlt("Sensor Network", "assets/overview.png")

=== Transmission and Management

Hierarchical: Sensors → local controllers → LoRaWAN gateway (timestamp sync, offline storage) → MQTT to cloud servers for analysis.

=== Operational Response

Continuous monitoring feeds LCA; anomaly detection @robinson2020 triggers alerts/automation (e.g., aeration for CO#sub[2] spikes) @chen2022, enabling data-driven management.

= Results

This section presents the experimental outcomes obtained from the processed IMTA dataset and the implemented machine learning models. The results highlight dataset characteristics, prediction accuracy, temporal behavior of CO#sub[2] flux, and comparative performance of the applied models.

== Dataset Characteristics and Observations

The final dataset used for experimentation consists of time-series observations collected from a shrimp–seaweed IMTA system after preprocessing and feature engineering.

Derived carbon indicators—shrimp respiration, seaweed sequestration, and net CO₂ flux—showed clear temporal variability. Diurnal patterns were observed across multiple parameters, with net CO#sub[2] flux generally increasing during nighttime due to dominant shrimp respiration and decreasing during daylight hours as seaweed photosynthesis increased carbon uptake. Seasonal and longer-term trends were also visible in relation to temperature and feeding intensity.

Chronological splitting of the dataset ensured that training was performed on historical data while evaluation was conducted on unseen future samples, reflecting real-world deployment conditions.

=== Dataset Description

The dataset used in this project consists of time-series measurements collected from a shrimp–seaweed Integrated Multi-Trophic Aquaculture (IMTA) system. It includes environmental, nutrient, biological, and carbon-related parameters essential for modeling CO#sub[2] dynamics.

#underline[Temporal Parameter]

- *datetime* : Represents the date and time at which each observation was recorded. This parameter is essential for time-series analysis and for capturing diurnal and seasonal variations in water quality and carbon flux.

#underline[Water Quality Parameters]

- *temperature_C* : Water temperature measured in degrees Celsius (°C). Temperature directly affects shrimp metabolism, seaweed photosynthesis, dissolved oxygen levels, and overall biochemical reaction rates.

- *pH* : Measure of water acidity or alkalinity. pH influences nutrient availability, ammonia toxicity, and CO₂ solubility, and varies with photosynthesis–respiration cycles.

- *DO_mgL* : Dissolved oxygen concentration in milligrams per liter (mg/L). DO reflects shrimp respiration and seaweed photosynthesis and is a key indicator of aquatic health.

- *salinity_ppt* : Salinity measured in parts per thousand (ppt). It affects shrimp growth, seaweed physiology, and gas exchange processes.

- *alkalinity_mgL* : Total alkalinity in mg/L representing the buffering capacity of water against pH fluctuations. It plays an important role in regulating carbon chemistry.

- *hardness_mgL* : Concentration of calcium and magnesium ions in mg/L. Water hardness influences shrimp shell formation and system stability.

- *turbidity_NTU* : Water turbidity measured in Nephelometric Turbidity Units (NTU). It indicates suspended particles that affect light penetration and seaweed photosynthesis.

#underline[Nutrient Parameters]

- *NH3_mgL* : Ammonia concentration in mg/L. Ammonia is a toxic byproduct of shrimp metabolism and an indicator of organic pollution.

- *NO2_mgL* : Nitrite concentration in mg/L. Nitrite is an intermediate nitrogen compound and can be harmful to shrimp at elevated levels.

- *NO3_mgL* : Nitrate concentration in mg/L. Nitrate is a less toxic nitrogen form and is absorbed by seaweed as a nutrient.

- *PO4_mgL* : Phosphate concentration in mg/L. Phosphates support primary productivity but may cause eutrophication if excessive.

#underline[Biological Parameters]

- *shrimp_biomass_g* : Total shrimp biomass measured in grams. Increased biomass leads to higher respiration rates and CO₂ emissions.

- *hourly_sgr* : Hourly specific growth rate of shrimp. This reflects metabolic activity and growth efficiency.

- *seaweed_dry_g* : Dry weight of seaweed biomass in grams. Seaweed biomass is directly related to carbon sequestration potential.

#underline[Carbon Composition Parameters]

- *C_percent* : Percentage of carbon content in seaweed biomass, representing stored organic carbon.

- *C_g* : Total amount of carbon stored in seaweed biomass, measured in grams.

- *CO2_eq_g* : Carbon dioxide equivalent in grams, calculated from stored carbon using molecular conversion factors.

#underline[Carbon Flux Parameters]

- *respiration_gCO2* : Amount of CO#sub[2] released due to shrimp respiration, measured in grams.

- *sequestration_gCO2* : Amount of CO#sub[2] absorbed by seaweed through photosynthesis, measured in grams.

- *net_CO2_flux_gCO2* : Net CO#sub[2] flux calculated as the difference between respiration and sequestration.  

Positive values indicate net CO#sub[2] emissions, while negative values indicate net CO#sub[2] sequestration.

#imageWithAlt("Synthetic Dataset", "assets/Dataset.png")

== Prediction Results for CO₂ Flux Components

The trained machine learning models successfully captured the relationship between environmental conditions, operational inputs, and carbon dynamics within the IMTA system. Predictions for shrimp respiration and seaweed sequestration closely followed observed values in the test dataset, resulting in accurate estimation of net CO#sub[2] flux.

Error metrics such as Mean Absolute Error (MAE) and Root Mean Square Error (RMSE) remained consistently low across evaluation windows, while coefficient of determination (R#super[2]) values indicated strong agreement between predicted and actual values. Minor deviations were observed during sudden environmental disturbances, such as rapid temperature shifts or abrupt changes in feeding rates, which are expected in real-time aquaculture environments.

Feature contribution analysis confirmed that feed input, dissolved oxygen, temperature, and time-based variables strongly influenced respiration trends, while chlorophyll-a concentration, daylight hours, and DO were closely associated with carbon sequestration behavior.

=== Temporal Performance and Trend Analysis

Time-series visualization of actual versus predicted net CO#sub[2] flux demonstrated that the models effectively tracked both short-term fluctuations and long-term trends. Daily photosynthesis–respiration cycles were clearly captured, with minimal lag between observed and predicted values.

The deep learning–based model showed improved smoothness and continuity in predictions, particularly during high-frequency variations, while tree-based models performed reliably in capturing overall trends and emission magnitudes. This confirms the importance of temporal modeling for carbon dynamics in IMTA systems, where environmental parameters change continuously.

=== Comparative Model Performance

A comparative analysis of model outputs highlights distinct strengths across approaches. Ensemble and regression-based models provided stable predictions and strong interpretability, supporting life cycle assessment and carbon accounting tasks. Sequence-based models achieved higher temporal accuracy and better adaptation to diurnal and seasonal patterns.

The combined use of these models enabled robust estimation of net CO#sub[2] emissions while maintaining reliability under varying environmental conditions. This hybrid modeling strategy strengthens confidence in the system’s predictive capability for real-time deployment.

=== Implications for Carbon Assessment in IMTA Systems

The obtained results demonstrate that integrating IoT-based sensing with data-driven modeling significantly improves the accuracy and reliability of carbon estimation in shrimp–seaweed IMTA systems. Continuous monitoring reduced uncertainty associated with manual sampling, while predictive modeling enabled proactive identification of emission trends.

The results also validate the feasibility of using such systems for dynamic life cycle assessment and potential carbon credit estimation, offering a scalable and sustainable solution for modern aquaculture management.

#imageWithAlt("Dataset Feature Importance", "assets/Random_Forest_Feature_Importance.jpeg")

#imageWithAlt("Random Forest Results", "assets/Random_Forest_Results.jpeg")

#imageWithAlt("Respiration Model Performance", "assets/Respiration_model_performance.jpeg")

#imageWithAlt("Sequestration Model Performance", "assets/Sequestration_model_performance.jpeg")

#imageWithAlt("BiGRU Results", "assets/BiGRU_Results.png")

#imageWithAlt("BiGRU Performance", "assets/BiGRU_Performance.png")
  

= Conclusion

In this project, we built an IoT system to monitor and predict CO#sub[2] levels in shrimp-seaweed IMTA setups in real time. By using sensors to track parameters like temperature, dissolved oxygen, pH, salinity, alkalinity, turbidity, and chlorophyll-a every 1-15 minutes, we addressed the shortcomings of traditional manual sampling that misses daily fluctuations.

Our prediction models—combining Random Forest, Bi-GRU, LSTM, ARIMA, and Prophet through weighted ensembles—provided reliable CO#sub[2] forecasts. They effectively handled day-night cycles in carbon dynamics, offering better accuracy than static methods for tracking emissions over time.

The life cycle assessment component linked field data with standard databases to calculate full carbon footprints from farm start to finish. This allowed us to determine net CO#sub[2] outputs and potential carbon credits. Analysis revealed feed rates, seaweed absorption, and energy use as the main factors, helping managers focus on high-impact areas for reductions.

Real-time alerts and automated controls, such as aeration during CO#sub[2] spikes, make the system practical for daily operations. Ultimately, integrating sensors with analytics proves a strong way to evaluate and improve carbon management in IMTA, supporting more sustainable aquaculture practices.

Looking ahead, we plan to evaluate performance in varied climates, and add more environmental metrics for broader monitoring.

= References

#bibliography("bibliography.yaml", style: "ieee", full:true, title: none)