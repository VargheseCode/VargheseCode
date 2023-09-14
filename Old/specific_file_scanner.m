% The purpose of this code is to look through all the DLPFC in 
%  Anas Khan Box for baseline_taskdata files. It returns all the values 
%  of a specific column in this case, it returns the response of all Go 
%  trials. It was an attempt to store all reaction times into one array
% For some reason, a file with baseline_taskdata must be open. I found this
% out at 12:13 AM 8/17/2023
% check accuracy
% accuracy tested on 2:18 AM 8/17/2023

% looking back on it, it might be better to just use a file scanner
clc
d = dir("C:\Users\alexv\Box\Anas Khan\DLPFC");
f = "C:\Users\alexv\Box\Anas Khan\DLPFC";
counter = 0
empty_array = [];
loaded_response = [];
for i = 1:length(d)
    str = getfield(d(i),"name");
    add_str = sprintf("%s\\%s",f,str);
    p = dir(add_str);
    for y = 1:length(p)
        if (getfield(p(y),"name") == "baseline_taskdata.mat")
            counter = counter + 1
             % loadedfile = load("baseline_taskdata.mat", "trials")
             % loaded_response = [trials.Response];
             % empty_array = [empty_array, loaded_response];  
             disp(add_str);
        end 
    end 
end
