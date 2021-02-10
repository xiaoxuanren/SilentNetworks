function [w,performance] = fit_weights_perceptron(Nc,tlength,num_of_iterations,percentCell,stim_duration,num_stimulations)
	w = zeros(Nc,1);
	Niter = num_of_iterations;
	lr = 1e-2;
	sthresh = 20;
	wrange = 10;
	load(['DATA\',num2str(num_stimulations),'times_of_stimulation_',num2str(stim_duration),'ms_stim',num2str(percentCell*100),'%_data_',int2str(Nc),'c_',int2str(tlength),'s_.mat']);
    load(['DATA\',num2str(num_stimulations),'times_of_stimulation_',num2str(stim_duration),'ms_stim',num2str(percentCell*100),'%_lagcorr_',int2str(Nc),'c_',int2str(tlength),'s.mat']);
    load(['DATA\',num2str(num_stimulations),'times_of_stimulation_',num2str(stim_duration),'ms_stim',num2str(percentCell*100),'%_lagcorr_silent_',int2str(Nc),'c_',int2str(tlength),'s.mat']);
    corrvec = corrvec_stim;
    corrvec(:,1:Nc*0.34)=corrvec_not_silent;  
    
%     [low, high] = find_cutoff(corrvec,Nc);
   
	inds_pre_i = find(corrvec < 0 | corrvec ==0);
	inds_pre_e = find(corrvec > 0);
	inds_pre = union(inds_pre_i,inds_pre_e);

    Npre = length(inds_pre);
	i_mid = round(tlength/2);   
        
	train_pre = spike_pre(:,inds_pre,1:i_mid);
	train_post = spike_post(:,1:i_mid);
	test_pre = spike_pre(:,inds_pre,(i_mid+1):end);
	test_post = spike_post(:,(i_mid+1):end);
	wm = wrange*(-1 + 2*rand(Npre,1));
	performance = zeros(Niter,1);
    matrix_w = zeros(Nc,Niter);
    
	for i=1:Niter
		for k=1:size(train_post,2)
			for j=1:size(train_post,1)
				x = squeeze(train_pre(j,:,k));
				ym = (x*wm)>sthresh;
				err = train_post(j,k) - ym;
				inds = find(x == 1);
				wm(inds) = wm(inds) + lr*err;
			end
		end
		performance(i) = round(eval_model(test_pre,test_post,wm),3);
		disp(['iteration ',int2str(i),': ',num2str(performance(i))])
		w(inds_pre) = wm;
        matrix_w(:,i) = w;
	 end
    save(['DATA\',num2str(num_stimulations),'times_of_stimulation_',num2str(stim_duration),'ms_stim',num2str(percentCell*100),'%_wm_perc_withFunction',int2str(Nc),'c_',int2str(tlength),'s_iteration',int2str(num_of_iterations),'.mat'],'matrix_w','performance','corrvec')    

end
