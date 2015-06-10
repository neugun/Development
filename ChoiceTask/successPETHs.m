function successPETHs(nexStruct, trials)
%Function to create PETHs for the successful events
    
    %Declare constants
    pethHalfWidth = 2;
    histBin = 50;
    fontSize = 6;
    
    %Get the event names from the nexStruct
    compiledEvents = loadCompiledEvents();
    neuronEventFieldnames = fieldnames(compiledEvents);
    
    %Event names from the trial struct
    eventFieldnames = {['cueOn'] ['centerIn'] ['centerOut'] ['tone'] ['sideIn'] ['sideOut'] ['foodClick'] ['foodRetrieval']};
    
    %Loop through each unit, get name
    for iUnit = 1:length(nexStruct.neurons)
        h = formatSheet;
        unitName = formatNeuronName(nexStruct.neurons{iUnit}.name);
        disp(['Creating PETH for ', unitName]);
        
        %Loop through events, get current event name
        for iEvent = 1: length(eventFieldnames)
            eventName = eventFieldnames{iEvent};
            disp(['Working on event ',eventName]);
            %Compile all timestamps from nexStruct.neurons
            neuronEventTs = compileEventTs(nexStruct, compiledEvents, neuronEventFieldnames, iEvent);
            %Loop through each trial to find the correct ones
            trialEventTs = [];
            for iTrial = 1 : length(trials)
                if trials(iTrial).correct
                    %Get the time stamps for the trials that are correct
                    tempTrialEventTs = trials(iTrial).timestamps;    
                    trialEventTs = [trialEventTs tempTrialEventTs];
                    allEventTsPeth = [];
                    
                    %Loop through the trial event timestamps
                    for iTs = 1: length(trialEventTs)
                        %Find the ids where the neuron timestamp is within
                        %the PETH window
                        pethTsRawIdx = nexStruct.neurons{iUnit}.timestamps > (trialEventTs.(eventName) - pethHalfWidth)...
                            & nexStruct.neurons{iUnit}.timestamps < trialEventTs.(eventName) + pethHalfWidth;
                        allEventTsPeth = [allEventTsPeth; nexStruct.neurons{iUnit}.timestamps(pethTsRawIdx) - trialEventTs.(eventName)];
                            
                    end
%                     for iTs=1:length(neuronEventTs)
%                         if neuronEventTs(iTs) > pethHalfWidth && max(neuronEventTs) - neuronEventTs(iTs) > pethHalfWidth
%                             pethsRawIdx = nexStruct.neurons{iUnit}.timestamps > neuronEventTs(iTs) - pethHalfWidth...
%                                 & nexStruct.neurons{iUnit}.timestamps < neuronEventTs(iTs) + pethHalfWidth;
%                             allEventTsPeth = [allEventTsPeth; nexStruct.neurons{iUnit}.timestamps(pethsRawIdx) - neuronEventTs(iTs)];
%                         end
%                     end
                end      
            end
            %plot
            subplot(2,4,iEvent);
            [counts,centers] = hist(allEventTsPeth,histBin);
            spikesPerSecond = (counts/((pethHalfWidth*2)/histBin))/length(trialEventTs);
            bar(centers,spikesPerSecond,1,'EdgeColor','none','FaceColor',[0 0.5 0.5]);
            hold on;
            plot([0 0],[0,max(spikesPerSecond)],':','color','k');
            xlabel('Time (s)','FontSize',fontSize);
            ylabel('Spikes/Second','FontSize',fontSize);
            title([unitName,':',eventName,', ',num2str(length(trialEventTs)),' events, ',num2str(length(allEventTsPeth)),' spikes'],'FontSize',fontSize);
        end
    end
end


function h = formatSheet()
    h = figure;
    set(h,'PaperOrientation','landscape');
    set(h,'PaperType','A4');
    set(h,'PaperUnits','centimeters');
    set(h,'PaperPositionMode','auto');
    set(h,'PaperPosition', [1 1 28 19]);
end

function neuronName = formatNeuronName(neuronName)
    parts = strsplit(neuronName,'_');
    neuronName = strjoin(parts(end-1:end),'-');
end