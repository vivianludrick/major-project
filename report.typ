#set page(
  paper: "a4",
  margin: (top: 1in, bottom: 1in, left: 1.5in, right: 1in),
)

#set par(
  justify: true,
  leading: 1em,
  spacing: 1.5em,
)
#let line_spacing = 1.5em
#let paragraph_spacing = 2em

#set text(
  font: "Times New Roman",
  size: 12pt,
)

#set heading(numbering: "1.1.")

// Level 1: 14pt, bold + underline, centered, page break before
#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: raw)).update(0)

  pagebreak()

  show heading: it => {
    align(center)[
      #block(above: 1.5em, below: 2em)[
        #set text(size: 14pt, weight: "bold")
        #underline[
          #if it.numbering != none {
            counter(heading).display(it.numbering)
            [ ] // This is the space that will now be underlined
          }
          #it.body
        ]
      ]
    ]
  }
  it
}

// Level 2: 14pt, bold only
#show heading.where(level: 2): it => {
  block(above: 1.5em, below: 1.5em, sticky: true)[
    #text(size: 14pt, weight: "bold")[#it]
  ]
}

// Level 3: 14pt, underline only
#show heading.where(level: 3): it => {
  block(above: 1.5em, below:1.5em,sticky: true)[
    #text(size: 12pt, weight: "regular")[
      #underline[
        #if it.numbering != none {
          counter(heading).display(it.numbering)
          [ ] // This is the space that will now be underlined
        }
        #it.body
      ]
    ]
  ]
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

#let title=[Data-Driven CO#sub[2] Monitoring and Prediction in an IoT-Based Shrimp–Seaweed Integrated Multi-Trophic Aquaculture System]

#let guide=(
  name:"Heena Pendhari", 
  designation:"Assistant Professor",
  shortDesignation:"Prof."
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
    #text(size: 18pt, weight: "bold")[
      #pageTitle
    ]
  ]
}


// Starts here

#align(center)[

  #text(size: 18pt, weight: "bold")[
    #title
  ]

  #v(0.5em)

  A project report submitted in partial fulfillment\
  of the requirements for the degree of

  #v(0.5em)

  #text(size: 15pt, weight: "bold")[
    Bachelor of Engineering\
    In\
    Computer Engineering
  ]

  #v(0.5em)

  by

  #v(0.5em)

  #text(weight: "bold")[
    Mark Lopes (9913)\
    Aryan Daripkar (9882)\
    Pratyay Koley (9909)\
    Vivian Ludrick (9914)
  ]

  #v(0.5em)

  Under the guidance of\
  #text(weight: "bold")[#guide.name]\
  #text(weight: "bold")[#guide.designation]

  #v(0.5em)

  #image("assets/clg_logo.png", width: 25%)

  #v(0.5em)

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

#set par(leading: line_spacing, spacing: paragraph_spacing)

#align(center + horizon)[
  _This work is dedicated to my family.\
  I am very thankful for their motivation and support._
]

#pagebreak()

#align(center)[
  #addPageTitle("Internal Approval Sheet")

  #v(1em)

  #text(
    size: 14pt,
    weight: "bold"
  )[CERTIFICATE]

  #v(1em)
]


This is to certify that the project entitled *"#title"* is a bonafide work of *Mark Lopes (9913), Aryan Daripkar (9882), Pratyay Koley (9909), Vivian Ludrick (9914)* submitted to the University of Mumbai in partial fulfillment of the requirement for the award of the degree of Bachelor in *Computer Engineering*.

#v(10em)

#grid(
  columns: 5,
  rows: 1,
  column-gutter: 1fr,
  align: center + horizon,
)[][
  *#guide.shortDesignation #guide.name*\
  Guide
][][
  *#coGuide.name*\
  Co-Guide
][]

#v(8em)

#grid(
  columns: 5,
  rows: 1,
  column-gutter: 1fr,
  align: center + horizon,
)[][
  *Dr. Sujata Deshmukh*\
  Head of Department
][][
  *Dr. Sapna Prabhu*\
  Principal
][]

#pagebreak()


#addPageTitle("Approval Sheet")
#v(1em)
#align(center)[
  #text(size:14pt, weight: "bold")[
    Project Report Approval
  ]
]
#v(2em)

This project report entitled *#title* by *Mark Lopes, Aryan Daripkar, Pratyay Koley and Vivian Ludrick* is approved for the
degree of Bachelor of Engineering in Computer Engineering.
#v(10em)

Examiner 1. ————————————–

Examiner 2. ————————————–

#v(7em)

Date:

Place:

#pagebreak()

#addPageTitle("Declaration")

We declare that this written submission represents our ideas in our own words and where others’ ideas or words have been included, we have adequately cited and referenced the original sources. We also declare that we have adhered to all principles of academic honesty and integrity and have not misrepresented or fabricated or falsified any idea/data/fact/source in my submission. We understand that any violation of the above will be cause for disciplinary action by the Institute and can also evoke penal action from the sources which have thus not been properly cited or from whom proper permission has not been taken when needed.

#v(20em)

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

#addPageTitle("Abstract")

The aquaculture industry plays a major role in meeting the global food supply but it also contributes significantly to greenhouse gas emissions. Shrimp farming in particular is a carbon-intensive process due to high feed requirements. IMTA(Integrated Multi-Trophic Aquaculture) systems offer a sustainable alternative to conventional farming methods by combining two species: fed (shrimp) and extractive (seaweed) that absorb excess nutrients in the water and balance CO#sub[2] levels.

Conventional monitoring methods for aquaculture rely on sampling at intervals and are therefore unable to continuously capture the fluctuating nature of key environmental measurements (e.g., temperature, dissolved oxygen (DO), pH, salinity), which in turn influence CO#sub[2] concentration. Thus, static data points do not provide sufficient information for decision-making because environmental variables that influence the CO#sub[2] value are not adequately represented in static snapshots. To address this shortcoming, we propose a real-time IoT-based, data-driven framework for continuous monitoring and predicting CO#sub[2] concentrations in shrimp/seaweed IMTA systems by integrating a network of sensors with machine learning and time series models that will intelligently analyze environmental variables.

The proposed framework addresses this shortcoming through three major objectives: (i) the creation of a real-time IoT-based monitoring system for measuring carbon-related environmental variables; (ii) developing predictive models of CO#sub[2] concentrations using statistical and machine learning-based methods including Random Forest, Bi-GRU, XGBoost; and (iii) data-driven decision-making for improved sustainability and efficiency of aquaculture operations.

Overall, we provide a framework that produces accurate and scalable solutions for continuous monitoring and predicting CO#sub[2] concentrations, therefore accelerating the adoption of smarter and more sustainable aquaculture practices.

#pagebreak()

#block(breakable: false)[

  #addPageTitle("Acknowledgments")

  We have great pleasure in presenting the report on *"#title"*. We take this 
  opportunity to express my sincere thanks towards the guide #guide.shortDesignation #guide.name, 
  C.R.C.E, Bandra (W), Mumbai, and co-guide #coGuide.name (#coGuide.designation) for providing the technical guidelines, and the 
  suggestions regarding the line of this work. We enjoyed discussing the work 
  progress with her during our visits to department. 

  We thank Dr. Sujata Deshmukh, Head of Computer Engineering department, 
  Principal and the management of C.R.C.E., Mumbai for encouragement and 
  providing necessary infrastructure for pursuing the project. 

  We also thank all non-teaching staff 
  for their valuable support, to complete our project.

  #v(12em)
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
]

#set par(leading: 1em, spacing: 1.5em)

#show outline: it => {
  show heading.where(level: 1): h => {
    align(center)[
      #block(above: 1.5em, below: 1.5em)[
        #text(size: 18pt, weight: "bold")[#h.body]
      ]
    ]
  }
  pagebreak()
  it
}

#outline(
  title: addPageTitle("Contents")
)

#outline(
  title: addPageTitle("List of Figures"),
  target: figure.where(kind: image),
)

#set par(leading: line_spacing, spacing: paragraph_spacing)

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

Feeding a rapidly growing global population remains a significant challenge, with aquaculture emerging as a key contributor to food production, surpassing traditional capture fisheries. However, the rapid expansion of aquaculture has raised environmental concerns, particularly due to the emission of greenhouse gases such as carbon dioxide (CO#sub[2]), methane (CH₄), and nitrous oxide (N₂O). Aquaculture drives greenhouse gas emissions in a variety of ways at each stage of production, from production and consumption of feed through energy consumed to biological processes occurring on-site. The contribution of aquaculture globally to greenhouse gas emissions is significant; shrimp farming in particular is one of the most carbon intensive forms of aquaculture primarily because it has a high demand for feed and requires a high degree of management.

Integrated Multi-Trophic Aquaculture (IMTA) is becoming a viable option for sustainable aquaculture production, as it allows for the cultivation of both fed species (such as shrimp) and extractive species (such as seaweed) in one environment. The extractive species remove excess nutrients and dissolved carbon that result from the fed species, and the seaweed is a major consumer of carbon dioxide as well as nitrogen and phosphorus, creating a better quality of water and helping to slow the accumulation of carbon in the system.

Although IMTA has been shown to be effective in improving aquaculture systems, most of the research to date has been conducted using static and infrequent measurements, often through the use of manual or controlled sampling methods. In the real world, many aquatic parameters (such as temperature, dissolved oxygen (DO), pH, and salinity) experience continual fluctuation. These fluctuations have a profound impact on shrimp metabolism and seaweed growth; therefore, they also affect CO#sub[2] concentration and system stability. Because of these continually changing parameters, traditional monitoring methods cannot provide accurate real-time system behavior; therefore, the ability to make sound operational decisions is limited.

In recent times, there have been many advancements made in regard to the Internet of Things (IoT) technologies, as well as data-driven analytics, which can help to mitigate some of the limitations discussed previously. With the use of integrated sensor-based IoT systems, it will be possible to obtain real-time continuous data on environmental parameters (e.g., temperature, dissolved oxygen, pH, salinity and dissolved CO#sub[2]). This data can then be analyzed in order to develop machine learning and time-series forecasting models, which will allow us to detect trends, identify temporal dependencies and ultimately, provide more accurate predictions for future CO#sub[2] levels.

Therefore, in light of the above, this research presents an IoT-based data-driven framework for real-time monitoring and prediction of CO#sub[2] in a shrimp–seaweed IMTA system. The objectives of this research include the following:
+ Create a real-time IOT device that has sensors that can continuously monitor things related to carbon like how many free carbon dioxide molecules there are in the water (dissolved CO#sub[2]), dissolved oxygen (DO), temperature, pH, salinity, and alkalinity, from inside a shrimp-seaweed aquaculture set up, and keep track of them all in real time.

+ Develop and build models that can predict future amounts of CO#sub[2] in the environment where aquaculture takes place, using machine learning and time-series modeling techniques (e.g. Random Forest, Bi-GRU, XGBoost).

+ Use the information collected by these IOT devices and your predictions from your modelling activities to guide decisions made by aquaculture producers that will lead to better use of resources and sustainability of operations.

= Literature Review

#set par(leading: 1em)

#table(
  columns: (1.25fr, 1fr, 1fr, 1.5fr),
  align: (left, left, left, left),
  stroke: 0.5pt + gray,
  inset: 8pt,

  [*Paper*], 
  [*Key Focus*], 
  [*Methodology Used*], 
  [*Key Findings Relevant to The Project*],

  [Y. Liu et al., “Effects of shellfish and macro-algae IMTA in North China on the environment, inorganic carbon system, organic carbon system, and sea-air CO#sub[2] fluxes,” Frontiers in Marine Science, vol. 9, p. 864306, Apr. 2022 @liu2022],
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

#set par(leading: line_spacing, spacing: paragraph_spacing)

= Problem Statement

The aquaculture industry contributes significantly to satisfying the world's growing food demand, yet contributes approximately 263 million tonnes of equivalent CO#sub[2] to the atmosphere each year. Shrimp farming is particularly carbon-intensive due mainly to the amount of formulated feed used in the operation. Integrated Multi-Trophic Aquaculture (IMTA) can help lessen this ecological footprint with the incorporation of seaweed into the same culture as shrimp farming. The shrimp naturally provide organic waste, which provides nutrients for the seaweed. Likewise, the seaweed provides nutrient uptake through excess nutrient uptake and carbon dioxide removal when it photosynthesizes. Together, these create a sustainable ecosystem. 

The vast majority of existing research regarding the carbon balance of IMTA systems has relied on infrequent manual sampling, which has been static in nature. Therefore, temporal changes in key environmental variables, such as temperature, dissolved oxygen (DO), pH and salinity, have not been measured in real time. These dynamic variables have a substantial impact on all biological processes, such as shrimp metabolism and seaweed growth, and thus they significantly impact the overall carbon balance of the IMTA system. Thus, current methodologies of measuring and analysing carbon balance in IMTA systems have failed to provide the necessary accuracy to effectively manage these systems.

The advent of the Internet of Things (IoT), sensor technology and data analysis has made it possible to measure and predict the temporal variability of dynamic environmental variables on a continuous basis. Yet, there remains a vacuity for an all-encompassing IMTA system that will unite these technologies.

The goal of this proposed project is to create a real-time approach to the monitoring and prediction of CO#sub[2] within the combined shrimp and seaweed IMTA system through an IoT-based framework. The design of the project will include continuous monitoring through IoT devices, coupled with data analytics software, for decision making processes that can lead to improved sustainability and efficiency of aquaculture.

= Project Description

== Overview

The objective of this project is to contribute to the development of an Internet of Things (IoT) framework for monitoring and predicting carbon dioxide (CO#sub[2]) in shrimp-seaweed integrated multi-trophic aquaculture (IMTA) systems @alam2024. This framework combines sensor data with machine learning models to quantify the CO#sub[2] emissions @hala2024, while also providing a spatio-temporal prediction of CO#sub[2] emissions @ye2024. 

In this way, the system enhances the limitations of traditional static sampling methods by obtaining continuous monitoring of temperature, dissolved oxygen, pH, salinity, total alkalinity and dissolved CO#sub[2] @shete2024. Data is transmitted via Wi-Fi to a web-based cloud platform using API-based communication, with local SD card storage for offline buffering during network interruptions. Machine learning models including Random Forest, Bi-GRU and XGBoost @hao2024 will be developed to forecast emission and determine net carbon footprint. 

Project aims: 
+ Conduct a real-time IoT system for measuring important carbon-related IMTA system parameters. 
+ To develop and evaluate machine learning and time-series models for accurate prediction of CO#sub[2] levels using temporal data.
+ To enable continuous monitoring and predictive insights for supporting sustainable and efficient aquaculture management.


== Modules

=== IoT Sensor Network (Data Acquisition)

Sensors are placed in shrimp ponds to assess water quality and carbon dynamics by measuring shrimp metabolism and seaweed metabolism @shete2024. ESP32 micro-controllers interface with the sensors for data acquisition and local processing, and transmit the data directly to the cloud over Wi-Fi. An SD card module is integrated for offline data storage during network interruptions. The sampling time intervals include temperature/DO/pH/salinity every 1-5 minutes and alkalinity/turbidity every 5-15 minutes @vinay2025.

=== Data Preprocessing and Feature Engineering

Cleans data: Data will be cleaned using linear interpolation for the short gaps (under 3h) in data, and multivariate regression for the longer gaps. Outliers will be removed using the Median Absolute Deviation method @robinson2020.

Features: Features of the cleaned dataset will include: the CO#sub[2] Uptake Index (includes seaweed growth rates and changes in DO) @massocato2022, Feed-based Carbon Input (amount of animal feed × emission factor), Energy-based Emissions (amount of electricity used to produce the food item × grid emission factor) and a 3/6-hour rolling average of each variable, along with a lagging variable for each, and finally the data will be max-min normalized.

=== Machine Learning Prediction Engine

Collection of models: Random Forest (base model with non-linear relationships and feature importance), Bi-GRU (128 units and bidirectional seasonal oscillation), XGBoost @hao2024.  Final CO#sub[2] forecasts will be implemented with a simple weight average of the models' forecasts.

=== Cloud Platform and Response System

Sensor data from the ESP nodes is stored both in Supabase and in real time, allowing for access at any time, and providing for future scalability. Wi-Fi management features include timestamp synchronization, offline buffering, anomalous CO#sub[2] spike detection and alerting, automated aeration control, trend monitoring, prediction monitoring, and historical data monitoring dashboards.

= Methodology

== Data Preprocessing

=== Acquisition and Composition

Data from shrimp-seaweed IMTA system combined automated sensors and manual sampling for environmental and biological metrics @vinay2025, organized into:

+ Water quality: pH, total alkalinity, temperature, salinity, dissolved oxygen (DO).  
+ Carbon emission factors: electricity (kWh), feed emissions (kg CO#sub[2]/kg), seaweed absorption rates @hala2024.
CO#sub[2] levels were measured as concentration in parts per million (ppm) using sensor data, representing the dissolved CO#sub[2] present in the water.

=== Handling Missing/Inconsistent Data

Small gaps (\<3 hours) imputed via linear interpolation; longer gaps via multivariate regression preserving variable relationships (e.g., DO-BOD, temperature-pH). Outliers filtered using Median Absolute Deviation @robinson2020 for spikes in pH/conductivity.

=== Feature Engineering

Derived features: CO#sub[2] Uptake Index (seaweed growth, DO changes) @massocato2022; Feed-based Carbon Input (feed rate × emission factor) @chen2022; Energy-based Emissions (electricity × grid factor). Added 3/6-hour rolling averages, lagged variables (e.g., DO[t-1], Temperature[t-3]), and Min-Max normalization.

== Model Architecture

=== Random Forest (Baseline)

Justification: Handles non-linear relationships; provides feature importance @khan2024.  

Working: Inputs (pH, TA, temperature, salinity, DO, seaweed growth, feed rate, BOD, electricity, emission factors). 300 trees with bootstrap; outputs CO#sub[2] emission/volume. Top predictors: feed rate, seaweed uptake, electricity. Evaluated with R², RMSE, MAE.

=== Bi-GRU

Justification: Captures temporal dependencies in fluctuating aquaculture data @guo2024; bidirectional for past/future trends.  

Working: 24-step sliding window (14 features); architecture: Input → Bi-GRU (128 units) → Dropout (0.2) → Dense. Adam optimizer (lr=0.001), MSE loss; forecasts CO#sub[2] at t+1/n. Evaluated with RMSE, MAE, MAPE.

=== LSTM

Justification: Models long-term dependencies, diurnal CO#sub[2] patterns (photosynthesis/respiration) @hao2024.  

Working: 48-hour window; architecture: Input → LSTM (128 units) → Dropout (0.3) → Dense (tanh/linear activation). Early stopping; compared to Bi-GRU/RF for accuracy/stability.

#imageWithAlt("LSTM Network", "assets/lstm.png")

=== XGBoost

// todo

== Validation and Integration

Chronological split: The training/validation/test split for the three methods will be 70% for training, 20% for validating and 10% for testing, and the results will provide validation inputs used in each of the analyses of time series forecasting.

#imageWithAlt("Time Series Forecasting", "assets/time_series_forecasting.png")

== IoT Sensor Network

=== Setup

Sensors at varying depths/locations for spatial coverage:  

- Dissolved CO#sub[2]: infrared-based sensor (0–2000 / 5000 / 10000 ppm range), accuracy ±(20 ppm + 5% of reading), response time < 20 s, 1–5 min intervals.
- Temperature: At 1 to 5 min intervals, use thermistor probes to track water temperature.  
- pH: glass electrodes (0-14), 1-5 min.  
- Alkalinity: Alkalinity data is measured using titration analyzers at 5 to 15 min intervals.
- DO: optical luminescent (0-20 mg/L), 1-5 min.  
- Salinity/conductivity: four-electrode (up to 70 ppt), 1-5 min.  
- Turbidity: Turbidity will be measured every 5 to 10 minutes using infrared sensors.  

ESP32 microcontrollers are used to transmit data to the cloud via Wi-Fi using REST APIs. An SD card in each microcontroller is also used to buffer data offline. 

#imageWithAlt("Architecture Diagram", "assets/overview.png")

=== Transmission and Management

The sensor data will go through to a supabase database via an esp32 microcontroller over wifi pathways. The esp32 will consolidate multiple sensor readings (Temperature, pH, DO, CO2, salinity) before sending them to the cloud via the supabase APIs and using the most reliable manner to transmit the measurement data to ensure that all data is recorded and transmitted properly.

If the data failed to send due to a network failure, it is stored locally on the sd card until the network comes back online at which point the esp32 will synchronize the local buffer of historical data to the cloud ensuring an uninterrupted data flow and storage.

= Results

The results from testing IMTA datasets and the corresponding analytics model outputs are provided below. The results show how the dataset behaves, how accurately CO#sub[2] in this space can be predicted over time, and how well the various predictions performed when compared to each other.

== Dataset Characteristics and Observations

The dataset is comprised of time-series observations that have been gathered from a shrimp-seaweed (Integrated Multi-Trophic Aquaculture), and pre-processed during the data preparation stage.

The derived carbon indicators/shrimp respiration (carbon released by shrimp), seaweed sequestration (carbon captured by seaweed), and net CO#sub[2] flux (the difference between the amount of carbon in shrimp and that in seaweed) all had fairly distinct temporal patterns. Each of the carbon indicators exhibited distinct day/night patterns /i.e. net CO#sub[2] flux was generally higher at night due primarily to shrimp respiration, and lower during the day when seaweed was performing photosynthesis and capturing carbon/. Additionally, each of the carbon indicators displayed seasonal trends and some long-term trends in accordance with temperature increases and feeding intensity increases.

The datasets used for training and testing will be split chronologically; i.e. the training set will be composed of past data while the test set will be made up of future ("unseen") data, thereby simulating the type of conditions that would be present in a real-world scenario.

=== Dataset Description

This project utilized a dataset composed of time-series data for a shrimp-seaweed IMTA system in relationship to CO#sub[2] dynamics and includes environmental, nutrient, biological, and carbon-related measurements that are necessary for creating a model to simulate CO#sub[2] dynamics

#underline[Temporal Parameter]

- *datetime* : Represents the date and time at which each observation was recorded. This parameter is essential for time-series analysis and for capturing diurnal and seasonal variations in water quality and carbon flux.

#underline[Water Quality Parameters]

- *temperature_C* : Water temperature measured in degrees Celsius (°C). Temperature directly affects shrimp metabolism, seaweed photosynthesis, dissolved oxygen levels, and overall biochemical reaction rates.

- *pH* : Measures how acidic or alkaline the water is. The pH level can influence the nutrients available for aquatic creatures, and whether or not ammonia is toxic to shrimp, as well as whether CO#sub[2] can dissolve in the water, and it will change with cycles of photosynthesis and respiration.

- *DO_mgpL* : Concentration of dissolved oxygen (DO) in milligrams per liter (mg/L) of water. The DO level reflects both shrimp breathing and seaweed photosynthesis, and is an important indicator of the health of the aquatic ecosystem.

- *salinity_ppt* : Measured as parts per thousand (ppt), the salinity will determine how fast shrimp grow; how the seaweed’s photosynthesis works; and how quickly gas exchange occurs.

- *alkalinity_mgL* : The total alkalinity in mg/L is the ability of the water to resist fluctuation or changes in pH level, and will be used to determine how much buffering capacity there is. The alkalinity level also plays an important role in maintaining balance in the chemical process of carbon.

- *hardness_mgL* : The concentration of calcium and magnesium in water, expressed in mg/L. Hardness of the water determines how well shrimp can form their shells and how stable the system will be.

- *turbidity_NTU* : Turbidity measured in Nephelometric Turbidity Units (NTU), indicates the concentration of particulate material suspended in the water, and can have an impact on how much light penetrates the water and thus, how well the seaweed will be able to photosynthesize.

#underline[Nutrient Parameters]

- *NH3_mgL* : The concentration of ammonia in milligrams per liter (mg/L). Ammonia is generated from the metabolism of shrimp and indicates levels of organic pollution.

- *NO2_mgL* : The concentration of nitrites (NO) as a milligram per liter (mg/L). Nitrites are intermediate forms of nitrogen and are harmful to shrimp if concentrations are high.

- *NO3_mgL* : The concentration of nitrates as a milligram per liter (mg/L). Nitrates are a less toxic form of nitrogen and are used by seaweed as nutrients.

- *PO4_mgL* : The concentration of phosphates (PO) as a milligram per liter (mg/L) in water. Phosphates encourage the growth of plants but, if they are too abundant, can result in an excessive amount of algae and other organisms (i.e. eutrophication).

#underline[Biological Parameters]

- *shrimp_biomass_g* : The total shrimp biomass in grams of shrimp. Increasing biomass will cause increased respiration rates and carbon dioxide (CO#sub[2]) emissions.

- *hourly_sgr* : The specific hourly growth rate of shrimp, relating to their metabolic rate and how efficiently they are growing.

- *seaweed_dry_g* : The dry (weight) biomass of seaweeds in grams of seaweed. The biomass of seaweed will directly relate to the amount of carbon it can sequester.

#underline[Carbon Composition Parameters]

- *C_percent* : The percent of carbon contained in the biomass of seaweed.

- *C_g* : The total grams of carbon contained in the biomass of seaweed.

- *CO2_eq_g* : The carbon dioxide equivalent, in grams, calculated from the amount of stored carbon using factor conversions for the molecular weight of carbon dioxide.

#underline[Carbon Flux Parameters]

- *respiration_gCO2* : Amount of CO#sub[2] released due to shrimp respiration, measured in grams.

- *sequestration_gCO2* : Amount of CO#sub[2] absorbed by seaweed through photosynthesis, measured in grams.

- *net_CO2_flux_gCO2* : Net CO#sub[2] flux calculated as the difference between respiration and sequestration.  

Positive values indicate net CO#sub[2] emissions, while negative values indicate net CO#sub[2] sequestration.

#imageWithAlt("Dataset", "assets/Dataset.png")

== Prediction Results for CO#sub[2] Flux Components

The machine learning algorithms demonstrated an excellent fit of the environmental measurements with the CO#sub[2] concentration dynamics in an IMTA system. CO#sub[2] values predicted by the models for the test dataset corresponded closely with the measurements from the sensors used in the test dataset; thus, illustrating the robustness of the model.

Most of the evaluation window's errors (MAE and RMSE) were low and showed very strong agreement (R2) between the predicted and actual values of CO#sub[2]. The only instance where an unexpected disturbance could be observed was due to sudden environmental change such as a rapid change in temperature which is expected in aquaculture systems.

The analyzation of features showed that temperature, dissolved oxygen, pH levels, and time had the most significant impact on variations in CO#sub[2] concentrations within the system.

=== Temporal Performance and Trend Analysis

Models that predict CO#sub[2] concentration levels captured both long-term trends and short-term fluctuations. Daily variation due to environmental changes was closely tracked with little lag time from actual to predicted levels of CO#sub[2] concentration.

The improved performance of the deep learning-based model provided a more consistent and continuous set of predictions for high-frequency fluctuations, whereas tree-based models performed reliably for capturing overall trends and the magnitude of carbon emissions. Therefore, there is a critical reason to consider temporal modeling for carbon dynamics in IMTA systems, where environmental factors continue to change.

=== Comparative Model Performance

There was a comparative analysis of the outputs from each of the predictive modeling approaches. The ensemble regression and the regression model provided consistent predictions with high levels of interpretability, providing information for carbon accounting and life cycle assessment tasks, while the sequence-based models provided greater accuracy in predicting temporal patterns and provided for flexibility when modeling diurnal and seasonal variability.

The combination of all three models provided for reasonable estimates of net CO#sub[2] emissions while producing reliable predictions across distinct and/or continuous environmental conditions. This hybrid modeling approach increases the degree of confidence in the predictive ability of this system for making real-time predictions for IMTA systems.

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

A real-time, IoT-enabled CO#sub[2] monitoring and forecasting system was developed for integrated multi-trophic aquaculture (IMTA) of shrimp and seaweed. The system collects multiple environmental parameters (e.g., temperature, dissolved oxygen, pH, salinity, alkalinity, turbidity) with multiple sensors within short intervals (1–5 minutes) to overcome the limitations of traditional manual sampling, which is unable to capture the dynamics of environmental fluctuations.

The proposed prediction algorithm, which combines multiple models through a weighted ensemble approach (Random Forest, Bidirectional Gate Recurrent Unit (Bi-GRU), Long Short-Term Memory (LSTM), Autoregressive Integrated Moving Average (ARIMA), and Prophet), provides accurate CO#sub[2] forecasting, captures temporal variation (i.e., day-night cycles), and provides much more accurate and continuous insights about the environment compared to traditional methods of static monitoring.

Feature analyses identified that environmental parameters (temperature, dissolved oxygen, pH) and time-dependent variables have a large impact on the variability of CO#sub[2] in the system. These insights provide improved knowledge of how environmental variables impact aquatic systems and enable informed management decisions for aquaculture production.

The combination of continuous real-time monitoring with predictive analytics will allow for proactive control of the environment. For example, if CO#sub[2] levels are found to exceed acceptable levels, then automated controls (e.g., aeration) can assist with improving operational efficiency, while simultaneously maintaining a stable environment.

Through the proposed framework, we can see how using machine learning techniques along with IoT-based sensors allows for the ongoing measurement and prediction of conditions in an aquaculture system to help establish intelligent and sustainable aquaculture systems based upon actionable insights derived from your data and real-time decision-making.

The next phase for this research includes putting the system into place at various sites with different environmental characteristics; collecting more data to allow the model to be generalized among multiple sites; and adding additional parameters to allow for additional insights into the environment of an aquaculture operation.


= References

#bibliography("bibliography.yaml", style: "ieee", full:true, title: none)
