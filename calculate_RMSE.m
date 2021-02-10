Nc = 200;   % Number of cell
tlength = 5000; % Duration of data
num_iteration = 100;  % number of iterations
percentCell = 0.25; % percent of cells to be stimulated
total_RMSE_all = [];
total_RMSE_High_E = [];
total_RMSE_Mild_E = [];
total_RMSE_High_I = [];
total_RMSE_Mild_I = [];
total_RMSE_notConnected = [];

for k = 4:4
    stim_duration = 50*k; % time duration of each stimulation
    for num_stimulations = 1:15 %number of stimulations
        load('DATA\conmat_stimulations.mat');
        load(['DATA\',num2str(num_stimulations),'times_of_stimulation_',num2str(stim_duration),'ms_stim',num2str(percentCell*100),'%_wm_perc_withFunction',int2str(Nc),'c_',int2str(tlength),'s_iteration100.mat'])
        
        %         corrvec = corrvec_stim;
        %         corrvec(:,1:Nc*0.34)=corrvec_not_silent;
        index_not_in_cutoff = find(isnan(corrvec));
        
        for i = 1:num_iteration
            w = matrix_w(:,i);
            conmat_w = [conmat, w]; % for all cells(conmat + guessed weights)
            conmat_w(index_not_in_cutoff,:) = []; %delete elements that not make the cutoff
            index_Excitory = find(conmat_w(:,1)>0); %index of excitory cells
            index_High_E = find(conmat_w(:,1)>4);
            index_Mild_E = find(conmat_w(:,1)>0 & conmat_w(:,1)<4);
            
            index_High_I = find(conmat_w(:,1)<-4);%index of inhibitory cells
            index_Mild_I = find(conmat_w(:,1)<0 & conmat_w(:,1)>-4 );
            index_notConnected = find(conmat_w(:,1)==0);
            
            conmat_w_High_E = conmat_w(index_High_E,:); %for excitory cells (conmat + guessed weights)
            conmat_w_Mild_E = conmat_w(index_Mild_E,:);
            
            conmat_w_High_I = conmat_w(index_High_I,:); %for inhibitory cells(conmat + guessed weights)
            conmat_w_Mild_I = conmat_w(index_Mild_I,:);
            conmat_w_notConnected = conmat_w(index_notConnected,:);
            
            %calculate RMSE for all groups of cells
            %RMSE_all = sqrt(mean((conmat_w(:,1)-conmat_w(:,2)).^2));
            D_all =  conmat_w(:,1)- conmat_w(:,2);
            SQE_all = D_all.^2;
            MSE_all = mean(SQE_all(:));
            RMSE_all = sqrt(MSE_all);
            
            D_High_E =  conmat_w_High_E(:,1)- conmat_w_High_E(:,2);
            SQE_High_E = D_High_E.^2;
            MSE_High_E = mean(SQE_High_E(:));
            RMSE_High_E = sqrt(MSE_High_E);
            
            D_Mild_E =  conmat_w_Mild_E(:,1)- conmat_w_Mild_E(:,2);
            SQE_Mild_E = D_Mild_E.^2;
            MSE_Mild_E = mean(SQE_Mild_E(:));
            RMSE_Mild_E = sqrt(MSE_Mild_E);
            
            D_High_I =  conmat_w_High_I(:,1)- conmat_w_High_I(:,2);
            SQE_High_I = D_High_I.^2;
            MSE_High_I = mean(SQE_High_I(:));
            RMSE_High_I = sqrt(MSE_High_I);
            
            D_Mild_I =  conmat_w_Mild_I(:,1)- conmat_w_Mild_I(:,2);
            SQE_Mild_I = D_Mild_I.^2;
            MSE_Mild_I = mean(SQE_Mild_I(:));
            RMSE_Mild_I = sqrt(MSE_Mild_I);
            
            D_notConnected =  conmat_w_notConnected(:,1)- conmat_w_notConnected(:,2);
            SQE_notConnected = D_notConnected.^2;
            MSE_notConnected = mean(SQE_notConnected(:));
            RMSE_notConnected = sqrt(MSE_notConnected);
            
            total_RMSE_all(i) = RMSE_all;
            total_RMSE_High_E(i) =  RMSE_High_E;
            total_RMSE_Mild_E(i) =  RMSE_Mild_E;
            total_RMSE_High_I(i) = RMSE_High_I;
            total_RMSE_Mild_I(i) = RMSE_Mild_I;
            total_RMSE_notConnected (i)=  RMSE_notConnected;
        end
        total_RMSE = [total_RMSE_all; total_RMSE_High_E; total_RMSE_Mild_E;total_RMSE_High_I;total_RMSE_Mild_I;total_RMSE_notConnected];
        save(['DATA\RMSE_',num2str(stim_duration),'ms_stim25_',num2str(num_stimulations),'stims.mat'],'total_RMSE');
    end
end
