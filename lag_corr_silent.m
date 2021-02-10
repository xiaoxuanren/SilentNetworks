function [] = lag_corr(Nc,tlength,percentCell,num_stimulations,stim_duration)
maxlag = 50;
load('DATA\conmat_stimulations');
load(['DATA\',num2str(num_stimulations),'times_of_stimulation_',num2str(stim_duration),'ms_stim',num2str(percentCell*100),'%_data_',int2str(Nc),'c_',int2str(tlength),'s_.mat']);
corrvec_stim = [];
randstim_array = randStim_array(1:num_stimulations,:);
intermediate =  zeros(2*maxlag+1,1,Nc);

for num_index = 1:size(randstim_array,1) % enter the loop of [times fo stimulations]       
    for index_array =1:length( randstim_array(num_index,:)) %enter the loop of [cells being stimulated in the stimulation]
        j = randstim_array(num_index, index_array); %cell number
        x = zeros(2*maxlag+1,1); %zero matrixs for cell j in this minute
        for k = (1 + 60*(num_index - 1)):60*num_index %loop through recording time
            ypre = spike_pre(1:stim_duration,j,k);
            ypost = spike_post(1:stim_duration,k);
            [x2,lags] = xcorr(ypost,ypre,maxlag);
            x = x+x2;
        end
        intermediate(:,:,j) = intermediate(:,:,j)+x; %sum of x for each stimulation
    end
end

for cell = 1:size(intermediate,3)
    p = intermediate(:,:,cell);
    m1 = mean(p([1:maxlag,(maxlag+2):end]));
    s2 = std(p([1:maxlag,(maxlag+2):end]));
    corrvec_stim(cell) = (p(maxlag+1)-m1)/s2;
end

save(['DATA\',num2str(num_stimulations),'times_of_stimulation_',num2str(stim_duration),'ms_stim',num2str(percentCell*100),'%_lagcorr_silent_',int2str(Nc),'c_',int2str(tlength),'s.mat'],'corrvec_stim')




