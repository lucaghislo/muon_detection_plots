%% FDT PLOT

clear; clc;

fontsize = 12;

% This script changes all interpreters from tex to latex. 
list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end


%% PLOT

f = figure('Visible', 'on');
h = histogram(data.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1);

set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2000])
xlabel('Energy [ADC]')
ylabel('Counts')

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/incoming_energy_single.pdf','ContentType','vector');


%% PROFILE W/ COMPARISON

data_MIT_NA = readtable('input/muons/muons_NA_MIT.txt');
colors = distinguishable_colors(3, 'w');

f = figure('Visible', 'on');
hold on
dummy = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h = histogram(data.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
p1 = plot(data_MIT_NA.Var1, data_MIT_NA.Var2, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
p2 = plot(data_MIT_NA.Var3, data_MIT_NA.Var4, 'LineWidth', 1, 'Color', [colors(3, 1), colors(3, 2), colors(3, 3)]);
hold off

box on
grid on
legend([dummy p1 p2], "Bergamo", " Napoli", "MIT")
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2000])
xlabel('Energy [ADC]')
ylabel('Counts')

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/incoming_energy_comparison.pdf','ContentType','vector');
%exportgraphics(gcf,'output/incoming_energy_comparison.png');