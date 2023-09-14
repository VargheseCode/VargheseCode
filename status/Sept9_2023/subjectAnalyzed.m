classdef subjectAnalyzed
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        ssubjectID
        sfilePath
        sfileName
        strtrials
    end

    methods
        function obj = subjectAnalyzed(ssubjectID,sfilePath, sfileName, strtrials)
            if nargin == 4
                obj.ssubjectID = ssubjectID;
                obj.sfilePath = sfilePath;
                obj.sfileName = sfileName;
                obj.strtrials = strtrials
            end
        end

    end
end