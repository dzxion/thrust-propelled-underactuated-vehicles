clc
clear

% ������
theta_tilde = -pi:0.01:pi;

% ֵ��
V = 1-cos(theta_tilde);

% ��ͼ
figure
plot(theta_tilde, V)