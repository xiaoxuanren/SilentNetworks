function [] = lag_corr(Nc,tlength,percentCell,stim_duration,num_stimulations)
maxlag = 50;
load(['DATA\',num2str(num_stimulations),'times_of_stimulation_',num2str(stim_duration),'ms_stim',num2str(percentCell*100),'%_data_',int2str(Nc),'c_',int2str(tlength),'s_.mat']);
corrvec_not_silent = [];

for j = 1:Nc*0.34
    x = zeros(2*maxlag+1,1);
    for k = 1:tlength
        ypre = spike_pre(:,j,k);
        ypost = spike_post(:,k);
        [x2,lags] = xcorr(ypost,ypre,maxlag);
        x = x+x2;
        
    end
    m1 = mean(x([1:maxlag,(maxlag+2):end]));
    s1 = std(x([1:maxlag,(maxlag+2):end]));
    corrvec_not_silent(j) = (x(maxlag+1)-m1)/s1;
end
save(['DATA\',num2str(num_stimulations),'times_of_stimulation_',num2str(stim_duration),'ms_stim',num2str(percentCell*100),'%_lagcorr_',int2str(Nc),'c_',int2str(tlength),'s.mat'],'corrvec_not_silent')




