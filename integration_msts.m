function [msCamData_Timestamp] = integration_msts(SessionData, msdata, msCamTimestamp)
%

sd = load('H:\data\2020-02-10_10-08-02\raw\bpod\GRIN_621a_N_SR_20200210_100740.mat');
msdata = load('C:\Users\Kyuhyun\Videos\20200210_cat\msCam_data_processed.mat');
path_name = 'C:\Users\Kyuhyun\Videos\20200210_cat';

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

msframe_id_session(ms_badframe, :) = []; % delete ts for bad frame

for ii = 1:height(msframe_id_session)
    msframe_id_session.abs_ts(ii) = msframe_id_session.sysClock(ii)/1000 + sd.SessionData.TrialStartTimestamp(msframe_id_session.trial(ii)) + sd.SessionData.Info.SessionStartTime_MATLAB;
end


msdata.ts = msframe_id_session.abs_ts';


end

