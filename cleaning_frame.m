function [m_out, nf_new, msCam_ts] = cleaning_frame(m_in, path_name, file_base)
%
raw_timestamp_data = dir(fullfile(path_name, '*.dat'));
[~,index]=natsort({raw_timestamp_data.name});raw_timestamp_data=raw_timestamp_data(index);clear index;

ntrials=length(raw_timestamp_data);

for fs=1:ntrials
    raw_timestamp=readtable(string(fullfile(path_name, raw_timestamp_data(fs).name)));
    behavCam_nFrame=find(raw_timestamp.camNum==0);
    msCam_nFrame=(raw_timestamp.camNum==1);
    
    frame_id(fs).behavCam = raw_timestamp(behavCam_nFrame, :); frame_id(fs).behavCam.trial(:) = fs;
    frame_id(fs).msCam = raw_timestamp(msCam_nFrame, :); frame_id(fs).msCam.trial(:) = fs;
    
    
    behavioral_timestamps=raw_timestamp(behavCam_nFrame,3);
    behavioral_temp(fs)={behavioral_timestamps};
    

end



behavframe_id_session= vertcat(frame_id.behavCam);
msframe_id_session= vertcat(frame_id.msCam);
for fs=1:ntrials
    ms_badframe(1, fs) = intersect(find(msframe_id_session.trial == fs),find(msframe_id_session.frameNum == 1));
    ms_badframe(2, fs) = ms_badframe(1, fs)+1;
end


%     timestamp=struct('names',raw_data_names,'behavioral',behavioral_temp,'neuronal',neuronal_temp);
%
%%

% dim_video= size(m_in, 'frame_all');
% %     imagesc(frame_all(1:dim_video(1), 1:dim_video(2), 3))
% 
% check_before=zeros(1, length(m_in.frame_all));
% 
% for ii=1:dim_video(3)
%     check_before(ii) = mean2(m_in.frame_all(1:dim_video(1), 1:dim_video(2), ii));
% end
% subplot(1,2,1)
% plot(check_before)
% ylim([0 0.5])

% loadname = strcat(file_base, '_frame_all.mat');
% target_file = string(fullfile(path_name, loadname));
% m_out = matfile(target_file, 'Writable', true);

m_in.Properties.Writable = true;

m_in.frame_all(:, :, ms_badframe) = []; % Delete bad frame
msframe_id_session(ms_badframe, :) = []; % delete ts for bad frame

m_out = m_in;
% dim_video= size(m_out, 'frame_all');
% check_after=zeros(1, length(m_in));
% 
% for jj=1:dim_video(3)
%     check_after(jj) = mean2(m_out.frame_all(1:dim_video(1), 1:dim_video(2), jj));
% end
% subplot(1,2,2)
% plot(check_after)
% ylim([0 0.5])

%%
dim_video_new=size(m_out.frame_all);
nf_new=dim_video_new(3);
msCam_ts = msframe_id_session; 

end

