close all

% ToDeg = 180/pi;
% ToRad = pi/180;

%% model parameters
pa.alpha_hat = 11;
pa.kL = 14;
pa.kD = 41.8;
pa.ka = 0.6460;
pa.c0 = 0.0139;
pa.c1 = 0.9430;
pa.c2 = 5.4641;
pa.c3 = 0.3151;

pa.m = 10;
pa.g = 9.81;
pa.J = diag([0.13,0.13,0.04]);
pa.L = 0.2;
% 
% %% controller parameters
% pa.m_hat = 3;
% pa.J_hat = diag([0.1,0.1,0.03]);
pa.ka = 0.6460;
pa.k1 = 0.1529;
pa.k2 = 0.0234;
pa.k3 = 6;
% pa.K_w = diag([20,20,20]);
% pa.beta = 1.28;
% pa.eta = 12;
% pa.a = 0.9;
% pa.k_z = 0.8;
% pa.beta_z = 0.8;
% pa.eta_z = 0.8;
% pa.delta = 8;
% pa.M = 50;
pa.tao = 80;

%% initial state
pa.x0 = [0;0];

%% desired state
pa.x_r = [0;0];
