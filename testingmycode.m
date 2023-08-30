clc %clears the command window
clear %clears the workspace variables

table_of_subjects = readtable('Testing_subjects.xlsx') %reads an excel file, Testing_subjects.xlsx, and converts data into a table

subject_matrix = table2cell([table_of_subjects]) %converts the table into cell array, and puts into variable subject_matrix

nostim = [subject_matrix(1:end,1)] %lists all of the nostim files
stim = [subject_matrix(1:end,2)] %lists all of the stim files

for i = 1:numel(nostim) %creates for loop for the length of nostim files
    load(strcat("C:\Users\alexv\Box\Lab work\Alex Varghese\NoStim_files\", nostim{i})) %loads each file using string concatentation    
    gotrials = trials([trials.BlockType] =="GNG"); %indexes trials with GNG Blocktype
    gotrials = gotrials([gotrials.Condition] == "GO"); %indexes trials with GO Condition 
    gotrials = gotrials([gotrials.ACC] == 1); %indexes trials with 1 Accuracy
    nostim_RT(i) = mean([gotrials.RT]); %averages the correct go reaction time for each trial and puts into array
    nostim_far(i) = sum([trials.Condition] == "NOGO" & [trials.ACC] == 0)/sum([trials.Condition] == "NOGO"); %finds the commission error for each trial and puts into array
end 


for i = 1:numel(stim) %same thing as above but with stim files 
    load(strcat("C:\Users\alexv\Box\Lab work\Alex Varghese\Stim_files\", stim{i}))
    gotrials = trials([trials.BlockType] =="GNG");
    gotrials = gotrials([gotrials.Condition] == "GO");
    gotrials = gotrials([gotrials.ACC] == 1);
    stim_RT(i) = mean([gotrials.RT]);
    stim_far(i) = sum([trials.Condition] == "NOGO" & [trials.ACC] == 0)/sum([trials.Condition] == "NOGO");
end 

% all subjects
matrix_RT = [nostim_RT(1,:); stim_RT(1,:)] %creates matrix with nostim and stim in each row for reaction time 
matrix_FAR = [nostim_far(1,:); stim_far(1,:)] %creates matrix with nostim and stim in each row for commission error

% creates a matrix for each condition (MCI, nonMCI, GPI, STN)
MCI_subjects = [matrix_RT(1,2), matrix_RT(1,3), matrix_RT(1,4), matrix_RT(1,7); matrix_RT(2,2), matrix_RT(2,3), matrix_RT(2,4), matrix_RT(2,7)]
MCI_far = [matrix_FAR(1,2), matrix_FAR(1,3), matrix_FAR(1,4), matrix_FAR(1,7); matrix_FAR(2,2), matrix_FAR(2,3), matrix_FAR(2,4), matrix_FAR(2,7)]
non_MCI_subjects = [matrix_RT(1,1), matrix_RT(1,8), matrix_RT(1,5), matrix_RT(1,6), matrix_RT(1,9), matrix_RT(1,10), matrix_RT(1,12); matrix_RT(2,1), matrix_RT(2,8), matrix_RT(2,5), matrix_RT(2,6), matrix_RT(2,9), matrix_RT(2,10), matrix_RT(2,12)]
non_MCI_far = [matrix_FAR(1,1), matrix_FAR(1,8), matrix_FAR(1,5), matrix_FAR(1,6), matrix_FAR(1,9), matrix_FAR(1,10), matrix_FAR(1,12); matrix_FAR(2,1), matrix_FAR(2,8), matrix_FAR(2,5), matrix_FAR(2,6), matrix_FAR(2,9), matrix_FAR(2,10) matrix_FAR(2,12)]
STN_subjects = [matrix_RT(1,8), matrix_RT(1,10), matrix_RT(1,9); matrix_RT(2,8), matrix_RT(2,10), matrix_RT(2,9)]
STN_far = [matrix_FAR(1,8), matrix_FAR(1,10), matrix_FAR(1,9); matrix_FAR(2,8),  matrix_FAR(2,10), matrix_FAR(2,9)]
GPi_subjects = [matrix_RT(1,1), matrix_RT(1,2), matrix_RT(1,3), matrix_RT(1,4), matrix_RT(1,5), matrix_RT(1,6), matrix_RT(1,7), matrix_RT(1,12); matrix_RT(2,1), matrix_RT(2,2), matrix_RT(2,3), matrix_RT(2,4), matrix_RT(2,5), matrix_RT(2,6), matrix_RT(2,7), matrix_RT(2,12)]
GPi_far = [matrix_FAR(1,1), matrix_FAR(1,2), matrix_FAR(1,3), matrix_FAR(1,4), matrix_FAR(1,5), matrix_FAR(1,6), matrix_FAR(1,7), matrix_FAR(1,12); matrix_FAR(2,1), matrix_FAR(2,2), matrix_FAR(2,3), matrix_FAR(2,4), matrix_FAR(2,5), matrix_FAR(2,6), matrix_FAR(2,7), matrix_FAR(2,12)]

%creates table
X = [1 1 1 1 1 1 1 1 1 1 1 1; 2 2 2 2 2 2 2 2 2 2 2 2]; %lists the amount of data sets, 1 stands for nonstim, 2 stands for stim
Y = [matrix_RT(1,:);matrix_RT(2,:)]; % assigns the Y-value(reaction time) to each x
plot(X,Y,'k') %plots x and y in black colors "k"
title("Average Reaction Time: All") %creates title 
xlim([0 3]) % limits the x axis
ylim([500 675]) % limits the y axis 
xticks([1 2]) % creates tick marks to label
xticklabels({"NoStim", "Stim"}) % labels 1 and 2 with nostim and stim 
savefig('Fig1_Average Reaction Time_All'); %saves figure with that name

figure(2)
Y = [matrix_FAR(1,:);matrix_FAR(2,:)]; % assigns the Y-value(reaction time) to each x
plot(X,Y,'k') %plots x and y in black colors "k"
title("Commission Error: All")  %creates title 
xlim([0 3])  % limits the x axis
ylim([-0.05 0.65]) % limits the y axis 
xticks([1 2]) % creates tick marks to label
xticklabels({"NoStim", "Stim"}) % labels 1 and 2 with nostim and stim 
savefig('Fig2_Commission Error_All'); %saves figure with that name


figure(3)
X = [1 1 1 1; 2 2 2 2];
Y = [MCI_subjects(1,:); MCI_subjects(2,:)];
plot(X,Y,'k')
title('Average Reaction Time: MCI Subjects')
xlim([0 3])
ylim([530 670])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('Fig3_Average Reaction Time_MCI Subjects')

figure(4)
Y = [MCI_far(1,:); MCI_far(2,:)];
plot(X,Y,'k')
title('Commission Error: MCI Subjects')
xlim([0 3])
ylim([0.1 0.47])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('Fig4_Commission Error_MCI Subjects')

figure(5)
X = [1 1 1 1 1 1 1; 2 2 2 2 2 2 2];
Y = [non_MCI_subjects(1,:);non_MCI_subjects(2,:)];
plot(X,Y,'k')
title("Average Reaction Time: Non-MCI Subjects")
xlim([0 3])
ylim([335 595])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('Fig5_Average Reaction Time_Non-MCI Subjects')

figure(6)
Y = [non_MCI_far(1,:);non_MCI_far(2,:)];
plot(X,Y,'k')
title("Commission Error: Non-MCI")
xlim([0 3])
ylim([-0.05 0.67])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('Fig6_Commission Error_MCI Subjects')

figure(7)
X = [1 1 1 ; 2 2 2]
Y = [STN_subjects(1,:); STN_subjects(2,:)];
plot(X,Y,'k')
title("Average Reaction Time: STN Subjects")
xlim([0 3])
ylim([335 485])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig7_Average Reaction Time_STN Subjects")

figure(8)
X = [1 1 1; 2 2 2]
Y = [STN_far(1,:); STN_far(2,:)];
plot(X,Y,'k')
title("Commission Error: STN Subjects")
xlim([0 3])
ylim([-0.05 0.63])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig8_Commission Error_MCI Subjects")

figure(9)
X = [1 1 1 1 1 1 1 1; 2 2 2 2 2 2 2 2]
Y = [GPi_subjects(1,:); GPi_subjects(2,:)];
plot(X,Y,'k')
title("Average Reaction Time: GPi Subjects")
xlim([0 3])
ylim([435 675])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig9_Average Reaction Time_GPi Subjects")

figure(10)
X = [1 1 1 1 1 1 1 1; 2 2 2 2 2 2 2 2]
Y = [GPi_far(1,:); GPi_far(2,:)];
plot(X,Y,'k')
title("Commission Error: GPi Subjects")
xlim([0 3])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig10_Commission Error_MCI Subjects")

figure(11)
X = [1 1 1; 2 2 2]
Y = [matrix_RT(1,8), matrix_RT(1,9), matrix_RT(1,10); matrix_RT(2,8), matrix_RT(2,9), matrix_RT(2,10)]
plot(X,Y,'k')
title("Average Reaction Time: STN & NON-MCI Subjects ")
subtitle("STN&MCI do not exist")
xlim([0 3])
ylim([335 490])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig11_Average Reaction Time_STNandNON-MCI Subjects ")

figure(12)
X = [1 1 1; 2 2 2]
Y = [matrix_FAR(1,8), matrix_FAR(1,9), matrix_FAR(1,10); matrix_FAR(2,8), matrix_FAR(2,9), matrix_FAR(2,10)]
plot(X,Y,'k')
title("Commission Error: STN & NON-MCI Subjects ")
subtitle("STN&MCI do not exist")
xlim([0 3])
ylim([-0.03 0.65])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig12_Commission Error_MCI Subjects")

figure(13)
X = [1 1 1 1; 2 2 2 2]
Y = [matrix_RT(1,1), matrix_RT(1,5), matrix_RT(1,6), matrix_RT(1,12); matrix_RT(2,1), matrix_RT(2,5), matrix_RT(2,6), matrix_RT(2,12)]
plot(X,Y,'k')
title("Average Reaction Time: GPi & NON-MCI Subjects")
ylim([440 595])
xlim([0 3])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig13_Average Reaction Time_GPiandNON-MCI Subjects")

figure(14)
X = [1 1 1 1; 2 2 2 2]
Y = [matrix_FAR(1,1), matrix_FAR(1,5), matrix_FAR(1,6), matrix_FAR(1,12); matrix_FAR(2,1), matrix_FAR(2,5), matrix_FAR(2,6), matrix_FAR(2,12)]
plot(X,Y,'k')
title("Commission Error: GPi and Non-MCI")
xlim([0 3])
ylim([0.01 0.30])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig14_Commission Error_MCI Subjects")

figure(15)
X = [1 1 1 1; 2 2 2 2]
Y = [matrix_RT(1,2), matrix_RT(1,3), matrix_RT(1,4) matrix_RT(1,7); matrix_RT(2,2), matrix_RT(2,3), matrix_RT(2,4) matrix_RT(2,7)]
plot(X,Y,'k')
ylim([535 670])
xlim([0 3])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
title("Average Reaction Time: GPi and MCI Subjects")
savefig("Fig15_Average Reaction Time_GPiandMCI Subjects")

figure(16)
X = [1 1 1 1; 2 2 2 2]
Y = [matrix_FAR(1,2), matrix_FAR(1,3), matrix_FAR(1,4) matrix_FAR(1,7); matrix_FAR(2,2), matrix_FAR(2,3), matrix_FAR(2,4) matrix_FAR(2,7)]
plot(X,Y,'k')
xlim([0 3])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
title("Commission Error: GPi and MCI Subjects")
savefig("Fig16_Commission Error_MCI Subjects")

