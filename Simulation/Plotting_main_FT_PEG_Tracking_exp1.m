close all

% cd('../')
addpath('utilization');
addpath('Data');
addpath('Figures');
path_fig = '../Figures/';
% path_fig = 'Figures';
path_pwd = pwd;
% load('Data/data_FT_PEG_Tracking.mat');
load('../Data/data_FT_PEG_Tracking.mat');

% 全局绘图参数设置
MarkerIndices = 1:100:length(t) - 2;
Markersize = 7; % 增大标记大小
fontsize = 16; % 增大字体大小
linewidth = 2; % 统一线宽
figuresize = [100, 100, 500, 400]; % 设置更大的图形窗口

% 设置默认绘图属性
set(0, 'DefaultAxesFontSize', fontsize);
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultTextFontName', 'Times New Roman');
set(0, 'DefaultLineLineWidth', linewidth);

savefig_flag = 0;
tightfig_flag = 0;

% 画图
%% Leader & Follower的Actor & Critic NN自适应参数
figure
cd(path_fig);
set(gcf, 'Position', figuresize); % 设置更大的图形窗口
% 设置统一的图形属性
lineWidth = 2;
fontSize = 12;
legendFontSize = 10;
labelFontSize = 12;
colors = [0.8500, 0.3250, 0.0980; % Orange-red
          0, 0.4470, 0.7410; % Blue
          0.4940, 0.1840, 0.5560; % Purple
          0.4660, 0.6740, 0.1880; % Green
          0.3010, 0.7450, 0.9330; % Light blue
          0.6350, 0.0780, 0.1840; % Dark red
          0.9290, 0.6940, 0.1250]; % Yellow

Marker = {'o'; 's'; 'd'; 'v'; '^'; '>'; '<'};

% 子图1，leader的Critic NN自适应参数
subplot(2, 1, 1);
h1 = plot(t, Wlc, 'LineWidth', lineWidth);

for i = 1:length(h1)
    set(h1(i), 'Color', colors(i, :), ...
        'Marker', Marker{i}, 'MarkerIndices', MarkerIndices, 'MarkerSize', Markersize);
end

% Enhanced grid and axis properties
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';
xlim([0, t(end)]);
ylabel('$\hat{W}_{c,l}$', 'interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', labelFontSize);
legend('$\hat{W}_{c,l}(1)$', '$\hat{W}_{c,l}(2)$', '$\hat{W}_{c,l}(3)$', 'interpreter', 'latex', ...
    'Location', 'best', 'FontSize', legendFontSize, 'Box', 'off', 'Orientation', 'horizontal');

% 子图2，follower的Critic NN自适应参数
subplot(2, 1, 2);
h3 = plot(t, Wfc, 'LineWidth', lineWidth);

for i = 1:length(h3)
    set(h3(i), 'Color', colors(i, :), ...
        'Marker', Marker{i}, 'MarkerIndices', MarkerIndices, 'MarkerSize', Markersize);
end

% Enhanced grid and axis properties
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';
xlim([0, t(end)]);
xlabel('Time (s)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
ylabel('$\hat{W}_{c,f}$', 'interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', labelFontSize);
legend('$\hat{W}_{c,f}(1)$', '$\hat{W}_{c,f}(2)$', '$\hat{W}_{c,f}(3)$', 'interpreter', 'latex', ...
    'Location', 'best', 'FontSize', legendFontSize, ...
    'Orientation', 'horizontal', 'numcolumns', 3, 'Box', 'off');

% 调整子图间距
set(gcf, 'Color', 'white');

if tightfig_flag
    tightfig;
end

% 获取当前图窗大小
fig = gcf;
fig.Units = 'inches';
figPosition = fig.Position;
width = figPosition(3);
height = figPosition(4);

% 设置保存选项
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0 0 width height]);
set(gcf, 'PaperSize', [width height]);

% 保存为 PDF 文件

cd(path_fig)

if savefig_flag == 1
    print(gcf, 'AC_NN_weights_exp1.pdf', '-dpdf');
end

cd(path_pwd);

%% 2d轨迹
figure
cd(path_fig);
set(gcf, 'Position', figuresize); % 设置更大的图形窗口
% Set plotting parameters
lineWidth = 2.5;
markerSize = 10;
fontSize = 16;

% Plot trajectories and markers
h1 = plot(xl(:, 1), xl(:, 2), 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', lineWidth);
hold on
h2 = plot(xl(1, 1), xl(1, 2), 'o', 'MarkerFaceColor', 'none', 'MarkerEdgeColor', [0.8500, 0.3250, 0.0980], ...
    'MarkerSize', markerSize, 'LineWidth', lineWidth);
h3 = plot(xl(end, 1), xl(end, 2), 'x', 'MarkerFaceColor', 'none', 'MarkerEdgeColor', [0.8500, 0.3250, 0.0980], ...
    'MarkerSize', markerSize, 'LineWidth', lineWidth);

h4 = plot(xf(:, 1), xf(:, 2), '--', 'Color', [0, 0.4470, 0.7410], 'LineWidth', lineWidth);
h5 = plot(xf(1, 1), xf(1, 2), 'o', 'MarkerFaceColor', 'none', 'MarkerEdgeColor', [0, 0.4470, 0.7410], ...
    'MarkerSize', markerSize, 'LineWidth', lineWidth);
h6 = plot(xf(end, 1), xf(end, 2), 'x', 'MarkerFaceColor', 'none', 'MarkerEdgeColor', [0, 0.4470, 0.7410], ...
    'MarkerSize', markerSize, 'LineWidth', lineWidth);

% Enhanced grid and axis properties
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';
axis equal

% Labels and title
xlabel('X-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
ylabel('Y-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);

% Legend
legend([h1, h2, h3, h4, h5, h6], ...
    {'Leader Trajectory', 'Leader Start', 'Leader End', ...
     'Follower Trajectory', 'Follower Start', 'Follower End'}, ...
    'Location', 'best', 'FontSize', fontSize - 2, 'Box', 'off', ...
    'Orientation', 'horizontal', 'NumColumns', 1);

% Set background color to white
set(gcf, 'Color', 'white');

if tightfig_flag
    tightfig;
end

% 获取当前图窗大小
fig = gcf;
fig.Units = 'inches';
figPosition = fig.Position;
width = figPosition(3);
height = figPosition(4);

% 设置保存选项
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0 0 width height]);
set(gcf, 'PaperSize', [width height]);

% 保存为 PDF 文件

cd(path_fig)

if savefig_flag == 1
    print(gcf, '2d_trajectory_exp1.pdf', '-dpdf');
end

cd(path_pwd);

%% 状态轨迹
figure
cd(path_fig);
set(gcf, 'Position', figuresize);
% Common plotting parameters
lineWidth = 2;
fontSize = 12;
legendFontSize = 10;
MarkerIndices = 1:100:length(t); % Add markers for better tracking

% First subplot - X position
subplot(2, 1, 1)

h1 = plot(t, xfd(:, 1), 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', lineWidth, ...
    'marker', 'o', 'MarkerIndices', MarkerIndices, 'MarkerSize', 4);
hold on
h2 = plot(t, xf(:, 1), '--', 'Color', [0, 0.4470, 0.7410], 'LineWidth', lineWidth, ...
    'marker', 'o', 'MarkerIndices', MarkerIndices, 'MarkerSize', 4);

% Enhanced grid and axis properties
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';
xlim([0, t(end)]);
ylim([-0.2, 2.8]);
ylabel('X-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
legend([h1, h2], {'Leader', 'Follower'}, ...
    'Location', 'best', 'FontSize', legendFontSize, ...
    'Box', 'off', 'NumColumns', 2);

% Second subplot - Y position
subplot(2, 1, 2)

h1 = plot(t, xfd(:, 2), 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', lineWidth, ...
    'marker', 'o', 'MarkerIndices', MarkerIndices, 'MarkerSize', 4);
hold on
h2 = plot(t, xf(:, 2), '--', 'Color', [0, 0.4470, 0.7410], 'LineWidth', lineWidth, ...
    'marker', 'o', 'MarkerIndices', MarkerIndices, 'MarkerSize', 4);

% Enhanced grid and axis properties
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';
xlim([0, t(end)]);
ylim([-0.2, 4]);
xlabel('Time (s)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
ylabel('Y-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
legend([h1, h2], {'Leader', 'Follower'}, ...
    'Location', 'best', 'FontSize', legendFontSize, ...
    'Box', 'off', 'NumColumns', 2);

% Set background color to white
set(gcf, 'Color', 'white');

if tightfig_flag
    tightfig;
end

% 获取当前图窗大小
fig = gcf;
fig.Units = 'inches';
figPosition = fig.Position;
width = figPosition(3);
height = figPosition(4);

% 设置保存选项
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0 0 width height]);
set(gcf, 'PaperSize', [width height]);

% 保存为 PDF 文件

cd(path_fig)

if savefig_flag == 1
    print(gcf, 'position_exp1.pdf', '-dpdf');
end

cd(path_pwd);

%% ctrl input
figure
cd(path_fig);
set(gcf, 'Position', figuresize); % 设置更大的图形窗口
% Common plotting parameters
lineWidth = 2;
fontSize = 12;
legendFontSize = 10;

% Leader control inputs
subplot(2, 1, 1)
h1 = plot(U(:, end), U(:, 1:len_ul), 'LineWidth', lineWidth);
hold on
h2 = yline(ulmax, '--k', 'LineWidth', lineWidth);
yline(-ulmax, '--k', 'LineWidth', lineWidth);

% Enhanced grid and axis properties
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';
ylim([-1.2 * ulmax, 1.2 * ulmax]);
xlim([0, U(end, end)]);

ylabel('Evasion input $\hat{u}_e$', 'Interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', labelFontSize);
legend([h1; h2], {'$u_{l,x}$', '$u_{l,y}$', 'Limit'}, ...
    'Interpreter', 'latex', 'Location', 'best', 'FontSize', legendFontSize, ...
    'Box', 'on', 'NumColumns', 3);

% Follower control inputs
subplot(2, 1, 2)
h3 = plot(U(:, end), U(:, len_ul + 1:len_ul + len_uf), 'LineWidth', lineWidth);
hold on
h4 = yline(ufmax, '--k', 'LineWidth', lineWidth);
yline(-ufmax, '--k', 'LineWidth', lineWidth);

% Enhanced grid and axis properties
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';
ylim([-1.2 * ufmax, 1.2 * ufmax]);
xlim([0, U(end, end)]);

xlabel('Time (s)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
ylabel('Pursuit input $\hat{u}_p$', 'Interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', labelFontSize);
legend([h3; h4], {'$u_{f,x}$', '$u_{f,y}$', 'Limit'}, ...
    'Interpreter', 'latex', 'Location', 'best', 'FontSize', legendFontSize, ...
    'Box', 'on', 'NumColumns', 4);

% Set background color to white
set(gcf, 'Color', 'white');

if tightfig_flag
    tightfig;
end

% 获取当前图窗大小
fig = gcf;
fig.Units = 'inches';
figPosition = fig.Position;
width = figPosition(3);
height = figPosition(4);

% 设置保存选项
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0 0 width height]);
set(gcf, 'PaperSize', [width height]);

% 保存为 PDF 文件

cd(path_fig)

if savefig_flag == 1
    print(gcf, 'control_exp1.pdf', '-dpdf');
end

cd(path_pwd);
