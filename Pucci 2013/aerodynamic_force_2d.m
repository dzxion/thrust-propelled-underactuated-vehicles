function aerodynamic_force_2d(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.S

  setup(block);
  
%endfunction

function setup(block)
  %% Register number of dialog parameters   
  block.NumDialogPrms = 1;
  
  %% Register number of input and output ports
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).Dimensions        = [2,1];% x_dot
  block.InputPort(1).DirectFeedthrough = true;
  
  block.InputPort(2).Dimensions        = [2,1];% xw_dot
  block.InputPort(2).DirectFeedthrough = true;
  
  block.InputPort(3).Dimensions        = [1];% theta
  block.InputPort(3).DirectFeedthrough = true;
  
%   block.InputPort(4).Dimensions        = 1;
%   block.InputPort(4).DirectFeedthrough = true;
%   
%   block.InputPort(5).Dimensions        = [3,1];
%   block.InputPort(5).DirectFeedthrough = true;
  
  block.OutputPort(1).Dimensions       = [2,1];
%   block.OutputPort(2).Dimensions       = [3,1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 0;
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
%   block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
%   block.RegBlockMethod('Update',                  @Update); 
  block.RegBlockMethod('Derivatives',             @Derivative);
%   block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
  
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
% block.ContStates.Data = [0;
%                          0;
%                          0;];
  
%endfunction

function Output(block)

x_dot = block.InputPort(1).Data;
xw_dot = block.InputPort(2).Data;
theta = block.InputPort(3).Data;

pa = block.DialogPrm(1).Data;
m = pa.m;
g = pa.g;
alpha_ba = pa.alpha_ba;
kL = pa.kL;
kD = pa.kD;
c0 = pa.c0;
c1 = pa.c1;
c2 = pa.c2;
c3 = pa.c3;
ka = pa.ka;

xa_dot = x_dot - xw_dot;
R = [cos(theta) -sin(theta);
     sin(theta) cos(theta)];
z_L = R*[1;0];
z_L = -z_L;
alpha = vector_angle_2d(xa_dot,z_L,'rad');

c_LL = c1*sin(2*alpha);
c_DL = c0+2*c1*(sin(alpha))^2;
c_Ls = 0.5*c2^2/((c2-c3)*(cos(alpha))^2+c3)*sin(2*alpha);
c_Ds = c0+c2*c3/((c2-c3)*(cos(alpha))^2+c3)*(sin(alpha))^2;
sigma_kL = (1+tanh(kL*alpha_ba^2-kL*alpha^2))/(1+tanh(kL*alpha_ba^2));
sigma_kD = (1+tanh(kD*alpha_ba^2-kD*alpha^2))/(1+tanh(kD*alpha_ba^2));
c_L = c_Ls*sigma_kL + c_LL*(1-sigma_kL);
c_D = c_Ds*sigma_kD + c_DL*(1-sigma_kD);

S = [0 -1;1 0];
xa_dot_ver = S*xa_dot;
xa_dot_norm = norm(xa_dot);
F_a = ka*xa_dot_norm*(c_L*xa_dot_ver-c_D*xa_dot);
block.OutputPort(1).Data = F_a;
  
%endfunction

function Derivative(block)

%endfunction

function Update(block)

%   block.Dwork(1).Data = block.InputPort(1).Data;
  
%endfunction

% function SetInputPortSamplingMode(block, idx, fd)
% 
% block.InputPort(idx).SamplingMode = fd;
% block.InputPort(idx).SamplingMode = fd;
% 
% block.OutputPort(1).SamplingMode = fd;
% block.OutputPort(2).SamplingMode = fd;

%endfunction

