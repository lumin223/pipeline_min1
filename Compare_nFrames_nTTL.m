for currentTrial = 1:SessionData.nTrials
    nFrames_1(currentTrial) = length(SessionData.RawEvents.Trial{currentTrial}.Events.BNC1Low);
    nFrames_2(currentTrial) = length(SessionData.RawEvents.Trial{currentTrial}.Events.BNC1High);
end

nFrame_Video = zeros(1, SessionData.nTrials);
for currentTrial = 1:length(nFrame_file)
nFrame_Video(1, currentTrial) = nFrame_file(currentTrial).Duration * 20;
nFrame_Video(2, currentTrial) = nFrame_Video(1, currentTrial)/2;
end
nFrame_Video(3,:) = cumsum(nFrame_Video(2,:));
frame_check = [nFrames_1; nFrames_2; nFrame_Video];

 frame_check(4, :) = round(frame_check(3, :)/2)
 

 frame_check(5, n) = frame_check(1, :)/frame_check(4, :);
 
 %% final image display (frame by frame)
 dim_video= size(frame_all);
%  imagesc(frame_all(1:dim_video(1), 1:dim_video(2), 3))

 % Total photon calculation (per frame)
for ii=1:dim_video(3)
    check(ii) = mean2(frame_all(1:dim_video(1), 1:dim_video(2), ii));
end

plot(check)

%% sample code to delete black + dimm frame
bkFrames = [1, 300, 535, 798, 1032, 1218, 1414, 1597, 1811, 1981, 2168];
dimFrames = bkFrames + 1;
badFrames = horzcat(bkFrames, dimFrames);

frame_all(:, :, badFrames) = [];
 