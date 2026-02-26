function control_law_833(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.S

  setup(block);
  
%endfunction

function setup(block)
  %% Register number of dialog parameters   
  block.NumDialogPrms = 1;
  
  %% Register number of input and output ports
  block.NumInputPorts  = 4;
  block.NumOutputPorts = 2;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  
  block.InputPort(1).Dimensions        = [3,1];% x_r
  block.InputPort(1).DirectFeedthrough = true;
 
  block.InputPort(2).Dimensions        = [3,1];% x
  block.InputPort(2).DirectFeedthrough = true;
  
  block.InputPort(3).Dimensions        = [3,1];% v
  block.InputPort(3).DirectFeedthrough = true;
  
  block.InputPort(4).Dimensions        = [3,3];% R
  block.InputPort(4).DirectFeedthrough = true;
  
%   block.InputPort(5).Dimensions        = [3,1];
%   block.InputPort(5).DirectFeedthrough = true;
  
  block.OutputPort(1).Dimensions       = [1];
  block.OutputPort(2).Dimensions       = [1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 6;
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
%   block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
%   block.RegBlockMethod('Update',                  @Update); 
  block.RegBlockMethod('Derivatives',             @Derivative);
  block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
  
%endfunction

function DoPostPropSetup(block)

  %% Setup Dwork
%   block.NumDworks = 1;
%   block.Dwork(1).Name = 'x0'; 
%   block.Dwork(1).Dimensions      = 1;
%   block.Dwork(1).DatatypeID      = 0;
%   block.Dwork(1).Complexity      = 'Real';
%   block.Dwork(1).UsedAsDiscState = true;

%endfunction

function InitConditions(block)

%% Initialize Dwork
%   block.Dwork(1).Data = block.DialogPrm(1).Data;
block.ContStates.Data = [0;
                         0;
                         0;
                         0;
                         0;
                         0];
  
%endfunction

function Output(block)

x_r = block.InputPort(1).Data;
x = block.InputPort(2).Data;
v = block.InputPort(3).Data;
R = block.InputPort(4).Data;
% T = block.InputPort(4).Data;
% Gamma = block.InputPort(5).Data;

pa = block.DialogPrm(1).Data;
g = 9.81;
k1 = pa.k1;
k2 = pa.k2;
k3 = pa.k3;
a = pa.a;
M = pa.M;
delta = pa.delta;
k_z = pa.k_z;
beta = pa.beta;
eta = pa.eta;
beta_z = pa.beta_z;
eta_z = pa.eta_z;
tao = pa.tao;

e1 = [1;0;0];
e2 = [0;1;0];
e3 = [0;0;1];

gamma_dot = [0;0;0];
x_r_dot_dot = [0;0;0];
x_r_dot = [0;0;0];

x_tilde = x - x_r;
z1 = block.ContStates.Data(1:3,1);
z2 = block.ContStates.Data(4:6,1);
z = z1;
z_dot = z2;
z_dot_dot = -2*k_z*z2 - k_z^2 * (z1-sat(z1,delta)) + k_z*h((norm(x_tilde))^2,beta_z,eta_z)*x_tilde;

R_T = R.';
v_tilde = v - R_T*x_r_dot;
y = x_tilde + z;
v_ba = v_tilde + R_T*z_dot;
gamma_e_hat = g*e3;
gamma_d = [0;0;0];
gamma_e_d_hat = gamma_e_hat - gamma_d;
% gamma = gamma_e - x_r_dot_dot;
gamma = gamma_d + sat(gamma_e_d_hat,M) - x_r_dot_dot + h((norm(y))^2,beta,eta)*y + z_dot_dot;
gamma_ba = R_T*gamma;
gamma_norm = norm(gamma);
mu_1 = mu_tao(gamma_norm + gamma_ba(3),tao);
mu_2 = mu_tao(gamma_norm,tao);
S1 = skew_symmetric_matrix(R*e1);
S2 = skew_symmetric_matrix(R*e2);
gamma_T = gamma.';
sigma = a/k1*tanh(k1*v_ba(3)/a);

T = F1 + k1*Fp_norm*v1_tilde;
omega = k2*Fp_norm*v2_tilde + mu_1*k3*Fp_norm*Fp_ba(2)/((Fp_norm + Fp_ba(1))^2) - mu_2*Fp_ba_T*S*R_T*F_delta/(Fp_norm^2); 

block.OutputPort(1).Data = T;
block.OutputPort(2).Data = omega;
  
%endfunction

function Derivative(block)

pa = block.DialogPrm(1).Data;
delta = pa.delta;
k_z = pa.k_z;
beta_z = pa.beta_z;
eta_z = pa.eta_z;

x_r = block.InputPort(1).Data;
x = block.InputPort(2).Data;
x_tilde = x - x_r;
z1 = block.ContStates.Data(1:3,1);
z2 = block.ContStates.Data(4:6,1);
z_dot = z2;
z_dot_dot = -2*k_z*z2 - k_z^2 * (z1-sat(z1,delta)) + k_z*h((norm(x_tilde))^2,beta_z,eta_z)*x_tilde;
block.Derivatives.Data = [z_dot;
                          z_dot_dot];

%endfunction

function Update(block)

%   block.Dwork(1).Data = block.InputPort(1).Data;
  
%endfunction

function SetInputPortSamplingMode(block, idx, fd)

block.InputPort(idx).SamplingMode = fd;
block.InputPort(idx).SamplingMode = fd;

block.OutputPort(1).SamplingMode = fd;
block.OutputPort(2).SamplingMode = fd;
block.OutputPort(3).SamplingMode = fd;

%endfunction

