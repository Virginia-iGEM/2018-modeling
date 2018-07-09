%2018 Virginia iGEM 
%Quorum Sensing 
%Model of Population Activation
%{
Function Module
Input vector "c" is an array of m by 1
Vector "c" contains state information of one cell

%c(1) = Ap
%c(2) = Ai
%c(3) = Ao
%c(4) = B
%c(5) = B|mrna
%c(6) = F
%c(7) = F|mrna
%c(8) = G
%c(9) = G|mrna
%c(10) = K
%c(11) = K|mrna
%c(12) = P
%c(13) = P|mrnaa
%c(14) = R
%c(15) = R|mrna
%c(16) = S
%c(17) = S|mrna
%c(18) = T
%c(19) = T|mrna
%c(20) = Y
%c(21) = Y|mrna

%}

B = 1.225; %Transcription bias towards lsrA-side of lsr

k_AoP = 1;
k_AoB = 1;
k_AiK = 1;
k_AiY = 1;
k_ApF = 1; 
k_ApR = 1;

k_B = 1;    d_B = 1;
k_F = 1;    d_F = 1;
k_G = 1;    d_G = 1;
k_K = 1;    d_K = 1;
k_P = 1;    d_P = 1;
k_R = 1;    d_R = 1;
k_S = 1;    d_S = 1;
k_T = 1;    d_T = 1;
k_Y = 1;    d_Y = 1;

k_B|mrna = 1;d_B|mrna = 1;
k_F|mrna = 1;d_F|mrna = 1;
             d_G|mrna = 1;
k_K|mrna = 1;d_K|mrna = 1;
k_P|mrna = 1;d_P|mrna = 1;
k_R|mrna = 1;d_R|mrna = 1;
k_S|mrna = 1;d_S|mrna = 1;
             d_T|mrna = 1;
k_Y|mrna = 1;d_Y|mrna = 1;

kp_B|mrna = 1;
kp_F|mrna = 1;
kp_G|mrna = 1;
kp_K|mrna = 1;
kp_S|mrna = 1;
kp_T|mrna = 1;
kp_Y|mrna = 1;

r_R
r_T

n_1 = 
n_2 = 

%---------------------------

%{

Function will calculate and output d/dt for each c(i)
 d/dt of c(i) will be determined by state of c
%}

function ["ToDo"] = Function(c)
if ~isvector(c)
    error('Input must be a vector')
end
%insert code for function

end
