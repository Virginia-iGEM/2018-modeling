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
%c(3) = Ap OUT FOR TESTING (SHIFT EVRERYTHING UP)
%c(4) = Ai
%c(5) = Ao
%c(6) = B
%c(7) = B|mrna ALL BELOW OUT FOR TESTING
%c(8) = F 
%c(9) = F|mrna
%c(10) = G
%c(11) = G|mrna
%c(12) = K
%c(13) = K|mrna
%c(14) = P
%c(15) = P|mrna
%c(16) = R
%c(17) = R|mrna
%c(18) = T
%c(19) = T|mrna
%c(20) = X
%c(21) = X|mrna
%c(22) = Y
%c(23) = Y|mrna
%}

%Rates of Reactions/Transport
k_AoP = 1;
k_AoB = 1;
k_AiK = 1;
k_AiY = 1;
k_ApF = 1; 
k_ApR = 1;
k_XS = 1;

%Transcription Coefficients
k_B = 1;    d_B = 10^-5;
k_F = 1;    d_F = 10^-5;
k_G = 1;    d_G = 10^-5;
k_K = 1;    d_K = 10^-5;
k_P = 1;    d_P = 10^-5;
k_R = 1;    d_R = 10^-5;
k_T = 1;    d_T = 10^-5;
k_X = 1;    d_X = 10^-5;
k_Y = 1;    d_Y = 10^-5;


%Relationships between transcription constants
b_RK = 1;
b_BF = 1;
%Transcription bias towards lsrA-side of lsr
B = 1.225; 


%These have relationships between each other that have not been considered with the 1's
%Translation and degradation of mRNAs (from natural plasmid)
k_B_mrna = 1;               d_B_mrna = 10^-5; 
k_F_mrna = b_BF*k_B_mrna;   d_F_mrna = 10^-5;
                            d_G_mrna = 10^-5;
k_K_mrna = b_RK*k_B_mrna/B; d_K_mrna = 10^-5;
k_P_mrna = 1;               d_P_mrna = 10^-5;
k_R_mrna = k_B_mrna/B;      d_R_mrna = 10^-5;
                            d_T_mrna = 10^-5;
k_X_mrna = 1;               d_X_mrna = 10^-5;
k_Y_mrna = 1;               d_Y_mrna = 10^-5;

%Synthetic plasmid parameters for Transcription
kp_B_mrna = 1;
kp_F_mrna = 1;
kp_G_mrna = 1;
kp_K_mrna = 1;
kp_T_mrna = k_B_mrna;
kp_X_mrna = 1;
kp_Y_mrna = 1;

%Regulation Coefficients
r_R = 1;
r_T = 1;

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
ddt = zeros(23,1);
ddt(3,1) = k_AiK*c(12)*c(4) - k_ApR*c(16)*c(3) - k_ApF*c(8)*c(3); %tends to go off to negative infinity
ddt(5,1) = k_AiY*c(22)*c(4) - k_AoP*c(14)*c(5) - k_AoB*c(6)*c(5);
ddt(4,1) = k_XS*c(20) - k_AiK*c(12)*c(4) - ddt(5,1);
ddt(6,1) = k_B*c(7) - d_B*c(6);
ddt(7,1) = k_B_mrna*(r_R^4/(r_R^4 + c(16)^4)) - c(7)*d_B_mrna + n_2*kp_B_mrna*(c(18)/(r_T+c(18)));
ddt(8,1) = k_F*c(9) - d_F*c(8);
ddt(9,1) = k_F_mrna*(r_R^4/(r_R^4 + c(16)^4)) - c(9)*d_F_mrna; %If changing LsrFG in system: + n_2*kp_F_mrna*(c(18)/(r_T+c(18)))
ddt(10,1) = k_G*c(11) - d_G*c(10);
ddt(11,1) = n_2*kp_G_mrna*(c(18)/(r_T+c(18))) - c(11)*d_G_mrna;
ddt(12,1) = k_K*c(13) - d_K*c(12);
ddt(13,1) = k_K_mrna*(r_R^4/(r_R^4 + c(16)^4)) - c(13)*d_K_mrna + n_2*kp_K_mrna*(c(18)/(r_T+c(18)));
ddt(14,1) = 0; %If changing PTS levels: k_P*c(15) - d_P*c(14);
ddt(15,1) = 0; %If changing PTS mRNA levela: k_P_mrna*(r_R^4/(r_R^4 + c(16)^4)) - c(15)*d_P_mrna + n_2*kp_P_mrna*(c(18)/(r_T+c(18)));
ddt(16,1) = 0*(k_R*c(17) - d_R*c(16) - k_ApR*c(16)*c(3)); %also tends to go to inf
ddt(17,1) = (n_1+1)*k_R_mrna*(r_R^4/(r_R^4 + c(16)^4)) - c(17)*d_R_mrna;
ddt(18,1) = k_T*c(19) - d_T*c(18);
ddt(19,1) = (n_1)*kp_T_mrna*(r_R^2/(r_R^2 + c(16)^2)) - c(19)*d_T_mrna;
ddt(20,1) = k_X*c(21) - d_X*c(20);
ddt(21,1) = n_2*kp_X_mrna*(c(18)/(r_T+c(18))) - c(21)*d_X_mrna;
ddt(22,1) = k_Y*c(23) - d_Y*c(22);
ddt(23,1) = n_2*kp_Y_mrna*(c(18)/(r_T+c(18))) - c(23)*d_Y_mrna;
%{
if ~isnan(ddt(3,1)) && ~isinf(ddt(3,1))
    ddt
end
%}
end
