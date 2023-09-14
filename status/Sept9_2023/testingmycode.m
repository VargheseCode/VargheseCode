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
STN_subjects = [matrix_RT(1,8), matrix_RT(1,10), matrix_RT(1,9), matrix_RT(1,11); matrix_RT(2,8), matrix_RT(2,10), matrix_RT(2,9), matrix_RT(2,11)];
STN_far = [matrix_FAR(1,8), matrix_FAR(1,10), matrix_FAR(1,9), matrix_FAR(1,11); matrix_FAR(2,8),  matrix_FAR(2,10), matrix_FAR(2,9) matrix_FAR(2,11)]
GPi_subjects = [matrix_RT(1,1), matrix_RT(1,2), matrix_RT(1,3), matrix_RT(1,4), matrix_RT(1,5), matrix_RT(1,6), matrix_RT(1,7), matrix_RT(1,12); matrix_RT(2,1), matrix_RT(2,2), matrix_RT(2,3), matrix_RT(2,4), matrix_RT(2,5), matrix_RT(2,6), matrix_RT(2,7), matrix_RT(2,12)]
GPi_far = [matrix_FAR(1,1), matrix_FAR(1,2), matrix_FAR(1,3), matrix_FAR(1,4), matrix_FAR(1,5), matrix_FAR(1,6), matrix_FAR(1,7), matrix_FAR(1,12); matrix_FAR(2,1), matrix_FAR(2,2), matrix_FAR(2,3), matrix_FAR(2,4), matrix_FAR(2,5), matrix_FAR(2,6), matrix_FAR(2,7), matrix_FAR(2,12)]

%creates table
X = [1 1 1 1 1 1 1 1 1 1 1 1; 2 2 2 2 2 2 2 2 2 2 2 2]; %lists the amount of data sets, 1 stands for nonstim, 2 stands for stim
Y = [matrix_RT(1,:);matrix_RT(2,:)]; % assigns the Y-value(reaction time) to each x
plot(X,Y,'k') %plots x and y in black colors "k"
title("Average Reaction Time: All") %creates title 
xlim([0 3]) % limits the x axis
% ylim([500 675]) % limits the y axis 
xticks([1 2]) % creates tick marks to label
xticklabels({"NoStim", "Stim"}) % labels 1 and 2 with nostim and stim 
savefig('Fig1_Average Reaction Time_All'); %saves figure with that name

figure(2)
Y = [matrix_FAR(1,:);matrix_FAR(2,:)]; % assigns the Y-value(reaction time) to each x
plot(X,Y,'k') %plots x and y in black colors "k"
title("Commission Error: All")  %creates title 
xlim([0 3])  % limits the x axis
ylim([-0.05 0.7]) % limits the y axis 
xticks([1 2]) % creates tick marks to label
xticklabels({"NoStim", "Stim"}) % labels 1 and 2 with nostim and stim 
savefig('Fig2_Commission Error_All'); %saves figure with that name

% T-Test for all subjects
[hAll_RT,pAll_RT, ci, stats] = ttest(nostim_RT(1,:), stim_RT(1,:), 0.05, "left")
[hAll_far,pAll_far, ci, stats] = ttest(nostim_far(1,:), stim_far(1,:), 0.05, "left")

figure(3)
X = [1 1 1 1; 2 2 2 2];
Y = [MCI_subjects(1,:); MCI_subjects(2,:)];
plot(X,Y,'k')
title('Average Reaction Time: MCI Subjects')
xlim([0 3])
ylim([530 680])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('Fig3_Average Reaction Time_MCI Subjects')

[hMCI_RT,pMCI_RT, ci, stats] = ttest(MCI_subjects(1,:), MCI_subjects(2,:), 0.05, "left")

figure(4)
Y = [MCI_far(1,:); MCI_far(2,:)];
plot(X,Y,'k')
title('Commission Error: MCI Subjects')
xlim([0 3])
ylim([0.1 0.5])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('Fig4_Commission Error_MCI Subjects')

[hMCI_far,pMCI_far, ci, stats] = ttest(MCI_far(1,:), MCI_far(2,:), 0.05, "left")

figure(5)
X = [1 1 1 1 1 1 1; 2 2 2 2 2 2 2];
Y = [non_MCI_subjects(1,:);non_MCI_subjects(2,:)];
plot(X,Y,'k')
title("Average Reaction Time: Non-MCI Subjects")
xlim([0 3])
ylim([320 620])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('Fig5_Average Reaction Time_Non-MCI Subjects')

[hNonMCI_RT,pNonMCI_RT, ci, stats] = ttest(non_MCI_subjects(1,:), non_MCI_subjects(2,:), 0.05, "left")

figure(6)
Y = [non_MCI_far(1,:);non_MCI_far(2,:)];
plot(X,Y,'k')
title("Commission Error: Non-MCI")
xlim([0 3])
ylim([-0.05 0.70])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('Fig6_Commission Error_MCI Subjects')

[hNonMCI_far,pNonMCI_far, ci, stats] = ttest(non_MCI_far(1,:), non_MCI_far(2,:), 0.05, "left")

figure(7)
X = [1 1 1 1; 2 2 2 2]
Y = [STN_subjects(1,:); STN_subjects(2,:)];
plot(X,Y,'k')
title("Average Reaction Time: STN Subjects")
xlim([0 3])
ylim([300 675])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig7_Average Reaction Time_STN Subjects")

[hSTN_subjects_RT,pSTN_subjects_RT, ci, stats] = ttest(STN_subjects(1,:), STN_subjects(2,:), 0.05, "left")

figure(8)
X = [1 1 1 1; 2 2 2 2]
Y = [STN_far(1,:); STN_far(2,:)];
plot(X,Y,'k')
title("Commission Error: STN Subjects")
xlim([0 3])
ylim([-0.05 0.7])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig8_Commission Error_MCI Subjects")

[hSTN_far,pSTN_far, ci, stats] = ttest(STN_far(1,:), STN_far(2,:), 0.05, "left")

figure(9)
X = [1 1 1 1 1 1 1 1; 2 2 2 2 2 2 2 2]
Y = [GPi_subjects(1,:); GPi_subjects(2,:)];
plot(X,Y,'k')
title("Average Reaction Time: GPi Subjects")
xlim([0 3])
ylim([410 700])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig9_Average Reaction Time_GPi Subjects")

[hGPi_subjects_RT,pGPi_subjects_RT, ci, stats] = ttest(GPi_subjects(1,:), GPi_subjects(2,:), 0.05, "left")

figure(10)
X = [1 1 1 1 1 1 1 1; 2 2 2 2 2 2 2 2]
Y = [GPi_far(1,:); GPi_far(2,:)];
plot(X,Y,'k')
title("Commission Error: GPi Subjects")
xlim([0 3])
xticks([1 2])
ylim([-0.05 0.75])
xticklabels({"NoStim", "Stim"})
savefig("Fig10_Commission Error_MCI Subjects")

[hGPi_far,pGPi_far, ci, stats] = ttest(GPi_far(1,:), GPi_far(2,:), 0.05, "left")

figure(11)
X = [1 1 1 ; 2 2 2 ]
Y = [matrix_RT(1,8), matrix_RT(1,9), matrix_RT(1,10); matrix_RT(2,8), matrix_RT(2,9), matrix_RT(2,10)]
plot(X,Y,'k')
title("Average Reaction Time: STN & NON-MCI Subjects ")
subtitle("STN&MCI do not exist")
xlim([0 3])
ylim([320 510])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig11_Average Reaction Time_STNandNON-MCI Subjects ")

STNandNonMCI_RT = [matrix_RT(1,8), matrix_RT(1,9), matrix_RT(1,10); matrix_RT(2,8), matrix_RT(2,9), matrix_RT(2,10)]
[hSTNandNonMCI_RT,pSTNandNonMCI_RT, ci, stats] = ttest(STNandNonMCI_RT(1,:), STNandNonMCI_RT(2,:), 0.05, "left")

figure(12)
X = [1 1 1 ; 2 2 2 ]
Y = [matrix_FAR(1,8), matrix_FAR(1,9), matrix_FAR(1,10); matrix_FAR(2,8), matrix_FAR(2,9), matrix_FAR(2,10)]
plot(X,Y,'k')
title("Commission Error: STN & NON-MCI Subjects ")
subtitle("STN&MCI do not exist")
xlim([0 3])
ylim([-0.1 0.75])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig12_Commission Error_MCI Subjects")

STNandNonMCI_far = [matrix_FAR(1,8), matrix_FAR(1,9), matrix_FAR(1,10); matrix_FAR(2,8), matrix_FAR(2,9), matrix_FAR(2,10)]
[hSTNandNonMCI_far,pSTNandNonMCI_far, ci, stats] = ttest(STNandNonMCI_far(1,:), STNandNonMCI_far(2,:), 0.05, "left")


figure(13)
X = [1 1 1 1; 2 2 2 2]
Y = [matrix_RT(1,1), matrix_RT(1,5), matrix_RT(1,6), matrix_RT(1,12); matrix_RT(2,1), matrix_RT(2,5), matrix_RT(2,6), matrix_RT(2,12)]
plot(X,Y,'k')
title("Average Reaction Time: GPi & NON-MCI Subjects")
ylim([425 600])
xlim([0 3])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig13_Average Reaction Time_GPiandNON-MCI Subjects")

GPi_NonMCI_RT = [matrix_RT(1,1), matrix_RT(1,5), matrix_RT(1,6), matrix_RT(1,12); matrix_RT(2,1), matrix_RT(2,5), matrix_RT(2,6), matrix_RT(2,12)]
[hGPi_NonMCI_RT,pGPi_NonMCI_RT, ci, stats] = ttest(GPi_NonMCI_RT(1,:), GPi_NonMCI_RT(2,:), 0.05, "left")


figure(14)
X = [1 1 1 1; 2 2 2 2]
Y = [matrix_FAR(1,1), matrix_FAR(1,5), matrix_FAR(1,6), matrix_FAR(1,12); matrix_FAR(2,1), matrix_FAR(2,5), matrix_FAR(2,6), matrix_FAR(2,12)]
plot(X,Y,'k')
title("Commission Error: GPi and Non-MCI")
xlim([0 3])
ylim([-0.05 0.7])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("Fig14_Commission Error_MCI Subjects")

GPi_NonMCI_far = [matrix_FAR(1,1), matrix_FAR(1,5), matrix_FAR(1,6), matrix_FAR(1,12); matrix_FAR(2,1), matrix_FAR(2,5), matrix_FAR(2,6), matrix_FAR(2,12)]
[hGPi_NonMCI_far,pGPi_NonMCI_far, ci, stats] = ttest(GPi_NonMCI_far(1,:), GPi_NonMCI_far(2,:), 0.05, "left")

figure(15)
X = [1 1 1 1; 2 2 2 2]
Y = [matrix_RT(1,2), matrix_RT(1,3), matrix_RT(1,4) matrix_RT(1,7); matrix_RT(2,2), matrix_RT(2,3), matrix_RT(2,4) matrix_RT(2,7)]
plot(X,Y,'k')
ylim([530 675])
xlim([0 3])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
title("Average Reaction Time: GPi and MCI Subjects")
savefig("Fig15_Average Reaction Time_GPiandMCI Subjects")

GPi_MCI_RT = [matrix_RT(1,2), matrix_RT(1,3), matrix_RT(1,4) matrix_RT(1,7); matrix_RT(2,2), matrix_RT(2,3), matrix_RT(2,4) matrix_RT(2,7)]
[hGPi_MCI_RT,pGPi_MCI_RT, ci, stats] = ttest(GPi_MCI_RT(1,:), GPi_MCI_RT(2,:), 0.05, "left")

figure(16)
X = [1 1 1 1; 2 2 2 2]
Y = [matrix_FAR(1,2), matrix_FAR(1,3), matrix_FAR(1,4) matrix_FAR(1,7); matrix_FAR(2,2), matrix_FAR(2,3), matrix_FAR(2,4) matrix_FAR(2,7)]
plot(X,Y,'k')
ylim([0.08 .475])
xlim([0 3])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
title("Commission Error: GPi and MCI Subjects")
savefig("Fig16_Commission Error_MCI Subjects")

GPi_MCI_far = [matrix_FAR(1,2), matrix_FAR(1,3), matrix_FAR(1,4) matrix_FAR(1,7); matrix_FAR(2,2), matrix_FAR(2,3), matrix_FAR(2,4) matrix_FAR(2,7)]
[hGPi_MCI_far,pGPi_MCI_far, ci, stats] = ttest(GPi_MCI_far(1,:), GPi_MCI_far(2,:), 0.05, "left")

t_testResults_RT(1,:) = ["T-Test" "T-Test" "T-Test" "T-Test" "T-Test" "T-Test" "T-Test" "T-Test"]
t_testResults_RT(2,:) = [hAll_RT hMCI_RT hNonMCI_RT hSTN_subjects_RT hGPi_subjects_RT hSTNandNonMCI_RT hGPi_NonMCI_RT hGPi_MCI_RT]
t_testResults_RT(3,:) = [pAll_RT pMCI_RT pNonMCI_RT pSTN_subjects_RT pGPi_subjects_RT pSTNandNonMCI_RT pGPi_NonMCI_RT pGPi_MCI_RT]

t_testResults_far(1,:) = ["T-Test" "T-Test" "T-Test" "T-Test" "T-Test" "T-Test" "T-Test" "T-Test"]
t_testResults_far(2,:) = [hAll_far hMCI_far hNonMCI_far hSTN_far hGPi_far hSTNandNonMCI_far hGPi_NonMCI_far hGPi_MCI_far]
t_testResults_far(3,:) = [pAll_far pMCI_far pNonMCI_far pSTN_far pGPi_far pSTNandNonMCI_far pGPi_NonMCI_far pGPi_MCI_far]


