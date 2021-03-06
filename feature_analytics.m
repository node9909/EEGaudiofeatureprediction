function feature_analytics(features)

f = [mean(features.audio.mapped2EEG.ITD,2)...
    mean(features.audio.mapped2EEG.ILD,2)...
    mean(features.audio.mapped2EEG.onsets,2)...
    mean(features.audio.mapped2EEG.offsets,2)...
    features.audio.mapped2EEG.spectral_centriod'...
    features.audio.mapped2EEG.spectral_brightness'...
    features.audio.mapped2EEG.spectral_flux'...
    mean(features.Kayser.mapped2EEG.saliency,2)...
    features.Elhilali.mapped2EEG.saliency'...
    features.Elhilali.mapped2EEG.envelope'...
    features.Elhilali.mapped2EEG.pitch'...
    features.Elhilali.mapped2EEG.specgram'...
    features.Elhilali.mapped2EEG.bw'...
    features.Elhilali.mapped2EEG.rate'];

labels = {'ITD','ILD','onsets','offsets',...
    'centroid','bright','flux','Ksal',...
    'Esal','env','pitch','specgram','bw','rate'};

figure;
boxplot(f,'plotstyle','compact','labels',labels);

figure;
for i = 1:7
    subplot(7,2,i);
    jwd = f(:,i);
    jwd(jwd==0) = NaN;
    hist(jwd,100);
    title(labels{i})
end
for i = 8:14
    subplot(7,2,i);
    jwd = f(:,i);
    jwd(jwd==0) = NaN;
    hist(jwd,100);
    title(labels{i})
end

