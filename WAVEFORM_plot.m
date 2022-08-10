%% WAVEFORM PLOT

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

data = readtable('input/WaveformScan_ASIC.dat');
time = data.tc(1:120);
ch_out = nan(size(time, 1), 32);
counter = 1;

for pt = 0:7
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
        plot(time, ch_out(:, j), 'Color', [colors(j, 1), colors(j, 2), colors(j, 3)])
    end
    hold off
    
    channels = strings(32, 1);
    for ch = 0:31
        channels(ch+1, 1) = strcat("Ch \#", num2str(ch));
    end
    
    legend(channels, 'NumColumns', 2, 'Location','eastoutside')
    xlabel('Time [$\mu$s]');
    xticklabels([0:0.5:3])
    ylabel('Channel\_out [ADC code]');
    ylim([50 850])
    set(gcf, 'Color', 'w');
    set(gca,'fontname','Computer Modern') 
    grid on
    box on
    
    ax = gca; 
    ax.XAxis.FontSize = fontsize; 
    ax.YAxis.FontSize = fontsize; 
    ax.Legend.FontSize = fontsize; 
    f.Position = [200 160 900  550];
    exportgraphics(gcf,['output/WAVEFORM_ASIC_Tamb_pt', num2str(pt) ,'.pdf'],'ContentType','vector');
end


%% ASIC a temperatura ambiente: mean WAVEFORM

clear; clc;
fontsize = 12;

data = readtable('input/WaveformScan_ASIC.dat');
time = data.tc(1:120);
ch_out = nan(size(time, 1), 32);
counter = 1;

f = figure('Visible', 'on');
colors = distinguishable_colors(8, 'w');

hold on
for pt = 0:7
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
     
    plot(time, mean(ch_out, 2), 'Color', [colors(pt+1, 1), colors(pt+1, 2), colors(pt+1, 3)])
end
hold off

peaking_times = strings(8, 1);
peaking_times_values = [0.30 0.47 0.65 0.82 1.00 1.27 1.54 1.82] % microsecondi
for pt = 0:7
    peaking_times(pt+1, 1) = strcat("$\tau_{", num2str(pt), '}$ = ', " ", num2str(peaking_times_values(pt+1), '%.2f'), ' $\mu$s');
end

%legend(peaking_times, 'Location', 'eastoutside')
xlabel('Time [$\mu$s]');
xticklabels([0:0.5:3])
ylabel('Channel\_out [ADC code]');
ylim([50 750])
set(gcf, 'Color', 'w');
set(gca,'fontname','Computer Modern') 
grid on
box on

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
%ax.Legend.FontSize = fontsize; 
%f.Position = [200 160 900  550];
exportgraphics(gcf,'output/WAVEFORM_ASIC_Tamb_allpt.pdf','ContentType','vector');



%% FEB a temperatura ambiente

data = readtable('input/WaveformScan_FEB.dat');
time = data.tc(1:120);
ch_out = nan(size(time, 1), 32);
counter = 1;

for pt = 0:7
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
        plot(time, ch_out(:, j), 'Color', [colors(j, 1), colors(j, 2), colors(j, 3)])
    end
    hold off
    
    channels = strings(32, 1);
    for ch = 0:31
        channels(ch+1, 1) = strcat("Ch \#", num2str(ch));
    end
    
    legend(channels, 'NumColumns', 2, 'Location','eastoutside')
    xlabel('Time [$\mu$s]');
    xticklabels([0:0.5:3])
    ylabel('Channel\_out [ADC code]');
    ylim([50 850])
    set(gcf, 'Color', 'w');
    set(gca,'fontname','Computer Modern') 
    grid on
    box on
    
    ax = gca; 
    ax.XAxis.FontSize = fontsize; 
    ax.YAxis.FontSize = fontsize; 
    ax.Legend.FontSize = fontsize; 
    f.Position = [200 160 900  550];
    exportgraphics(gcf,['output/WAVEFORM_FEB_Tamb_pt', num2str(pt) ,'.pdf'],'ContentType','vector');
end


%% FEB a temperatura ambiente: mean WAVEFORM

clear; clc;
fontsize = 12;

data = readtable('input/WaveformScan_FEB.dat');
time = data.tc(1:120);
ch_out = nan(size(time, 1), 32);
counter = 1;

f = figure('Visible', 'on');
colors = distinguishable_colors(8, 'w');

hold on
for pt = 0:7
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
     
    plot(time, mean(ch_out, 2), 'Color', [colors(pt+1, 1), colors(pt+1, 2), colors(pt+1, 3)])
end
hold off

peaking_times = strings(8, 1);
peaking_times_values = [0.30 0.47 0.65 0.82 1.00 1.27 1.54 1.82] % microsecondi
for pt = 0:7
    peaking_times(pt+1, 1) = strcat("$\tau_{", num2str(pt), '}$ = ', " ", num2str(peaking_times_values(pt+1), '%.2f'), ' $\mu$s');
end

%legend(peaking_times, 'Location', 'eastoutside')
xlabel('Time [$\mu$s]');
xticklabels([0:0.5:3])
ylabel('Channel\_out [ADC code]');
ylim([50 750])
set(gcf, 'Color', 'w');
set(gca,'fontname','Computer Modern') 
grid on
box on

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
%ax.Legend.FontSize = fontsize; 
%f.Position = [200 160 900  550];
exportgraphics(gcf,'output/WAVEFORM_FEB_Tamb_allpt.pdf','ContentType','vector');


%% MODULO a -40C con sensori a -250V

data = readtable('input/WaveformScan_MODULE_40C_250V.dat');
time = data.tc(1:120);
ch_out = nan(size(time, 1), 32);
counter = 1;

for pt = 0:7
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
        plot(time, ch_out(:, j), 'Color', [colors(j, 1), colors(j, 2), colors(j, 3)])
    end
    hold off
    
    channels = strings(32, 1);
    for ch = 0:31
        channels(ch+1, 1) = strcat("Ch \#", num2str(ch));
    end
    
    legend(channels, 'NumColumns', 2, 'Location','eastoutside')
    xlabel('Time [$\mu$s]');
    xticklabels([0:0.5:3])
    ylabel('Channel\_out [ADC code]');
    ylim([50 850])
    set(gcf, 'Color', 'w');
    set(gca,'fontname','Computer Modern') 
    grid on
    box on
    
    ax = gca; 
    ax.XAxis.FontSize = fontsize; 
    ax.YAxis.FontSize = fontsize; 
    ax.Legend.FontSize = fontsize; 
    f.Position = [200 160 900  550];
    exportgraphics(gcf,['output/WAVEFORM_MODULE_40C_250V_pt', num2str(pt) ,'.pdf'],'ContentType','vector');
end


%% MODULO a -40C con sensori a -250V: mean WAVEFORM

clear; clc;
fontsize = 12;

data = readtable('input/WaveformScan_MODULE_40C_250V.dat');
time = data.tc(1:120);
ch_out = nan(size(time, 1), 32);
counter = 1;

f = figure('Visible', 'on');
colors = distinguishable_colors(8, 'w');

hold on
for pt = 0:7
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
     
    plot(time, mean(ch_out, 2), 'Color', [colors(pt+1, 1), colors(pt+1, 2), colors(pt+1, 3)])
end
hold off

peaking_times = strings(8, 1);
peaking_times_values = [0.30 0.47 0.65 0.82 1.00 1.27 1.54 1.82] % microsecondi
for pt = 0:7
    peaking_times(pt+1, 1) = strcat("$\tau_{", num2str(pt), '}$ = ', " ", num2str(peaking_times_values(pt+1), '%.2f'), ' $\mu$s');
end

legend(peaking_times, 'Location', 'eastoutside')
xlabel('Time [$\mu$s]');
xticklabels([0:0.5:3])
ylabel('Channel\_out [ADC code]');
ylim([50 750])
set(gcf, 'Color', 'w');
set(gca,'fontname','Computer Modern') 
grid on
box on

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize; 
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/WAVEFORM_MODULE_40C_250V_allpt.pdf','ContentType','vector');


%% MODULO a -40C con sensori a 0V

data = readtable('input/WaveformScan_MODULE_40C_0V.dat');
time = data.tc(1:120);
ch_out = nan(size(time, 1), 32);
counter = 1;

for pt = 0:7
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
        plot(time, ch_out(:, j), 'Color', [colors(j, 1), colors(j, 2), colors(j, 3)])
    end
    hold off
    
    channels = strings(32, 1);
    for ch = 0:31
        channels(ch+1, 1) = strcat("Ch \#", num2str(ch));
    end
    
    legend(channels, 'NumColumns', 2, 'Location','eastoutside')
    xlabel('Time [$\mu$s]');
    xticklabels([0:0.5:3])
    ylabel('Channel\_out [ADC code]');
    ylim([50 850])
    set(gcf, 'Color', 'w');
    set(gca,'fontname','Computer Modern') 
    grid on
    box on
    
    ax = gca; 
    ax.XAxis.FontSize = fontsize; 
    ax.YAxis.FontSize = fontsize; 
    ax.Legend.FontSize = fontsize; 
    f.Position = [200 160 900  550];
    exportgraphics(gcf,['output/WAVEFORM_MODULE_40C_0V_pt', num2str(pt) ,'.pdf'],'ContentType','vector');
end


%% MODULO a -40C con sensori a 0V: mean WAVEFORM

clear; clc;
fontsize = 12;

data = readtable('input/WaveformScan_MODULE_40C_0V.dat');
time = data.tc(1:120);
ch_out = nan(size(time, 1), 32);
counter = 1;

f = figure('Visible', 'on');
colors = distinguishable_colors(8, 'w');

hold on
for pt = 0:7
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
     
    plot(time, mean(ch_out, 2), 'Color', [colors(pt+1, 1), colors(pt+1, 2), colors(pt+1, 3)])
end
hold off

peaking_times = strings(8, 1);
peaking_times_values = [0.30 0.47 0.65 0.82 1.00 1.27 1.54 1.82] % microsecondi
for pt = 0:7
    peaking_times(pt+1, 1) = strcat("$\tau_{", num2str(pt), '}$ = ', " ", num2str(peaking_times_values(pt+1), '%.2f'), ' $\mu$s');
end

legend(peaking_times, 'Location', 'eastoutside')
xlabel('Time [$\mu$s]');
xticklabels([0:0.5:3])
ylabel('Channel\_out [ADC code]');
ylim([50 750])
set(gcf, 'Color', 'w');
set(gca,'fontname','Computer Modern') 
grid on
box on

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize; 
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/WAVEFORM_MODULE_40C_0V_allpt.pdf','ContentType','vector');