% This script changes all interpreters from tex to latex. 
list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end

data = readtable('HV_voltage_current.dat');

plot(data.voltage, data.current)

box on
grid on
xlabel('Sensors biasing voltage [V]')
ylabel('Leakage Current [$\mu$A]')

exportgraphics(gcf, 'HK_current.pdf', 'ContentType', 'vector');