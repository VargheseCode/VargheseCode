% fig = uifigure('Position', [100 100 300 250]);
% lbx = uilistbox(fig);
% % multi = lbx.Multiselect
% 
% lbx.Multiselect = 'on';

clc %clears the command window
clear %clears the workspace variables

table_of_subjects = readtable('Testing_subjects_Ess.xlsx') %reads an excel file, Testing_subjects.xlsx, and converts data into a table

subject_matrix = table2cell([table_of_subjects]) %converts the table into cell array, and puts into variable subject_matrix

nostim = [subject_matrix(1:end,1)] %lists all of the nostim files
stim = [subject_matrix(1:end,2)] %lists all of the stim files


for i = 1:numel(nostim) %creates for loop for the length of nostim files
    load(strcat("C:\Users\alexv\Box\Lab work\Alex Varghese\EssentialTremor\NOSTIM\", nostim{i})) %loads each file using string concatentation    
    gotrials = trials([trials.BlockType] =="GNG"); %indexes trials with GNG Blocktype
    gotrials = gotrials([gotrials.Condition] == "GO"); %indexes trials with GO Condition 
    gotrials = gotrials([gotrials.ACC] == 1); %indexes trials with 1 Accuracy
    nostim_RT(i) = mean([gotrials.RT]); %averages the correct go reaction time for each trial and puts into array
    nostim_far(i) = sum([trials.Condition] == "NOGO" & [trials.ACC] == 0)/sum([trials.Condition] == "NOGO"); %finds the commission error for each trial and puts into array
end 


for i = 1:numel(stim) %same thing as above but with stim files 
    load(strcat("C:\Users\alexv\Box\Lab work\Alex Varghese\EssentialTremor\STIM\", stim{i}))
    gotrials = trials([trials.BlockType] =="GNG");
    gotrials = gotrials([gotrials.Condition] == "GO");
    gotrials = gotrials([gotrials.ACC] == 1);
    stim_RT(i) = mean([gotrials.RT]);
    stim_far(i) = sum([trials.Condition] == "NOGO" & [trials.ACC] == 0)/sum([trials.Condition] == "NOGO");
end 

sz = size(stim_RT)
nostim_ticks = ones(sz)
stim_ticks = ones(sz) + 1

figure(1)
X = [nostim_ticks; stim_ticks]; %lists the amount of data sets, 1 stands for nonstim, 2 stands for stim
Y = [nostim_RT;stim_RT]; % assigns the Y-value(reaction time) to each x
plot(X,Y,'k') %plots x and y in black colors "k"
title("Average RT: All") %creates title 
xlim([0 3]) % limits the x axis
ylim([540 820]) % limits the y axis 
xticks([1 2]) % creates tick marks to label
xticklabels({"NoStim", "Stim"}) % labels 1 and 2 with nostim and stim 
savefig('Test'); %saves figure with that name

figure(2)
X = [nostim_ticks; stim_ticks]; %lists the amount of data sets, 1 stands for nonstim, 2 stands for stim
Y = [nostim_far;stim_far]; % assigns the Y-value(reaction time) to each x
plot(X,Y,'k') %plots x and y in black colors "k"
title("Average Commission Error: All") %creates title 
xlim([0 3]) % limits the x axis
% ylim([540 820]) % limits the y axis 
xticks([1 2]) % creates tick marks to label
xticklabels({"NoStim", "Stim"}) % labels 1 and 2 with nostim and stim 
savefig('Test1'); %saves figure with that name

