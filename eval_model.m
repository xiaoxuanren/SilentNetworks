function perf = eval_model(spike_pre,spike_post,w)
	sthresh = 20;
	spike_post_m = false(size(spike_post));
	for t = 1:size(spike_post,2)
		x = squeeze(spike_pre(:,:,t));
		spike_post_m(:,t) = (x*w)>sthresh;
	end
	if (length(find(spike_post_m==1))==0) || (length(find(spike_post==1))==0)
		if (length(find(spike_post_m==1))==0) && (length(find(spike_post==1))==0)
			perf = 1;
		else
			perf = 0;
		end
	else
		perf = length(find(and(spike_post_m,spike_post)==1))/length(find(spike_post==1))+...
			length(find(and(spike_post_m,spike_post)==1))/length(find(spike_post_m==1));
		perf = perf/2;
	end
end






