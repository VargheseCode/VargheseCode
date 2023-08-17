% % %Separating all non-GNG trials
% % %returns location of GNG
% sample: input
%  y = gng_separation_matrix('C:\Users\alexv\Box\Anas Khan\DLPFC', 'DLPFC067','baseline_taskdata');
%  x = gng_separation_matrix('C:\Users\alexv\Box\Anas Khan\DLPFC', 'DLPFC047','baseline_taskdata');
% 
 function [y] = gng_separation_matrix(x,z,alpha)  
    backslash = "\\";
    string_concat = strcat(x, backslash, z, backslash, alpha);
    subjectID = z; %%check what this does, I want it to come back
    disp(subjectID)
    % string_concat = 'C:\Users\alexv\Box\Anas Khan\DLPFC\DLPFC067\baseline_taskdata.mat';
    load(string_concat,'trials');
    holding_array = [, trials.BlockType];
    counter = 0;
    y = [];
    
    y = find(holding_array ~= "GNG");

 end 
