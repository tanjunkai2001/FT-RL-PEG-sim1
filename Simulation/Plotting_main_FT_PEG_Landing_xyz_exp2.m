close all

% addpath('../utilization');
% addpath('../Data');
% addpath('../Figures');
addpath('utilization');
addpath('Data');
addpath('Figures');
path_fig = '../Figures';
path_pwd = pwd;
load('Data/data_FT_PEG_Landing_xyz.mat');

RL = load('Data/data_FT_PEG_Landing_xyz_comparisonRL.mat');
FT = load('Data/data_FT_PEG_Landing_xyz_comparisonFT.mat');


% 全局绘图参数设置
MarkerIndices = 1:200:length(t) - 2;
Markersize = 7; % 增大标记大小
fontsize = 16; % 增大字体大小
linewidth = 2; % 统一线宽
figuresize = [100, 100, 500, 400]; % 设置更大的图形窗口

% 设置默认绘图属性
set(0, 'DefaultAxesFontSize', fontsize);
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultTextFontName', 'Times New Roman');
set(0, 'DefaultLineLineWidth', linewidth);

savefig_flag = 1;
tightfig_flag = 0;

% 画图
%% Leader & Follower的Actor & Critic NN自适应参数
figure
cd(path_fig);
set(gcf, 'Position', figuresize); % 设置更大的图形窗口
labelFontSize = 12;

% Define colors for different lines
colors = [0.8500, 0.3250, 0.0980; % Orange-red
          0, 0.4470, 0.7410; % Blue
          0.4940, 0.1840, 0.5560; % Purple
          0.4660, 0.6740, 0.1880; % Green
          0.3010, 0.7450, 0.9330; % Light blue
          0.6350, 0.0780, 0.1840; % Dark red
          0.9290, 0.6940, 0.1250]; % Yellow

Marker = {'o'; 's'; 'd'; 'v'; '^'; '>'; '<'};

% Leader's Critic NN parameters
subplot(2, 1, 1);

for i = 1:size(Wlc, 2)
    plot(t, Wlc(:, i), 'Color', colors(i, :), 'LineWidth', linewidth, ...
        'Marker', Marker{i}, ...
        'MarkerIndices', MarkerIndices, 'MarkerSize', Markersize);
    hold on
end

grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';
ylabel('$\hat{W}_{c,l}$', 'Interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', labelFontSize);
legend({'$\hat{W}_{c,l}(1)$', '$\hat{W}_{c,l}(2)$', '$\hat{W}_{c,l}(3)$'}, ...
    'Interpreter', 'latex', 'Location', 'best', 'FontSize', fontsize - 6, ...
    'Box', 'off', 'Orientation', 'horizontal');

% Follower's Critic NN parameters
subplot(2, 1, 2);

for i = 1:size(Wfc, 2)
    plot(t, Wfc(:, i), 'Color', colors(i, :), 'LineWidth', linewidth, ...
        'Marker', Marker{i}, ...
        'MarkerIndices', MarkerIndices, 'MarkerSize', Markersize);
    hold on
end

grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';
xlabel('Time (s)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
ylabel('$\hat{W}_{c,f}$', 'Interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', labelFontSize);
legend({'$\hat{W}_{c,f}(1)$', '$\hat{W}_{c,f}(2)$', '$\hat{W}_{c,f}(3)$', '$\hat{W}_{c,f}(4)$', '$\hat{W}_{c,f}(5)$', '$\hat{W}_{c,f}(6)$'}, ...
    'Interpreter', 'latex', 'Location', 'best', 'FontSize', fontsize - 6, ...
    'Box', 'off', 'Orientation', 'horizontal', 'NumColumns', 3);

% Apply common settings to both subplots
for i = 1:2
    subplot(2, 1, i)
    xlim([min(t) max(t)]);
    ax = gca;
    ax.XGrid = 'on';
    ax.YGrid = 'on';
end

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
    print(gcf, 'AC_NN_weights_exp2.pdf', '-dpdf');
end

cd(path_pwd);

%% 2d轨迹
figure
cd(path_fig);
set(gcf, 'Position', figuresize);

% Create smooth curves with more points
t_interp = linspace(0, 1, 1000);
xl_smooth = interp1(linspace(0, 1, length(xl)), xl, t_interp, 'spline');
xf_smooth = interp1(linspace(0, 1, length(xf)), xf, t_interp, 'spline');

% Plot trajectories with gradient colors
color_leader = [0.8500, 0.3250, 0.0980]; % Orange-red
color_follower = [0, 0.4470, 0.7410]; % Blue

lineWidth = 2.5;
markerSize = 10;


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

% Enhance axes and labels
xlabel('X-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
ylabel('Y-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);

% Create better looking legend
legend('Leader Trajectory', 'Follower Trajectory', 'Leader Start', 'Follower Start', ...
    'Leader End', 'Follower End', ...
    'Location', 'best', 'FontSize', fontsize - 2, 'Box', 'off');

% Enhanced grid and axis properties
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';
axis equal

% % Set aspect ratio and limits with some padding
% axis equal
% xlim_curr = xlim;
% ylim_curr = ylim;
% xlim([xlim_curr(1) - 0.5, xlim_curr(2) + 0.5]);
% ylim([ylim_curr(1) - 0.5, ylim_curr(2) + 0.5]);

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
    print(gcf, '2d_trajectory_exp2.pdf', '-dpdf');
end

cd(path_pwd);

%% 状态轨迹
figure
cd(path_fig);
set(gcf, 'Position', figuresize); % 设置更大的图形窗口
% Set common style parameters
color_leader = [0.8500, 0.3250, 0.0980]; % Orange-red for leader
color_follower = [0, 0.4470, 0.7410]; % Blue for follower
MarkerIndices = 1:200:length(t); % Add markers for better tracking

% Position subplot (x)
subplot(3, 1, 1)
plot(t, xfd(:, 1), 'Color', color_leader, 'LineWidth', linewidth, ...
    'marker', 'o', 'MarkerIndices', MarkerIndices, 'MarkerSize', 4);
hold on
plot(t, xf(:, 1), '--', 'Color', color_follower, 'LineWidth', linewidth, ...
    'marker', 'o', 'MarkerIndices', MarkerIndices, 'MarkerSize', 4);
grid on; ax = gca;
ax.GridLineStyle = ':'; ax.GridAlpha = 0.3;
ylabel('X-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
legend('Leader', 'Follower', 'Location', 'best', 'FontSize', fontsize - 6, ...
    'Box', 'off', 'Orientation', 'horizontal');

% Position subplot (y)
subplot(3, 1, 2)
plot(t, xfd(:, 2), 'Color', color_leader, 'LineWidth', linewidth, ...
    'marker', 'o', 'MarkerIndices', MarkerIndices, 'MarkerSize', 4);
hold on
plot(t, xf(:, 2), '--', 'Color', color_follower, 'LineWidth', linewidth, ...
    'marker', 'o', 'MarkerIndices', MarkerIndices, 'MarkerSize', 4);
grid on; ax = gca;
ax.GridLineStyle = ':'; ax.GridAlpha = 0.3;
ylabel('Y-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
legend('Leader', 'Follower', 'Location', 'best', 'FontSize', fontsize - 6, ...
    'Box', 'off', 'Orientation', 'horizontal');

% Position subplot (z)
subplot(3, 1, 3)
plot(t, xfd(:, 3), 'Color', color_leader, 'LineWidth', linewidth, ...
    'marker', 'o', 'MarkerIndices', MarkerIndices, 'MarkerSize', 4);
hold on
plot(t, xf(:, 3), '--', 'Color', color_follower, 'LineWidth', linewidth, ...
    'marker', 'o', 'MarkerIndices', MarkerIndices, 'MarkerSize', 4);
grid on; ax = gca;
ax.GridLineStyle = ':'; ax.GridAlpha = 0.3;
xlabel('Time (s)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
ylabel('Z-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
legend('Leader', 'Follower', 'Location', 'best', 'FontSize', fontsize - 6, ...
    'Box', 'off', 'Orientation', 'horizontal');

% Apply common settings to all subplots
for i = 1:3
    subplot(3, 1, i)
    ax = gca;
    ax.LineWidth = 1.2;
    ax.Box = 'on';
    ax.XGrid = 'on';
    ax.YGrid = 'on';
end

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
    print(gcf, 'position_exp2.pdf', '-dpdf');
end

cd(path_pwd);

%% trajectory in 3d
figure
cd(path_fig);
set(gcf, 'Position', figuresize); % 设置更大的图形窗口
% Create smooth curves with more points
t_interp = linspace(0, 1, 1000);
xfd_smooth = interp1(linspace(0, 1, length(xfd)), xfd, t_interp, 'spline');
xf_smooth = interp1(linspace(0, 1, length(xf)), xf, t_interp, 'spline');

% Define colors
color_leader = [0.8500, 0.3250, 0.0980]; % Orange-red
color_follower = [0, 0.4470, 0.7410]; % Blue

% Plot smooth trajectories
plot3(xfd_smooth(:, 1), xfd_smooth(:, 2), xfd_smooth(:, 3), 'Color', color_leader, 'LineWidth', linewidth);
hold on
plot3(xf_smooth(:, 1), xf_smooth(:, 2), xf_smooth(:, 3), '--', 'Color', color_follower, 'LineWidth', linewidth);

% Add start/end markers with enhanced visibility
scatter3(xfd(1, 1), xfd(1, 2), xfd(1, 3), 100, 'o', 'MarkerEdgeColor', color_leader, 'LineWidth', 2);
scatter3(xfd(end, 1), xfd(end, 2), xfd(end, 3), 100, 'x', 'MarkerEdgeColor', color_leader, 'LineWidth', 2);
scatter3(xf(1, 1), xf(1, 2), xf(1, 3), 100, 'o', 'MarkerEdgeColor', color_follower, 'LineWidth', 2);
scatter3(xf(end, 1), xf(end, 2), xf(end, 3), 100, 'x', 'MarkerEdgeColor', color_follower, 'LineWidth', 2);

% Enhance axes and labels
xlabel('X-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
ylabel('Y-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);
zlabel('Z-axis (m)', 'FontWeight', 'bold', 'FontSize', labelFontSize);

% Create better looking legend
legend('Leader Trajectory', 'Follower Trajectory', 'Leader Start', ...
    'Leader End', 'Follower Start', 'Follower End', ...
    'Location', 'north', 'FontSize', fontsize - 4, 'Box', 'off', ...
    'Orientation', 'horizontal', 'NumColumns', 2);

% Enhanced grid and axis properties
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';

% Set viewing angle
% view(-135, 35);

% Set aspect ratio and add some padding to the axes
axis equal
ax.XLim = [min([xfd(:, 1); xf(:, 1)]) - 0.5, max([xfd(:, 1); xf(:, 1)]) + 0.5];
ax.YLim = [min([xfd(:, 2); xf(:, 2)]) - 0.5, max([xfd(:, 2); xf(:, 2)]) + 0.5];
ax.ZLim = [0, max([xfd(:, 3); xf(:, 3)]) + 0.5];

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
    print(gcf, '3d_trajectory_exp2.pdf', '-dpdf');
end

cd(path_pwd);

%% ctrl input
figure
cd(path_fig);
set(gcf, 'Position', figuresize); % 设置更大的图形窗口
% Define colors and plotting parameters
color_x = [0.8500, 0.3250, 0.0980]; % Orange-red
color_y = [0, 0.4470, 0.7410]; % Blue
color_z = [0.4940, 0.1840, 0.5560]; % Purple
MarkerIndices = 1:50:length(U); % Add markers every 50 points

% Leader's control input
subplot(2, 1, 1)
p1 = plot(U(:, end), U(:, 1), '-', 'Color', color_x, 'LineWidth', linewidth);
hold on
p2 = plot(U(:, end), U(:, 2), '-', 'Color', color_y, 'LineWidth', linewidth);
l1 = yline(ulmax, '--k', 'LineWidth', 1.5);
yline(-ulmax, '--k', 'LineWidth', 1.5);

ylim([-1.2 * ulmax, 1.2 * ulmax]);
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';

legend([p1, p2, l1], {'$u_{l,x}$', '$u_{l,y}$', 'Limit'}, ...
    'Interpreter', 'latex', 'FontSize', fontsize - 6, 'Box', 'on', ...
    'Location', 'best', 'Orientation', 'horizontal');
ylabel('Evasion input $\hat{u}_e$', 'Interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', labelFontSize);

% Follower's control input
subplot(2, 1, 2)
p1 = plot(U(:, end), U(:, len_ul + 1), '-', 'Color', color_x, 'LineWidth', linewidth);
hold on
p2 = plot(U(:, end), U(:, len_ul + 2), '-', 'Color', color_y, 'LineWidth', linewidth);
p3 = plot(U(:, end), U(:, len_ul + 3), '-', 'Color', color_z, 'LineWidth', linewidth);
l1 = yline(ufmax, '--k', 'LineWidth', 1.5);
yline(-ufmax, '--k', 'LineWidth', 1.5);

ylim([-1.2 * ufmax, 1.2 * ufmax]);
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
ax.LineWidth = 1.2;
ax.Box = 'on';

legend([p1, p2, p3, l1], {'$u_{f,x}$', '$u_{f,y}$', '$u_{f,z}$', 'Limit'}, ...
    'Interpreter', 'latex', 'FontSize', fontsize - 6, 'Box', 'on', ...
    'Location', 'best', 'Orientation', 'horizontal');
xlabel('Time (s)', 'FontWeight', 'bold');
ylabel('Pursuit input $\hat{u}_p$', 'Interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', labelFontSize);

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
    print(gcf, 'control_exp2.pdf', '-dpdf');
end

cd(path_pwd);
