 clear all; close all;
% stimulate the network from 50ms up to 1 second, with iteration of 1 to 10

%PARAMETERS
Nc = 200;   % total number of pre-synaptic neurons
tlength = 5000; % recording duration 5000 seconds

%CONSTANTS
silentNeurons = 0.66; %percent of silent neurons
num_iteration = 100;  % number of iterations 
num_stimulations = 15; %number of stimulations
percentCell = 0.25; % percent of cells to be stimulated in each stimulation
Nc_conE = 80; % number of excitatory neurons
Nc_conI = 20; % number of inhibitory nuerons
wmax = 8; % maximum weight 

% GENERATE CONNECTIVITY MATRIX
generate_conmat_and_randStim_array(Nc,percentCell,num_stimulations,Nc_conE,Nc_conI,wmax);

% STIMULATION AND DERIVIATION.
for k = 4
    stim_duration = 50*k; % time duration of each stimulation
    for num_stimulations = 15:15 %number of stimulations
        generate_data_withStim_withSilentNeurons(Nc,tlength,percentCell,num_stimulations,stim_duration);
        lag_corr(Nc,tlength,percentCell,stim_duration,num_stimulations);
        lag_corr_silent(Nc,tlength,percentCell,num_stimulations,stim_duration);
        fit_weights_perceptron(Nc,tlength,num_iteration,percentCell,stim_duration,num_stimulations);
    end
end

%View raster plot
load(['DATA\',num2str(num_stimulations),'times_of_stimulation_200ms_stim25%_data_',num2str(Nc),'c_',num2str(tlength),'s_.mat',], 'spike_pre');
  figure;
imshow(spike_pre(:,:,450)');
title('action potentials fired during the 450th second of recording, silent 66% cells, stimulate 25% cells');
xlabel('milliseconds');
ylabel('cells');
axis on      
    