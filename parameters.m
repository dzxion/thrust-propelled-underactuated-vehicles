clear
clc

ToDeg = 180/pi;
ToRad = pi/180;

%% model parameters
pa.ke1 = 0.13;
pa.ke2 = 0.03;
pa.ke3 = 0.03;
pa.ke4 = 0.005;
pa.ke5 = 0.28;
pa.varepsilon_ae = 0.05;
pa.varepsilon_m = 0.05;

pa.m = 3.2;
% pa.g = 9.81;
pa.J = diag([0.13,0.13,0.04]);
pa.L = 0.2;

%% controller parameters
pa.m_hat = 3;
pa.J_hat = diag([0.1,0.1,0.03]);
pa.k_a = 5;
pa.k1 = 0.245;
pa.k2 = 0.06;
pa.k3 = 9.6;
pa.K_w = diag([20,20,20]);
pa.beta = 1.28;
pa.eta = 12;
pa.a = 0.9;
pa.k_z = 0.8;
pa.beta_z = 0.8;
pa.eta_z = 0.8;
pa.delta = 8;
pa.M = 50;
pa.tao = 1;

%% initial state
pa.x0 = [8;5;-8];

%% desired state
pa.x_r = [0;0;0];
