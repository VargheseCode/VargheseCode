function [data_error,data_GO,data_NG,time,FA_rate,RT,RTs,GO_errors,trials] = EpochMyData(data,trials)



FA_rate = length(trials([trials.Condition] == "NOGO" & [trials.ACC] == 0)) / length(trials([trials.Condition] == "NOGO"));
trials([trials.BlockType] == "S") = [];
trials([trials.BlockType] == "R") = [];
GO_errors = length(trials([trials.Condition] == "GO" & [trials.ACC] == 0)) / length(trials([trials.Condition] == "GO"));

removeIndices = arrayfun(@(x) ~isempty(x.RT) && x.RT < 300, trials);
trials(removeIndices) = [];

RT = mean([trials([trials.Condition] == "GO").RT]); % Mean reaction time for session
RTs = [trials([trials.Condition] == "GO").RT]; % All reaction times for session

backwards = 2125;
forwards = 2625;
time = [-backwards:forwards]; % Set epoch length


for elecE = 1:min(size(data))
    cnt = 1;
    cntr = 1;
    cnte = 1;
    % Get Go and Nogo trial epochs
    for iTrials = 1:length(trials)
        if trials(iTrials).Condition == "NOGO"
            tempENG = data(round(trials(iTrials).StimulusTime/10)-backwards:round(trials(iTrials).StimulusTime/10)+forwards,elecE);
            data_NG(:,cnt,elecE) = tempENG;
            cnt = cnt +1;
        else
            tempEG = data(round(trials(iTrials).StimulusTime/10)-backwards:round(trials(iTrials).StimulusTime/10)+forwards,elecE);
            data_GO(:,cntr,elecE) = tempEG;
            cntr = cntr +1;
        end
        
        if all([trials.ACC] == 1)
            data_error = [];
        elseif trials(iTrials).ACC == 0
            data_error(:,cnte,elecE) = data(round(trials(iTrials).StimulusTime/10)-backwards:round(trials(iTrials).StimulusTime/10)+forwards,elecE);
            cnte = cnte + 1;
        elseif trials(iTrials).ACC ~= 0
            continue
        end
    end
end
end