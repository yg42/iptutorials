%% First distributed code with matlab
% This code is the base to introduce the parallel computation with matlab.
%
% 1 job is created, containing several tasks. Each task is dispatched
% on the different machines. The myRand.m function is used as an illustration.

%% Connection to the job manager
% The cluster uses a job manager (PBS). We must inform matlab to use it,
% and also what to tell it.

% jm: job monitor
jm = findResource('scheduler','type','pbspro')

% location of the datas, computed and shared by the tasks.
set(jm, 'DataLocation', '/home/yann/matlab/');

% You can specify that the file system is shared between the nodes.
% matlab avoids to replicate all the datas.
set(jm, 'HasSharedFilesystem', true);

% This is the configuration of the CIS cluster golgoth:
% it specifies where to find the matlab executables.
set(jm, 'ClusterMatlabRoot', '/appli/share/matlab');

% Configuration of EACH TASK of the PBS job:
% you can add everything you would have added in a PBS script.
% ncpus: use 1 cpu
% walltime: total time used
% matlabDCE: the most important resource, when you request one licence token.
% mem=1gb: request for 1 gb memory per process
set(jm, 'resourcetemplate', '-l ncpus=1,walltime=00:10:00,matlabDCE=1');

%% Structure of the Job Manager
% get(jm)

%% Create a job
% A job is constituted of several tasks. Each task will be an independant process.
job = jm.createJob;

% Set the name of the job for more fun!
set(job, 'Name', 'toto');

%% Add the local (personnal) path to the different tasks.
% It is to be preferred to set(job, 'FileDependencies',...)
% because it does not copy all the files over the different nodes
myPath = {'/home/yann/matlab'};
set(job, 'PathDependencies', myPath);

%% Structure of the job
get(job)

% You can get the methods of the job.
% methods(job)

%% Creation of the tasks
%  The tasks are independant processes. Each task (in this case)
% will generate a random square matrix.
% Put whatever you want in these lines.
%
% Warning: the maximum running tasks number depends on the number of licences (32).
% Matlab does not deal efficiently with the licences (an error occurs), this is why
% PBS is (shoud be) configured to handle them (with matlabDCE resource).
for lp=1:35,
    % @myRand : function to be executed
    % 1       : number of arguments of the function
    % {...}   : arguments
  task(lp)=job.createTask(@myRand,1,{lp});
end

%% Submit the job
% Matlab can directly send the job to PBS.
% It is equivalent to the shell command qsub.
submit(job);

% Then, it is the responsability of PBS to start the job.

%% You can wait !
% Now, this script can be stopped. You can exit matlab, take a nap, have some coffee
% and come back later to get the results.

exit

% The results will be retrieved in the next program.