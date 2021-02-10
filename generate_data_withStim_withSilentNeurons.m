function [] = generate_data_withStim_withSilentNeurons(Nc,tlength,percentCell,num_stimulations,stim_duration)
%parameters
sthresh = 20; %threshold
Nc_conE = 80; %excitatory cells
Nc_conI = 20; %inbihitory cells
pspike = 1/50; %probability of fire
wmax = 8; %max weight
silentNeurons = 0.66; %percent of silent neurons

%      load conectivity matrix
load('DATA\conmat_stimulations');

%initially all cells
spike_pre = false(1000,Nc,tlength);
spike_post = false(1000,tlength);

%silent cells
B = [0];
silent_cells = repmat(B, 1000, Nc*silentNeurons);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  with in the period of stimulations
for kkk = 1 : num_stimulations
    r = randStim_array(kkk,:);
    for ti = (1+(kkk -1)*60):60*kkk
        x = (rand(1000,Nc)<pspike); %spike matrix
        x(:,(Nc*(1 -silentNeurons)+1):Nc) = silent_cells; %generate silent neurons
        %stimulate
        for cell = 1:Nc*percentCell
            t = randperm(stim_duration,3*stim_duration/50);%rand index of miliseconds
            x(t,r(cell)) = 1;
        end
        %fire of silent neurons
        if(rem(ti,60) == 0)
            for index = (Nc*(1-silentNeurons)+1):Nc
                x(randperm(1000,1),index) = 1;
            end
        end
        spike_pre(:,:,ti) = x;
        spike_post(:,ti) = (x*conmat)>sthresh; %master ecll reveive signals from all cesll
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% time with no stimulations
for ti = (1+60*num_stimulations):tlength
    x = (rand(1000,Nc)<pspike); %spike matrix
    x(:,(Nc*(1 -silentNeurons)+1):Nc) = silent_cells; %generate silent neurons
    %fire of silent neurons
    if(rem(ti,60) == 0)
        for index = (Nc*(1-silentNeurons)+1):Nc
            x(randperm(1000,1),index) = 1;
        end
    end
    spike_pre(:,:,ti) = x;
    spike_post(:,ti) = (x*conmat)>sthresh; %master ecll reveive signals from all cesll
end

save(['DATA\',num2str(num_stimulations),'times_of_stimulation_',num2str(stim_duration),'ms_stim',num2str(percentCell*100),'%_data_',int2str(Nc),'c_',int2str(tlength),'s_.mat'],'spike_pre','spike_post','conmat')
 end

