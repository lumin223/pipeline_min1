clc; clear; close all;
folder = uigetdir('title',"Choose the folder where pre-processed videos are");
videos = dir(fullfile(folder,'msCam*.avi'));
% videos(1:2)=[];
[~,index] = natsort({videos.name}); videos = videos(index); clear index;   % use the natsort function
count=0;
end_frame_of_each_video=zeros([1 numel(videos)]);
cd (folder)
video_out=VideoWriter('test.avi','Grayscale AVI');
video_out.FrameRate = 20;
open(video_out);

%%
% frames=readFrame(video, [3 inf]);
tic
for i = 1:length(videos)
    video=VideoReader(videos(i).name);
    number_of_frames = int16(fix(video.FrameRate*video.Duration));  % NumberOfFrames cannot be accessed after using readFrame.
    readFrame(video); readFrame(video);
    while hasFrame(video)
        frame_curr=readFrame(video);
        writeVideo(video_out,frame_curr);
        count=count+1;
    end
    end_frame_of_each_video(i) = count;
	frame_end=frame_curr;
end
end_frame_record = fopen('end_frame_record.txt','a');
fprintf(end_frame_record, '%d\n', end_frame_of_each_video);
close(video_out);
fclose(end_frame_record);
toc
