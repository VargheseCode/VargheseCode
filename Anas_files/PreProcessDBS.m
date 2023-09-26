function [INFO,DBS_data,trials,FileInfo] = PreProcessDBS(subjectID,fname,baseDir)

% Load INFO file and data files
INFO = LoadInfoFile; % Load INFO file from Box Drive
subjectPath = [baseDir subjectID '/'];
taskfile = dir([subjectPath fname '*taskdata.mat']);
S = load([subjectPath taskfile.name],'trials','restperiods');
trials = S.trials;
load([subjectPath fname '.mat'],'Data','FileInfo')

% Preprocessing

FileNames = {INFO(strcmp({INFO.ID}, subjectID)).File.FileName};

ns_idx = find(contains(FileNames,fname));

DBS_bad_contacts = INFO(strcmp({INFO.ID}, subjectID)).File(ns_idx).BadDBSContacts;
DBS_EIDs = INFO(strcmp({INFO.ID}, subjectID)).File(ns_idx).DBSElectrodeIDs;
DBS_good_IDs = DBS_EIDs(~ismember(DBS_EIDs,DBS_EIDs(DBS_bad_contacts)));
DBS_good_idxs = ismember(FileInfo.chanlabels, DBS_good_IDs);

% Extract data from good channels
Data = double(Data)';
DBS_mat = Data(:,DBS_good_idxs);

Fs = FileInfo.srate;

% Bandpass Filter
[b,a] = butter(2, [0.5 500]/(Fs/2), 'bandpass'); % Setting butterworth filter; 2nd order 1 to 500 hz
DBS_mat = filtfilt(b,a,DBS_mat);

% Notch filter for line noise
d1 = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59.5,'HalfPowerFrequency2',60.5, ...
               'DesignMethod','butter','SampleRate',Fs);
d2 = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',119.5,'HalfPowerFrequency2',120.5, ...
               'DesignMethod','butter','SampleRate',Fs);
d3 = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',179.5,'HalfPowerFrequency2',180.5, ...
               'DesignMethod','butter','SampleRate',Fs);
d4 = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',239.5,'HalfPowerFrequency2',240.5, ...
               'DesignMethod','butter','SampleRate',Fs);


DBS_mat = filtfilt(d1,DBS_mat);
DBS_mat = filtfilt(d2,DBS_mat);
DBS_mat = filtfilt(d3,DBS_mat);
DBS_mat = filtfilt(d4,DBS_mat);


DBS_data = DBS_mat(1:10:end,:);
end