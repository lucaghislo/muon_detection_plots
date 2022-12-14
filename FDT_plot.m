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

%legend(channels, 'NumColumns', 4, 'Location','southeast')
xlabel('Incoming energy [MeV]');
ylabel('Channel Output [ADU]');
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
%ax.Legend.FontSize = fontsize-3; 
%f.Position = [200 160 900  550];
exportgraphics(gcf,'output/FDT_ASIC_Tamb.pdf','ContentType','vector');


%% ASIC a temperatura ambiente: mean FDT

clear; clc;
fontsize = 12;

data = readtable('input/TransferFunction_ASIC.dat');
CAL_voltage = data.CAL_V(1:55);
ch_out = nan(size(CAL_voltage, 1), 32);
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
     
    plot(CAL_voltage, mean(ch_out, 2), 'Color', [colors(pt+1, 1), colors(pt+1, 2), colors(pt+1, 3)])
end
hold off

peaking_times = strings(8, 1);
peaking_times_values = [0.30 0.47 0.65 0.82 1.00 1.27 1.54 1.82] % microsecondi
for pt = 0:7
    peaking_times(pt+1, 1) = strcat("$\tau_{", num2str(pt), '}$ = ', " ", num2str(peaking_times_values(pt+1), '%.2f'), ' $\mu$s');
end

legend(peaking_times, 'Location', 'southeast')
xlabel('Incoming energy [MeV]');
ylabel('Channel Output [ADU]');
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
%f.Position = [200 160 900  550];
exportgraphics(gcf,'output/FDT_ASIC_Tamb_allpt.pdf','ContentType','vector');


%% ASIC a -40C: mean FDT

clear; clc;
fontsize = 12;

data = readtable('input/TransferFunction_ASIC_-40C.dat');
CAL_voltage = data.CAL_V(1:55);
ch_out = nan(size(CAL_voltage, 1), 32);
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
     
    plot(CAL_voltage, mean(ch_out, 2), 'Color', [colors(pt+1, 1), colors(pt+1, 2), colors(pt+1, 3)])
end
hold off

peaking_times = strings(8, 1);
peaking_times_values = [0.30 0.47 0.65 0.82 1.00 1.27 1.54 1.82] % microsecondi
for pt = 0:7
    peaking_times(pt+1, 1) = strcat("$\tau_{", num2str(pt), '}$ = ', " ", num2str(peaking_times_values(pt+1), '%.2f'), ' $\mu$s');
end

legend(peaking_times, 'Location', 'southeast')
xlabel('Incoming energy [MeV]');
ylabel('Channel Output [ADU]');
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
%f.Position = [200 160 900  550];
exportgraphics(gcf,'output/FDT_ASIC_-40C_allpt.pdf','ContentType','vector');
print(f, 'output/FDT_ASIC_-40C_allpt','-dsvg')


%% FEB a temperatura ambiente

data = readtable('input/TransferFunction_FEB.dat');
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

%legend(channels, 'NumColumns', 2, 'Location','eastoutside')
xlabel('Incoming energy [MeV]');
ylabel('Channel Output [ADU]');
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
%ax.Legend.FontSize = fontsize; 
%f.Position = [200 160 900  550];
exportgraphics(gcf,'output/FDT_FEB_Tamb.pdf','ContentType','vector');


%% FEB a temperatura ambiente: mean FDT

clear; clc;
fontsize = 12;

data = readtable('input/TransferFunction_FEB.dat');
CAL_voltage = data.CAL_V(1:55);
ch_out = nan(size(CAL_voltage, 1), 32);
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
     
    plot(CAL_voltage, mean(ch_out, 2), 'Color', [colors(pt+1, 1), colors(pt+1, 2), colors(pt+1, 3)])
end
hold off

peaking_times = strings(8, 1);
peaking_times_values = [0.30 0.47 0.65 0.82 1.00 1.27 1.54 1.82] % microsecondi
for pt = 0:7
    peaking_times(pt+1, 1) = strcat("$\tau_{", num2str(pt), '}$ = ', " ", num2str(peaking_times_values(pt+1), '%.2f'), ' $\mu$s');
end

legend(peaking_times, 'Location', 'southeast')
xlabel('Incoming energy [MeV]');
ylabel('Channel Output [ADU]');
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
%f.Position = [200 160 900  550];
exportgraphics(gcf,'output/FDT_FEB_Tamb_allpt.pdf','ContentType','vector');


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
    channels(ch+1, 1) = strcat("", num2str(ch));
end

hleg = legend(channels, 'NumColumns', 2, 'Location','eastoutside')
xlabel('Incoming energy [MeV]');
ylabel('Channel Output [ADU]');
xlim([0, 53824]);
ylim([0 2000])
xticks([0:10000:50000])
xticklabels([0:10:50])
yticks([0:200:2000])
set(gcf, 'Color', 'w');
set(gca,'fontname','Computer Modern') 
grid on
box on

htitle = get(hleg,'Title');
set(htitle,'String','\textbf{Channel}')

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize; 
%f.Position = [200 160 900  550];
f.Position = [200 160 950  550];
exportgraphics(gcf,'output/FDT_MODULE_40C_250V.pdf','ContentType','vector');


%% MODULO a -40C con sensori a -250V: mean FDT

clear; clc;
fontsize = 12;

data = readtable('input/TransferFunction_MODULE_40C_250V.dat');
CAL_voltage = data.CAL_V(1:55);
ch_out = nan(size(CAL_voltage, 1), 32);
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
     
    plot(CAL_voltage, mean(ch_out, 2), 'Color', [colors(pt+1, 1), colors(pt+1, 2), colors(pt+1, 3)])
end
hold off

peaking_times = strings(8, 1);
peaking_times_values = [0.30 0.47 0.65 0.82 1.00 1.27 1.54 1.82] % microsecondi
for pt = 0:7
    peaking_times(pt+1, 1) = strcat("$\tau_{", num2str(pt), '}$ = ', " ", num2str(peaking_times_values(pt+1), '%.2f'), ' $\mu$s');
end

legend(peaking_times, 'Location', 'eastoutside')
xlabel('Incoming energy [MeV]');
ylabel('Channel Output [ADU]');
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
exportgraphics(gcf,'output/FDT_MODULE_40C_250V_allpt.pdf','ContentType','vector');


%% CALCOLO GUADAGNO IN BASSA ENERGIA PT4 (per singolo canale)

clearvars -except ch_out X

x = X(2:11);
%y_all = mean(ch_out, 2);
y_all = ch_out
y_211 = y_all(2:11, :)

gains = nan(32, 1);

f = figure('Visible', 'on');
hold on
for ch = 1:32
    y = y_211(:, ch);
    plot(x, y)

    % Fit line to data using polyfit
    c = polyfit(x,y,1);
    mdl = fitlm(x,y)
    
    % Display evaluated equation y = p0 + p1*x
    disp(['Equation is y = ' num2str(c(2)) ' + ' num2str(c(1)) '*x, R = ' num2str(corrcoef(y))])
    gains(ch) = c(1);
end
hold off


%% MODULO a -40C con sensori a 0V

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
ylabel('Channel Output [ADU]');
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


%% MODULO a -40C con sensori a 0V: mean FDT

clear; clc;
fontsize = 12;

data = readtable('input/TransferFunction_MODULE_40C_0V.dat');
CAL_voltage = data.CAL_V(1:55);
ch_out = nan(size(CAL_voltage, 1), 32);
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
     
    plot(CAL_voltage, mean(ch_out, 2), 'Color', [colors(pt+1, 1), colors(pt+1, 2), colors(pt+1, 3)])
end
hold off

peaking_times = strings(8, 1);
peaking_times_values = [0.30 0.47 0.65 0.82 1.00 1.27 1.54 1.82] % microsecondi
for pt = 0:7
    peaking_times(pt+1, 1) = strcat("$\tau_{", num2str(pt), '}$ = ', " ", num2str(peaking_times_values(pt+1), '%.2f'), ' $\mu$s');
end

legend(peaking_times, 'Location', 'northeast')
xlabel('Incoming energy [MeV]');
ylabel('Channel Output [ADU]');
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
%f.Position = [200 160 900  550];
exportgraphics(gcf,'output/FDT_MODULE_40C_0V_allpt.pdf','ContentType','vector');