function EEGanalysis(eegfile)

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

EEG = pop_biosig(eegfile,'channels',[1:3,8:22]);

labels = {'R5','R3','R1','R2','R4','R6','R8','R7','L7','L5','L4a','L3','L1','L2','L4','L4b','L6','L8'}

for c=1:length(EEG.chanlocs)
    EEG.chanlocs(c).labels = labels{c}; 
end

% display('Stefans Setup')
% labels={{1,'R7'},{2,'R3'},{3,'R1'}, {4,'Second Pin (fl)'},{5,'Thrid Pin (fl)'},...
%         {6,'Forth Pin (fl)'}, {7,'First Pin (fl)'},{8,'R2'},{9,'R4'},...
%         {10,'R8'},{11,'R10'},{12,'R9'}, {13,'L9'},{14,'L7'},{15,'DRL Hom'},...
%         {16,'L3'},{17,'L1'},{18,'L2'}, {19,'L4'},{20,'REF Hom'},{21,'L8'},...
%         {22,'L10'},{23,'Yaw'},{24,'Pitch'}, {25,'Roll'}};
% for ch=1:EEG.nbchan
%     EEG.chanlocs(ch).labels=labels{ch}{2};
% end
% EEG = pop_select( EEG,'nochannel',{'x1' 'x2' 'x3' 'x4' 'x5' 'x6' 'GyroX' 'GyroY' 'GyroZ'});
        

% rereference to linked mastoids (FROM SD, NOT SURE WHERE THE /2 COMES FROM)
EEG.data(16,:) = EEG.data(16,:)/2;
EEG = pop_reref(EEG,16);

EEG = pop_select(EEG,'nochannel',11); % rigt DRL

% remove a bad channel
EEG = pop_select(EEG,'nochannel',1);
EEG.badchan = 1;

% filter
EEG = pop_eegfiltnew(EEG,[],.5,8250,true,[],0);
EEG = pop_eegfiltnew(EEG,[],20,330,0,[],0);

EEG = pop_runica(EEG, 'extended',1,'interupt','on');
%EEG = pop_subcomp(EEG,[1 2 3],0);

% concatenate all recordings, then do ICA on filtered and pruned data
% (1-40/50 Hz), (then perhaps reject again on ICA time course), then apply
% weights to pruned raw data (although we don#t actually do that because we
% will predict from the ICA time courses directly).
% Also, calculate contralateralty and ITD/ILD relationship!
% Cross-validation to see whether that is predictive
