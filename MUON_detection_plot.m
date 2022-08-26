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


%% PLOT TUTTI I CANALI SINGOLARMENTE (sensore di interesse in rosso)

f = figure('Visible', 'off');
%tiledlayout(4, 8)
colors = distinguishable_colors(2, 'w');

for ch = 0:31
    % self trigger
    data1 = readtable("input\muons\Run_10_08_2022_13.07.48_1hr_self.txt");
    
    % external trigger delay 34
    data2 = readtable("input\muons\Run_11_08_2022_11.29.16_2hr_ext_34.txt");
    
    %nexttile
    %h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1);

    if ch>15 && ch<24
        h2 = histogram(data2.Energy_ADC_(data2.Channel==ch), 'DisplayStyle', 'stairs', 'LineWidth', 0.7, 'BinWidth', 10, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
    else
        h2 = histogram(data2.Energy_ADC_(data2.Channel==ch), 'DisplayStyle', 'stairs', 'LineWidth', 0.7, 'BinWidth', 10, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
    end

    %h3 = histogram(data2.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'BinWidth', 10);
    
    box on
    grid on
    title(['\textbf{Channel ', num2str(ch),'}'])
    %legend(['Ch = ', num2str(ch), ''])
    set(gca, 'YScale', 'log')
    set(gca,'YMinorGrid','on')
    set(gca,'YGrid','on')
    xlim([0 1000])
    ylim([1 1000])
    %xlabel('Energy [ADU]')
    %ylabel('Counts')
    
    ax = gca; 
    ax.XAxis.FontSize = fontsize; 
    ax.YAxis.FontSize = fontsize; 
    %f.Position = [0 0 2160 4096*10];

    exportgraphics(gcf,['output/incoming_energy_32channels_34_2hr_', num2str(ch),'.pdf'],'ContentType','vector');
end

%exportgraphics(gcf,'output/incoming_energy_32channels_34_2hr.pdf','ContentType','vector');


%% PLOT DI TUTTI I CANALI (1 plot per ogni RIVELATORE!!!)

f = figure('Visible', 'off');
colors = distinguishable_colors(2, 'w');

channels_inizio = [0, 8, 16, 24];
channels_fine = [7,  15, 23, 31];

for sens = 1:4    
    % external trigger delay 34
    data2 = readtable("input\muons\Run_11_08_2022_11.29.16_2hr_ext_34.txt");

    if sens == 3
        h2 = histogram(data2.Energy_ADC_(data2.Channel>channels_inizio(sens) & data2.Channel<channels_fine(sens)), 'DisplayStyle', 'stairs', 'LineWidth', 0.7, 'BinWidth', 10, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
    else
        h2 = histogram(data2.Energy_ADC_(data2.Channel>channels_inizio(sens) & data2.Channel<channels_fine(sens)), 'DisplayStyle', 'stairs', 'LineWidth', 0.7, 'BinWidth', 10, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
    end

    box on
    grid on
    title(['\textbf{Detector ', num2str(sens), ' (Channels ', num2str(channels_inizio(sens)) ,' - ', num2str(channels_fine(sens)),')}'])
    set(gca, 'YScale', 'log')
    set(gca,'YMinorGrid','on')
    set(gca,'YGrid','on')
    xlim([0 2000])
    ylim([0.9 2000])
    xlabel('Energy [ADU]')
    ylabel('Counts')
    yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$"])
    
    ax = gca; 
    ax.XAxis.FontSize = fontsize; 
    ax.YAxis.FontSize = fontsize; 
    %f.Position = [0 0 2160 4096*10];

    exportgraphics(gcf,['output/incoming_energy34_2hr_sens', num2str(sens),'.pdf'],'ContentType','vector');
    print(f, ['output/incoming_energy34_2hr_sens', num2str(sens)],'-dsvg')
end


%% PLOT DI TUTTI I CANALI (1 singolo plot per tutti i sensori)

f = figure('Visible', 'off');
colors = distinguishable_colors(4, 'w');

channels_inizio = [0, 8, 16, 24];
channels_fine = [7,  15, 23, 31];

hold on
for sens = 1:4    
    % external trigger delay 34
    data2 = readtable("input\muons\Run_11_08_2022_11.29.16_2hr_ext_34.txt");

    h2 = histogram(data2.Energy_ADC_(data2.Channel>channels_inizio(sens) & data2.Channel<channels_fine(sens)), 'DisplayStyle', 'stairs', 'LineWidth', 0.5, 'BinWidth', 10, 'EdgeColor', [colors(sens, 1), colors(sens, 2), colors(sens, 3)]);

    box on
    grid on
    set(gca, 'YScale', 'log')
    set(gca,'YMinorGrid','on')
    set(gca,'YGrid','on')
    xlim([0 2000])
    ylim([0.9 2000])
    xlabel('Energy [ADU]')
    ylabel('Counts')
    yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$"])

    ax = gca; 
    ax.XAxis.FontSize = fontsize; 
    ax.YAxis.FontSize = fontsize; 
end
hold off

legend(["Si(Li) Sensor \#", num2str(sens), ' (Channels ', num2str(channels_inizio(sens)) ,' - ', num2str(channels_fine(sens)), ')'])
exportgraphics(gcf,['output/incoming_energy34_2hr_allsens.pdf'],'ContentType','vector');


%% PLOT TUTTI I CANALI e GAUSSIANA NOISE

fontsize = 12;

% self trigger 1hr
data_table = readtable("input\muons\Run_10_08_2022_13.07.48_1hr_self.txt");
tiledlayout('flow')
colors = distinguishable_colors(2, 'w');

ENC_channels = nan(32, 1);

f = figure('Visible', 'off');

for ch = 0:31
    nexttile
    hold on
    data = data_table.Energy_ADC_(data_table.Channel == ch);
    data = data(data<200)
    plot_m = histogram(data, 'DisplayStyle', 'stairs', 'LineWidth', 0.7, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)])
    dummy = plot(nan, nan, 'LineWidth', 0.7, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);

    noise_data = data;
    dist = fitdist(noise_data, "normal")
    
    bin_w = 1;
    scale = 5;
    
    pd = fitdist(noise_data,'Normal')
    x_values = [(plot_m.BinEdges(1)):0.01:(plot_m.BinEdges(end)+50)];
    pdf_data = pdf(pd, x_values) * trapz(plot_m.Values) * scale;
    plot_normale = plot(x_values, pdf_data, 'LineWidth', 0.7, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)])

    set(gca, 'YScale', 'linear')
    xlim([0 250])
    ylim([1 600])
    xlabel('Energy [ADU]')
    ylabel('Counts')
    
    % FWHM
    FWHM = 2*sqrt(2*log(2))*dist.sigma
    ENC = FWHM / 0.75439
    ENC_channels(ch+1) = ENC;

    box on
    grid on
    title("Channel " + num2str(ch))
    legend([plot_normale], {"$\mu$ = " + " " + num2str(round(dist.mu, 2)) + " ADU" + newline + "$\sigma$ = " + " " + ...
        num2str(round(dist.sigma, 2)) + " ADU" + newline + "ENC = " + num2str(round(ENC, 2)) + " ADU"}, 'location', 'northeast')
    %annotation('textbox', [0.5, 0.2, 0.1, 0.1], 'String', ["$\mu$ = " + " " + num2str(round(dist.mu, 2)) + " ADU, $\sigma$ = " + " " + num2str(round(dist.sigma, 2)) + " ADU"])

    hold off
end

% ax = gca; 
% ax.XAxis.FontSize = fontsize; 
% ax.YAxis.FontSize = fontsize; 
f.Position = [0 0 2160*3 4096*3];
exportgraphics(gcf,'output/incoming_energy_32channels_gaussiana_self.pdf','ContentType','vector');


%% PLOT TUTTI I CANALI e GAUSSIANA NOISE (test con americio)

fontsize = 12;

% self trigger 1hr con americio
%data_table = readtable("input/test_americio/1hr_allchannels.txt");
data_table = readtable("input/muons/Run_11_08_2022_11.29.16_1hr_self_130.txt");

tiledlayout('flow')
colors = distinguishable_colors(2, 'w');

ENC_channels = nan(32, 1);

data_pedestal = readtable("input\Pedestals_MODULE_40C_250V.dat");
pedestal_mean = data_pedestal.mean;
pedestal_std = data_pedestal.std;

f = figure('Visible', 'off');

for ch = 0:31
    nexttile
    hold on
    data = data_table.Energy_ADC_(data_table.Channel == ch);
    %data = data(data<200)
    plot_m = histogram(data, 'DisplayStyle', 'stairs', 'LineWidth', 0.7, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)])
    dummy = plot(nan, nan, 'LineWidth', 0.7, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);

    %noise_data = data;
    %dist = fitdist(noise_data, "normal")

    normdist = normpdf([0:600], pedestal_mean(ch+1), pedestal_std(ch+1))*100000;
    plot([0:600], normdist, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
    
    bin_w = 1;
    scale = 5;
    
    %pd = fitdist(noise_data,'Normal')
    %x_values = [(plot_m.BinEdges(1)):0.01:(plot_m.BinEdges(end)+50)];
    %pdf_data = pdf(pd, x_values) * trapz(plot_m.Values) * scale;
    %plot_normale = plot(x_values, pdf_data, 'LineWidth', 0.7, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)])

    set(gca, 'YScale', 'linear')
    xlim([0 600])
    ylim([0.1 100000])
    xlabel('Energy [ADU]')
    ylabel('Counts')
    set(gca, 'YScale', 'log')
    
    % FWHM
    %FWHM = 2*sqrt(2*log(2))*dist.sigma
    %ENC = FWHM / 0.75439
    %ENC_channels(ch+1) = ENC;

    box on
    grid on
    title("Channel " + num2str(ch))
    %legend([plot_normale], {"$\mu$ = " + " " + num2str(round(dist.mu, 2)) + " ADU" + newline + "$\sigma$ = " + " " + num2str(round(dist.sigma, 2)) + " ADU" + newline + "ENC = " + num2str(round(ENC, 2)) + " ADU"}, 'location', 'northeast')
    %annotation('textbox', [0.5, 0.2, 0.1, 0.1], 'String', ["$\mu$ = " + " " + num2str(round(dist.mu, 2)) + " ADU, $\sigma$ = " + " " + num2str(round(dist.sigma, 2)) + " ADU"])

    hold off
end

% ax = gca; 
% ax.XAxis.FontSize = fontsize; 
% ax.YAxis.FontSize = fontsize; 
f.Position = [0 0 2160*3 4096*3];
exportgraphics(gcf,'output/incoming_energy_32channels_gaussiana_self_muons.pdf','ContentType','vector');


%% PLOT ENC

f = figure('Visible','on')
fontsize = 12;
colors = distinguishable_colors(6, 'w');

hold on
%p1 = plot([0:31], ENC_channels.*0.841, 'LineWidth', 1, 'Marker','o', 'MarkerSize',4, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)], 'MarkerFaceColor', [colors(1, 1), colors(1, 2), colors(1, 3)])
p2 = plot([0:31], ENC.*0.841, 'LineWidth', 1, 'Marker','o', 'MarkerSize',4, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)], 'MarkerFaceColor', [colors(1, 1), colors(1, 2), colors(1, 3)])

ylim([0 60])
xlim([-1 32])

plot([-1:1:32], repelem(4, 34), 'LineStyle','-.', 'LineWidth', 1, 'Color', 'red')
text(28.8, 7, '4 keV', 'Color', 'red','FontName','Computer Modern', 'FontSize', 12)
hold off

box on
grid on
title("\textbf{ENC}");
%legend([p1 p2], "Evaluated from gaussian interpolation of pedestal", "Evaluated from estimated CDF over charge scan", "Location", "northwest")
xlabel("Channels")
ylabel("FWHM ENC [keV]")
ylim([0 100])

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
%ax.Legend.FontSize = fontsize-2;
exportgraphics(gcf,'output/ENC_channels.pdf','ContentType','vector');


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
ylim([0.9 100000])
xlabel('Energy [ADU]')
ylabel('Counts')
yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$" "$10^{5}$"])

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/incoming_energy_comparison.pdf','ContentType','vector');
exportgraphics(gcf,'output/incoming_energy_comparison.png');


%% PROFILE W/ NOISE SUPPRESSION (THR = 100)

data1 = readtable('input/muons/Run_10_08_2022_13.07.48_1hr_self.txt');
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


%% PROFILE W/ NOISE SUPPRESSION (THR = 130)

data1 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_self_130.txt');
data_noise_suppr = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_self_130_ZS.txt');
colors = distinguishable_colors(2, 'w');

f = figure('Visible', 'on');
hold on
dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'BinWidth', 10, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h2 = histogram(data_noise_suppr.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
%histfitlandau(data_noise_suppr.Energy_ADC_(data_noise_suppr.Energy_ADC_>5),3,0,1500)

hold off

box on
grid on
legend([dummy1 dummy2], "Without zero suppression", " With zero suppression")
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2000])
ylim([0.9 100000])
xlabel('Energy [ADU]')
ylabel('Counts')
yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$" "$10^{5}$"])

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
%ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/incoming_energy_thr130_ZS_comparativa.pdf','ContentType','vector');
exportgraphics(gcf,'output/incoming_energy_thr130_ZS_comparativa.png');
print(f, 'output/incoming_energy_thr130_ZS_comparativa','-dsvg')


%% PROFILE W/ NOISE SUPPRESSION (THR = 130, 150)

data1 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_self_130.txt');
%data_noise_suppr = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_self_150_ZS.txt');
data_noise_suppr = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_self_130_ZS.txt');
colors = distinguishable_colors(4, 'w');

f = figure('Visible', 'on');
hold on
dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'BinWidth', 10, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h2 = histogram(data_noise_suppr.Energy_ADC_(data_noise_suppr.Energy_ADC_>5), 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
%histfitlandau(data_noise_suppr.Energy_ADC_(data_noise_suppr.Energy_ADC_>5),10,0,1500)

hold off

box on
grid on
legend([dummy1 dummy2], "Without zero suppression", " With zero suppression")
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2000])
%ylim([0.5 10000])
ylim([0.9 100000])
xlabel('Energy [ADU]')
ylabel('Counts')
yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$" "$10^{5}$"])

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
%exportgraphics(gcf,'output/incoming_energy_thr130_ZS_landau.pdf','ContentType','vector');
exportgraphics(gcf,'output/incoming_energy_zero_suppr_thr130.pdf','ContentType','vector');



%% DIFFERENT DELAYS

fontsize = 12;

data1 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_ext_39.txt');
data2 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_ext_44.txt');
data3 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_ext_49.txt');
data4 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_ext_34.txt');
data5 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_ext_20.txt');
data6 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_ext_10.txt');
colors = distinguishable_colors(6, 'w');

f = figure('Visible', 'on');
hold on
dummy6 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy5 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
dummy4 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(3, 1), colors(3, 2), colors(3, 3)]);
dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(4, 1), colors(4, 2), colors(4, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(5, 1), colors(5, 2), colors(5, 3)]);
dummy3 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(6, 1), colors(6, 2), colors(6, 3)]);
h6 = histogram(data6.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 0.3, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h5 = histogram(data5.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 0.3, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
h4 = histogram(data4.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 0.3, 'EdgeColor', [colors(3, 1), colors(3, 2), colors(3, 3)]);
h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 0.3, 'EdgeColor', [colors(4, 1), colors(4, 2), colors(4, 3)]);
h2 = histogram(data2.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 5,'LineWidth', 0.3, 'EdgeColor', [colors(5, 1), colors(5, 2), colors(5, 3)]);
h3 = histogram(data3.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 5,'LineWidth', 0.3, 'EdgeColor', [colors(6, 1), colors(6, 2), colors(6, 3)]);
hold off

box on
grid on
legend([dummy6 dummy5 dummy4 dummy1 dummy2 dummy3], "Delay: 10 FPGA Clocks", "Delay: 20 FPGA Clocks", "Delay: 34 FPGA Clocks", "Delay: 39 FPGA Clocks", "Delay: 44 FPGA Clocks", "Delay: 49 FPGA Clocks")
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


%% COMPARATIVA SELF/EXT 

fontsize = 12;

% self trigger data THR = 130
data2 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_self_130.txt');

% old (THR = 130, delay = 34)
%data3 = readtable('input/muons/Run_11_08_2022_11.29.16_2hr_ext_34.txt');

% new (THR = 130, delay = 34)
data3 = readtable('input/muons/external_trigger_THR_130_delay_34_NEW.txt');

colors = distinguishable_colors(7, 'w');
f = figure('Visible', 'on');

hold on
%dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy3 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(5, 1), colors(5, 2), colors(5, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
%h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h3 = histogram(data3.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(5, 1), colors(5, 2), colors(5, 3)]);
h2 = histogram(data2.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
hold off

box on
grid on
%legend([dummy1 dummy3 dummy2], "External Trigger, delay: 34 FPGA Clocks (1)", "External Trigger, delay: 34 FPGA Clocks (2)", "Self trigger")
legend([dummy3 dummy2], "External Trigger", "Self trigger")
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2000])
ylim([0.9 100000])
xlabel('Energy [ADU]')
ylabel('Counts')
yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$" "$10^{5}$"])

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/incoming_energy_external34_self_130_2.pdf','ContentType','vector');
%exportgraphics(gcf,'output/incoming_energy_external34_self_130.png');


%% PLOT ACQUISIZIONI SELF TRIGGER SPAN THR 150 - 250

fontsize = 12;

% external trigger delay 39
data1 = readtable('input/selfTrigger_THR_analysis/self_10min_THR_150.txt');
data2 = readtable('input/selfTrigger_THR_analysis/self_10min_THR_160.txt');
data3 = readtable('input/selfTrigger_THR_analysis/self_10min_THR_170.txt');
data4 = readtable('input/selfTrigger_THR_analysis/self_10min_THR_180.txt');
data5 = readtable('input/selfTrigger_THR_analysis/self_10min_THR_190.txt');
data6 = readtable('input/selfTrigger_THR_analysis/self_10min_THR_200.txt');
data7 = readtable('input/selfTrigger_THR_analysis/self_10min_THR_210.txt');
data8 = readtable('input/selfTrigger_THR_analysis/self_10min_THR_220.txt');
data9 = readtable('input/selfTrigger_THR_analysis/self_10min_THR_230.txt');
data10 = readtable('input/selfTrigger_THR_analysis/self_10min_THR_240.txt');

colors = distinguishable_colors(10, 'w');
f = figure('Visible', 'on');
hold on

dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
dummy3 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(3, 1), colors(3, 2), colors(3, 3)]);
dummy4 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(4, 1), colors(4, 2), colors(4, 3)]);
dummy5 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(5, 1), colors(5, 2), colors(5, 3)]);
dummy6 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(6, 1), colors(6, 2), colors(6, 3)]);
dummy7 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(7, 1), colors(7, 2), colors(7, 3)]);
dummy8 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(8, 1), colors(8, 2), colors(8, 3)]);
dummy9 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(9, 1), colors(9, 2), colors(9, 3)]);
dummy10 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(10, 1), colors(10, 2), colors(10, 3)]);

h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 1, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h2 = histogram(data2.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
h3 = histogram(data3.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(3, 1), colors(3, 2), colors(3, 3)]);
h4 = histogram(data4.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(4, 1), colors(4, 2), colors(4, 3)]);
h5 = histogram(data5.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(5, 1), colors(5, 2), colors(5, 3)]);
h6 = histogram(data6.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(6, 1), colors(6, 2), colors(6, 3)]);
h7 = histogram(data7.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 1, 'EdgeColor', [colors(7, 1), colors(7, 2), colors(7, 3)]);
h8 = histogram(data8.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(8, 1), colors(8, 2), colors(8, 3)]);
h9 = histogram(data9.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(9, 1), colors(9, 2), colors(9, 3)]);
h10 = histogram(data10.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'EdgeColor', [colors(10, 1), colors(10, 2), colors(10, 3)]);
hold off

box on
grid on
legend([dummy1 dummy2 dummy3 dummy4 dummy5 dummy6 dummy7 dummy8 dummy9 dummy10], "THR = 150", "THR = 160", ...
    "THR = 170", "THR = 180", "THR = 190", "THR = 200", "THR = 210", "THR = 220", "THR = 230", "THR = 240")
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2047])
ylim([0.9 10000000])
xlabel('Energy [ADU]')
ylabel('Counts')
yticks([1 10 100 1000 10000 100000 1000000 10000000])
yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$" "$10^{5}$" "$10^{6}$" "$10^{7}$"])

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/selfTrigger_THR_analysis.pdf','ContentType','vector');


%% CONFRONTO CON/SENZA AMERICIO (THR = 214)

fontsize = 12;

% external trigger delay 39
data1 = readtable('input/test_americio/1hr_allchannels.txt');
data2 = readtable('input/test_americio/1hr_allchannels_no-americio_ZS.txt');

colors = distinguishable_colors(10, 'w');
f = figure('Visible', 'on');
hold on

dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);

h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 1, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h2 = histogram(data2.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
hold off

box on
grid on
legend([dummy1 dummy2], "With Americium ", "Without Americium")
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2047])
ylim([0.9 100080000])
xlabel('Energy [ADU]')
ylabel('Counts')
yticks([1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000])
yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$" "$10^{5}$" "$10^{6}$" "$10^{7}$" "$10^{8}$"])

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/selfTrigger_THR_214_americium_comparison.pdf','ContentType','vector');


%% SINGLE CHANNEL SENZA ZS THR = 214 (Ch. 6) + TUTTI I CANALI

fontsize = 12;

% THR = 214
data1 = readtable('input/test_americio/ch6_THR_214.txt');
data3 = readtable('input/test_americio/ch6_THR_214_ch5-7.txt');
data4 = readtable('input/test_americio/ch6_THR_214_ch0-7.txt');
data5 = readtable('input/test_americio/ch6_THR_214_ch0-15.txt');
data6 = readtable('input/test_americio/ch6_THR_214_ch0-23.txt');
data2 = readtable('input/test_americio/self_THR_214_no-americio.txt');

colors = distinguishable_colors(6, 'w');
f = figure('Visible', 'on');

hold on
dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy3 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(3, 1), colors(3, 2), colors(3, 3)]);
dummy4 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(4, 1), colors(4, 2), colors(4, 3)]);
dummy5 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(5, 1), colors(5, 2), colors(5, 3)]);
dummy6 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(6, 1), colors(6, 2), colors(6, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);

h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 1, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h3 = histogram(data3.Energy_ADC_(data3.Channel == 6), 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 1, 'EdgeColor', [colors(3, 1), colors(3, 2), colors(3, 3)]);
h4 = histogram(data4.Energy_ADC_(data4.Channel == 6), 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 1, 'EdgeColor', [colors(4, 1), colors(4, 2), colors(4, 3)]);
h5 = histogram(data5.Energy_ADC_(data5.Channel == 6), 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 1, 'EdgeColor', [colors(5, 1), colors(5, 2), colors(5, 3)]);
h6 = histogram(data6.Energy_ADC_(data6.Channel == 6), 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 1, 'EdgeColor', [colors(6, 1), colors(6, 2), colors(6, 3)]);
h2 = histogram(data2.Energy_ADC_(data2.Channel == 6), 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 1, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
hold off

box on
grid on
title("\textbf{Channel 6}")
legend([dummy1 dummy3 dummy4 dummy5 dummy6 dummy2], "Enabled: Ch. 6", "Enabled: Ch. 5, 6, 7", "Enabled: Ch. 0 to 7", "Enabled: Ch. 0 to 15", "Enabled: Ch. 0 to 23", "Enabled: Ch. 0 to 31")
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2047])
ylim([0.9 1000000])
xlabel('Energy [ADU]')
ylabel('Counts')
yticks([1 10 100 1000 10000 100000 1000000 10000000 100000000])
yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$" "$10^{5}$" "$10^{6}$" "$10^{7}$"])

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/selfTrigger_THR_214_ch6.pdf','ContentType','vector');


%% THR = 214 - ANALISI SINGOLI SENSORI (attivati uno alla volta)

fontsize = 12;

% THR = 214
data1 = readtable('input/test_americio/ch6_THR_214_ch0-7.txt');
data2 = readtable('input/test_americio/ch6_THR_214_ch8-15.txt');
data3 = readtable('input/test_americio/ch6_THR_214_ch16-23.txt');
data4 = readtable('input/test_americio/ch6_THR_214_ch24-31.txt');
data5 = readtable('input/test_americio/self_THR_214_no-americio.txt');

colors = distinguishable_colors(6, 'w');
f = figure('Visible', 'on');

hold on
dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
dummy3 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(3, 1), colors(3, 2), colors(3, 3)]);
dummy4 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(4, 1), colors(4, 2), colors(4, 3)]);
%dummy5 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(5, 1), colors(5, 2), colors(5, 3)]);

h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 0.8, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h2 = histogram(data2.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 0.8, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
h3 = histogram(data3.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 0.8, 'EdgeColor', [colors(3, 1), colors(3, 2), colors(3, 3)]);
h4 = histogram(data4.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 0.8, 'EdgeColor', [colors(4, 1), colors(4, 2), colors(4, 3)]);
%h5 = histogram(data5.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 0.8, 'EdgeColor', [colors(5, 1), colors(5, 2), colors(5, 3)]);
hold off

box on
grid on
%legend([dummy1 dummy2 dummy3 dummy4 dummy5], "Sens. \#0 - Ch. 0 - 7", "Sens. \#1 - Ch. 8 - 15", "Sens. \#2 - Ch. 16 - 23", "Sens. \#3 - Ch. 24 - 31", 'All sens. - Ch. 0 - 31')
legend([dummy1 dummy2 dummy3 dummy4], "Sens. \#0 - Ch. 0 - 7", "Sens. \#1 - Ch. 8 - 15", "Sens. \#2 - Ch. 16 - 23", "Sens. \#3 - Ch. 24 - 31")
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2047])
ylim([0.9 10000000])
xlabel('Energy [ADU]')
ylabel('Counts')
yticks([1 10 100 1000 10000 100000 1000000 10000000 100000000])
yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$" "$10^{5}$" "$10^{6}$" "$10^{7}$"])

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/selfTrigger_THR_214_sensors_comparison_no-all.pdf','ContentType','vector');


%% THR = 214 solo SENSORE 3 (tutti gli 8 canali)

clear; clc;
fontsize = 12;
data = readtable('input/test_americio/ch6_THR_214_ch24-31.txt');

colors = distinguishable_colors(8, 'w');
f = figure('Visible', 'on');

counter = 1;
dummys = nan(8, 1);
channels = [24:31];
legend_description = "Channel \#" + channels;
hold on
for i = 24:31
    dummy = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(counter, 1), colors(counter, 2), colors(counter, 3)]);
    dummys(counter, 1) = dummy;
    h = histogram(data.Energy_ADC_(data.Channel == i), 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 0.8, 'EdgeColor', [colors(counter, 1), colors(counter, 2), colors(counter, 3)]);
    counter = counter + 1;
end
hold off

box on
grid on
legend(dummys, legend_description);
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2047])
ylim([0.9 1000000])
xlabel('Energy [ADU]')
ylabel('Counts')
yticks([1 10 100 1000 10000 100000 1000000 10000000])
yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$" "$10^{5}$" "$10^{6}$"])

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/selfTrigger_THR_214_sensor3_channels.pdf','ContentType','vector');


%% THR = 200 - ANALISI SINGOLI SENSORI (attivati uno alla volta)

fontsize = 12;

% THR = 214
data1 = readtable('input/selfTrigger_THR_analysis/THR_200/detector_0_TH200.txt');
data2 = readtable('input/selfTrigger_THR_analysis/THR_200/detector_1_TH200.txt');
data3 = readtable('input/selfTrigger_THR_analysis/THR_200/detector_2_TH200.txt');
data4 = readtable('input/selfTrigger_THR_analysis/THR_200/all_detectors_TH200.txt');
data5 = readtable('input/test_americio/self_THR_214_no-americio.txt');

colors = distinguishable_colors(6, 'w');
f = figure('Visible', 'on');

hold on
dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
dummy3 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(3, 1), colors(3, 2), colors(3, 3)]);
dummy4 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(4, 1), colors(4, 2), colors(4, 3)]);
%dummy5 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(5, 1), colors(5, 2), colors(5, 3)]);

h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 0.8, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h2 = histogram(data2.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 0.8, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
h3 = histogram(data3.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 0.8, 'EdgeColor', [colors(3, 1), colors(3, 2), colors(3, 3)]);
h4 = histogram(data4.Energy_ADC_(data4.Channel >= 24 & data4.Channel <= 31), 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 0.8, 'EdgeColor', [colors(4, 1), colors(4, 2), colors(4, 3)]);
%h5 = histogram(data5.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10, 'LineWidth', 0.8, 'EdgeColor', [colors(5, 1), colors(5, 2), colors(5, 3)]);
hold off

box on
grid on
%legend([dummy1 dummy2 dummy3 dummy4 dummy5], "Sens. \#0 - Ch. 0 - 7", "Sens. \#1 - Ch. 8 - 15", "Sens. \#2 - Ch. 16 - 23", "Sens. \#3 - Ch. 24 - 31", 'All sens. - Ch. 0 - 31')
legend([dummy1 dummy2 dummy3 dummy4], "Sens. \#0 - Ch. 0 - 7", "Sens. \#1 - Ch. 8 - 15", "Sens. \#2 - Ch. 16 - 23", "Sens. \#3 - Ch. 24 - 31")
set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2047])
ylim([0.9 20000])
xlabel('Energy [ADU]')
ylabel('Counts')
yticks([1 10 100 1000 10000 200000])
yticklabels([1 10 "$10^{2}$" "$10^{3}$" "$10^{4}$"])

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/selfTrigger_THR_200_sensors_comparison_no-all.pdf','ContentType','vector');
