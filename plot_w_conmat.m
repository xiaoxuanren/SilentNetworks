
%Plot conmat VS derived weights

tlength = 500; %recording duration
Nc = 200; %number of neurons
percentCell = 0.25;
num_of_iterations = 100;
silent = 0.66;
figure('position', [0, 0, 200, 200]);
for k = 4:4%
    stim_duration = 50*k; % time duration of each stimulation
    for num_stimulations = 1:1%number of stimulations
        load('DATA\conmat_stimulations.mat');
        load(['DATA\',num2str(num_stimulations),'times_of_stimulation_',num2str(stim_duration),'ms_stim',num2str(percentCell*100),'%_wm_perc_withFunction',int2str(Nc),'c_',int2str(tlength),'s_iteration',int2str(num_of_iterations),'.mat']);
             w = matrix_w(:,100);
            
            index_active = 1:Nc*(1-silent)+1;
            index_silent = round((Nc*(1-silent)+1):Nc);
            index_stim = randStim_array(num_stimulations,:);
            index_not_connected = find(conmat ==0);
            index_connected = find(conmat ~=0);
            
            index_stim_connected = intersect(index_stim,index_connected);
            index_stim_notConnected = intersect(index_not_connected,index_stim);
            index_stim_active = intersect(index_stim, index_active);
            index_stim_silent = intersect(index_stim, index_silent);
            
            index_not_stim_connected = round(setdiff(index_connected, index_stim_connected));
            index_not_stim_connected_active = intersect(index_not_stim_connected, index_active);
            index_not_stim_connected_silent = intersect(index_not_stim_connected, index_silent);
            
            index_not_stim_not_connected = round(setdiff(index_not_connected, index_stim_notConnected));
            index_not_stim_not_connected_active = intersect(index_not_stim_not_connected, index_active);
            index_not_stim_not_connected_silent = intersect(index_not_stim_not_connected, index_silent);
            hold on;

            plot(conmat(index_not_stim_connected_active),w(index_not_stim_connected_active),'<','Color','b'); 
            plot(conmat(index_not_stim_connected_silent),w(index_not_stim_connected_silent),'<','Color',[0.5 0.5 0.5]); 
            plot(conmat(index_not_stim_not_connected_active),w(index_not_stim_not_connected_active),'o','Color','b'); 
            plot(conmat(index_not_stim_not_connected_silent),w(index_not_stim_not_connected_silent),'o','Color',[0.5 0.5 0.5]); 
            plot(conmat(index_stim_connected),w(index_stim_connected),'<','Color','r'); 
            plot(conmat(index_stim_notConnected),w(index_stim_notConnected),'o','Color','r');
            hold off;
           xlabel('actual weight');
           ylabel('derived weight');
        end
    end





