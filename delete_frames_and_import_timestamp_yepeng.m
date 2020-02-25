function [frame_all nf_new timestamp] = delete_frames_and_import_timestamp(filepath)
    cd (filepath)
    load(uigetfile('.mat','Get all frames'));
    raw_timestamp_data=dir(fullfile(filepath, 'timestamp*.dat'));
    %%
    [~,index]=natsort({raw_timestamp_data.name});raw_timestamp_data=raw_timestamp_data(index);clear index;
    raw_data_names={raw_timestamp_data.name};
    ntrials=numel(raw_data_names);
    delete_frames=[1 2*ntrials];
    behavioral_temp=repmat({''},1,ntrials);
    neuronal_temp=repmat({''},1,ntrials);
    count=1;
    for fs=1:ntrials
        raw_timestamp=importdata(string(raw_data_names(fs)),'\t',1);
        raw_timestamp=raw_timestamp.data;
        behavioral_numbers=(raw_timestamp(:,1)==0);
        behavioral_timestamps=raw_timestamp(behavioral_numbers,3);
        behavioral_temp(fs)={behavioral_timestamps};
        neuronal_numbers=(raw_timestamp(:,1)==1);
        neuronal_timestamps=raw_timestamp(neuronal_numbers,3);
        neuronal_temp(fs)={neuronal_timestamps};
        delete_frames(2*fs-1:2*fs)=[count count+1];
        count=count+length(neuronal_timestamps);
    end
    timestamp=struct('names',raw_data_names,'behavioral',behavioral_temp,'neuronal',neuronal_temp);
    
    %%
    dim_video= size(frame_all);
    imagesc(frame_all(1:dim_video(1), 1:dim_video(2), 3))
    check_before=[1 dim_video(3)];
    check_after=[1 dim_video(3)-2*ntrials];
    for ii=1:dim_video(3)
        check_before(ii) = mean2(frame_all(1:dim_video(1), 1:dim_video(2), ii));
    end
    frame_all(:, :, delete_frames) = [];
    for jj=1:(dim_video(3)-2*ntrials)
        check_after(jj) = mean2(frame_all(1:dim_video(1), 1:dim_video(2), jj));
    end
    %%
    dim_video_new=size(frame_all);
    nf_new=dim_video_new(3);
end

