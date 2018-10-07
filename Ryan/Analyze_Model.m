clear all;

CORE = '24'; %Which Rivanna core do you want to run
runfeature = 'dR=0\_ApR/10';       %What changes are being tested
var_display = {'Ap','Ai','Ao','R','K','B','T','G',};   %What variables to display
save = false;

directory = split(pwd,'\');
current = directory{length(directory)};

b = false;
for i = {'Joseph','Grace','Ryan','Dylan'}
    if strcmp(i,current)
        b = true;
    end
end

if ~b
    error('Please work from your name''s directory'); 
else
    fprintf('Loading Data...')
    matfile = dir(strcat(pwd,'\data\Rivanna',CORE,'*\*.mat'));
    load(strcat(matfile.folder,'\',matfile.name));
end

bag = {M_cells, Psi_cells, para, config, var, time, var_display};

for fignum = 1:10
    clear figure(fignum)
end
%Get Readout
Readout = zeros(para('n'),config('n_snapshots'),length(var_display));
for t = 1:config('n_snapshots')
    for c = 1:para('n')
        for v = 1:length(var_display)
            Readout(c,t,v) = Psi_cells{t}(var(var_display{v}),c);
        end
    end
end

%Analyze
fprintf('\nAnalyzing...')
CellAverage = zeros(config('n_snapshots'),length(var_display));
for t = 1:config('n_snapshots')
    for v = 1:length(var_display)
         CellAverage(t,v) = mean(Readout(:,t,v));
    end
end

CellStdDev = zeros(config('n_snapshots'),length(var_display));
for t = 1:config('n_snapshots')
    for v = 1:length(var_display)
         CellStdDev(t,v) = std(Readout(:,t,v));
    end
end


%Display
fprintf('\nDisplaying...\n');
PlotData(CellAverage,strcat('Avg Cell Conc:',{' '},runfeature),true,true,false,bag,1);
if save
    saveas(figure(1),[pwd strcat('\Analyses\',runfeature,'-Sep23')]);
end
%PlotData(CellStdDev,strcat('Std Dev Conc: ',{' '},runfeature),true,true,false,bag,2);
%PlotData(Readout,strcat('CellConcs:',{' '},runfeature),false,false,false,bag,3);
%PlotData(0,'',false,false,true,bag);

function PlotData(data, feature, analyzed, tabs, gridview, bag,fignum) 
%data must be config('n_snapshots') by length(var_display)
%feature: essentially just figure title
%gridview: display Gridview
%tabs: coallate different variables into tabs
%analyzed: does this data not contain multiple cellular data columns
%fignum: keeps successive runs from overwrite each other
M_cells = bag{1};
Psi_cells = bag{2};
para = bag{3};
config = bag{4};
var = bag{5};
time = bag{6};
var_display = bag{7};

if ~gridview
    if analyzed
        hold on
        figure(fignum)
        if ~tabs
            for v = 1:length(var_display)
                plot(time,data(:,v));
                title(feature);
                xlabel('time (min)')
                ylabel(strcat(var_display{v}, ' (uM)'));
            end
            legend(var_display)
        else
            tabgp = uitabgroup;
            for v = 1:length(var_display)
                tab = uitab(tabgp,'Title',strcat('___',var_display{v},'___'));
                axes('Parent',tab);
                plot(time,data(:,v));
                title(feature);
                xlabel('time (min)')
                ylabel(strcat(var_display{v}, ' (uM)'));
                legend(var_display{v})
            end
    
        end
        hold off
    else
        hold on
        figure(fignum)
        for c = 1:para('n')
            plot(time,data(c,:,1));
        end
        xlabel('time (min)')
        ylabel(strcat(var_display{1}, ' (uM)'));
        legend(var_display{1})
        hold off
    end
else
    GridView(M_cells,Psi_cells,0*var(var_display{1}),para('t_i'),para('t_f'),config('n_snapshots'));
end

end