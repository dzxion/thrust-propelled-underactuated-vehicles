%% 清空工作区
clear; clc; close all;

%% 定义符号变量
syms alpha real
syms c0 c1 c2 c3 real
syms k_L k_D real
syms alpha_bar real

%% 定义常数（实际数值）
c0_val = 0.0139;
c1_val = 0.9430;
c2_val = 5.4641;
c3_val = 0.3151;
alpha_bar_val = 11 * pi/180;  % 转换为弧度
k_L_val = 14;
k_D_val = 41.8;

%% 定义辅助函数
% B(alpha)函数
B_alpha = (c2 - c3)*cos(alpha)^2 + c3;

% 混合函数sigma
sigma_L = (1 + tanh(k_L*alpha_bar^2 - k_L*alpha^2)) / (1 + tanh(k_L*alpha_bar^2));
sigma_D = (1 + tanh(k_D*alpha_bar^2 - k_D*alpha^2)) / (1 + tanh(k_D*alpha_bar^2));

% 线性区域系数
c_LL = c1 * sin(2*alpha);
c_DL = c0 + 2*c1 * sin(alpha)^2;

% 失速区域系数
c_LS = (0.5*c2^2 * sin(2*alpha)) / B_alpha;
c_DS = c0 + (c2*c3 * sin(alpha)^2) / B_alpha;

%% 计算c_L和c_D
c_L = c_LS * sigma_L + c_LL * (1 - sigma_L);
c_D = c_DS * sigma_D + c_DL * (1 - sigma_D);

%% 对alpha求导
dc_L_dalpha = diff(c_L, alpha);
dc_D_dalpha = diff(c_D, alpha);

%% 简化表达式
dc_L_dalpha_simple = simplify(dc_L_dalpha);
dc_D_dalpha_simple = simplify(dc_D_dalpha);

%% 显示结果
fprintf('========== c_L(alpha)对alpha的导数 ==========\n');
pretty(dc_L_dalpha_simple)

fprintf('\n========== c_D(alpha)对alpha的导数 ==========\n');
pretty(dc_D_dalpha_simple)

%% 代入数值
c_L_num = subs(c_L, [c0 c1 c2 c3 alpha_bar k_L k_D], ...
    [c0_val c1_val c2_val c3_val alpha_bar_val k_L_val k_D_val]);
c_D_num = subs(c_D, [c0 c1 c2 c3 alpha_bar k_L k_D], ...
    [c0_val c1_val c2_val c3_val alpha_bar_val k_L_val k_D_val]);

dc_L_dalpha_num = subs(dc_L_dalpha_simple, ...
    [c0 c1 c2 c3 alpha_bar k_L k_D], ...
    [c0_val c1_val c2_val c3_val alpha_bar_val k_L_val k_D_val]);

dc_D_dalpha_num = subs(dc_D_dalpha_simple, ...
    [c0 c1 c2 c3 alpha_bar k_L k_D], ...
    [c0_val c1_val c2_val c3_val alpha_bar_val k_L_val k_D_val]);

%% 绘制曲线
alpha_range = linspace(-pi, pi, 1000);
c_L_values = double(subs(c_L_num, alpha, alpha_range));
c_D_values = double(subs(c_D_num, alpha, alpha_range));
dc_L_values = double(subs(dc_L_dalpha_num, alpha, alpha_range));
dc_D_values = double(subs(dc_D_dalpha_num, alpha, alpha_range));

% 创建图形窗口
figure('Position', [100 100 1400 900])

% 子图1: c_L(α)
subplot(2,2,1)
plot(alpha_range*180/pi, c_L_values, 'b-', 'LineWidth', 2)
xlabel('\alpha (度)', 'FontSize', 12)
ylabel('c_L', 'FontSize', 12)
title('c_L(\alpha) 升力系数', 'FontSize', 14, 'FontWeight', 'bold')
grid on
xlim([-180 180])
ylim([min(c_L_values)*1.1, max(c_L_values)*1.1])
hold on
% 标记失速角
plot([alpha_bar_val*180/pi, alpha_bar_val*180/pi], ylim, 'r--', 'LineWidth', 1.5)
text(alpha_bar_val*180/pi + 5, max(c_L_values)*0.9, ['\alpha_{stall} = ' num2str(alpha_bar_val*180/pi) '°'], 'Color', 'r')

% 子图2: c_D(α)
subplot(2,2,2)
plot(alpha_range*180/pi, c_D_values, 'r-', 'LineWidth', 2)
xlabel('\alpha (度)', 'FontSize', 12)
ylabel('c_D', 'FontSize', 12)
title('c_D(\alpha) 阻力系数', 'FontSize', 14, 'FontWeight', 'bold')
grid on
xlim([-180 180])
ylim([min(c_D_values)*0.9, max(c_D_values)*1.1])
hold on
plot([alpha_bar_val*180/pi, alpha_bar_val*180/pi], ylim, 'b--', 'LineWidth', 1.5)
text(alpha_bar_val*180/pi + 5, max(c_D_values)*0.8, ['\alpha_{stall} = ' num2str(alpha_bar_val*180/pi) '°'], 'Color', 'b')

% 子图3: dc_L/dα
subplot(2,2,3)
plot(alpha_range*180/pi, dc_L_values, 'b-', 'LineWidth', 2)
xlabel('\alpha (度)', 'FontSize', 12)
ylabel('dc_L/d\alpha', 'FontSize', 12)
title('c_L(\alpha) 的导数', 'FontSize', 14, 'FontWeight', 'bold')
grid on
xlim([-180 180])
hold on
plot([alpha_bar_val*180/pi, alpha_bar_val*180/pi], ylim, 'r--', 'LineWidth', 1.5)
plot(xlim, [0 0], 'k-', 'LineWidth', 0.5)  % 零线

% 子图4: dc_D/dα
subplot(2,2,4)
plot(alpha_range*180/pi, dc_D_values, 'r-', 'LineWidth', 2)
xlabel('\alpha (度)', 'FontSize', 12)
ylabel('dc_D/d\alpha', 'FontSize', 12)
title('c_D(\alpha) 的导数', 'FontSize', 14, 'FontWeight', 'bold')
grid on
xlim([-180 180])
hold on
plot([alpha_bar_val*180/pi, alpha_bar_val*180/pi], ylim, 'b--', 'LineWidth', 1.5)
plot(xlim, [0 0], 'k-', 'LineWidth', 0.5)  % 零线

sgtitle('升力系数和阻力系数及其导数', 'FontSize', 16, 'FontWeight', 'bold')

%% 单独绘制c_L和c_D的对比图（可选）
figure('Position', [100 100 800 600])
plot(alpha_range*180/pi, c_L_values, 'b-', 'LineWidth', 2)
hold on
plot(alpha_range*180/pi, c_D_values, 'r-', 'LineWidth', 2)
xlabel('\alpha (度)', 'FontSize', 12)
ylabel('系数值', 'FontSize', 12)
title('升力系数 c_L 和 阻力系数 c_D 对比', 'FontSize', 14, 'FontWeight', 'bold')
legend('c_L 升力系数', 'c_D 阻力系数', 'Location', 'best')
grid on
xlim([-180 180])
ylim([-2, 2])
hold on
plot([alpha_bar_val*180/pi, alpha_bar_val*180/pi], ylim, 'k--', 'LineWidth', 1.5)
text(alpha_bar_val*180/pi + 5, 1.5, ['失速角 = ' num2str(alpha_bar_val*180/pi) '°'], 'Color', 'k')

%% 输出特定角度下的值
test_angles = [-20:10:20] * pi/180;
fprintf('\n========== 特定角度下的值 ==========\n');
fprintf('角度(度)\tc_L\t\tc_D\t\tdc_L/dα\t\tdc_D/dα\n');
for i = 1:length(test_angles)
    c_L_test = double(subs(c_L_num, alpha, test_angles(i)));
    c_D_test = double(subs(c_D_num, alpha, test_angles(i)));
    dc_L_test = double(subs(dc_L_dalpha_num, alpha, test_angles(i)));
    dc_D_test = double(subs(dc_D_dalpha_num, alpha, test_angles(i)));
    fprintf('%8.1f\t%8.4f\t%8.4f\t%10.6f\t%10.6f\n', ...
        test_angles(i)*180/pi, c_L_test, c_D_test, dc_L_test, dc_D_test);
end

%% 可选：生成LaTeX代码
fprintf('\n========== LaTeX表达式 ==========\n');
latex_cL = latex(c_L);
latex_cD = latex(c_D);
latex_dcL = latex(dc_L_dalpha_simple);
latex_dcD = latex(dc_D_dalpha_simple);

disp('c_L(α):')
disp(latex_cL)
disp('c_D(α):')
disp(latex_cD)
disp('dc_L/dα:')
disp(latex_dcL)
disp('dc_D/dα:')
disp(latex_dcD)

%% 生成可调用的函数句柄
c_L_func = matlabFunction(c_L_num, 'Vars', alpha);
c_D_func = matlabFunction(c_D_num, 'Vars', alpha);
dc_L_func = matlabFunction(dc_L_dalpha_num, 'Vars', alpha);
dc_D_func = matlabFunction(dc_D_dalpha_num, 'Vars', alpha);

% 测试函数
alpha_test = 10 * pi/180;
fprintf('\n========== 函数句柄测试 (α = 10°) ==========\n');
fprintf('c_L(10°) = %f\n', c_L_func(alpha_test));
fprintf('c_D(10°) = %f\n', c_D_func(alpha_test));
fprintf('dc_L/dα(10°) = %f\n', dc_L_func(alpha_test));
fprintf('dc_D/dα(10°) = %f\n', dc_D_func(alpha_test));

%% 保存函数到文件（可选）
% 取消注释下面的行可以保存函数到独立的.m文件
% matlabFunction(c_L_num, 'File', 'c_L_function', 'Vars', alpha);
% matlabFunction(c_D_num, 'File', 'c_D_function', 'Vars', alpha);
% matlabFunction(dc_L_dalpha_num, 'File', 'dc_L_dalpha_function', 'Vars', alpha);
% matlabFunction(dc_D_dalpha_num, 'File', 'dc_D_dalpha_function', 'Vars', alpha);