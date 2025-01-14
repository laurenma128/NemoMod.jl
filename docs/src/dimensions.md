```@meta
CurrentModule = NemoMod
```
# [Dimensions](@id dimensions)

Input parameters and calculated variables in NEMO are segmented (subscripted) by certain key components of the energy system. These *model dimensions* describe geographical, technological, temporal, and other elements of the system. You define dimensions for each NEMO scenario, and they can vary between scenarios for a given energy system. Dimensions are specified in tables in a NEMO [scenario database](@ref scenario_db) as outlined below. Each dimension has an abbreviation that's used when referring to it in NEMO's code and scenario databases.

## [Emission](@id emission)

Emissions or other externalities in the energy system. You can associate costs with emissions, and the quantity of emissions produced can be constrained (see [Parameters](@ref parameters)). **Abbreviation: `e`.**

#### Scenario database

**Table: `EMISSION`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `val` | text | Unique identifier for emission |
| `desc` | text  | Description of emission |

#### Julia code

* Set of emissions: `semission` (an `Array` of `EMISSION.val`)
* Subscript for emissions in other variables: `e`

## [Fuel](@id fuel)

Energy carriers. **Abbreviation: `f`.**

#### Scenario database

**Table: `FUEL`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `val` | text | Unique identifier for fuel |
| `desc` | text  | Description of fuel |

#### Julia code

* Set of fuels: `sfuel` (an `Array` of `FUEL.val`)
* Subscript for fuels in other variables: `f`

## [Mode of operation](@id mode_of_operation)

Different ways in which [technologies](@ref technology) can function. Typically, one mode is defined for energy generation or production; if a scenario models energy [storage](@ref storage), another is defined for charging storage. **Abbreviation: `m`.**

#### Scenario database

**Table: `MODE_OF_OPERATION`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `val` | text | Unique identifier for mode |
| `desc` | text  | Description of mode |

#### Julia code

* Set of modes: `smode_of_operation` (an `Array` of `MODE_OF_OPERATION.val`)
* Subscript for modes in other variables: `m`

## [Node](@id node)

Locations in a transmission (or transmission and distribution) network. Networks are defined with nodes and [transmission lines or segments](@ref transmissionline), and nodal modeling of energy demand and supply can be enabled for individual [fuels](@ref fuel). **Abbreviation: `n`.**

#### Scenario database

**Table: `NODE`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `val` | text | Unique identifier for node |
| `desc` | text  | Description of node |
| `r` | text  | [Region](@ref region) in which node is located (`REGION.val`) |

#### Julia code

* Set of nodes: `snode` (an `Array` of `NODE.val`)
* Subscript for nodes in other variables: `n`

## [Region](@id region)

Geographic regions. **Abbreviation: `r`.**

#### Scenario database

**Table: `REGION`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `val` | text | Unique identifier for region |
| `desc` | text  | Description of region |

#### Julia code

* Set of regions: `sregion` (an `Array` of `REGION.val`)
* Subscript for regions in other variables: `r`

## [Storage](@id storage)

Energy storage options or facilities. **Abbreviation: `s`.**

#### Scenario database

**Table: `STORAGE`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `val` | text | Unique identifier for storage |
| `desc` | text  | Description of storage |
| `netzeroyear` | integer  | Indicates that storage can have no net charging or discharging over a [year](@ref year) (`1` = enabled) |
| `netzerotg1` | integer  | Indicates that storage can have no net charging or discharging over a [time slice group 1](@ref tsgroup1) (`1` = enabled) |
| `netzerotg2` | integer  | Indicates that storage can have no net charging or discharging over a [time slice group 2](@ref tsgroup2) (`1` = enabled) |

#### Julia code

* Set of storage: `sstorage` (an `Array` of `STORAGE.val`)
* Subscript for storage in other variables: `s`

## [Technology](@id technology)

Energy-consuming or producing devices or equipment. **Abbreviation: `t`.**

#### Scenario database

**Table: `TECHNOLOGY`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `val` | text | Unique identifier for technology |
| `desc` | text  | Description of technology |

#### Julia code

* Set of technologies: `stechnology` (an `Array` of `TECHNOLOGY.val`)
* Subscript for technologies in other variables: `t`

## [Time slice](@id timeslice)

Sub-annual periods used to model energy demand and supply in selected cases. The width of each time slice (as a fraction of the year) is defined with the parameter [YearSplit](@ref YearSplit). **Abbreviation: `l`.**

#### Scenario database

**Table: `TIMESLICE`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `val` | text | Unique identifier for time slice |
| `desc` | text  | Description of time slice |

#### Julia code

* Set of time slices: `stimeslice` (an `Array` of `TIMESLICE.val`)
* Subscript for technologies in other variables: `l`

## [Time slice group 1](@id tsgroup1)

Groupings of [time slices](@ref timeslice) within a [year](@ref year). **Abbreviation: `tg1`.**

#### Scenario database

**Table: `TSGROUP1`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `name` | text | Unique identifier for group |
| `desc` | text  | Description of group |
| `order` | integer  | Order of group within a year (should be `1` for first group, incremented by 1 for subsequent groups) |
| `multiplier` | real  | Multiplier used in storage calculations (see [Time slicing](@ref time_slicing)) |

#### Julia code

* Set of groups: `stsgroup1` (an `Array` of `TSGROUP1.name`)
* Subscript for groups in other variables: `tg1`

## [Time slice group 2](@id tsgroup2)

Groupings of [time slices](@ref timeslice) within a [time slice group 1](@ref tsgroup1). **Abbreviation: `tg2`.**

#### Scenario database

**Table: `TSGROUP2`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `name` | text | Unique identifier for group |
| `desc` | text  | Description of group |
| `order` | integer  | Order of group within a time slice group 1 (should be `1` for first group, incremented by 1 for subsequent groups) |
| `multiplier` | real  | Multiplier used in storage calculations (see [Time slicing](@ref time_slicing)) |

#### Julia code

* Set of groups: `stsgroup2` (an `Array` of `TSGROUP2.name`)
* Subscript for groups in other variables: `tg2`

## [Transmission line](@id transmissionline)

Connections between [nodes](@ref node) in a transmission (or transmission and distribution) network - e.g., electrical lines or pipes in a natural gas network. Transmission lines allow energy to flow from one node to another. **Abbreviation: `tr`.**

#### Scenario database

**Table: `TransmissionLine`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `id` | text | Unique identifier for line |
| `n1` | text  | First node connected to line (`NODE.val`) |
| `n2` | text  | Second node connected to line (`NODE.val`) |
| `f` | text  | [Fuel](@ref fuel) transported over line (`FUEL.val`) |
| `maxflow` | real  | Maximum flow supported by line (MW) |
| `reactance` | real  | Line's reactance (per unit assuming a 1 MVA power base, only relevant for electrical lines when using direct current optimized power flow modeling; see [`TransmissionModelingEnabled`](@ref TransmissionModelingEnabled)) |
| `yconstruction` | integer  | Exogenously specified construction year for line (leave null if NEMO should endogenously determine whether to build line [i.e., for candidate lines]) |
| `capitalcost` | real  | Line's capital cost (scenario's cost unit) |
| `fixedcost` | real  | Line's fixed annual operation and maintenance cost (scenario's cost unit) |
| `variablecost` | real  | Line's variable operation and maintenance (scenario's cost unit / energy unit) |
| `operationallife` | integer  | Line's operational lifetime (years, used to retire both exogenously and endogenously built lines) |
| `efficiency` | real  | Efficiency of transmission over line (%, only used for pipeline flow modeling; see [`TransmissionModelingEnabled`](@ref TransmissionModelingEnabled)) |
| `interestrate` | real  | Interest rate NEMO should use to calculate financing costs if building line endogenously (0 to 1; see [`vfinancecosttransmission`](@ref vfinancecosttransmission)) |

#### Julia code

* Set of lines: `stransmission` (an `Array` of `TransmissionLine.id`)
* Subscript for lines in other variables: `tr`

!!! note

    NEMO includes binary decision variables in a scenario's optimization problem if you a) model a transmission line with a non-zero variable cost; or b) model a line with an efficiency less than 1 using [transmission modeling type 3](@ref TransmissionModelingEnabled). This can increase solver run-time.

## [Year](@id year)

Years covered by scenario. Years must be integral. **Abbreviation: `y`.**

#### Scenario database

**Table: `YEAR`**

| Name | Type | Description |
|:--- | :--: |:----------- |
| `val` | text | Unique identifier for year |
| `desc` | text  | Description of year |

#### Julia code

* Set of years: `syear` (an `Array` of `YEAR.val` in numeric order)
* Subscript for years in other variables: `y`
