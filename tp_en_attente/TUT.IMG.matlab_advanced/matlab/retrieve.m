% I closed matlab, thus, I have to get back the variables and arrays
% as well as the job.

% jm: job monitor
jm = findResource('scheduler','type','pbspro')

% job
j= findJob(jm, 'Name', 'toto');

% Ici, nous allons attendre la fin du job.
% We make sure the job has finished
waitForState(j,'finished');

%% get back all the results
data=getAllOutputArguments(j);
data{1:35}

%% destroy the findJob
% this is mandatory, you have to destroy the job
% otherwise, it will remain for ever
destroy(j);

% end of program
% exit
