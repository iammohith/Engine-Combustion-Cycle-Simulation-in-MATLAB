% Engine Combustion Cycle Simulation with Constant and Variable Heat Capacity Ratios
% Author: [Mohith Sai Gorla]
% Description:
% This script simulates the combustion cycle of an internal combustion engine.
% It calculates piston displacement, velocity, acceleration, volume, temperature,
% and pressure for both constant and variable heat capacity ratios (gamma).
% The script also plots various parameters to visualize the engine cycle.
% This is for test
% Clear workspace and command window
clear; clc;

%% --- Initialization of Parameters ---

% Geometric and engine parameters
s = 0.1;            % Stroke length in meters
r = s / 2;          % Crank radius in meters
l = 4 * s;          % Connecting rod length in meters
d = s;              % Cylinder diameter in meters
rc = 9;             % Compression ratio
n = 1000;           % Engine speed in RPM

% Thermodynamic properties
tmax = 3000;        % Peak temperature in Kelvin
cv = 0.71;          % Molar specific heat at constant volume (constant gamma case)
gamma = 1.4;        % Heat capacity ratio (constant gamma case)
R = 0.287;          % Gas constant for air in kJ/kg·K

% Inlet conditions
p = 101325;         % Inlet pressure in Pascals
t = 25;             % Inlet temperature in Celsius
t = t + 273;        % Convert inlet temperature to Kelvin

% Crank angle setup
theta_deg = -180:1:180;          % Crank angle from -180 to 180 degrees
theta = pi / 180 * theta_deg;    % Convert crank angle to radians

% Engine speed in radians per second
w = 2 * pi * n / 60;

%% --- Preallocate Arrays for Efficiency ---

% Arrays for piston kinematics
y = zeros(1, 361);        % Piston displacement
ys = zeros(1, 361);       % Piston velocity
ya = zeros(1, 361);       % Piston acceleration

% Arrays for thermodynamic state variables (constant gamma)
vs = zeros(1, 362);       % Swept volume
ts = zeros(1, 362);       % Instantaneous temperature
ps = zeros(1, 362);       % Instantaneous pressure
wcom = zeros(1, 361);     % Compression work
wexp = zeros(1, 361);     % Expansion work

% Arrays for thermodynamic state variables (variable gamma)
gammac = zeros(1, 362);   % Gamma as a function of temperature
cvc = zeros(1, 362);      % Specific heat at constant volume (variable gamma)
tsc = zeros(1, 362);      % Instantaneous temperature (variable gamma)
psc = zeros(1, 362);      % Instantaneous pressure (variable gamma)
g = zeros(1, 20);         % Iterative array for variable gamma computation
error = zeros(1, 361);    % Error in gamma iteration

%% --- Calculated Constants and Initial Conditions ---

% Calculate maximum swept volume and clearance volume
vmax = pi / 4 * d^2 * y(1);          % Maximum swept volume (initial displacement)
vc = vmax / (rc - 1);                % Clearance volume based on compression ratio

% Initialize swept volume and thermodynamic properties at start
vs(1) = vmax + vc;                    % Total initial volume
ts(1) = t;                            % Initial temperature
ps(1) = p;                            % Initial pressure
tsc(1) = t;                           % Initial temperature (variable gamma)
psc(1) = p;                           % Initial pressure (variable gamma)
gammac(1) = gamma;                    % Initial gamma (constant case)
cvc(1) = cv;                          % Initial cv (constant case)

% Set final swept volume and thermodynamic properties (for cycle closure)
vs(362) = vmax + vc;
ts(362) = t;
psc(362) = p;
tsc(362) = t;
psc(362) = p;

%% --- Simulation Loop Over Crank Angles ---

for i = 2:361
    if i < 181
        % **Compression Stroke and Part of Expansion Stroke**
        
        % Calculate piston displacement using kinematic equations
        y(i) = l * ((r / l)^2 * sin(theta(i) / 2)^2) + r * (1 - cos(theta(i)));
        
        % Calculate piston velocity
        ys(i) = r * w * (sin(theta(i)) + (r / l) * sin(2 * theta(i)) / 2);
        
        % Calculate piston acceleration
        ya(i) = r * w^2 * (cos(theta(i)) + (r / l) * cos(2 * theta(i)));
        
        % Calculate instantaneous swept volume
        vs(i) = vc + (pi / 4) * d^2 * y(i);
        
        %% --- Thermodynamics with Constant Gamma ---
        % Apply adiabatic compression/expansion formula: P * V^gamma = constant
        ps(i) = (vs(i-1) / vs(i))^gamma * ps(i-1);
        
        % Temperature relation: T * V^(gamma-1) = constant
        ts(i) = (vs(i-1) / vs(i))^(gamma - 1) * ts(i-1);
        
        %% --- Thermodynamics with Variable Gamma ---
        % Initialize gamma with previous value
        g(1) = gammac(i-1);
        
        % Iterative computation to update gamma based on temperature
        for j = 2:20
            % Update temperature based on current gamma estimate
            t2 = (vs(i-1) / vs(i))^(g(j-1) - 1) * tsc(i-1);
            
            % Update specific heat at constant volume
            cv2 = (0.71 * (t2 - tsc(i-1)) + 19e-5 / 2 * (t2^2 - tsc(i-1)^2)) / (t2 - tsc(i-1));
            
            % Update gamma based on new cv
            g(j) = (cv2 + R) / cv2;
            
            % Calculate relative error between iterations
            error(i) = abs((g(j-1) - g(j))) / g(j);
            
            % Check for convergence (optional: can implement break if error < tolerance)
        end
        
        % Assign converged gamma and updated thermodynamic properties
        gammac(i) = g(20);
        cvc(i) = cv2;
        tsc(i) = t2;
        psc(i) = (vs(i-1) / vs(i))^gammac(i) * psc(i-1);
        
    elseif i == 181
        % **Top Dead Center (Peak Compression)**
        
        % Calculate piston displacement
        y(i) = l * ((r / l)^2 * sin(theta(i) / 2)^2) + r * (1 - cos(theta(i)));
        
        % Calculate piston velocity
        ys(i) = r * w * (sin(theta(i)) + (r / l) * sin(2 * theta(i)) / 2);
        
        % Calculate piston acceleration
        ya(i) = r * w^2 * (cos(theta(i)) + (r / l) * cos(2 * theta(i)));
        
        % At Top Dead Center, volume is minimum (clearance volume)
        vs(i) = vc;
        
        %% --- Thermodynamics at Top Dead Center ---
        % For constant gamma, set temperature to peak value
        ts(i) = tmax;
        ps(i) = (ts(i) / ts(i-1)) * ps(i-1);
        
        %% --- Thermodynamics with Variable Gamma ---
        % Set temperature to peak value
        tsc(i) = tmax;
        
        % Update pressure based on temperature
        psc(i) = (tsc(i) / tsc(i-1)) * psc(i-1);
        
        % Update specific heat at constant volume with temperature dependence
        cvc(i) = 0.71 + 19e-5 / 2 * (tsc(i) - tsc(i-1));
        
        % Update gamma based on new cv
        gammac(i) = (cvc(i) + R) / cvc(i);
        
    else
        % **Expansion Stroke**
        
        % Calculate piston displacement
        y(i) = l * ((r / l)^2 * sin(theta(i) / 2)^2) + r * (1 - cos(theta(i)));
        
        % Calculate piston velocity
        ys(i) = r * w * (sin(theta(i)) + (r / l) * sin(2 * theta(i)) / 2);
        
        % Calculate piston acceleration
        ya(i) = r * w^2 * (cos(theta(i)) + (r / l) * cos(2 * theta(i)));
        
        % Calculate instantaneous swept volume
        vs(i) = vc + (pi / 4) * d^2 * y(i);
        
        %% --- Thermodynamics with Constant Gamma ---
        % Apply adiabatic compression/expansion formula: P * V^gamma = constant
        ps(i) = (vs(i-1) / vs(i))^gamma * ps(i-1);
        
        % Temperature relation: T * V^(gamma-1) = constant
        ts(i) = (vs(i-1) / vs(i))^(gamma - 1) * ts(i-1);
        
        %% --- Thermodynamics with Variable Gamma ---
        % Initialize gamma with previous value
        g(1) = gammac(i-1);
        
        % Iterative computation to update gamma based on temperature
        for j = 2:20
            % Update temperature based on current gamma estimate
            t2 = (vs(i-1) / vs(i))^(g(j-1) - 1) * tsc(i-1);
            
            % Update specific heat at constant volume
            cv2 = (0.71 * (t2 - tsc(i-1)) + 19e-5 / 2 * (t2^2 - tsc(i-1)^2)) / (t2 - tsc(i-1));
            
            % Update gamma based on new cv
            g(j) = (cv2 + R) / cv2;
            
            % Calculate relative error between iterations
            error(i) = abs((g(j-1) - g(j))) / g(j);
            
            % Check for convergence (optional: can implement break if error < tolerance)
        end
        
        % Assign converged gamma and updated thermodynamic properties
        gammac(i) = g(20);
        cvc(i) = cv2;
        tsc(i) = t2;
        psc(i) = (vs(i-1) / vs(i))^gammac(i) * psc(i-1);
        
    end
end

%% --- Calculate Thermodynamic Quantities for Cycle ---

% **Constant Gamma Case**
qrej = cv * (ts(361) - ts(362));          % Heat rejected during cycle
qadded = cv * (ts(181) - ts(180));        % Heat added during cycle
wcomt = cv * (ts(180) - ts(1));           % Total compression work
wexpt = cv * (ts(181) - ts(361));         % Total expansion work
wt = wexpt - wcomt;                       % Net cycle work
eta = wt / qadded;                        % Thermal efficiency

% **Variable Gamma Case**
% Final adjustments for cycle closure
gammac(362) = 1.4;
cvc(362) = 0.71 + 19e-5 / 2 * (tsc(361) + tsc(362));

% Calculate heat added and rejected with variable gamma
qaddedc = (0.71 + 19e-5 / 2 * (tsc(180) + tsc(181))) * (tsc(181) - tsc(180));
qrejc = cvc(362) * (tsc(361) - tsc(362));

% Calculate compression and expansion work with variable gamma
wcomtc = (0.71 + 19e-5 / 2 * (tsc(1) + tsc(180))) * (tsc(180) - tsc(1));
wexptc = (0.71 + 19e-5 / 2 * (tsc(180) + tsc(361))) * (tsc(181) - tsc(361));
wtc = wexptc - wcomtc;                    % Net cycle work (variable gamma)
etac = wtc / qaddedc;                     % Thermal efficiency (variable gamma)

%% --- Visualization: Plotting Results ---

% Plot Piston Displacement vs Crank Angle
figure;
plot(theta_deg, y, 'Color', [0.8 0.3 0.01], 'LineWidth', 1.5);
title('Change of Displacement with Crank Angle');
xlabel('Crank Angle (degrees)');
ylabel('Piston Displacement (m)');
set(gca, 'FontName', 'Century Gothic', 'FontSize', 16, 'FontWeight', 'bold', ...
    'GridAlpha', 0.07, 'GridLineStyle', '--', 'LineWidth', 1.5, ...
    'XColor', [0 0 0], 'XMinorTick', 'on', 'YColor', [0 0 0], 'YMinorTick', 'on');
grid on;

% Plot Piston Velocity vs Crank Angle
figure;
plot(theta_deg, ys, 'Color', [0.8 0.3 0.01], 'LineWidth', 1.5);
title('Change of Piston Velocity with Crank Angle');
xlabel('Crank Angle (degrees)');
ylabel('Piston Velocity (m/s)');
set(gca, 'FontName', 'Century Gothic', 'FontSize', 16, 'FontWeight', 'bold', ...
    'GridAlpha', 0.07, 'GridLineStyle', '--', 'LineWidth', 1.5, ...
    'XColor', [0 0 0], 'XMinorTick', 'on', 'YColor', [0 0 0], 'YMinorTick', 'on');
grid on;

% Plot Piston Acceleration vs Crank Angle
figure;
plot(theta_deg, ya, 'Color', [0.8 0.3 0.01], 'LineWidth', 1.5);
title('Change of Piston Acceleration with Crank Angle');
xlabel('Crank Angle (degrees)');
ylabel('Piston Acceleration (m/s²)');
set(gca, 'FontName', 'Century Gothic', 'FontSize', 16, 'FontWeight', 'bold', ...
    'GridAlpha', 0.07, 'GridLineStyle', '--', 'LineWidth', 1.5, ...
    'XColor', [0 0 0], 'XMinorTick', 'on', 'YColor', [0 0 0], 'YMinorTick', 'on');
grid on;

% Plot PV Diagram for Constant and Variable Gamma
figure;
plot(vs, ps, 'b', vs, psc, 'r', 'LineWidth', 1.5);
legend('Constant Gamma', 'Variable Gamma', 'Location', 'Best');
xlabel('Volume (m^3)');
ylabel('Pressure (Pa)');
title('Cycle PV Diagram');
set(gca, 'FontName', 'Century Gothic', 'FontSize', 16, 'FontWeight', 'bold', ...
    'GridAlpha', 0.07, 'GridLineStyle', '--', 'LineWidth', 1.5, ...
    'XColor', [0 0 0], 'XMinorTick', 'on', 'YColor', [0 0 0], 'YMinorTick', 'on');
grid on;

% Plot Pressure vs Crank Angle for Constant and Variable Gamma
figure;
plot(theta_deg, ps(1:361), 'b', theta_deg, psc(1:361), 'r', 'LineWidth', 1.5);
legend('Constant Gamma', 'Variable Gamma', 'Location', 'Best');
xlabel('Crank Angle (degrees)');
ylabel('Pressure (Pa)');
title('Change of Pressure with Crank Angle');
set(gca, 'FontName', 'Century Gothic', 'FontSize', 16, 'FontWeight', 'bold', ...
    'GridAlpha', 0.07, 'GridLineStyle', '--', 'LineWidth', 1.5, ...
    'XColor', [0 0 0], 'XMinorTick', 'on', 'YColor', [0 0 0], 'YMinorTick', 'on');
grid on;

% Plot Gamma vs Temperature During Cycle
figure;
plot(gammac(1:180), tsc(1:180), 'c', ...
     gammac(180:181), tsc(180:181), 'r', ...
     gammac(181:361), tsc(181:361), 'b', 'LineWidth', 1.5);
legend('Compression', 'Combustion', 'Expansion', 'Location', 'Best');
xlabel('Gamma');
ylabel('Temperature (K)');
title('Change of Gamma with Temperature');
set(gca, 'FontName', 'Century Gothic', 'FontSize', 16, 'FontWeight', 'bold', ...
    'GridAlpha', 0.07, 'GridLineStyle', '--', 'LineWidth', 1.5, ...
    'XColor', [0 0 0], 'XMinorTick', 'on', 'YColor', [0 0 0], 'YMinorTick', 'on');
grid on;
