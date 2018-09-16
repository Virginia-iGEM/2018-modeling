
var_display = 'Ap';
%Statistically Analyze
%Graph
Readout1 = zeros(para('n'),config('n_snapshots'));
Readout2 = zeros(para('n'),config('n_snapshots'));
Readout3 = zeros(para('n'),config('n_snapshots'));
for i = 1:config('n_snapshots')
    for j = 1:para('n')
        Readout1(j,i) = Psi_cells{i}(var(var_display),j);
    end
end

hold on
figure(1)

for i=1:para('n')
    plot(time,Readout1(i,:));
    %plot(t,Readout2(i,:));
    %plot(t,Readout3(i,:));
    legend(var_display)
end
hold off
GridView(M_cells,Psi_cells,var(var_display),para('t_i'),para('t_f'),config('n_snapshots'));
%SaveData(M_cells, Psi_cells, time)