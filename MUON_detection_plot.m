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
tiledlayout(4, 8)
colors = distinguishable_colors(2, 'w');

for ch = 0:31
    % self trigger
    data1 = readtable("input\muons\Run_10_08_2022_13.07.48_1hr_self.txt");
    
    % external trigger delay 44
    data2 = readtable("input\muons\Run_11_08_2022_11.29.16_2hr_ext_34.txt");
    
    nexttile
    %h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1);

    if ch>15 && ch<24
        h2 = histogram(data2.Energy_ADC_(data2.Channel==ch), 'DisplayStyle', 'stairs', 'LineWidth', 0.7, 'BinWidth', 10, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
    else
        h2 = histogram(data2.Energy_ADC_(data2.Channel==ch), 'DisplayStyle', 'stairs', 'LineWidth', 0.7, 'BinWidth', 10, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
    end
    %h3 = histogram(data2.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'BinWidth', 10);
    
    box on
    grid on
    title(['Channel ', num2str(ch)])
    %legend(['Ch = ', num2str(ch), ''])
    set(gca, 'YScale', 'log')
    set(gca,'YMinorGrid','on')
    set(gca,'YGrid','on')
    xlim([0 2000])
    ylim([1 1000])
    xlabel('Energy [ADU]')
    ylabel('Counts')
    
%     ax = gca; 
%     ax.XAxis.FontSize = fontsize; 
%     ax.YAxis.FontSize = fontsize; 
     f.Position = [0 0 2160 4096*10];
   
end

exportgraphics(gcf,'output/incoming_energy_32channels_34_2hr.pdf','ContentType','vector');


%% PLOT TUTTI I CANALI e GAUSSIANA NOISE

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

f.Position = [0 0 2160*3 4096*3];
exportgraphics(gcf,'output/incoming_energy_32channels_gaussiana_self.pdf','ContentType','vector');


%% PLOT ENC

f = figure('Visible','on')

hold on
plot([0:31], ENC_channels.*0.841, 'LineWidth', 1, 'Marker','o', 'MarkerSize',4, 'MarkerFaceColor', '0.00,0.45,0.74')
ylim([0 60])
xlim([-1 32])

plot([-1:1:32], repelem(4, 34), 'LineStyle','-.', 'LineWidth', 1, 'Color', 'red')
text(28.8, 5.7, '4 keV', 'Color', 'red','FontName','Computer Modern', 'FontSize', 12)
hold off

box on
grid on
xlabel("Channel")
ylabel("FWHM ENC [keV]")

exportgraphics(gcf,'output/ENC_channels_ext_trigger.pdf','ContentType','vector');


%% PROFILE W/ COMPARISON NAPOLI e MIT

data = readtable("input\muons\Run_10_08_2022_13.07.48_1hr_self.txt");
data_MIT_NA = readtable('input/muons/muons_NA_MIT.txt');
colors = distinguishable_colors(3, 'w');

f = figure('Visible', 'on');
hold on
dummy = plot_m(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h = histogram(data.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
p1 = plot_m(data_MIT_NA.Var1, data_MIT_NA.Var2, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
p2 = plot_m(data_MIT_NA.Var3, data_MIT_NA.Var4, 'LineWidth', 1, 'Color', [colors(3, 1), colors(3, 2), colors(3, 3)]);
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
%ylim([0.8 10000])
xlabel('Energy [ADU]')
ylabel('Counts')

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
%ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/incoming_energy_thr130_ZS_comparativa.pdf','ContentType','vector');
%exportgraphics(gcf,'output/incoming_energy_zero_suppr_thr130_landau.png');


%% PROFILE W/ NOISE SUPPRESSION (THR = 150)

%data1 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_self_130.txt');
data_noise_suppr = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_self_150_ZS.txt');
colors = distinguishable_colors(2, 'w');

f = figure('Visible', 'on');
hold on
%dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
%h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'BinWidth', 10, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h2 = histogram(data_noise_suppr.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 10,'LineWidth', 1, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
histfitlandau(data_noise_suppr.Energy_ADC_(data_noise_suppr.Energy_ADC_>5),5,0,2000)

hold off

box on
grid on
%legend([dummy1 dummy2], "Without zero suppression", " With zero suppression")
%set(gca, 'YScale', 'log')
set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
xlim([0 2000])
%ylim([0.5 10000])
%ylim([0.8 10000])
xlabel('Energy [ADU]')
ylabel('Counts')

ax = gca; 
ax.XAxis.FontSize = fontsize; 
ax.YAxis.FontSize = fontsize; 
%ax.Legend.FontSize = fontsize;
f.Position = [200 160 900  550];
exportgraphics(gcf,'output/incoming_energy_thr150_ZS_landau.pdf','ContentType','vector');
%exportgraphics(gcf,'output/incoming_energy_zero_suppr_thr130_landau.png');



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

% external trigger delay 39
data1 = readtable('input/muons/Run_11_08_2022_11.29.16_1hr_ext_34.txt');
data2 = readtable('input/muons/Run_10_08_2022_13.07.48_1hr_self.txt');
data3 = readtable('input/muons/Run_11_08_2022_11.29.16_2hr_ext_34.txt');
colors = distinguishable_colors(3, 'w');

f = figure('Visible', 'on');
hold on
dummy1 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(1, 1), colors(1, 2), colors(1, 3)]);
dummy3 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(3, 1), colors(3, 2), colors(3, 3)]);
dummy2 = plot(nan, nan, 'LineWidth', 1, 'Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
h1 = histogram(data1.Energy_ADC_, 'DisplayStyle', 'stairs', 'LineWidth', 1, 'EdgeColor', [colors(1, 1), colors(1, 2), colors(1, 3)]);
h3 = histogram(data3.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 5,'LineWidth', 1, 'EdgeColor', [colors(3, 1), colors(3, 2), colors(3, 3)]);
h2 = histogram(data2.Energy_ADC_, 'DisplayStyle', 'stairs', 'BinWidth', 5,'LineWidth', 1, 'EdgeColor', [colors(2, 1), colors(2, 2), colors(2, 3)]);
hold off

box on
grid on
legend([dummy1 dummy3 dummy2], "External Trigger, delay: 34 FPGA Clocks (1)", "External Trigger, delay: 34 FPGA Clocks (2)", "Self trigger")
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
exportgraphics(gcf,'output/incoming_energy_ext34_self_comparison.pdf','ContentType','vector');
