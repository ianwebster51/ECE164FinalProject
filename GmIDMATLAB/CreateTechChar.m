%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Drew A. Hall
% DrewHall@ucsd.edu
% 28-Feb-2012
% 
% Process Gm/Id based data and generate technology charts
%
% Notes:
%   - See EE164 course notes
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;

DataDir = './Data';                     % Folder containg spectre CSV files
DeviceNames = {'pfet', 'nfet'};         % Device names from simulation, in order
W = 10e-6;                              % Width of the device used in simulation

fTechName = 'GF018.mat';                % Output file

% gm/id range to be considerd in plots
gmid_max = 20;
gmid_min = 5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read in the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
idx = 1;
tech.DeviceNames = DeviceNames;

fNames = dir(fullfile(DataDir, '*.csv'));

% This is needed to preserve the order of the addition
[~, reindex] = sort( str2double( regexp( {fNames.name}, '\d+', 'match', 'once' )));
fNames = fNames(reindex);

for i = 1:length(fNames)
    Data = textread(fullfile(fNames(i).folder, fNames(i).name), '', -1, 'headerlines', 2);
    [Pts, ~] = size(Data);
    
    % Extract the length from the filename
    strTmp = char(fNames(i).name);
    idx1 = strfind(strTmp, 'L=');
    idx2 = strfind(strTmp, '.csv');
    L = str2double(strTmp(idx1+2:idx2-1));

    for k = 1:length(DeviceNames)
        tech.L(k, idx:idx+Pts-1) = L.*ones(Pts,1);
        tech.W(k, idx:idx+Pts-1) = W.*ones(Pts,1);
        tech.Vgs(k, idx:idx+Pts-1) = Data(:,1);
        tech.Id(k, idx:idx+Pts-1) = abs(Data(:,2+(k-1)*7));
        tech.gm(k, idx:idx+Pts-1) = Data(:,3+(k-1)*7);
        tech.gds(k, idx:idx+Pts-1) = Data(:,4+(k-1)*7);
        tech.Vt(k, idx:idx+Pts-1) = Data(:,5+(k-1)*7);
        tech.Cgg(k, idx:idx+Pts-1) = Data(:,6+(k-1)*7);
        tech.Cdb(k, idx:idx+Pts-1) = Data(:,7+(k-1)*7);
        tech.Cgd(k, idx:idx+Pts-1) = Data(:,8+(k-1)*7);   
    end
    
    idx = idx + Pts;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculations in normalized design space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:length(DeviceNames) 
    tech.gmId(k,:) = tech.gm(k,:) ./ tech.Id(k,:);
    tech.gmro(k,:) = tech.gm(k,:) ./ tech.gds(k,:);
    tech.Vov(k,:) = abs(tech.Vgs(k,:)) - abs(tech.Vt(k,:));
    tech.fT(k,:) = 1/(2*pi) .* tech.gm(k,:) ./ tech.Cgg(k,:);
    tech.IdW(k,:) = tech.Id(k,:) ./ tech.W(k,:);
    
    X1 = tech.Cgd(k,:) ./ tech.Cgg(k,:);
    X2 = tech.Cdb(k,:) ./ tech.Cgg(k,:);
    
    % Extrinsic capacitances
    for i = 1:length(tech.L(k,:))
        Cgd(k,i) = lookup(tech.L(k,i), tech.L(k,:), 10, tech.gmId(k,:), X1);
        Cdd(k,i) = lookup(tech.L(k,i), tech.L(k,:), 10, tech.gmId(k,:), X2);
    end
end

save(fTechName, 'tech');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numL = length(unique(tech.L(1,:)));
Pts = length(tech.L(1,:))/numL;
Lengths = tech.L(1, 1:Pts:end);
strLegend = cellstr(num2str(Lengths', 'L=%0.02f'));

for k = 1:length(tech.DeviceNames)
    strName = tech.DeviceNames{k};
    figure('Name', sprintf('Intrinsic Gain - %s', strName), 'NumberTitle', 'off');
    plot(reshape(tech.gmId(k,:),[Pts numL]), reshape(tech.gmro(k,:), [Pts numL]), 'LineWidth', 2);
    set(gca, 'FontSize', 8, 'FontName', 'Arial', 'FontWeight', 'Bold', ...
        'Box', 'Off', 'TickDir', 'out', 'XMinorTick', 'on', 'YMinorTick', 'on');
    xlabel('g_m/I_d [S/A]', 'FontSize', 10, 'FontName', 'Arial', 'FontWeight', 'Bold');
    ylabel('g_m/g_o [S/S]', 'FontSize', 10, 'FontName', 'Arial', 'FontWeight', 'Bold');
    legend(strLegend, 'Location', 'NorthEast', 'Interpreter', 'none');
    
    figure('Name', sprintf('Current Density - %s', strName), 'NumberTitle', 'off');
    semilogy(reshape(tech.gmId(k,:),[Pts numL]), reshape(tech.IdW(k,:),[Pts numL]), 'LineWidth', 2);
    set(gca, 'FontSize', 10, 'FontName', 'Arial', 'FontWeight', 'Bold', ...
        'Box', 'Off', 'TickDir', 'out', 'XMinorTick', 'on', 'YMinorTick', 'on');
    xlabel('g_m/I_d [S/A]', 'FontSize', 10, 'FontName', 'Arial', 'FontWeight', 'Bold');
    ylabel('I_d/W [A/m]', 'FontSize', 10, 'FontName', 'Arial', 'FontWeight', 'Bold');
    legend(strLegend, 'Location', 'NorthEast', 'Interpreter', 'none');

    figure('Name', sprintf('Transit Frequency - %s', strName), 'NumberTitle', 'off');
    plot(reshape(tech.gmId(k,:),[Pts numL]), reshape(tech.fT(k,:),[Pts numL])./1e9, 'LineWidth', 2);
    set(gca, 'FontSize', 10, 'FontName', 'Arial', 'FontWeight', 'Bold', ...
        'Box', 'Off', 'TickDir', 'out', 'XMinorTick', 'on', 'YMinorTick', 'on');
    xlabel('g_m/I_d [S/A]', 'FontSize', 10, 'FontName', 'Arial', 'FontWeight', 'Bold');
    ylabel('f_T [GHz]', 'FontSize', 10, 'FontName', 'Arial', 'FontWeight', 'Bold');
    legend(strLegend, 'Location', 'NorthEast', 'Interpreter', 'none');

    figure('Name', sprintf('FoM - %s', strName), 'NumberTitle', 'off');
    plot(reshape(tech.gmId(k,:),[Pts numL]), reshape(tech.gmId(k,:) .* tech.fT(k,:) ./1e9,[Pts numL]), 'LineWidth', 2);
    set(gca, 'FontSize', 10, 'FontName', 'Arial', 'FontWeight', 'Bold', ...
        'Box', 'Off', 'TickDir', 'out', 'XMinorTick', 'on', 'YMinorTick', 'on');
    xlabel('g_m/I_d [S/A]', 'FontSize', 10, 'FontName', 'Arial', 'FontWeight', 'Bold');
    ylabel('g_m/I_d*f_T [S/A*GHz]', 'FontSize', 10, 'FontName', 'Arial', 'FontWeight', 'Bold');
    legend(strLegend, 'Location', 'NorthEast', 'Interpreter', 'none');
 end