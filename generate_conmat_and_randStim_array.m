function [conmat,randStim_array] = generate_conmat_and_randStim_array(Nc,percentCell,num_stim,Nc_conE,Nc_conI,wmax)

%generate connectivity matrix
conmat = generate_conmat(Nc,Nc_conE,Nc_conI,wmax);

%generate index of neurons to be randomly stimulated 
randStim_array = [];% index of nuerons being stimulated
for i = 1:num_stim
    randStim_array(i,:)= randperm(Nc,Nc*percentCell);
end
save('DATA\conmat_stimulations.mat','conmat','randStim_array');
end


