%{
Uplink Simulation
@cellconf:  the config of a cell
@tticonf:   the config of TTI (transmission time interval). It is a slot for 5G but a subframe for 4G
@ueconf:    the configuation of UE (mostly on Tx/Rx ant num)
@simuconf:  the simulation config (e.g., the number of Frames, the number of slots, the SNR range & etc.)
%}
function ulsimu(sysconfig, tticonfig, simuconfig, ueconfig)
end



waveformInfo = hOFDMInfo(symParameters);
channelObj = [];
collectResult = cell(numel(simParameters.SNRIn), 1);
for case_idx = 1 : length(ttiConfig)
%%
slot
number
 dump mode
set
frame
and
for
if
simParameters.DumpIq
II simParameters.DumpRx
simParameters.frameSim = ttiConfig{case_idx}.sfn;
simParameters.slotSim
= ttiConfig{case_idx}.slot;
end
%% collect current slot beam ID
currentSlotBeamId = collect_slot_beam_id(ttiConfig{case_idx}, symParameters.cellBeamId);
%% simulation snr loop
for snrIdx = 1:numel(simParameters.SNRIn)
SNR= 10^(simParameters.SNRIn(snrIdx)/20);
noisePowAmp = 10^(simParameters.noisePowerdB/20);
signalPowAmp = SNR * noisePowAmp;
collectResult{snrIdx}.snr = simParameters.SNRIn(snrIdx);
for frameIdx = simParameters.frameSim
%% Reset the random number
generator
and
channel
if channel.FadingChannel
channelObj = nrTDLChannelInit(channel);
channel.amp = SNR;
end
for
slotIdx
= simParameters.slotSim
demodResults = [];
for beamId = currentslotBeamId
%% ul signal generation
[txGrid, txPrachWaveform,
UeInfo, txInfo] = phy_procedures_ue_tx(symParameters, UeInfo, ttiConfig{case_idx}, waveformInfo, frameIdx,
slotIdx,
simParameters, beamId);
fillFalg = 0;
samplesPerslot = getsamplesPerslot(slotIdx, symParameters);
txWaveform = zeros(samplesPerslot, simParameters.NTxAnts);
%% 0FDM modulation
if ~isempty(txGrid)
symParameters.NFFT, symParameters.SubcarrierSpacing,
slotIdx,
symParameters.ULFrequencyPoint);
txWaveform = txWaveform + ofdm_modulate(txGrid,
fillFalg = 1;
end
if
~isempty(txPrachWaveform)
if length(txPrachWaveform) == size(txWaveform, 1)
txWaveform = txWaveform + txPrachWaveform;
else
txWaveform = txPrachWaveform;
end
fillFalg = 1;
end
if
fillFalg == 0
continue;