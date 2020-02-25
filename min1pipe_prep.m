% to put all msCam file in same folder with renaming
% dat file transfer

clean

tic
%% Set folder
filepath=uigetdir;

%% Load folder & rename

folder=dir(filepath);
folder(1:2) = [];

% rename folder name for the order
for fs = 1:length(folder)
    name = folder(fs).name;
    name_split = strsplit(name,'_');
    hour = num2str(sscanf(name_split{1}, strcat("H", "%d")), '%02d');
    minute = num2str(sscanf(name_split{2}, strcat("M", "%d")), '%02d');
    second = num2str(sscanf(name_split{3}, strcat("S", "%d")), '%02d');
    rename = strcat('H', hour, '_M', minute, '_S', second);
    
    tf=strcmp(name, rename); % Compare string
    if tf == 0
    cd(filepath)
    [status, msg] = movefile(name, rename);
    else
    end
    folder(fs).rename = rename;
end
folder_archive = folder;

%% Reload folder & extract msCam & copy files & rename

folder=dir(filepath);
folder(1:2) = [];

% make destination folder to copy
path_structure = regexp(filepath, filesep, 'split');
path_structure(end) = strcat(path_structure(end), '_cat');
file_destination = fullfile(path_structure{:});
mkdir(file_destination)
msCam_Seq = struct;
for fs = 1:length(folder)
    folder_scan = fullfile(filepath, folder(fs).name, 'msCam*.avi');
    timestamp=fullfile(filepath,folder(fs).name,'timestamp.dat');  %% added
    msCam_list = struct2cell(dir(folder_scan));
    if fs ==1 
        msCam_Seq = msCam_list;
    else
        msCam_Seq = [msCam_Seq msCam_list];
    end
    copyfile(timestamp,fullfile(file_destination,sprintf('timestamp%d.dat',fs)));  % added
end
msCam_Seq = msCam_Seq';

for SeqAlign = 1:length(msCam_Seq)
    msCam_Seq{SeqAlign,7} = strcat('msCam', num2str(SeqAlign), '.avi');
    sourcefile = char(fullfile(msCam_Seq(SeqAlign, 2), msCam_Seq(SeqAlign,1)));
    targetfile = char(fullfile(file_destination, msCam_Seq(SeqAlign,7)));
     [status, msg] = copyfile(sourcefile,targetfile);
    nFrame_file(SeqAlign) = VideoReader(targetfile);
end

%% save variable for achive
Archive_variable = fullfile(file_destination, strcat(path_structure(end),'_',date,  '.mat'));
save(char(Archive_variable))

