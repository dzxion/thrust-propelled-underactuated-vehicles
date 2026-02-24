clc
clear

% ∂®“Â”Ú
theta_tilde = -pi:0.01:pi;

% ÷µ”Ú
V = 1-cos(theta_tilde);

% ªÊÕº
figure
plot(theta_tilde, V)