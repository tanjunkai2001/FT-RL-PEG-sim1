function [gamma,dgamma] = func_gamma(wa, w_upper, w_lower)
    len = length(wa);
    gamma = zeros(len, 1);
    for i = 1:len
        gamma(i) = (wa(i) - w_lower)*(wa(i) - w_upper);
    end
    dgamma = 2*wa - w_upper - w_lower;
end
