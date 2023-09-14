clear 
MCI_files_nostim = {"23lfp2_taskdata.mat", "25task3_taskdata.mat", "26LFP3_taskdata.mat", "34task2_taskdata.mat", "35task2_taskdata.mat", "44baseline_taskdata.mat", "61baseline_taskdata.mat", "31task1_taskdata.mat", "45baseline_taskdata.mat", "47baseline_taskdata.mat", "73baseline_taskdata.mat", "32Task_2_taskdata.mat"};
MCI_files_stim =   {"23lfp3_taskdata.mat", "25task5_taskdata.mat", "26LFP4_taskdata.mat", "34task4_taskdata.mat", "35task3_taskdata.mat", "44task_2_taskdata.mat", "61itbs_taskdata.mat", "31task3_taskdata.mat", "45itbs_taskdata.mat", "47itbs_taskdata", "73itbs_taskdata.mat", "32Task_3_taskdata.mat"};
MCI_subjects = [25, 26, 34, 61]
non_MCI_subjects = [23 31 35 44 45 47 32]
STN_subjects = [31 73 47 45]
Gpi_subjects = [23 25 26 34 35 44 61 32]


for i = 1:numel(MCI_files_stim)
    load(strcat("C:\Users\alexv\Box\Lab work\Alex Varghese\NoStim_files\", MCI_files_nostim{i}))    
    gotrials = trials([trials.BlockType] =="GNG");
    gotrials = gotrials([gotrials.Condition] == "GO");
    gotrials = gotrials([gotrials.ACC] == 1);
    RT(i) = mean([gotrials.RT]);
    far(i) = sum([trials.Condition] == "NOGO" & [trials.ACC] == 0)/sum([trials.Condition] == "NOGO");

end 

noStim = [RT; far];
far1 = far

for i = 1:numel(MCI_files_stim)
    load(strcat("C:\Users\alexv\Box\Lab work\Alex Varghese\Stim_files\", MCI_files_stim{i}))
    gotrials = trials([trials.BlockType] =="GNG");
    gotrials = gotrials([gotrials.Condition] == "GO");
    gotrials = gotrials([gotrials.ACC] == 1);
    RT(i) = mean([gotrials.RT]);
    far(i) = sum([trials.Condition] == "NOGO" & [trials.ACC] == 0)/sum([trials.Condition] == "NOGO");
end 

Stim = [RT; far];
far2 = far

RT_matrix = [noStim(1,:);Stim(1,:)]
far_matrix = [noStim(2,:);Stim(2,:)]

noStim_RT_data = [noStim(1,:)];
stim_RT_data = [Stim(1,:)];
reactiontime = table(MCI_subjects, noStim_RT_data, stim_RT_data)


figure(1)
X = [1 1 1 1 1 1 1 1 1 1 1 1; 2 2 2 2 2 2 2 2 2 2 2 2];
Y = [RT_matrix(1,:);RT_matrix(2,:)];
plot(X,Y)
title("Reaction Time All")
xlim([0 3])
ylim([530 675])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('Reaction_Time_All_Subjects');

figure(2)
Y = [far_matrix(1,:);far_matrix(2,:)];
plot(X,Y,'k')
title("False Accuracy All")
xlim([0 3])
ylim([-0.05 0.65])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('False_Accuracy_All_Subjects');

MCI_subjects = [RT_matrix(1,2), RT_matrix(1,3), RT_matrix(1,4), RT_matrix(1,7); RT_matrix(2,2), RT_matrix(2,3), RT_matrix(2,4), RT_matrix(2,7)]
MCI_far = [far_matrix(1,2), far_matrix(1,3), far_matrix(1,4), far_matrix(1,7); far_matrix(2,2), far_matrix(2,3), far_matrix(2,4), far_matrix(2,7)]

figure(3)
X = [1 1 1 1; 2 2 2 2];
Y = [MCI_subjects(1,:); MCI_subjects(2,:)];
plot(X,Y,'k')
title('Average Reaction Time for MCI Subjects')
xlim([0 3])
ylim([530 670])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('MCI-RT')
% [h,p] = ttest(far1, far2)

figure(4)
Y = [MCI_far(1,:); MCI_far(2,:)];
plot(X,Y,'k')
title('False Accuracy for MCI Subjects')
xlim([0 3])
ylim([0.1 0.47])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('MCI-Far')

non_MCI_subjects = [RT_matrix(1,1), RT_matrix(1,8), RT_matrix(1,5), RT_matrix(1,6), RT_matrix(1,9), RT_matrix(1,10), RT_matrix(1,12); RT_matrix(2,1), RT_matrix(2,8), RT_matrix(2,5), RT_matrix(2,6), RT_matrix(2,9), RT_matrix(2,10), RT_matrix(2,12)]
non_MCI_far = [far_matrix(1,1), far_matrix(1,8), far_matrix(1,5), far_matrix(1,6), far_matrix(1,9), far_matrix(1,10), far_matrix(1,12); far_matrix(2,1), far_matrix(2,8), far_matrix(2,5), far_matrix(2,6), far_matrix(2,9), far_matrix(2,10) far_matrix(2,12)]

figure(5)
X = [1 1 1 1 1 1 1; 2 2 2 2 2 2 2];
Y = [non_MCI_subjects(1,:);non_MCI_subjects(2,:)];
plot(X,Y)
title("Average Reaction Time for non-MCI Subjects")
xlim([0 3])
ylim([335 595])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('Non-MCI_RT')

figure(6)
Y = [non_MCI_far(1,:);non_MCI_far(2,:)];
plot(X,Y)
title("False Accuracy for Non-MCI")
xlim([0 3])
ylim([-0.05 0.63])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig('Non-MCI_Far')

STN_subjects = [RT_matrix(1,8), RT_matrix(1,10), RT_matrix(1,9); RT_matrix(2,8), RT_matrix(2,10), RT_matrix(2,9)]
STN_far = [far_matrix(1,8), far_matrix(1,10), far_matrix(1,9); far_matrix(2,8),  far_matrix(2,10), far_matrix(2,9)]

figure(7)
X = [1 1 1 ; 2 2 2]
Y = [STN_subjects(1,:); STN_subjects(2,:)];
plot(X,Y)
title("Average Reaction Time for STN Subjects")
xlim([0 3])
ylim([335 485])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("STN Subjects- RT")

figure(8)
X = [1 1 1; 2 2 2]
Y = [STN_far(1,:); STN_far(2,:)];
plot(X,Y)
title("Average False Accuracy Rate for STN Subjects")
xlim([0 3])
ylim([-0.05 0.63])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("STN Subjects- FAR")


GPi_subjects = [RT_matrix(1,1), RT_matrix(1,2), RT_matrix(1,3), RT_matrix(1,4), RT_matrix(1,5), RT_matrix(1,6), RT_matrix(1,7), RT_matrix(1,12); RT_matrix(2,1), RT_matrix(2,2), RT_matrix(2,3), RT_matrix(2,4), RT_matrix(2,5), RT_matrix(2,6), RT_matrix(2,7), RT_matrix(2,12)]
GPi_far = [far_matrix(1,1), far_matrix(1,2), far_matrix(1,3), far_matrix(1,4), far_matrix(1,5), far_matrix(1,6), far_matrix(1,7), far_matrix(1,12); far_matrix(2,1), far_matrix(2,2), far_matrix(2,3), far_matrix(2,4), far_matrix(2,5), far_matrix(2,6), far_matrix(2,7), far_matrix(2,12)]

figure(8)
X = [1 1 1 1 1 1 1 1; 2 2 2 2 2 2 2 2]
Y = [GPi_subjects(1,:); GPi_subjects(2,:)];
plot(X,Y)
title("Reaction Time for GPi Subjects")
xlim([0 3])
ylim([435 675])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("GPi Subjects- RT")

figure(9)
X = [1 1 1 1 1 1 1 1; 2 2 2 2 2 2 2 2]
Y = [GPi_far(1,:); GPi_far(2,:)];
plot(X,Y)
title("False Accuracy Rate for GPi Subjects")
xlim([0 3])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("GPi Subjects- far")

figure(10)
X = [1 1 1; 2 2 2]
Y = [RT_matrix(1,8), RT_matrix(1,9), RT_matrix(1,10); RT_matrix(2,8), RT_matrix(2,9), RT_matrix(2,10)]
plot(X,Y)
title("Average Reaction Time for STN & NON-MCI Subjects ")
subtitle("STN&MCI do not exist")
xlim([0 3])
ylim([335 490])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("STN & NON-MCI Subjects")

figure(11)
X = [1 1 1; 2 2 2]
Y = [far_matrix(1,8), far_matrix(1,9), far_matrix(1,10); far_matrix(2,8), far_matrix(2,9), far_matrix(2,10)]
plot(X,Y)
title("Average Commission Error for STN & NON-MCI Subjects ")
subtitle("STN&MCI do not exist")
xlim([0 3])
ylim([-0.03 0.65])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("STN & NON-MCI Subjects")

%
figure(12)
X = [1 1 1 1; 2 2 2 2]
Y = [RT_matrix(1,1), RT_matrix(1,5), RT_matrix(1,6), RT_matrix(1,12); RT_matrix(2,1), RT_matrix(2,5), RT_matrix(2,6), RT_matrix(2,12)]
plot(X,Y)
title("Average Reaction Time for GPi & NON-MCI Subjects")
ylim([440 595])
xlim([0 3])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("GPi NON-MCI_RT")

figure(13)
X = [1 1 1 1; 2 2 2 2]
Y = [far_matrix(1,1), far_matrix(1,5), far_matrix(1,6), far_matrix(1,12); far_matrix(2,1), far_matrix(2,5), far_matrix(2,6), far_matrix(2,12)]
plot(X,Y)
title("False Accuracy Rate for GPi and Non-MCI")
xlim([0 3])
ylim([0.01 0.30])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
savefig("GPi & NON-MCI Far")

figure(14)
X = [1 1 1 1; 2 2 2 2]
Y = [RT_matrix(1,2), RT_matrix(1,3), RT_matrix(1,4) RT_matrix(1,7); RT_matrix(2,2), RT_matrix(2,3), RT_matrix(2,4) RT_matrix(2,7)]
plot(X,Y)
ylim([535 670])
xlim([0 3])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
title("Average Reaction Time for GPi and MCI Subjects")
savefig("GPi & MCI RT")

figure(15)
X = [1 1 1 1; 2 2 2 2]
Y = [far_matrix(1,2), far_matrix(1,3), far_matrix(1,4) far_matrix(1,7); far_matrix(2,2), far_matrix(2,3), far_matrix(2,4) far_matrix(2,7)]
plot(X,Y)
xlim([0 3])
xticks([1 2])
xticklabels({"NoStim", "Stim"})
title("False Accuracy Rate for GPi and MCI Subjects")
savefig("GPi & MCI FAR")
