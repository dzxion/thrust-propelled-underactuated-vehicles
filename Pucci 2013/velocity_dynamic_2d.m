function velocity_dynamic_2d(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.

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
 
  block.InputPort(1).Dimensions        = 1;% T
  block.InputPort(1).DirectFeedthrough = false;
  
  block.InputPort(2).Dimensions        = [1];% Theta
  block.InputPort(2).DirectFeedthrough = false;
  
  block.InputPort(3).Dimensions        = [2,1];% Fa
  block.InputPort(3).DirectFeedthrough = false;
  
%   block.InputPort(4).Dimensions        = [3,1];
%   block.InputPort(4).DirectFeedthrough = false;
  
  block.OutputPort(1).Dimensions       = [2,1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 2;
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
%   block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
%   block.RegBlockMethod('Update',                  @Update); 
  block.RegBlockMethod('Derivatives',             @Derivative);
  
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
                         0;];
  
%endfunction

function Output(block)

block.OutputPort(1).Data = block.ContStates.Data;
  
%endfunction

function Derivative(block)

pa = block.DialogPrm(1).Data;
m = pa.m;
g = pa.g;
% L = 0.2;
T = block.InputPort(1).Data;
theta = block.InputPort(2).Data;
% omega = block.InputPort(3).Data;
Fa = block.InputPort(3).Data;
% v = block.ContStates.Data;

R = [cos(theta) -sin(theta);
     sin(theta) cos(theta)];
i_b = [1;0];
i = R*i_b;
% R_T = R.';
% e3 = [0;0;1];
% Se3 = skew_symmetric_matrix(e3);
% Sigma_R = -1/L * Se3;
% Fe = m*g*e3 + R*Sigma_R*Gamma + R*F_ae; 

v_dot = (-T*i + Fa)/m + g;
block.Derivatives.Data = v_dot;

%endfunction

function Update(block)

%   block.Dwork(1).Data = block.InputPort(1).Data;
  
%endfunction

