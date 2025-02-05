close all
clear all
clc

cd('../')
addpath('utilization');
addpath('Data');

rng(1);

%% ADP参数
global Al Bl Af Bf dWlc_ dWla_ dWfc_  dWfa_ N temp len_Wl len_Wf len_xl len_xf len_ul len_uf U ulmax ufmax
Al = zeros(2); Bl = eye(2);
Af = zeros(3); Bf = eye(3);

[len_ul, len_xl] = size(Bl);
[len_uf, len_xf] = size(Bf);
len_t = 25;
len_Wl = 3;
len_Wf = 7;

N = 20;
dWlc_ = zeros(len_Wl, N);
dWla_ = zeros(len_Wl, N);
dWfc_ = zeros(len_Wf, N);
dWfa_ = zeros(len_Wf, N);
temp = 1;
U = [];
ulmax = 0.75;
ufmax = 1.0;


%% 初始化
% xf0 = 1 * ones(len_xf, 1);
xl0 = [2; 3];
xf0 = [3; 2; 1];
Wl0 = rand(len_Wl*2, 1) + 0.1;
% Wl0 = 0.1 * ones(len_Wl, 1);
Wf0 = rand(len_Wf*2, 1) + 0.5;

X0 = [xl0; xf0; Wl0; Wf0];

T = 0.01;
tspan = 0:T:len_t;

%% ode simulation
[t, X] = ode45(@origin_sys, tspan, X0);

% data extraction
xl = X(:, 1:len_xl);
xf = X(:, len_xl + 1:len_xl + len_xf);
Wla = X(:, len_xl + len_xf + 1:len_xl + len_xf + len_Wl);
Wlc = X(:, len_xl + len_xf + len_Wl + 1:len_xl + len_xf + len_Wl * 2);
Wfa = X(:, len_xl + len_xf + len_Wl * 2 + 1:len_xl + len_xf + len_Wl * 2 + len_Wf);
Wfc = X(:, len_xl + len_xf + len_Wl * 2 + len_Wf + 1: len_xl + len_xf + len_Wl * 2 + len_Wf * 2);
% [xfd, dxfd] = ref_sincos_xyz(t);
[xfd, dxfd] = ref_circle_xyz(t);
xfd = xfd'; % dxfd = dxfd';
xfd = [xl, zeros(length(xl), 1)];


save('Data/data_FT_PEG_Landing_xyz.mat');
% save('Data/data_FT_PEG_Landing_xyz_comparisonFT.mat');
% save('Data/data_FT_PEG_Landing_xyz_comparisonRL.mat');

%% Plot
% Plotting_figure
% Plotting_figure_AC

%% ODE
function dX = origin_sys(t, X)
    global Al Bl Af Bf dWlc_ dWla_ dWfc_  dWfa_ N temp len_Wl len_Wf len_xl len_xf len_ul len_uf U ulmax ufmax
    global alpha_l alpha_h
    global num_obs len_z ro ra rd L1 L2 L3 id_obs

    % data extraction
    xl = X(1:len_xl);
    xf = X(len_xl + 1:len_xl + len_xf);
    Wla = X(len_xl + len_xf + 1:len_xl + len_xf + len_Wl);
    Wlc = X(len_xl + len_xf + len_Wl + 1:len_xl + len_xf + len_Wl * 2);
    Wfa = X(len_xl + len_xf + len_Wl * 2 + 1:len_xl + len_xf + len_Wl * 2 + len_Wf);
    Wfc = X(len_xl + len_xf + len_Wl * 2 + len_Wf + 1: len_xl + len_xf + len_Wl * 2 + len_Wf * 2);

    xfd = [xl; 0];
    e = xf - xfd;
    

    % ADP controller design
    Ql = 1 * eye(len_xl);
    Rl = 100 * eye(len_ul)*2;

    Qf = 1 * eye(len_xf);
    Rf = 50 * eye(len_uf)*2;

    % [sigmal, dsigmal] = basis_StaFNN_modified(e(1:2)); % State-following NN basis
    % [sigmaf, dsigmaf] = basis_Kron6NN_xyz(e); % State-following NN basis

    alpha = 0.8;
    % alpha = 1;
    [dsigmal] = Grad_Sigma_V_FT_XY_3NN(e(1:2), alpha); % State-following NN basis
    [dsigmaf] = Grad_Sigma_V_FT_XYZ_7NN(e, alpha); % State-following NN basis

    ul = ulmax * tanh(0.5 / ulmax * Rl \ Bl' * dsigmal' * Wla);
    uf = -ufmax * tanh(0.5 / ufmax * Rf \ Bf' * dsigmaf' * Wfa);
    U = [U; [ul', uf', t]];

    % ode
    de = Af * e + Bf * uf;
    dxl = Al * xl + Bl * ul;
    dxfd = [dxl; 0];
    dxf = de + dxfd;

    % ADP update weights
    omegal = dsigmal * de(1:2);
    omegaf = dsigmaf * de;
    deltal = Wlc' * omegal - e(1:2)' * Ql * e(1:2) + ul' * Rl * ul - uf' * Rf * uf;
    deltaf = Wfc' * omegaf + e' * Qf * e + uf' * Rf * uf - ul' * Rl * ul;
    alpha = 1;
    dWlc_currnent =- 0.1 * omegal * deltal / (omegal' * omegal + 1) ^ (1+alpha);
    dWfc_currnent =- 0.1 * omegaf * deltaf / (omegaf' * omegaf + 1) ^ (1+alpha);
    % dWlc_currnent =- 0.1 * omegal * deltal / (omegal' * omegal + 1) ^ 2;
    % dWfc_currnent =- 0.1 * omegaf * deltaf / (omegaf' * omegaf + 1) ^ 2;
    dWlc_(:, temp) = dWlc_currnent;
    % dWla_(:, temp) = dWla_currnent;
    dWfc_(:, temp) = dWfc_currnent;
    % dWfa_(:, temp) = dWfa_currnent;
    temp = mod(temp, N) + 1;
    dWlc = sum(dWlc_, 2);
    dWfc = sum(dWfc_, 2);
    [gammala, dgammala] = func_gamma(Wla, 3, -3);
    [gammafa, dgammafa] = func_gamma(Wfa, 5, -5);
    kla = 1;
    kfa = 1;
    if (Wla - Wlc)' * dgammala > 0
        projla = 0;
    else
        projla = kla*dgammala*dgammala'/(dgammala'*kla*dgammala)*kla;
    end
    if (Wfa - Wfc)' * dgammafa > 0
        projfa = 0;
    else
        projfa = kfa*dgammafa*dgammafa'/(dgammafa'*kfa*dgammafa)*kfa;
        projfa = 0;
    end
    dWla = - (1 - projla) * (Wla - Wlc);
    dWfa = - (1 - projfa) * (Wfa - Wfc);
    dWl = [dWla; dWlc];
    dWf = [dWfa; dWfc];

    % output
    dX = [dxl; dxf; dWl; dWf];
end
