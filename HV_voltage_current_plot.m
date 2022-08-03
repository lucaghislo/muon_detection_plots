%% LEAKAGE CURRENT PLOT

clear; clc;

fontsize = 12;

list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end

%% MODULO A TEMPERATURA AMBIENTE

data = readtable('input/HV_voltage_current_Tamb.dat');

f = figure('Visible', 'on');
scatter(data.voltage, data.current, '')

box on
grid on
xlabel('Bias voltage [V]')
ylabel('Leakage Current [$\mu$A]')

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
exportgraphics(gcf, 'output/HK_current_Tamb.pdf', 'ContentType', 'vector');