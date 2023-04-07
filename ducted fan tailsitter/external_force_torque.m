function external_force_torque(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.S

  setup(block);
  
%endfunction

function setup(block)
  %% Register number of dialog parameters   
  block.NumDialogPrms = 1;
  
  %% Register number of input and output ports
  block.NumInputPorts  = 5;
  block.NumOutputPorts = 2;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).Dimensions        = [3,1];
  block.InputPort(1).DirectFeedthrough = true;
  
  block.InputPort(2).Dimensions        = [3,1];
  block.InputPort(2).DirectFeedthrough = true;
  
  block.InputPort(3).Dimensions        = [3,3];
  block.InputPort(3).DirectFeedthrough = true;
  
  block.InputPort(4).Dimensions        = 1;
  block.InputPort(4).DirectFeedthrough = true;
  
  block.InputPort(5).Dimensions        = [3,1];
  block.InputPort(5).DirectFeedthrough = true;
  
  block.OutputPort(1).Dimensions       = [3,1];
  block.OutputPort(2).Dimensions       = [3,1];
  
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
% block.ContStates.Data = [0;
%                          0;
%                          0;];
  
%endfunction

function Output(block)

v = block.InputPort(1).Data;
vf = block.InputPort(2).Data;
R = block.InputPort(3).Data;
T = block.InputPort(4).Data;
Gamma = block.InputPort(5).Data;

pa = block.DialogPrm(1).Data;
m = pa.m;
g = 9.81;
L = pa.L;
varepsilon_ae = pa.varepsilon_ae;
varepsilon_m = pa.varepsilon_m;
ke1 = pa.ke1;
ke2 = pa.ke2;
ke3 = pa.ke3;
ke4 = pa.ke4;
ke5 = pa.ke5;

e3 = [0;0;1];
Se3 = skew_symmetric_matrix(e3);
Sigma_R = -1/L * Se3;

R_T = R.';
ve = v - R_T*vf;

temp1 = [-ke1*sqrt(ve(1)^2 + ve(2)^2)*ve(1) - ke2*norm(ve)*ve(1);
         -ke1*sqrt(ve(1)^2 + ve(2)^2)*ve(2) - ke2*norm(ve)*ve(2);
         -ke3*(ve(1)^2 + ve(2)^2)-ke4*norm(ve(3))*ve(3)];

temp2 = [ke1*sqrt(ve(1)^2 + ve(2)^2)*ve(2) + ke2*norm(ve)*ve(2);
       -ke1*sqrt(ve(1)^2 + ve(2)^2)*ve(1) - ke2*norm(ve)*ve(1);
        0];
    
F_ae_B = temp1 - ke5*sqrt(T)*ve;
Gamma_ae_B = varepsilon_ae*temp2 - varepsilon_m*ke5*sqrt(T)*Se3*ve;

F_e = m*g*e3 + R*Sigma_R*Gamma + R*F_ae_B;
Gamma_e = Gamma_ae_B;

block.OutputPort(1).Data = F_e;
block.OutputPort(2).Data = Gamma_e;
  
%endfunction

function Derivative(block)

%endfunction

function Update(block)

%   block.Dwork(1).Data = block.InputPort(1).Data;
  
%endfunction

function SetInputPortSamplingMode(block, idx, fd)

block.InputPort(idx).SamplingMode = fd;
block.InputPort(idx).SamplingMode = fd;

block.OutputPort(1).SamplingMode = fd;
block.OutputPort(2).SamplingMode = fd;

%endfunction

