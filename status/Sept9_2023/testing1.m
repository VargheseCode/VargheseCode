clc %clears the command window
clear %clears the workspace variables

table_of_subjects = readtable('Testing_subjects_Ess.xlsx') %reads an excel file, Testing_subjects.xlsx, and converts data into a table
subject_matrix = table2cell([table_of_subjects]) %converts the table into cell array, and puts into variable subject_matrix
nostim = [subject_matrix(1:end,1)] %lists all of the nostim files
stim = [subject_matrix(1:end,2)] %lists all of the stim files

location_array = [subject_matrix(1:end,3)]
mci_status = [subject_matrix(1:end,4)]

subject_identifier = [string()];

for i = 1:length(nostim)
    % car = char(nostim(i))
    % subject_identifier(i) = [strcat(extractBefore(char(nostim(i)),3)), char(location_array(i)), char(mci_status(i))]
    subject_identifier(i) = [sprintf("%s     %s     %s", extractBefore(char(nostim(i)),3), char(location_array(i)), char(mci_status(i)))]
end 

% list = {'Red','Yellow','Blue', 'Green','Orange','Purple'};
[indx,tf] = listdlg('ListString',subject_identifier);

selected_subjects = [nostim(indx), stim(indx), location_array(indx), mci_status(indx)]

for i = 1:numel(selected_subjects(:,1)) %creates for loop for the length of nostim files
    load(strcat("C:\Users\alexv\Box\Lab work\Alex Varghese\NoStim_files\", selected_subjects(i,1))) %loads each file using string concatentation    
    gotrials = trials([trials.BlockType] =="GNG"); %indexes trials with GNG Blocktype
    gotrials = gotrials([gotrials.Condition] == "GO"); %indexes trials with GO Condition 
    gotrials = gotrials([gotrials.ACC] == 1); %indexes trials with 1 Accuracy
    nostim_RT(i) = mean([gotrials.RT]); %averages the correct go reaction time for each trial and puts into array
    nostim_far(i) = sum([trials.Condition] == "NOGO" & [trials.ACC] == 0)/sum([trials.Condition] == "NOGO"); %finds the commission error for each trial and puts into array
end 


for i = 1:numel(selected_subjects(:,2)) %same thing as above but with stim files 
    load(strcat("C:\Users\alexv\Box\Lab work\Alex Varghese\Stim_files\", selected_subjects(i,2)))
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
savefig('Test3'); %saves figure with that name

figure(2)
X = [nostim_ticks; stim_ticks]; %lists the amount of data sets, 1 stands for nonstim, 2 stands for stim
Y = [nostim_far;stim_far]; % assigns the Y-value(reaction time) to each x
plot(X,Y,'k') %plots x and y in black colors "k"
title("Average Commission Error: All") %creates title 
xlim([0 3]) % limits the x axis
% ylim([540 820]) % limits the y axis 
xticks([1 2]) % creates tick marks to label
xticklabels({"NoStim", "Stim"}) % labels 1 and 2 with nostim and stim 
savefig('Test4'); %saves figure with that name

p = anova1(nostim_RT,location_array(indx))
ap = anova1(nostim_RT,mci_status(indx))