function [trialIds,allTimes] = sortTrialsBy(trials,timingField)

allTimes = [];
trialIds = [];
trialCount = 1;
for iTrial = 1:length(trials)
    % might not want to force correct in the future
    if trials(iTrial).correct
        allTimes(trialCount) = getfield(trials(iTrial).timing,timingField);
        trialIds(trialCount) = iTrial;
        trialCount = trialCount + 1;
    end
end

[allTimes,k] = sort(allTimes);
trialIds = trialIds(k);
disp(['sortTrialsBy.m: ',timingField,' asc (low -> high)']);