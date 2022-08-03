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


%% ASIC a temperatura ambiente

data = readtable('input/TransferFunction_ASIC.dat');
pt = 6;
CAL_voltage = data.CAL_V(1:55);
ch_out = nan(size(CAL_voltage, 1), 32);
counter = 1;

for ch = 0:31
    counter = 1;
    for i = 1:size(data, 1)
        if data.pt(i) == pt
            if data.ch(i) == ch
                ch_out(counter, ch+1) = table2array(data(i, "mean"));
                counter = counter + 1;
            end
        end
    end
end

f = figure('Visible', 'on');
colors = distinguishable_colors(32, 'w');
hold on
for j = 1:size(ch_out, 2)
    plot(CAL_voltage, ch_out(:, j), 'Color', [colors(j, 1), colors(j, 2), colors(j, 3)])
end
hold off

channels = strings(32, 1);
for ch = 0:31
    channels(ch+1, 1) = strcat("Ch \#", num2str(ch));
end

legend(channels, 'NumColumns', 2, 'Location','eastoutside')
xlabel('Incoming energy [MeV]');
ylabel('Channel\_out [ADC code]');
xlim([0, 53824]);
ylim([0 2000])
xticks([0:10000:50000])
xticklabels([0:10:50])
yticks([0:200:2000])
set(gcf, 'Color', 'w');
set(gca,'fontname','Computer Modern') 
grid on
box on

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize; 
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/FDT_ASIC_Tamb.pdf','ContentType','vector');


%% MODULO a -40C con sensori a -250V

data = readtable('input/TransferFunction_MODULE_40C_250V.dat');
pt = 6;
CAL_voltage = data.CAL_V(1:55);
ch_out = nan(size(CAL_voltage, 1), 32);
counter = 1;

for ch = 0:31
    counter = 1;
    for i = 1:size(data, 1)
        if data.pt(i) == pt
            if data.ch(i) == ch
                ch_out(counter, ch+1) = table2array(data(i, "mean"));
                counter = counter + 1;
            end
        end
    end
end

f = figure('Visible', 'on');
colors = distinguishable_colors(32, 'w');
hold on
for j = 1:size(ch_out, 2)
    plot(CAL_voltage, ch_out(:, j), 'Color', [colors(j, 1), colors(j, 2), colors(j, 3)])
end
hold off

channels = strings(32, 1);
for ch = 0:31
    channels(ch+1, 1) = strcat("Ch \#", num2str(ch));
end

legend(channels, 'NumColumns', 2, 'Location','eastoutside')
xlabel('Incoming energy [MeV]');
ylabel('Channel\_out [ADC code]');
xlim([0, 53824]);
ylim([0 2000])
xticks([0:10000:50000])
xticklabels([0:10:50])
yticks([0:200:2000])
set(gcf, 'Color', 'w');
set(gca,'fontname','Computer Modern') 
grid on
box on

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize; 
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/FDT_MODULE_40C_250V.pdf','ContentType','vector');


%% MODULO a -40C con sensori a -250V

data = readtable('input/TransferFunction_MODULE_40C_0V.dat');
pt = 6;
CAL_voltage = data.CAL_V(1:55);
ch_out = nan(size(CAL_voltage, 1), 32);
counter = 1;

for ch = 0:31
    counter = 1;
    for i = 1:size(data, 1)
        if data.pt(i) == pt
            if data.ch(i) == ch
                ch_out(counter, ch+1) = table2array(data(i, "mean"));
                counter = counter + 1;
            end
        end
    end
end

f = figure('Visible', 'on');
colors = distinguishable_colors(32, 'w');
hold on
for j = 1:size(ch_out, 2)
    plot(CAL_voltage, ch_out(:, j), 'Color', [colors(j, 1), colors(j, 2), colors(j, 3)])
end
hold off

channels = strings(32, 1);
for ch = 0:31
    channels(ch+1, 1) = strcat("Ch \#", num2str(ch));
end

legend(channels, 'NumColumns', 2, 'Location','eastoutside')
xlabel('Incoming energy [MeV]');
ylabel('Channel\_out [ADC code]');
xlim([0, 53824]);
ylim([0 2000])
xticks([0:10000:50000])
xticklabels([0:10:50])
yticks([0:200:2000])
set(gcf, 'Color', 'w');
set(gca,'fontname','Computer Modern') 
grid on
box on

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize; 
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/FDT_MODULE_40C_0V.pdf','ContentType','vector');