# Combustion Simulation

## Overview

This repository contains a MATLAB script (`combustion.m`) that simulates the thermodynamic cycle of a combustion engine. The simulation calculates various parameters, such as piston displacement, velocity, acceleration, pressure, and temperature, throughout the engine cycle. It also explores the effects of constant and variable specific heats on the engine's performance, providing valuable insights through graphical visualizations.

## Features

- **Piston Displacement**: Calculates the displacement of the piston throughout the crank angle.
- **Piston Velocity and Acceleration**: Computes the velocity and acceleration of the piston as a function of the crank angle.
- **Pressure-Volume (PV) Diagram**: Generates a PV diagram showing the relationship between pressure and volume during the engine cycle.
- **Temperature and Pressure Analysis**: Compares temperature-dependent and temperature-independent properties of the engine.
- **Efficiency Calculation**: Calculates the efficiency of the thermodynamic cycle based on the work done during compression and expansion.

## Parameters

Understanding the parameters used in the simulation is crucial for modifying and interpreting the results effectively. Below is a detailed explanation of each parameter initialized in the `combustion.m` script:

### Geometric and Engine Parameters

| **Parameter** | **Symbol** | **Value** | **Unit** | **Description** |
|---------------|------------|-----------|----------|-----------------|
| Stroke Length | `s` | `0.1` | meters | The distance the piston travels from the top dead center (TDC) to the bottom dead center (BDC). |
| Crank Radius | `r` | `s / 2` | meters | Radius of the crankshaft, calculated as half the stroke length. |
| Connecting Rod Length | `l` | `4 * s` | meters | Length of the connecting rod connecting the piston to the crankshaft. |
| Cylinder Diameter | `d` | `s` | meters | Diameter of the engine cylinder. |
| Compression Ratio | `rc` | `9` | dimensionless | Ratio of the total cylinder volume when the piston is at BDC to the clearance volume when the piston is at TDC. |
| Engine Speed | `n` | `1000` | RPM | Revolutions per minute of the engine crankshaft. |

### Thermodynamic Properties

| **Parameter** | **Symbol** | **Value** | **Unit** | **Description** |
|---------------|------------|-----------|----------|-----------------|
| Peak Temperature | `tmax` | `3000` | Kelvin | Maximum temperature reached during the combustion process. |
| Specific Heat at Constant Volume (Constant Gamma) | `cv` | `0.71` | kJ/kg·K | Molar specific heat capacity at constant volume for the constant gamma case. |
| Heat Capacity Ratio (Constant Gamma) | `gamma` | `1.4` | dimensionless | Ratio of specific heats (Cp/Cv) for the constant gamma case. |
| Gas Constant | `R` | `0.287` | kJ/kg·K | Specific gas constant for air. |

### Inlet Conditions

| **Parameter** | **Symbol** | **Value** | **Unit** | **Description** |
|---------------|------------|-----------|----------|-----------------|
| Inlet Pressure | `p` | `101325` | Pascals | Atmospheric pressure at the inlet. |
| Inlet Temperature | `t` | `25` (converted to `298` K) | Celsius/Kelvin | Initial temperature of the incoming air, converted from Celsius to Kelvin. |

### Crank Angle Setup

| **Parameter** | **Symbol** | **Value** | **Unit** | **Description** |
|---------------|------------|-----------|----------|-----------------|
| Crank Angle (Degrees) | `theta_deg` | `-180:1:180` | degrees | Discrete crank angles ranging from -180° to 180° in 1° increments. |
| Crank Angle (Radians) | `theta` | `pi / 180 * theta_deg` | radians | Crank angles converted from degrees to radians for trigonometric calculations. |

### Engine Speed in Radians per Second

| **Parameter** | **Symbol** | **Value** | **Unit** | **Description** |
|---------------|------------|-----------|----------|-----------------|
| Angular Speed | `w` | `2 * pi * n / 60` | radians/second | Angular speed of the engine crankshaft converted from RPM to radians per second. |

## Getting Started

### Prerequisites

- MATLAB (preferably R2018b or later)
- Basic understanding of thermodynamics and combustion processes

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/iammohith/Combustion.git
   ```
2. **Navigate to the project directory:**
   ```bash
   cd Combustion
   ```
3. **Open the `combustion.m` script in MATLAB.**

### Usage

1. **Set the Parameters:**
   - Open the `combustion.m` script.
   - Adjust the parameters in the **Parameters** section as needed to match your specific engine configuration or simulation requirements.

2. **Run the Simulation:**
   - Execute the script in MATLAB by clicking the **Run** button or typing `combustion` in the MATLAB command window.

3. **Analyze the Results:**
   - The script will generate several plots illustrating the engine's performance characteristics:
     - **Piston Displacement vs. Crank Angle**
     - **Piston Velocity vs. Crank Angle**
     - **Piston Acceleration vs. Crank Angle**
     - **Pressure-Volume (PV) Diagram**
     - **Pressure vs. Crank Angle**
     - **Change of Gamma with Temperature**

## Results

The simulation produces visualizations that help understand the engine cycle dynamics and the impact of variable specific heats on performance. The generated plots include:

- **Change of Displacement with Crank Angle:** Shows how the piston's position varies throughout the engine cycle.
- **Change of Piston Velocity with Crank Angle:** Illustrates the speed at which the piston moves during different phases of the cycle.
- **Change of Piston Acceleration with Crank Angle:** Depicts the acceleration of the piston, indicating the forces acting upon it.
- **Cycle PV Diagram:** Visual representation of the pressure-volume relationship during the compression and expansion strokes.
- **Change of Pressure with Crank Angle:** Demonstrates how pressure within the cylinder changes as the crankshaft rotates.
- **Change of Gamma with Temperature:** Highlights the variation of the heat capacity ratio (gamma) with temperature during the cycle.

## Contributing

Contributions are welcome! If you have suggestions for improvements or additional features, please create an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the community for their contributions and support in the field of thermodynamics and engine simulations.
