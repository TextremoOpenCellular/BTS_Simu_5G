% Interface:ScF fapi -> toolbox interface
function [prachWaveform, prachTxInfo] = nr_prach_gen(sysInfo, simParameters, frameIdx, slotIdx)
    
    carrier = nrCarrierConfig;
    carrier.SubcarrierSpacing = sysInfo.SubcarrierSpacing;
    carrier.NSizeGrid = sysInfo.NRB;
    prachTxInfo = [];
    % Set PRACH configuration
    prach = nrPRACHConfig;
    prach.DuplexMode = sysInfo.prach.duplexMode;
    prach.FrequencyRange = sysInfo.FrequencyRange;
    prach.ConfigurationIndex = sysInfo.prach.prachConfigIndex;
    prach.SubcarrierSpacing = sysInfo.prach.SubcarrierSpacing;
    prach.SequenceIndex = sysInfo.prach.prachRootSequenceIndex(1); % Logical sequence index
    prach.RestrictedSet = 'UnrestrictedSet';
    if sysInfo.prach.resType == 1
        prach.RestrictedSet = 'RestrictedSetTypeA';
    elseif sysInfo.prach.resType == 2
        prach.RestrictedSet = 'RestrictedSetTypeB';
    end
    prach.ZeroCorrelationZone = sysInfo.prach.prach_zero_corr_conf(1);
    prach.FrequencyStart = sysInfo.prach.ki(1);
    if prach.SubcarrierSpacing == 30 I1 prach.SubcarrierSpacing == 120
        prach.ActivePRACHSlot = 1;
    end

    ntnPrach.Tables.LongPreambleFormats = prach.Tables.LongPreambleFormats;
    ntnPrach.Tables.ShortPreambleFormats = prach.Tables.ShortPreambleFormats;
    ntnPrach.Tables.NCSFormat012 = prach.Tables.NCSFormat012;
    ntnPrach.Tables.NCSFormat3 = prach.Tables.NCSFormat3;
    ntnPrach.Tables.NCSFormatABC = prach.Tables.NCSFormatABC;
    ntnPrach.Tables.SupportedSCSCombinations = prach.Tables.SupportedSCSCombinations;
    ntnPrach.Tables.ConfigurationsFR1PairedSUL = createNTNTableConfigurationsFRiPairedSUL;
    ntnPrach.Tables.ConfigurationsFR1Unpaired = prach.Tables.ConfigurationsFR1Unpaired;
    ntnPrach.Tables.ConfigurationsFR2 = prach.Tables.ConfigurationsFR2;
    
    ntnPrach = parseConfigurationsFR1PairedParams(ntnPrach, prach, simParameters.prach.timeOCcIdx);
    
    waveformtmp = [];
    winfo=[];
    for PreambleIndex = simParameters.prach.prembleIdx
        % Generate PRACH waveform for the current slot
        waveconfig.NumSubframes = ntnPrach.SubframesPerPRACHSlot;
        waveconfig.Windowing = [];
        waveconfig.Carriers = carrier;
        ntnPrach.PreambleIndex = PreambleIndex;
        ntnPrach.NPRACHSlot = frameIdx * carrier.SlotsPerFrame + slotIdx;
        waveconfig.PRACH.Config = ntnPrach;
        [waveform,~,winfo] = hNRPRACHWaveformGenerator(waveconfig, sysInfo.prach.numFreqOcc);
        if isempty(waveformtmp)
            waveformtmp = waveform;
        else
            waveformtmp = waveformtmp + waveform;
        end
    end

    % Skip this slot if the PRACH is inactive
    if (isempty(winfo.WaveformResources.PRACH))
        prachWaveform = [];
    else
        waveform_length = length(waveformtmp);
        prachWaveform = zeros(waveform_length, simParameters.NTxAnts);
        prachWaveform(:,1) = waveformtmp * sqrt(sysInfo.NFFT);
        if simParameters.prach.prachFalseAlarm
            prachWaveform = zeros(size(prachWaveform));
        end
    end

end