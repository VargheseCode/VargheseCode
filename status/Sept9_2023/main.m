clear
clc
subject21 = subjectAnalyzed("Subject25", "C:\Users\alexv\Box\Lab work\Alex Varghese\Stim_files\", "25task5_taskdata.mat")

subject21.strtrials = load('C:\Users\alexv\Box\Lab work\Alex Varghese\NoStim_files\25task3_taskdata.mat')

strcorrectTrials = trials([subject21.strtrials.trials.BlockType] == "GNG");


% gotrials = trials([trials.BlockType] =="GNG"); %indexes trials with GNG Blocktype
% gotrials = trials([trials.BlockType] =="GNG"); %indexes trials with GNG Blocktype
% gotrials = gotrials([gotrials.Condition] == "GO"); %indexes trials with GO Condition
% gotrials = gotrials([gotrials.ACC] == 1); %indexes trials with 1 Accuracy
% nostim_RT(i) = mean([gotrials.RT]); %averages the correct go reaction time for each trial and puts into array
% nostim_far(i) = sum([trials.Condition] == "NOGO" & [trials.ACC] == 0)/sum([trials.Condition] == "NOGO"); %finds the commission error for each trial and puts into array