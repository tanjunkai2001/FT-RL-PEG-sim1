close all
clear all
clc
cd('../')
addpath('utilization');
addpath('Data');
addpath('Simulation');

rng(1); % random seed

%% ADP参数
% global Al Bl Af Bf
global dWlc_ dWla_ dWfc_  dWfa_ N temp len_Wl len_Wf len_xl len_xf len_ul len_uf U ulmax ufmax
Al = zeros(2); Bl = eye(2);
Af = zeros(2); Bf = eye(2);

[len_ul, len_xl] = size(Bl);
[len_uf, len_xf] = size(Bf);
len_t = 10;
len_Wl = 3;
len_Wf = 3;

N = 20;
dWlc_ = zeros(len_Wl, N);
dWla_ = zeros(len_Wl, N);
dWfc_ = zeros(len_Wf, N);
dWfa_ = zeros(len_Wf, N);
temp = 1;
U = [];
ulmax = 0.5;
ufmax = 0.5;


%% 初始化
% xf0 = 1 * ones(len_xf, 1);
xl0 = [2; 3];
xf0 = [2.5; 2.5];
Wl0 = rand(len_Wl*2, 1) + 0.5;
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

xfd = [xl];

% save('Data/data_FT_PEG_Tracking.mat');


%% Plot
% Plotting_main_FT_PEG_Tracking_exp1
% Plotting_figure_AC

%% ODE
function dX = origin_sys(t, X)
    % global Al Bl Af Bf 
    global dWlc_ dWla_ dWfc_  dWfa_ N temp len_Wl len_Wf len_xl len_xf len_ul len_uf U ulmax ufmax
    global alpha_l alpha_h
    global num_obs len_z ro ra rd L1 L2 L3 id_obs

    % data extraction
    xl = X(1:len_xl);
    xf = X(len_xl + 1:len_xl + len_xf);
    Wla = X(len_xl + len_xf + 1:len_xl + len_xf + len_Wl);
    Wlc = X(len_xl + len_xf + len_Wl + 1:len_xl + len_xf + len_Wl * 2);
    Wfa = X(len_xl + len_xf + len_Wl * 2 + 1:len_xl + len_xf + len_Wl * 2 + len_Wf);
    Wfc = X(len_xl + len_xf + len_Wl * 2 + len_Wf + 1: len_xl + len_xf + len_Wl * 2 + len_Wf * 2);

    xfd = [xl];
    e = xf - xfd;

    t


    Al = [-xl(1)+xl(2); -0.5*xl(1)-0.5*xl(2)*(1-(cos(2*xl(1)+1))^2)];
    Bl = diag([sin(2*xl(1)+1)+2, cos(2*xl(1))+2]);
    Af = [-xf(1)+xf(2); -0.5*xf(1)-0.5*xf(2)*(1-(cos(2*xf(1)+1))^2)];
    Bf = diag([sin(2*xf(1)+1)+2, cos(2*xf(1))+2]);


    % ADP controller design
    Ql = 2 * eye(len_xl);
    Rl = 20 * eye(len_ul);

    Qf = 1 * eye(len_xf);
    Rf = 20 * eye(len_uf);

    % [sigmal, dsigmal] = basis_StaFNN_modified(e(1:2)); % State-following NN basis
    % [sigmaf, dsigmaf] = basis_Kron6NN(e); % State-following NN basis

    alpha = 0.8;
    [dsigmal] = Grad_Sigma_V_FT_XY_3NN(e(1:2), alpha); % Finite-time NN basis for pursuer
    [dsigmaf] = Grad_Sigma_V_FT_XY_3NN(e(1:2), alpha); % Finite-time NN basis for evader

    ul = ulmax * tanh(0.5 / ulmax * Rl \ Bl' * dsigmal' * Wla);
    uf = -ufmax * tanh(0.5 / ufmax * Rf \ Bf' * dsigmaf' * Wfa);
    U = [U; [ul', uf', t]];

    % ode
    % de = Af * e + Bf * uf;
    de = Af - Al + Bf*uf;
    % dxl = Al * xl + Bl * ul;
    dxl = Al + Bl * ul;
    dxfd = [dxl];
    dxf = de + dxfd;

    % ADP update weights
    omegal = dsigmal * de;
    omegaf = dsigmaf * de;
    deltal = Wlc' * omegal - e' * Ql * e + ul' * Rl * ul - uf' * Rf * uf;
    deltaf = Wfc' * omegaf + e' * Qf * e + uf' * Rf * uf - ul' * Rl * ul;
    dWlc_currnent =- 1 * omegal * deltal / (omegal' * omegal + 1) ^ 2;
    dWfc_currnent =- 1 * omegaf * deltaf / (omegaf' * omegaf + 1) ^ 2;
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
    dWla = - (1 - projla) * abs(Wla - Wlc).^alpha.*sign(Wla - Wlc);
    dWfa = - (2 - projfa) * abs(Wfa - Wfc).^alpha.*sign(Wfa - Wfc);
    dWl = [dWla; dWlc];
    dWf = [dWfa; dWfc];

    % output
    dX = [dxl; dxf; dWl; dWf];
end
