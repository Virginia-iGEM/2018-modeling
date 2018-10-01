%2018 Virginia iGEM 
%Quorum Sensing 
%Model of Population Activation

function [ddt] = Cellular_Function(c)

%{
Function Module
Input vector "c" is an array of m by 1
Vector "c" contains state information of one cell

%c(1) = x
%c(2) = y
%c(3) = Ap 
%c(4) = Ai
%c(5) = Ao
%c(6) = B %LsrACDB
%c(7) = B|mrna ALL BELOW OUT FOR TESTING
%c(8) = F %LsrF
%c(9) = F|mrna
%c(10) = G %sfGFP
%c(11) = G|mrna
%c(12) = K %LsrK
%c(13) = K|mrna
%c(14) = P %PTS
%c(15) = P|mrna
%c(16) = R %LsrR
%c(17) = R|mrna
%c(18) = T %T7
%c(19) = T|mrna
%c(20) = X_g %LuxS from genome
%c(21) = X_p %LuxS from plasmid
%c(22) = X_p|mrna 
%c(23) = Y_g %YdgG from genome
%c(24) = Y_p %YdgG from plasmid
%c(25) = Y_p|mrna
%}

%Rates of Reactions/Transport
k_AoP = 0.0001;
k_AoB = 0.0005;
k_cat_AiK = 456;
k_M_AiK = 1000;
k_AiY = 0.0001*10000;
k_ApF = 0.019825; 
k_ApR = 0.05;
k_XS = (1.2e-4)/1000;

%Translation Coefficients
k_B = 0.48;    d_B = 0.02;
k_F = 2.4657;    d_F = 0.02;
k_G = 3.02521;    d_G = 0.02;
k_K = 1.35849;    d_K = 0.02;
k_P = 1;    d_P = 0.02; %PTS Levels are considered constant in our model; this isn't used
k_R = 2.26415;    d_R = 0.02;
k_T = 0.813559;    d_T = 0.02;
k_X = 4.186;    d_X = 0.02;
k_Y = 2.0869565;    d_Y = 0.02;

%These have relationships between each other that have not been considered with the 1's
%Transcription and degradation of mRNAs (from natural plasmid)
k_B_mrna = 0.5497;               d_B_mrna = 0.4; 
k_F_mrna = 0.46154;               d_F_mrna = 0.4;
                            d_G_mrna = 0.4;
k_K_mrna = 0.9906;               d_K_mrna = 0.4;
k_P_mrna = 1;               d_P_mrna = 0.4;
k_R_mrna = 2.6415;               d_R_mrna = 0.4;
                            d_T_mrna = 0.4;
k_X_mrna = 4.8837;               d_X_mrna = 0.4;
k_Y_mrna = 2.4348;               d_Y_mrna = 0.4;

%Synthetic plasmid parameters for Transcription
kp_B_mrna = 0.573;
kp_F_mrna = 2.95;
kp_G_mrna = 3.61;
kp_K_mrna = 1.62;
kp_T_mrna = 0.27119;
kp_X_mrna = 5.00;
kp_Y_mrna = 2.49;

%Regulation Coefficients
r_R_B = 0.2;
r_R_R = 0.05;
r_T = 100;

%Number of Plasmids (1 = LsrR + T7, 2 = All other genes)
n_1 = 1;
n_2 = 1;

%---------------------------

%{
Function will calculate and output d/dt for each c(i)
 d/dt of c(i) will be determined by state of c and differential equations
 relating how the species concentrations affect each other
%}

if ~isvector(c)
    error('Input must be a vector')
end
ddt = zeros(25,1);
ddt(3,1) = c(12)*c(4)*k_cat_AiK/(k_M_AiK+c(4)) - k_ApR*c(16)*c(3) - k_ApF*c(8)*c(3);
ddt(5,1) = k_AiY*(c(23)+c(24))*c(4) - k_AoP*c(14)*c(5) - k_AoB*c(6)*c(5);
ddt(4,1) = k_XS*(c(20)+c(21)) - c(12)*c(4)*k_cat_AiK/(k_M_AiK+c(4)) - ddt(5,1);
ddt(6,1) = k_B*c(7) - d_B*c(6);
ddt(7,1) = k_B_mrna*(r_R_B^4/(r_R_B^4 + c(16)^4)) - c(7)*d_B_mrna ;%+ n_2*kp_B_mrna*(c(18)/(r_T+c(18)));
ddt(8,1) = k_F*c(9) - d_F*c(8);
ddt(9,1) = k_F_mrna*(r_R_B^4/(r_R_B^4 + c(16)^4)) - c(9)*d_F_mrna ;%+ n_2*kp_F_mrna*(c(18)/(r_T+c(18)))
ddt(10,1) = k_G*c(11) - d_G*c(10);
ddt(11,1) =  - c(11)*d_G_mrna + n_2*kp_G_mrna*(c(18)/(r_T+c(18)));
ddt(12,1) = k_K*c(13) - d_K*c(12);
ddt(13,1) = k_K_mrna*(r_R_R^4/(r_R_R^4 + c(16)^4)) - c(13)*d_K_mrna ;%+ n_2*kp_K_mrna*(c(18)/(r_T+c(18)));
ddt(14,1) = 0 ;%+ k_P*c(15) - d_P*c(14);
ddt(15,1) = 0 ;%+ k_P_mrna*(r_R^4/(r_R^4 + c(16)^4)) - c(15)*d_P_mrna + n_2*kp_P_mrna*(c(18)/(r_T+c(18)));
ddt(16,1) = k_R*c(17) - d_R*c(16) - k_ApR*c(16)*c(3);
ddt(17,1) = (n_1+1)*k_R_mrna*(r_R_R^4/(r_R_R^4 + c(16)^4)) - c(17)*d_R_mrna;
ddt(18,1) = k_T*c(19) - d_T*c(18);
ddt(19,1) = (n_1)*kp_T_mrna*(r_R_B^2/(r_R_B^2 + c(16)^2)) - c(19)*d_T_mrna;
ddt(20,1) = 0;
ddt(21,1) = k_X*c(22) - d_X*c(21);
ddt(22,1) =  - c(22)*d_X_mrna ;%+ n_2*kp_X_mrna*(c(18)/(r_T+c(18)));
ddt(23,1) = 0;
ddt(24,1) = k_Y*c(25) - d_Y*c(24);
ddt(25,1) =  - c(25)*d_Y_mrna ;%+ n_2*kp_Y_mrna*(c(18)/(r_T+c(18)));
end
