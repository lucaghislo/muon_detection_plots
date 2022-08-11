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

f = figure('Visible', 'off');
iledlayout('flow')
colors = distinguishable_colors(2, 'w');

for ch = 0:31
    % self trigger
    data1 = readtable("input\muons\Run_10_08_2022_13.07.48_1hr_self.txt");
    
    % external trigger delay 44
    data2 = readtable("input\muons\Run_11_08_2022_11.29.16_1hr_ext_49.txt");
    
    nexttile
    %h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1);

    if ch>15 && ch<24
        h2 = histogram(data2.Energy_ADC_(data2.Channel==ch), 'DisplayStyle', 'stairs', 'LineWidth', 1, 'BinWidth', 10, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
    else
        h2 = histogram(data2.Energy_ADC_(data2.Channel==ch), 'DisplayStyle', 'stairs', 'LineWidth', 1, 'BinWidth', 10, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
    end
    %h3 = histogram(data2.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'BinWidth', 10);
    
    box on
    grid on
    legend(['Ch = ', num2str(ch), ''])
    set(gca, 'YScale', 'log')
    set(gca,'YMinorGrid','on')
    set(gca,'YGrid','on')
    xlim([0 2000])
    xlabel('Energy [ADC]')
    ylabel('Counts')
    
%     ax = gca; 
%     ax.XAxis.FontSize = fontsize; 
%     ax.YAxis.FontSize = fontsize; 
     f.Position = [0 0 2160 4096];
   
end

exportgraphics(gcf,'output/incoming_energy_32channels_49.pdf','ContentType','vector');


%% PROFILE W/ COMPARISON NAPOLI e MIT

data = readtable("input\muons\Run_10_08_2022_13.07.48_1hr_self.txt");
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


%% PROFILE W/ NOISE SUPPRESSION

data_noise_suppr = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_self.txt');
colors = distinguishable_colors(2, 'w');

f = figure('Visible', 'on');
hold on
dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h2 = histogram(data_noise_suppr.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 5,'LineWidth', 1, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
hold off

box on
grid on
legend([dummy1 dummy2], "Without zero suppression", " With zero suppression")
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2000])
ylim([0.8 10000])
xlabel('Energy [ADC]')
ylabel('Counts')

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/incoming_energy_zero_suppr.pdf','ContentType','vector');


%% DIFFERENT DELAYS

data1 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_ext_39.txt');
data2 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_ext_44.txt');
data3 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_ext_49.txt');
colors = distinguishable_colors(3, 'w');

f = figure('Visible', 'on');
hold on
dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
dummy3 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(3, 1), colors(3, 2), colors(3, 3)]);
h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h2 = histogram(data2.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 5,'LineWidth', 1, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
h3 = histogram(data3.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 5,'LineWidth', 1, 'EdgeColor', [colors(3, 1), colors(3, 2), colors(3, 3)]);
hold off

box on
grid on
legend([dummy1 dummy2 dummy3], "Delay: 39 FPGA Clocks", "Delay: 44 FPGA Clocks", "Delay: 49 FPGA Clocks")
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2000])
ylim([0.8 10000])
xlabel('Energy [ADC]')
ylabel('Counts')

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/incoming_energy_different_delays.pdf','ContentType','vector');

