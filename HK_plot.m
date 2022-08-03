%% HK TEST PLOT

clear; clc;

% This script changes all interpreters from tex to latex. 
list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end


%% CORRENTI DI LEAKAGE TUTTE LE TENSIONI TUTTI I CANALI

clear; clc;
fontsize = 12;

leakage_measures = nan(32, 26);

counter = 1;
for voltage = 0:10:250
    for channel = 0:31
        data = readtable(['input/HK_test_03082022/HK_', num2str(voltage), '/data/HK_Leakage_ch', num2str(channel),'.dat']);
        ch_mean = mean(data.Value);
        leakage_measures(channel+1, counter) = round(ch_mean);
    end
    counter = counter + 1;
end

voltage_coeff = 1.76;
den_coeff = 3.87;
R = 1.99*10^6; % H = 0
leakage_measures_I = abs(((1024 - leakage_measures) * voltage_coeff)/(den_coeff * 10 * R));
leakage_measures_I = leakage_measures_I * 1000; % mA -> uA
leakage_measures_I = leakage_measures_I * 1000; % uA -> nA


%% PLOT

fontsize = 12;
colors = distinguishable_colors(32, 'w');

f = figure('Visible', 'on');
hold on
for i = 1:size(leakage_measures_I, 1)
    plot([0:-10:-250], leakage_measures_I(i, :), 'Color', [colors(i, 1), colors(i, 2), colors(i, 3)]);
end
hold off

channels = strings(32, 1);
for ch = 0:31
    channels(ch+1, 1) = strcat("Ch \#", num2str(ch));
end

legend(channels, 'NumColumns', 2, 'Location','eastoutside')
grid on
box on
ylim([-0.5 20.5])
xticks([-250:25:0])
xlabel('Bias voltage [V]')
ylabel('Leakage current [nA]')

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize; 
f.Position = [200 160 1100  600];
exportgraphics(gcf,'output/leakage_current.pdf','ContentType','vector');


%% SOMMA CORRENTI LEAKAGE PER TENSIONI

f = figure('Visible', 'on')
plot([0:-10:-250], sum(leakage_measures_I), 'LineWidth', 1, 'Marker','o', 'MarkerSize',4, 'MarkerFaceColor', '0.00,0.45,0.74')

grid on
box on
xlabel('Bias voltage [V]')
ylabel('Total leakage current [nA]')
xticks([-250:25:0])
yticks([0:50:500])
ylim([0 500])

fontsize = 12;
ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
%f.Position = [200 160 1100  600];
exportgraphics(gcf,'output/leakage_current_sum.pdf','ContentType','vector');