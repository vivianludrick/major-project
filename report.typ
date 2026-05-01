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

#let imageWithAlt(altText, imagePath, width: 85%) = {
  figure(
    kind: image,
    caption:[#altText] 
  )[
    #image(imagePath, width: width)
  ]
}

#let imagePair(altA, pathA, altB, pathB) = {
  grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    figure(kind: image, caption: [#altA])[#image(pathA, width: 100%)],
    figure(kind: image, caption: [#altB])[#image(pathB, width: 100%)],
  )
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

We declare that this written submission represents our ideas in our own words and where others' ideas or words have been included, we have adequately cited and referenced the original sources. We also declare that we have adhered to all principles of academic honesty and integrity and have not misrepresented or fabricated or falsified any idea/data/fact/source in my submission. We understand that any violation of the above will be cause for disciplinary action by the Institute and can also evoke penal action from the sources which have thus not been properly cited or from whom proper permission has not been taken when needed.

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

Shrimp aquaculture accumulates dissolved CO#sub[2] through continuous shrimp respiration and organic waste decomposition. Integrated Multi-Trophic Aquaculture (IMTA) mitigates this by co-cultivating seaweed alongside shrimp. The seaweed absorbs dissolved CO#sub[2] through photosynthesis during daylight hours and produces dissolved oxygen as a by-product, functioning as a natural carbon sink. Over a full diel cycle, photosynthetic drawdown outweighs overnight seaweed respiration, resulting in a net reduction in dissolved CO#sub[2] compared to a seaweed-absent system.

This project validates this effect through real field measurements at a shrimp farm in Konkan Division, Maharashtra, India. A custom ESP32-based IoT sensor node recorded 1,502 dissolved CO#sub[2] readings over eleven days (28 March - 7 April 2026), spanning an IMTA phase (approx. seven days, _Red Seaweed_ sp. present) and a non-IMTA phase (approx. four days, seaweed removed). Field data confirms that net dissolved CO#sub[2] is measurably lower during the IMTA phase, providing empirical evidence for the carbon mitigation effect of IMTA in Indian pond aquaculture.

Since the sensor measured only CO#sub[2], XGBoost models trained on a reference IMTA dataset were used to synthetically generate companion variables (respiration, sequestration, DO, ammonia, nitrite, nitrate, pH), producing a 2,150-row hybrid dataset. Three models were then trained on this data using a chronological 80/20 split: XGBoost (R² = 0.84/0.80), Random Forest (R² = 0.845/0.836), and a Bidirectional GRU (R² = 0.91/0.95) for respiration and sequestration respectively. The BiGRU achieved the strongest performance by capturing temporal dependencies in the diurnal CO#sub[2] cycle, demonstrating the viability of data-driven carbon forecasting from a single-sensor deployment.

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

  We are grateful to the aquaculture farm at Konkan Division, Maharashtra for 
  granting us access to their shrimp pond for field data collection, without 
  which this work would not have been possible.

  #v(8em)
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

#outline(
  title: addPageTitle("List of Tables"),
  target: figure.where(kind: table),
)

#set par(leading: line_spacing, spacing: paragraph_spacing)

#set page(numbering: "1")
#counter(page).update(1)

#set page(
  footer: context {
    let page-num = counter(page).get().first()
    if page-num > 0 {
      align(center)[
        #counter(page).display("1")
      ]
    }
  }
)

= Introduction

Aquaculture is one of the fastest-growing food production sectors and helps meet rising seafood demand as wild fisheries decline due to fish removals. However, shrimp farming has a high carbon footprint, with elevated dissolved CO#sub[2] from shrimp respiration and microbial breakdown of feed wastes, alongside limited plant uptake in monoculture systems @hala2024. High CO#sub[2] levels are also linked to poor shrimp health, increasing stress and reducing growth. Effective carbon management is therefore essential for both productivity and environmental sustainability.

Integrated Multi-Trophic Aquaculture (IMTA) is an example of the combined growing of shrimp and seaweed together in a closed-loop carbon system @hala2024. Within that closed-loop carbon system, the seaweeds will absorb the CO#sub[2], nitrogen, and phosphorus in the water from the shrimp waste, then will return the oxygen into the water with the process of photosynthesis. Moreover, it should improve water quality properties such as DO and pH levels and dissolved CO#sub[2] will be reduced by 15 to 35% when compared to traditional monoculture system @hala2024 @bullen2024. Therefore in that same system the shrimp (which are the CO#sub[2] source) and the seaweed (which is a carbon sink) are both function as beneficial to the overall ecosystem.

While some support the potential of integrated multi-trophic aquaculture (IMTA) systems when approaching performance measurement i.e. production levels or benefits, field-based evidence is limited. Existing studies often rely upon laboratory experiments or predictive models that utilize restricted datasets, making them difficult to validate out in the real world @kortet2024. Furthermore, there is a lack of properly designed and comprehensive data because macroalgae are often deployed in a field-only study to measure a limited number of parameters (e.g., fish health, water quality) even though ML models require numerous input to function properly.

This project addresses these gaps by deploying an ESP32-based IoT sensor to collect about 1,502 dissolved CO#sub[2] measurements during IMTA (7 days) and non-IMTA (4 days) phases in a shrimp pond in the Konkan Division, Maharashtra, India, from 28 March to 7 April 2026. It also explores carbon flux prediction using synthetic dataset augmentation to support multi-variable ML models @shete2024 @vinay2025.

The objectives of the project are:

+ Deploy a real-time IoT sensor system to continuously measure dissolved CO#sub[2] in a shrimp pond under both IMTA and non-IMTA conditions @floresiwasaki2025.

+ Construct a hybrid dataset by augmenting the real CO#sub[2] measurements with synthetically generated biological and chemical parameters derived from a reference IMTA model.

+ Train and evaluate machine learning models, specifically XGBoost, Random Forest, and Bidirectional GRU (BiGRU), to predict shrimp respiration (gCO#sub[2]) and seaweed sequestration (gCO#sub[2]) from the hybrid dataset @ye2024.

+ Demonstrate, through field data, that dissolved CO#sub[2] concentrations are measurably lower when seaweed is present in the pond, providing empirical validation of the IMTA CO#sub[2] mitigation effect @bullen2024.

= Literature Review

#set par(leading: 0.8em)

#table(
  columns: (0.3fr, 1.25fr, 1fr, 1fr, 1.5fr),
  align: (center, left, left, left, left),
  stroke: 0.5pt + gray,
  inset: 8pt,

  [*Sr. No.*],
  [*Paper*], 
  [*Key Focus*], 
  [*Methodology Used*], 
  [*Key Findings Relevant to The Project*],

  [1],
  [Y. Liu et al., "Effects of shellfish and macro-algae IMTA in North China on the environment, inorganic carbon system, organic carbon system, and sea-air CO#sub[2] fluxes," Frontiers in Marine Science, vol. 9, p. 864306, Apr. 2022 @liu2022],
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

  [2],
  [M. M. Alam et al., "Potential of integrated multitrophic aquaculture to make prawn farming sustainable in Bangladesh," Frontiers in Sustainable Food Systems, vol. 8, p. 1412919, Oct. 2024 @alam2024],
  [IMTA potential for reducing GHG in prawn farming],
  [- Systematic review: 112 articles (2000 - 2024)
- PRISMA framework
- Economic viability & bioremediation analysis],
  [- Conventional prawn farms produce 18.8 kg CO#sub[2]eq/MT vs 3.1kg (China shrimp)
- Bivalves/seaweeds sequester CO#sub[2] as blue carbon sinks
- Global mollusks sequestered 0.97--1.93 million ton C/year
- IMTA shows 24% higher net profit than monoculture
- Feed & energy are major carbon sources],

  [3],
  [S. Ye, "Analysis of influencing factors of carbon emissions from China's marine fishery energy consumption under different development scenarios," Frontiers in Marine Science, vol. 11, p. 1377215, Mar. 2024 @ye2024],
  [Carbon emission factors and prediction for marine fishery],
  [- Carbon accounting (2006 - 2020): Sources - Sinks
- PSO-BIGRU machine learning
- Random Forest for factor importance],
  [- 17% emission reduction achieved from 4.72 to 3.90 million tons
- Carbon sinks are dominant reduction factor
- PSO-BIGRU gives best predictions (MAE: 1.251)
- Key predictors: carbon sinks, per capita income, fishery population],

  [4],
  [M. T. Vinay, K. T. Veeramanju, and B. R. Sreenivasa, "Multivariate analysis of water quality parameters for sustainable prawn farming," South Eastern European Journal of Public Health, vol. 26, no. suppl.2, pp. 3707–3719, 2025 @vinay2025],
  [Multivariate analysis for predicting water quality effects on prawn health],
  [- 3 scenario predictions (2021 - 2030)
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

  [5],
  [Y. Jiang and F. Yan, "Aquaculture prediction model based on improved water quality parameter data prediction algorithm under the background of big data," Journal of Applied Mathematics, vol. 2022 @jiang2022],
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

  [6],
  [A. F. Hala et al., "Life cycle assessment of integrated multi-trophic aquaculture: A review on methodology and challenges for its sustainability evaluation," Aquaculture, vol. 565, p. 741035, Sep. 2024 @hala2024],
  [LCA in IMTA for carbon reduction],
  [- Review of 29 LCA studies (2009 – 2022)
- Analysis of fed (shrimp) and extractive (seaweed) systems
- Cradle-to-farm boundary comparisons
- Methodological challenges assessment],
  [- IMTA cuts impacts 20–50% vs. monocultures
- Seaweed sequesters 10–30% of CO#sub[2] emissions
- Hotspots: feed (40–60%), energy (20–30%)
- Supports real-time dynamic LCA for carbon credits],

  [7],
  [H. Guo, "Intelligent water quality prediction system with a hybrid CNN–LSTM model," Water Practice and Technology, vol. 19, no. 11, pp. 4538–4551, Nov. 2024. @guo2024],
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

Shrimp farming contributes significantly to dissolved CO#sub[2] accumulation in pond water through continuous biological respiration and organic matter decomposition @alam2024. While IMTA (the practice of co-cultivating seaweed with shrimp) is theoretically well-supported as a mechanism for reducing dissolved carbon through photosynthetic uptake @edf2022 @bullen2024, the real-world, field-level evidence for this effect in Indian pond aquaculture remains thin. Most studies rely on laboratory-controlled or simulated data @kortet2024, limiting their applicability to operational farm settings.

A second challenge compounds the first: even when field CO#sub[2] data can be collected, the absence of simultaneous multi-parameter measurements (pH, dissolved oxygen, ammonia, nitrate, etc.) makes it impossible to directly apply the multi-variable predictive models described in the literature @vinay2025 @khalid2025. Without a richer dataset, building and validating ML-based CO#sub[2] forecasting models is infeasible.

This project addresses both problems. On the empirical side, it asks whether dissolved CO#sub[2] is demonstrably lower during the IMTA phase (seaweed present) compared to the non-IMTA phase (seaweed absent) in the same pond, using the same sensor hardware. On the modelling side, it asks how to bridge the data scarcity gap so that established ML architectures can be applied to a real but limited sensor dataset.

Specifically, this project addresses four problems: (1) deploying an IoT CO#sub[2] sensor in a live shrimp pond and collecting timestamped readings across both IMTA and non-IMTA phases; (2) enriching the single-column sensor data into a multi-variable dataset suitable for ML modelling by transferring relationships from a reference IMTA dataset using XGBoost; (3) training and evaluating XGBoost, Random Forest, and BiGRU models to predict shrimp respiration and seaweed sequestration from the hybrid dataset; and (4) comparing the actual CO#sub[2] time series between the two phases to provide field-level evidence that seaweed presence reduces dissolved CO#sub[2] concentrations.

= Project Description

== Overview

This study investigates the dissolved CO#sub[2] dynamics of shrimp ponds operated under IMTA and non-IMTA conditions based on both field validation as well as data-driven methods. The major contribution of this project was the creation of a complete pipeline from raw IoT sensor data collected from a live shrimp pond to the generation of enriched synthetic data using reference model transfers to the multi-model component predictions of local CO#sub[2] concentrations allowing both empirical data and deterministic predictions for CO#sub[2] management in shrimp aquaculture.

The study was conducted at a shrimp farm in Konkan Division, Maharashtra, India, where dissolved CO#sub[2] was monitored continuously using a custom-built ESP32 sensor node. The shrimp in the pond were at the same phase of their life cycle throughout the entire measurement period, isolating the effect of seaweed presence as the key variable. The measurement period was divided into two phases:

- *IMTA Phase (≈ 7 days, 28 March – 3 April 2026)*: Seaweed (_Red Seaweed_ sp.) was present in the pond alongside shrimp. The seaweed absorbed dissolved CO#sub[2] through photosynthesis, providing a natural carbon sink within the system @massocato2022 @lawton2013.

- *Non-IMTA Phase (≈ 4 days, 4 April – 7 April 2026)*: Seaweed was removed from the pond. The same shrimp population continued to respire and produce CO#sub[2], now without any biological CO#sub[2] uptake mechanism in the pond.

Dissolved CO#sub[2] is the only variable measured by the Internet of Things (IoT) hardware. The quantity of multi-parameter laboratory data available was limited for the purposes of this research project; therefore, a synthetic data enrichment step was performed through the generation of a hybrid dataset containing dissolved CO2, shrimp respiration (gCO#sub[2]), seaweed sequestration (gCO#sub[2]), dissolved oxygen (DO), ammonia (NH#sub[3]), nitrite (NO#sub[2]), nitrate (NO#sub[3]), and pH values. The hybrid dataset was generated using artificial intelligence models, specifically XGBoost (Extreme Gradient Boosting), trained on a reference Integrated Multi-Trophic Aquaculture (IMTA) dataset containing carbon flux and water quality variables, to establish a simple mapping from the CO#sub[2] signal to each of the reference variables, and applied to the actual sensor data, thereby allowing for the creation of a comprehensive hybrid dataset that contained the above-mentioned variables as well as timestamps that aligned with the original measurements of CO2.

The complete hybrid dataset was then used to train artificial intelligence models (XGBoost, Random Forest, and Bidirectional Gated Recurrent Unit) to provide real-time predictions of CO#sub[2] respiration and sequestration for a more accurate understanding of the contribution of each species to the overall carbon balance.

#imageWithAlt("IMTA System Flow Diagram", "assets/IMTA_flow.jpeg")

== Modules

=== IoT Sensor Node (Data Acquisition)


A custom sensor node was assembled using an ESP32 microcontroller connected to an NDIR-based CO#sub[2] sensor via UART. The node was deployed inside the shrimp pond on 28 March 2026 at the Konkan Division farm site. The ESP32 read dissolved CO#sub[2] values from the sensor every four minutes, timestamped each reading using NTP-synchronized time, and transmitted the data to a Supabase cloud database over Wi-Fi @shete2024 @floresiwasaki2025. An SD card module was also integrated for offline buffering in the event of network interruptions, with automatic re-synchronisation to the cloud once connectivity was restored.


The sensor node was kept running continuously throughout both the IMTA and non-IMTA phases, ensuring that the hardware and placement conditions were identical across both measurement windows and that any difference in CO#sub[2] readings is attributable to the presence or absence of seaweed rather than to changes in the measurement system.

#imageWithAlt("Wiring Schematic: ESP32, CO#sub[2] Sensor, and SD Card", "assets/schematic_diagram.png")

#imageWithAlt("ESP32 Sensor Setup at Pond Site", "assets/actual_esp_setup.png", width: 40%)

=== Synthetic Data Enrichment

The raw sensor output consisted of a single column: timestamped dissolved CO#sub[2] values (ppm). To enable multi-variable ML modelling, the real CO#sub[2] signal was used as the primary input to generate companion biological and chemical columns.

The enrichment procedure was as follows:

+ A reference IMTA dataset (sourced from the literature and containing hourly records of temperature, pH, DO, salinity, alkalinity, hardness, turbidity, nutrient levels, shrimp biomass, seaweed biomass, carbon composition, and carbon flux variables) was loaded.

+ For each target column (respiration\_gCO#sub[2], sequestration\_gCO#sub[2], DO\_mgL, NH#sub[3]\_mgL, NO#sub[2]\_mgL, NO#sub[3]\_mgL, pH), an XGBoost model was trained using the reference dataset. The features were lag-1, lag-2, lag-3, lag-6, rolling means (window 3 and 6), the first difference of CO#sub[2], and sine/cosine hour encodings.

+ The trained models were applied to the scaled real sensor signal to generate predictions for each companion column. Residual noise sampled from training residuals, state-dependent scaling, and a mild temporal smoothing term (exponential moving average with α ≈ 0.55) were added to produce realistic stochastic variation consistent with field data.

+ The following physical constraints were placed on the model: ammonia, nitrite, and nitrate and DO were clipped at non-negative values; the pH of the model was limited to values within the physiologically reasonable range (between 6.5 and 9.0).

The result was a 2,150-row hybrid dataset aligned to the real measurement timestamps, with the structure shown below:

#figure(
  kind: table,
  caption: [Hybrid Dataset Column Schema]
)[
  #table(
    columns: (1.5fr, 1fr, 2fr),
    align: (left, left, left),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Column*], [*Unit*], [*Source*],
    [datetime], [—], [Real sensor (timestamp)],
    [co2\_proxy], [ppm], [Real sensor (measured)],
    [respiration\_gCO#sub[2]], [g CO#sub[2]], [Synthetically generated],
    [sequestration\_gCO#sub[2]], [g CO#sub[2]], [Synthetically generated],
    [DO\_mgL], [mg/L], [Synthetically generated],
    [NH#sub[3]\_mgL], [mg/L], [Synthetically generated],
    [NO#sub[2]\_mgL], [mg/L], [Synthetically generated],
    [NO#sub[3]\_mgL], [mg/L], [Synthetically generated],
    [pH], [—], [Synthetically generated],
  )
]

=== Machine Learning Prediction Engine

Three model architectures were trained and evaluated on the hybrid dataset:

*XGBoost and Random Forest (Tree-Based Ensemble Models)*: These models were trained separately for two prediction tasks: shrimp respiration (gCO#sub[2]) and seaweed sequestration (gCO#sub[2]) @khan2024. The feature sets were engineered from the real CO#sub[2] signal: lag-1 and lag-3 values were used for respiration prediction; a light proxy variable (sine-encoded hour), its interaction with CO#sub[2] (co2\_light), and the lagged co2\_light were added for sequestration prediction @massocato2022. The dataset was split chronologically 80/20 with a 12-step gap between training and test sets to avoid data leakage.

*Bidirectional GRU (BiGRU)*: A sequence model with a 12-step sliding window was trained for both respiration and sequestration @hao2024. Input features were Min-Max scaled. The architecture consisted of a single Bidirectional GRU layer (32 units) followed by a Dense output layer, compiled with the Adam optimiser and MSE loss. The model was trained for 10 epochs.

= Methodology

== Data Collection

=== Field Setup and Sensor Deployment

The IoT sensor node was deployed in a shrimp pond at a commercial aquaculture farm in Konkan Division, Maharashtra, India on 28 March 2026. The node comprised:

- *Microcontroller*: ESP32 (dual-core, Wi-Fi enabled)
- *Dissolved CO2 Sensor*: This sensor is based on NDIR technology and is wired to the I2C protocol through a UART port (9600 baud rate).
- *Offline Buffer*: An SD card module (SPI, CS pin 5) is used for buffering data offline.
- *Connectivity*: This module provides Wi-Fi, time synchronization via an NTP server, and a REST API push to Supabase @shete2024.

#imageWithAlt("Project Team at Shrimp Pond Site, Konkan Division (28 March 2026)", "assets/group_photo_with_setup.png")

The sensor took readings of dissolved CO2 about every four minutes. Each reading was timestamped, validated (sensor noise \<10ppm @essamlali2024), and uploaded to the cloud database. If the Wi-Fi connection was unavailable, the reading was written to a local CSV file on the SD card until the Internet connection was renewed and the data from the CSV was synchronized to the cloud.

=== Measurement Period and Experimental Design

Data were gathered over eleven days roughly in two different experimental conditions:

#figure(
  kind: table,
  caption: [Experimental Phases of the Field Study]
)[
  #table(
    columns: (1fr, 1fr, 1fr, 1.5fr),
    align: (left, left, center, left),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Phase*], [*Dates*], [*Duration*], [*Condition*],
    [IMTA Phase], [28 Mar – 3 Apr 2026], [≈ 7 days], [Seaweed present in pond alongside shrimp],
    [Non-IMTA Phase], [4 Apr – 6 Apr 2026], [≈ 4 days], [Seaweed removed; shrimp only],
  )
]

The shrimp population in the pond was the same age grouping during both data collection periods and thus they were not confounded by different shrimp ages as it related to the statistical comparison of CO#sub[2] @chen2022. The sea vegetation species used for seaweed in this study was _Red Seaweed_, which is also a common species in Integrated Multi-Trophic Aquaculture IMTA systems, and has been shown to have a high rate of CO#sub[2] uptake from photosynthesis and has a high potential rate for bioremediating aquatic environments @lawton2013 @massocato2022. A total of 1,502 CO#sub[2] dissolved readings were taken over the 11 day measurement period.

#imageWithAlt([Observed CO#sub[2] Trend: IMTA vs Non-IMTA Phases], "assets/observed_trend_in_data.png")

== Synthetic Data Enrichment

=== Procedure

The ESP32 sensor node only recorded measurements of this gas as dissolved CO#sub[2]. Predictive models for each of the components related to carbon flux require reference biological variables associated with the model @vinay2025, as well as data pertaining to the chemical environment in which these variables exist. A database of reference IMTA data was present, but was not sampled from the same pond as the sensor measurements. The direct use of this data for training will result in an incorrect representation of the relationship between variable types due to a "domain mismatch." An enrichment strategy will allow for a better representation of these variable relationships, by allowing synthetically generated variables based on information learned about how CO2 relates to other variable types in the reference dataset.

The reference IMTA dataset had hourly records like temperature (°C), pH, dissolved oxygen (mg/L), salinity (ppt), alkalinity (mg/L), hardness (mg/L), turbidity (NTU), NH#sub[3], NO#sub[2], NO#sub[3], PO#sub[4] (all in mg/L), shrimp biomass (g), hourly specific growth rate, seaweed dry weight (g), carbon percentage, carbon mass (g), CO#sub[2] equivalent (g), shrimp respiration (gCO#sub[2]), seaweed sequestration (gCO#sub[2]), and net CO#sub[2] flux (gCO#sub[2]) in it.

#imageWithAlt("Reference IMTA Lab Dataset (Head View)", "assets/LabDataset.png")

Feature engineering applied to both datasets:

#figure(
  kind: table,
  caption: [Engineered Features Used in Synthetic Data Generation]
)[
  #table(
    columns: (1fr, 2fr),
    align: (left, left),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Feature*], [*Description*],
    [lag1, lag2, lag3, lag6], [Lagged values of CO#sub[2] signal at 1, 2, 3, 6 steps back],
    [roll\_mean], [3-step rolling mean of CO#sub[2]],
    [roll\_mean\_long], [6-step rolling mean of CO#sub[2]],
    [co2\_diff], [First difference of CO#sub[2] (rate of change)],
    [sin\_hour, cos\_hour], [Sine and cosine encoding of hour-of-day (captures diurnal cycle)],
  )
]

We built XGBoost models (400 estimators, max depth 5, and learning rate of 0.05) on the reference dataset for each of our target columns (respiration, sequestration, DO, NH#sub[3], NO#sub[2], NO#sub[3] and pH). The CO#sub[2] signal measured by the sensors was scaled in the value range of the reference dataset, the model would generate predictions from the features extracted, and these predictions would produce residual noise (which is smoothed using Gaussian filters in temporary periods and state levels) and a balanced sinusoidal drift term (to minimise any deterministic artefacts).

=== Validation of the Enrichment

A held-out validation was run on the hybrid dataset by training a separate XGBoost model on the first 80% of the data and evaluating on the last 20% (with a 12-step gap):

#figure(
  kind: table,
  caption: [Synthetic Data Enrichment Validation Results]
)[
  #table(
    columns: (1fr, 1fr, 1fr),
    align: (left, center, center),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Target*], [*R²*], [*MAE*],
    [Respiration (gCO#sub[2])], [≈ 0.84], [Low],
    [Sequestration (gCO#sub[2])], [≈ 0.80], [Low],
  )
]

These results confirm that the synthetic columns are structurally consistent with the real CO#sub[2] signal and carry meaningful predictive relationships.

== Model Architecture

=== Tree-Based Ensemble Models (XGBoost and Random Forest)

XGBoost builds trees sequentially, each correcting residuals of the previous one, and handles non-linear relationships well @khan2024. Random Forest trains on bootstrap samples with random feature subsets and averages predictions to reduce variance, serving as an interpretable, robust baseline @ye2024. Both models were trained for two tasks:

#figure(
  kind: table,
  caption: [Tree-Based Model Configuration]
)[
  #table(
    columns: (1fr, 1.2fr, 1.5fr, 1fr),
    align: (left, left, left, left),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Task*], [*Model*], [*Features*], [*Hyperparameters*],
    [Respiration], [XGBoost], [co2\_proxy, lag1, lag3], [300 estimators, max depth 5],
    [Respiration], [Random Forest], [co2\_proxy, lag1, lag3], [200 trees],
    [Sequestration], [XGBoost], [co2\_proxy, lag1, lag3, co2\_light, co2\_light\_lag], [400 estimators, max depth 6],
    [Sequestration], [Random Forest], [co2\_proxy, lag1, lag3, co2\_light, co2\_light\_lag], [200 trees],
  )
]

The light proxy (co2\_light) was computed as the CO#sub[2] signal scaled by (sin(2π(hour−6)/24) + 1)/2, encoding the daytime photosynthesis cycle. The dataset was split chronologically 80/20 with a 12-step gap between training and test sets.

=== Bidirectional GRU (BiGRU)

The BiGRU processes the input sequence in both forward and backward directions simultaneously, enabling the model to capture both historical context and future trends within the input window @hao2024. This is particularly suited to aquaculture CO#sub[2] data, which exhibits strong diurnal periodicity and short-term autocorrelation @linardatos2023 @zhong2024.

Architecture: Input (12-step window × 3 features) → Bidirectional GRU (32 units) → Dense (1 output). Optimiser: Adam. Loss: MSE. Epochs: 10. Features were Min-Max scaled before sequencing.

== Data Split and Evaluation

The dataset was split chronologically to simulate real-world deployment:

#figure(
  kind: table,
  caption: [Train/Test Split Details]
)[
  #table(
    columns: (0.8fr, 1fr, 1fr),
    align: (left, center, center),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Set*], [*Rows*], [*Proportion*],
    [Training], [1,704], [80%],
    [Gap (excluded)], [12], [—],
    [Test], [430], [20%],
  )
]

Models were evaluated using R² (coefficient of determination), MAE (mean absolute error), and RMSE (root mean squared error).

= Results

== Observed CO#sub[2] Trend: IMTA vs. Non-IMTA

The most significant conclusion from this project is that dissolved carbon dioxide (CO#sub[2]) concentrations in the shrimp pond are consistently at a lower net level during the Integrated Multi Trophic Aquaculture (IMTA) phase (with seaweed, from 28 March through 3 April 2026) versus when there is a non-IMTA phase (no seaweed, from 4–6 April 2026). This finding is consistent with a long‐standing principle that seaweed functions as a biological filter for dissolved CO#sub[2] within the pond, consuming dissolved CO#sub[2] through photosynthesis during daylight hours, and increasing the water pH, which reduces the total carbon loading on the system (@liu2022 @massocato2022).

The data collected during the IMTA phase exhibit a clear diurnal pattern to CO#sub[2] concentration within the pond; there was a significant decrease (drawdown) of CO#sub[2] during day hours due to the ability of the periphyton-forming macroalgae to act as a large carbon sink through photosynthesis. During the night, when photosynthesis is non-existent, the macroalgae do, however, produce some CO#sub[2] as they respire, producing an oscillating pattern in the time-series plot. Despite the production of CO#sub[2] at night, the 24-hour net balance of the total dissolved CO#sub[2] in the pond during the IMTA phase is significantly lower than during the non-IMTA phase due to the greater dissolved CO#sub[2] drawdown produced by seaweed photosynthesis than produced by respiration at night @bullen2024 @hala2024.

During the periods following the removal of the seaweed (non-IMTA phase), the diurnal oscillating pattern of dissolved CO#sub[2] concentration decreased and overall CO#sub[2] concentrations within the pond stabilised at a steady level and consist only of carbon produced by the shrimp as they respire or through decomposition of organic materials.

#figure(
  kind: image,
  caption:[Observed CO#sub[2] Time Series: IMTA vs Non-IMTA] 
)[
  #image("assets/observed_trend_in_data.png", width: 85%)
]

== Dataset Characteristics

The hybrid dataset used for modelling comprised 2,150 rows, aligned to the real measurement timestamps. The dissolved CO#sub[2] signal (co2\_proxy) ranged from 335 ppm to approximately 6,709 ppm. Shrimp respiration values (gCO#sub[2]) were generated in the range 0.15–2.5 g CO#sub[2], reflecting realistic shrimp biomass respiration rates for the life-cycle stage observed. Seaweed sequestration values ranged from approximately −0.05 to 2.3 g CO#sub[2], with negative values during overnight periods representing the seaweed's own respiratory output.

#figure(
  kind: table,
  caption: [Hybrid Dataset Column Descriptions]
)[
  #table(
    columns: (1.2fr, 0.7fr, 2.1fr),
    align: (left, left, left),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Column*], [*Unit*], [*Description*],
    [datetime], [—], [Timestamp of observation (IST); used for time-series modelling and diurnal analysis.],
    [co2\_proxy], [ppm], [Directly measured dissolved CO#sub[2]; real sensor output.],
    [DO\_mgL], [mg/L], [Dissolved oxygen; produced by seaweed photosynthesis by day, consumed by shrimp respiration. Inversely correlated with CO#sub[2] on a diurnal cycle @jiang2022.],
    [NH#sub[3]\_mgL], [mg/L], [Ammonia; by-product of shrimp metabolism, absorbed as nutrient by seaweed @massocato2022.],
    [NO#sub[2]\_mgL], [mg/L], [Nitrite; intermediate nitrification product absorbed by seaweed @lawton2013.],
    [NO#sub[3]\_mgL], [mg/L], [Nitrate; terminal nitrification product absorbed by seaweed @lawton2013.],
    [pH], [—], [Water acidity; CO#sub[2] dissolution lowers pH, seaweed photosynthesis raises it @liu2022 @vinay2025.],
    [respiration\_gCO#sub[2]], [g CO#sub[2]], [Grams of CO#sub[2] released per interval by shrimp respiration; primary target for carbon-source modelling.],
    [sequestration\_gCO#sub[2]], [g CO#sub[2]], [Grams of CO#sub[2] absorbed per interval by seaweed photosynthesis; negative values indicate net night-time seaweed respiration.],
  )
]

== Prediction Results

=== Tree-Based Models: XGBoost and Random Forest

Both XGBoost and Random Forest were evaluated on the held-out test set (430 samples) for respiration and sequestration prediction @khan2024 @ye2024. Results are summarised below:

#figure(
  kind: table,
  caption: [XGBoost and Random Forest Model Performance]
)[
  #table(
    columns: (0.9fr, 1fr, 1fr, 1fr),
    align: (left, center, center, center),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Task*], [*Model*], [*R²*], [*Notes*],
    [Respiration], [XGBoost], [0.840], [Features: co2\_proxy, lag1, lag3],
    [Respiration], [Random Forest], [0.845], [Features: co2\_proxy, lag1, lag3],
    [Sequestration], [XGBoost], [0.800], [Features: co2\_proxy, lag1, lag3, co2\_light, co2\_light\_lag],
    [Sequestration], [Random Forest], [0.836], [Features: co2\_proxy, lag1, lag3, co2\_light, co2\_light\_lag],
  )
]

Random Forest marginally outperformed XGBoost on both tasks, with R² scores of 0.845 and 0.836 for respiration and sequestration respectively. The inclusion of the light proxy interaction feature (co2\_light) in the sequestration model significantly improved predictions by capturing the daytime photosynthesis signal.

#imageWithAlt("Random Forest Feature Importance", "assets/Random_Forest_Feature_Importance.jpeg")

The feature importance plot confirms that `hour` (time of day) is the dominant predictor for both tasks, particularly for sequestration, where it accounts for approximately 76% of importance, reflecting the tight coupling of seaweed photosynthesis to the daytime light cycle. For respiration, `seaweed_dry_g` and `shrimp_biomass_g` are the next most important features, capturing the biological scale of both species in the system. The `co2_proxy` signal and its temporal lags provide additional predictive power for both tasks.

*Respiration: Actual vs Predicted*

#imagePair(
  "Respiration: Actual vs Predicted", "assets/Respiration_ActualVsPredicted.jpg",
  "Respiration: Residual Plot (XGBoost)", "assets/Respiration_ResidualPlot.jpg"
)

Both models capture the broad trajectory of respiration across the test window, including the major mid-series peak and the subsequent decline, but underestimate the peak magnitude. The residual plot reveals heteroscedasticity: errors are small and well-centred at low predicted values but become increasingly positively biased at higher respiration levels, indicating the models consistently underestimate high-respiration events.

*Sequestration: Actual vs Predicted*

#imagePair(
  "Sequestration: Actual vs Predicted", "assets/Sequestration_ActualVsPredicted.jpg",
  "Sequestration: Residual Plot (XGBoost)", "assets/Sequestration_ReidualPlot.jpg"
)

Both models correctly identify the timing of the sequestration event but substantially underpredict the peak: predictions stay in the 1.2-1.9 range while the actual maximum is approximately 2.4 gCO#sub[2]. The residual plot shows a non-random wave pattern, indicating systematic nonlinear bias at mid-to-high predicted values, a ceiling effect where the models saturate before reaching the true sequestration peak.

=== BiGRU Model

The BiGRU model, trained with a 12-step input window, achieved substantially higher R² scores than the tree-based models on both tasks @hao2024 @guo2024:

#figure(
  kind: table,
  caption: [BiGRU Model Performance]
)[
  #table(
    columns: (1fr, 0.8fr, 1fr, 1fr),
    align: (left, center, center, center),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Task*], [*R²*], [*MAE (gCO#sub[2])*], [*Notes*],
    [Respiration], [0.910], [0.228], [12-step window, BiGRU(32)],
    [Sequestration], [0.950], [0.087], [12-step window, BiGRU(32)],
  )
]

The BiGRU's bidirectional architecture allowed it to leverage both past and near-future contextual information within the input window, resulting in smoother and more accurate predictions, particularly for sequestration, where the strong diurnal signal (tied to daytime photosynthesis) benefits from the model's awareness of the temporal position within the diel cycle @hao2024 @linardatos2023.

=== Detailed Diagnostic Plots

The following plots provide component-level diagnostics for the BiGRU model on both prediction tasks.

*Respiration:*

#imagePair(
  "BiGRU Respiration: Actual vs Predicted", "assets/BiGRU_Respiration_ActualVsPredicted.jpg",
  "BiGRU Respiration: Residual Plot", "assets/BiGRU_Respiration_Residuals.jpg"
)

The BiGRU captures the overall trajectory of shrimp respiration, including the sharp mid-series peak above 4.5 gCO#sub[2], but produces a smoother, slightly damped prediction. The residual plot reveals increasing positive bias at higher predicted values: residuals are tightly clustered near zero at low predicted respiration but spread upward to approximately +1.5 gCO#sub[2] at high values, indicating consistent underestimation of peak respiration events.

*Sequestration:*

#imagePair(
  "BiGRU Sequestration: Actual vs Predicted", "assets/BiGRU_Sequestration_ActualVsPredicted.jpg",
  "BiGRU Sequestration: Residual Plot", "assets/BiGRU_Sequestration_Residuals.jpg"
)

The BiGRU correctly identifies the timing of the sequestration event but the predicted peak remains below the actual maximum, showing the same damping behaviour as the respiration model. The residual plot exhibits heteroscedasticity: residuals are near zero at low predicted values but widen substantially at higher predicted sequestration, with the model saturating around 1.6-1.8 gCO#sub[2] while actual values continue to rise.

=== Comparative Summary

#figure(
  kind: table,
  caption: [All Models Comparative Performance Summary]
)[
  #table(
    columns: (1fr, 1.2fr, 1fr, 1fr),
    align: (left, left, center, center),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Task*], [*Model*], [*R²*], [*MAE*],
    [Respiration], [XGBoost], [0.840], [—],
    [Respiration], [Random Forest], [0.845], [—],
    [Respiration], [BiGRU], [0.910], [0.228],
    [Sequestration], [XGBoost], [0.800], [—],
    [Sequestration], [Random Forest], [0.836], [—],
    [Sequestration], [BiGRU], [0.950], [0.087],
  )
]

Across all models and both tasks, the BiGRU consistently achieved the highest predictive accuracy, benefiting from its ability to model temporal dependencies in the CO#sub[2] signal. The tree-based models remain valuable for their interpretability and feature importance outputs.

= Conclusion

This project demonstrates, through real field data collected at a shrimp farm in Konkan Division, Maharashtra, that dissolved CO#sub[2] concentrations in a shrimp pond are measurably lower on a net basis during the IMTA phase (seaweed present) compared to the non-IMTA phase (seaweed absent). Seaweed photosynthesis during daylight hours acts as a continuous biological CO#sub[2] filter, driving daytime drawdown events that reduce the overall dissolved carbon load over a full diel cycle, confirming the carbon mitigation role of seaweed in an IMTA system @liu2022 @bullen2024 @edf2022.

An IoT pipeline was established and functioned: an ESP32 microcontroller connected to a UART dissolved CO#sub[2] sensor transmitted via Wi-Fi to a Supabase cloud database while ultimately buffering to an SD card for offline fallback (@shete2024, @floresiwasaki2025). It was successful during continuous deployment outdoors for 11 days with 1502 timestamped CO#sub[2] dissolved readings produced.

Because there is very little historical multi-parameter lab data available for model development, a synthetic data enrichment method was developed for use in this study. XGBoost models were trained using the IMTA reference dataset to provide a practical means of transferring learned relationships between CO#sub[2] and its companion biological variables to real sensor signals. This created a hybrid dataset comprised of 2150 rows of data across 9 columns which reduced the difference between the richness of data necessary for machine learning models and the simplicity of deploying a field with one sensor.

Three different predictive models were created and validated with the hybrid dataset. The BiGRU model (@hao2024) demonstrated the best performance: R² = 0.91 for predicting shrimp respiration and R² = 0.95 for predicting CO#sub[2] sequestration via seaweed; these were better than any other model developed. Tree-based models (XGBoost: R² = 0.84/0.80; Random Forest: R² = 0.845/0.836) (@khan2024) provided similarly accurate predictions of feature importance and suggested that dissolved CO#sub[2] signals with lags are the leading predictors of carbon flux components in this environment.

The main outcomes of this project were:

+ *Field evidence for CO#sub[2] mitigation by seaweed in IMTA*: The actual sensor data confirms that seaweed presence results in a lower net dissolved CO#sub[2] load over a full diel cycle. Daytime photosynthetic drawdown by seaweed outweighs its overnight respiratory contribution, producing an overall carbon concentration in the IMTA phase that is lower than in the non-seaweed traditional non-IMTA phase @massocato2022 @liu2022 @kortet2024.

+ *Synthetic enrichment is a effective method*: When laboratory measured multi-parameter data is not available from the literature, synthetic enrichment of the reference data through model transfer methods produces a hybrid dataset that contains sufficient statistical structure to train ML models that are appropriate for use @essamlali2024.

+ *BiGRU outperforms tree-based models for temporal CO#sub[2] prediction*: The bidirectional temporal architecture captures diurnal periodicity more effectively than point-in-time ensemble methods @hao2024, particularly for sequestration, which is tightly coupled to the light cycle for a given day @massocato2022.

Future work should incorporate additional sensors and parameters (pH, DO, temperature) simultaneously with CO#sub[2] @khalid2025, which would eliminate the need for the synthetic enrichment step and provide cleaner, richer training data. Longer-term field deployments spanning multiple growth cycles and seaweed biomass levels would further validate the IMTA CO#sub[2] mitigation effect at scale @hala2024 @alam2024.

= References

#bibliography("bibliography.yaml", style: "ieee", full:true, title: none)
