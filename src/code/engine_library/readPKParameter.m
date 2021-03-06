function PKPList = readPKParameter(simulationName)
%READPKPARAMETER reads a PK Analysis result file 
%
% Inputs: 
%   - simulationName (string) name of the simulation 
% Outputs: 
%   - PKPList cellarray of structures with following fields
%       name (string)   name of pkparameter
%       unit (string)   unit of pkparameter
%       value (double vector): individual values of PK Parameter 

% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org


% getName of the csvfile
csvfile = fullfile('simulations',[simulationName '-PK-Analyses.csv']); 

load(fullfile('tmp',simulationName,'outputList.mat'),'OutputList');


iBunch = 1;
while exist(csvfile,'file')


    % read data
    warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames');
    tTmp = readtable(csvfile,'Filetype','text','Delimiter',';');
    warning('ON', 'MATLAB:table:ModifiedAndSavedVarnames');
    
    outputPathList = tTmp.QuantityPath;
    PKParameter = tTmp.Parameter;
    value = tTmp.Value;
    unit = tTmp.Unit;
    
    for iO = 1:length(OutputList)
        
        jjO = strcmp(OutputList(iO).pathID,outputPathList);
        
        tmp = [];
        for iPK = 1:size(OutputList(iO).pKParameterList,2)
            
            jjPK = jjO & strcmp(OutputList(iO).pKParameterList{1,iPK},PKParameter);
            
            if any(jjPK)
                ij = find(jjPK,1);
                
                tmp(iPK).name = PKParameter{ij}; %#ok<AGROW>
                tmp(iPK).unit = unit{ij}; %#ok<AGROW>
                tmp(iPK).value = value(jjPK)'; %#ok<AGROW>
            end
        end
        
        if iBunch ==1
            PKPList{iO} = tmp; %#ok<AGROW>
        else
            PKPList{iO} = [PKPList{iO};tmp]; %#ok<AGROW>
        end
    end
    
     
    % get name of resultfile
    iBunch = 1 + iBunch;
    csvfile = fullfile('simulations',sprintf('%s-%d-PK-Analyses.csv',simulationName,iBunch));
    
    
end

% save as temporary file
save(fullfile('tmp',simulationName,'pKPList.mat'),'PKPList');
return
