%% CONVERSIONE TEMPERATURA

data = readtable('input/HK_test_10082022_man/temp_40C_250V_0.dat');

mead_temp_ADC = round(mean(data.Value));

V_T = 0.9 * 1000 - (mead_temp_ADC - 1024) * 1.72 / (3.87);
T = 30 + (5.506 - sqrt((-5.506) ^ 2 + 4 * 0.00176 * (870.6 - V_T))) / (2 * (-0.00176))