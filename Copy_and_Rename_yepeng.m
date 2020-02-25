clc; clear all;
fatherdir='D:\Study_Files\MATLAB\DataAnalysis@FuccilloLab';  % Change this path to the father path of session directories
cd (fatherdir)
addpath(genpath(pwd));  % for invoking function files in other subfolders of father folder later

maindir=uigetdir('Select main folder for data of a session');
[temp name]=fileparts(maindir);
newdirname=strcat(name,'_new');
mkdir (newdirname)
newdir=fullfile(fatherdir,newdirname,'\');

subdir=dir(maindir);

%% Sort-and-copy videos
cd (maindir)

[~,index] = sort({subdir.date}); subdir = subdir(index); clear index;  % sort by date (easier!)

tic
count=1;
for i = 1:length(subdir)
    if (isequal(subdir(i).name, '.')||isequal(subdir,'..')||~subdir(i).isdir)
        continue;
    end
    subdirpath = fullfile(maindir, subdir(i).name, '*.avi' );
    avi=dir(subdirpath);
    for j = 1:length(avi)
        avipath=fullfile(maindir,subdir(i).name,avi(j).name);
        temp=avi(j).name(1:end-5);  % Extract the name component we want (delete "*1.avi")
        number=sprintf('%03d',count);  
        number=num2str(number);
        new_name=strcat(temp,number,'.avi');  % Produce the new name w/ format "001" or so
%     eval(['!rename' 32 avi(j).name 32 new_name]);  % No need for this
        copyfile(avipath,[newdir new_name]);  % Copy videos to a new file
        count=count+1;
    end
end
toc