function angular_velocity_dynamic(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.

  setup(block);
  
%endfunction

function setup(block)
  %% Register number of dialog parameters   
  block.NumDialogPrms = 1;
  
  %% Register number of input and output ports
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).Dimensions        = [3,1];
  block.InputPort(1).DirectFeedthrough = false;
  
  block.InputPort(2).Dimensions        = [3,1];
  block.InputPort(2).DirectFeedthrough = false;
  
  block.OutputPort(1).Dimensions       = [3,1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 3;
  
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
                         0;
                         0;];
  
%endfunction

function Output(block)

block.OutputPort(1).Data = block.ContStates.Data;
  
%endfunction

function Derivative(block)

Gamma = block.InputPort(1).Data;
Gamma_e = block.InputPort(2).Data;
omega = block.ContStates.Data;
pa = block.DialogPrm(1).Data;
J = pa.J;
% J = diag([0.13,0.13,0.14]);

Sw = skew_symmetric_matrix(omega);
omega_dot = inv(J)*(-Sw*J*omega + Gamma + Gamma_e);
block.Derivatives.Data = omega_dot;

%endfunction

function Update(block)

%   block.Dwork(1).Data = block.InputPort(1).Data;
  
%endfunction

