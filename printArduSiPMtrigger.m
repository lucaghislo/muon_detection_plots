%% CHANGE TO LATEX INTERPRETER

clear; clc;

% This script changes all interpreters from tex to latex. 
list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end


%% PLOT TRIGGER

data = readtable('input/ArduSiPM_trigger/C1coil20may00000.txt')

data = data(:, [1:2]);
data = table2array(data);

f = figure('Visible', 'on')
plot(data(:, 1), data(:, 2), 'LineWidth', 1)

grid on
box on
xlim([-1*10^-7 4*10^-7])
xticklabels([0:50:500])

ylabel('Amplitude [V]')
xlabel('Time [ns]')

ax = gca; 
fontsize = 12;
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 

f.Position = [0 0 800 500]

exportgraphics(gcf,'output/ArduSiPM_trigger.pdf','ContentType','vector');