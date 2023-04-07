function controller_angular_velocity(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.S

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
  
  block.InputPort(1).Dimensions        = [3,1];% omega_d
  block.InputPort(1).DirectFeedthrough = true;
 
  block.InputPort(2).Dimensions        = [3,1];% omega
  block.InputPort(2).DirectFeedthrough = true;
  
%   block.InputPort(3).Dimensions        = [3,1];% v
%   block.InputPort(3).DirectFeedthrough = true;
%   
%   block.InputPort(4).Dimensions        = [3,3];% R
%   block.InputPort(4).DirectFeedthrough = true;
  
%   block.InputPort(5).Dimensions        = [3,1];
%   block.InputPort(5).DirectFeedthrough = true;
  
  block.OutputPort(1).Dimensions       = [3,1];
  
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
%                          0;
%                          0;
%                          0;
%                          0];
  
%endfunction

function Output(block)

omega_d = block.InputPort(1).Data;
omega = block.InputPort(2).Data;
pa = block.DialogPrm(1).Data;
J_hat = pa.J_hat;
K_w = pa.K_w;
Sw = skew_symmetric_matrix(omega);

Gamma = Sw*J_hat*omega_d - J_hat*K_w*(omega-omega_d);
block.OutputPort(1).Data = [Gamma];
  
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
block.OutputPort(3).SamplingMode = fd;

%endfunction

