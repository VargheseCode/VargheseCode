%%
baseDir = '/Users/anaskhan/Library/CloudStorage/Box-Box/Lab work/Anas Khan/DLPFC/'; % Set to where you stored the data
subjectID = 'DLPFC031';
subnum = 5;
fname = 'task1';
%% Load and preprocess ECOG data
[INFO,ECOG_nostim,trials] = PreProcessECOG(subjectID,fname,baseDir);

% Artifact identification
[~,idxs] = FindArtifacts(ECOG_nostim,trials,1);
badidx = [idxs];

%% Remove trials with artifacts
trials(badidx) = [];

%% Epoch Data
[ECOG_error,ECOG_GO,ECOG_NG,time,FAR,RT,RTs,GO_errors,trials] = EpochMyData(ECOG_nostim,trials);

% for cc = 1:size(ECOG_GO,3)
%     for ii = 1:size(ECOG_GO,2)
%         idxs = find(abs((ECOG_GO(1501:end-1500,ii,cc) - mean(ECOG_GO(1501:end-1500,ii,cc)))./std(ECOG_GO(1501:end-1500,ii,cc))) >= 4);
%         ECOG_GO(idxs+1500,ii,cc) = median(ECOG_GO(1501:end-1500,ii,cc));
%     end
% end
% 
% for cc = 1:size(ECOG_NG,3)
%     for ii = 1:size(ECOG_NG,2)
%         idxs = find(abs((ECOG_NG(1501:end-1500,ii,cc) - mean(ECOG_NG(1501:end-1500,ii,cc)))./std(ECOG_NG(1501:end-1500,ii,cc))) >= 4);
%         ECOG_NG(idxs+1500,ii,cc) = median(ECOG_NG(1501:end-1500,ii,cc));
%     end
% end

GOtrials = trials([trials.Condition] == "GO");
NGtrials = trials([trials.Condition] == "NOGO");

correctGO = [GOtrials.ACC] == 1;
correctNG = [NGtrials.ACC] == 1;

%RTs = [GOtrials(correctGO).RT]';
% Bipolar rereferencing
[ECOG_GO,ECOG_NG,ECOG_error] = BipolarReref(ECOG_GO,ECOG_NG,ECOG_error);
%% Remove Electrodes
ECOG_GO(:,:,1:2) = [];
ECOG_NG(:,:,1:2) = [];
ECOG_error(:,:,1) = [];

%% ECOG
% Get Go powers
num_GO_trials = size(ECOG_GO,2);
[GO_CWT,frex,trimmedT] = MyCWT(ECOG_GO,num_GO_trials,time);
GO_powers = GO_CWT.*conj(GO_CWT);
GO_phases = angle(GO_CWT);

% Get NoGo powers
num_NG_trials = size(ECOG_NG,2);
[NG_CWT,~,~] = MyCWT(ECOG_NG,num_NG_trials,time);
NG_powers = NG_CWT.*conj(NG_CWT);
NG_phases = angle(NG_CWT);

clear GO_CWT NG_CWT

% Normalize to pre-stim baseline for all trials

% Concatenate all trials to calculate mean and std for each freq and each electrode
allTrials = cat(3,NG_powers,GO_powers);
allBLs = allTrials(:,1:301,:,:);
allBLs = reshape(allBLs,[size(allTrials,1) 301*size(allBLs,3) size(allTrials,4)]);

clear allTrials

% Initialize means and stds matrices
meanBL = NaN(size(GO_powers,1),size(GO_powers,4));
sdBL = NaN(size(GO_powers,1),size(GO_powers,4));

% Loop over frequencies and electrodes
for elec = 1:size(NG_powers,4)
    for fi = 1:size(NG_powers,1)
        meanBL(fi,elec) = mean(allBLs(fi,:,elec));
        sdBL(fi,elec) = std(allBLs(fi,:,elec));
    end
end

clear allBLs
% Use means and stds to z-score raw data

% Initialize z-scored matrices
zNG_powers = NaN(size(NG_powers,1),length(trimmedT),num_NG_trials,size(NG_powers,4));
zGO_powers = NaN(size(GO_powers,1),length(trimmedT),num_GO_trials,size(GO_powers,4));

for elec = 1:size(NG_powers,4)
    for fi = 1:size(NG_powers,1)
        zNG_powers(fi,:,:,elec) = (NG_powers(fi,:,:,elec) - meanBL(fi,elec))./sdBL(fi,elec);
        zGO_powers(fi,:,:,elec) = (GO_powers(fi,:,:,elec) - meanBL(fi,elec))./sdBL(fi,elec);
    end
end

[~,fidx] = arrayfun(@(x) min(abs(x-frex)), [2 4 10 40 200]);
frexticks = frex(fidx);
clear fidx

clear Error_powers GO_powers NG_powers fi elec meanBL sdBL ECOG_NG ECOG_GO ECOG_nostim fname INFO num_GO_trials num_NG_trials
%%
zGO_powers = zGO_powers(:,:,correctGO,:);
zNG_powers = zNG_powers(:,:,correctNG,:);

eGO_phases = GO_phases(:,:,correctGO,:);
eNG_phases = NG_phases(:,:,correctNG,:);

clear GO_phases NG_phases
%%
zGO_powers = zGO_powers(:,:,~correctGO,:);
zNG_powers = zNG_powers(:,:,correctNG,:);

GO_phases = GO_phases(:,:,correctGO,:);
NG_phases = NG_phases(:,:,correctNG,:);

clearvars -except GOErrors subjectID subnum RT Beta lowFreq NG_phases GO_phases eGO_phases eNG_phases CompGOISPC CompNGISPC frex frexticks trimmedT zGO_powers zNG_powers
%%
NGPowers(subnum).Subject = subjectID;
NGPowers(subnum).ngPower = zNG_powers;
NGPowers(subnum).Frex = frex;
NGPowers(subnum).Time = trimmedT;
clearvars -except NGPowers
%%
GOErrors(subnum).Subject = subjectID;
GOErrors(subnum).goPower = zGO_powers;
GOErrors(subnum).Frex = frex;
GOErrors(subnum).Time = trimmedT;
clearvars -except GOErrors

%%
errorPower(12).Subject = subjectID;
errorPower(12).goPower = zER_powers;
errorPower(12).Frex = frex;
errorPower(12).Time = trimmedT;
%%
PDPowers(subnum).Subject = subjectID;
PDPowers(subnum).goPower = zGO_powers;
PDPowers(subnum).ngPower = zNG_powers;
PDPowers(subnum).Frex = frex;
PDPowers(subnum).Time = trimmedT;

PDPhases(subnum).Subject = subjectID;
PDPhases(subnum).goPhases = eGO_phases;
PDPhases(subnum).ngPhases = eNG_phases;
PDPhases(subnum).Frex = frex;
PDPhases(subnum).Time = trimmedT;

TaskMetrics(subnum).Subject = subjectID;
TaskMetrics(subnum).FARs = FAR;
TaskMetrics(subnum).GOER = GO_errors;
TaskMetrics(subnum).RT = RT;
TaskMetrics(subnum).RTs = RTs;

clearvars -except Coordinates PDPhases PDPowers errorPower Coordinates TaskMetrics
%%
save('PDCorrect.mat',"PDPhases","PDPowers",'Coordinates')
save("PDError.mat",'errorPower')
save('TaskMetrics.mat','TaskMetrics')

%%
Coordinates(subnum).Subject = subjectID;
Coordinates(subnum).Disease = 'PD';
Coordinates(subnum).HandKnob = [27.2 -17.9];
Coordinates(subnum).Electrodes = [10.3 59; 14.4 58.5; 19.5 56.2; 24.1 50.4; 27.2 42.6];
clearvars -except Coordinates allPhases allPowers
%%

figure(1)
contourf(trimmedT,frex,mean(zGO_powers(:,:,:,1),3),50,'LineColor','none');
set(gca,'YScale','log')
yticks(frexticks)
yticklabels([2 4 10 40 194])
xlabel('Time (ms)')
ylabel('Frequency (Hz)')
cb = colorbar;
caxis([-0.5 0.5])
set(cb,'yTick',[-0.5 0 0.5])
cb.Label.String = ['\bf' 'Power (z)' '\rm'];


figure(2);

contourf(trimmedT,frex,mean(zNG_powers(:,:,:,1),3),50,'LineColor','none');
set(gca,'YScale','log')
yticks(frexticks)
yticklabels([2 4 10 40 194])
xlabel('Time (ms)')
ylabel('Frequency (Hz)')
cb = colorbar;
caxis([-0.5 0.5])
set(cb,'yTick',[-0.5 0 0.5])
cb.Label.String = ['\bf' 'Power (z)' '\rm'];
