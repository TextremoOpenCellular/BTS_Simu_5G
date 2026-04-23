%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ntnPrach = parseConfigurationsFRiPairedParams(ntnPrach, prach, timeOCCIdx)

    if strcmp(prach.DuplexMode, 'FDD')
        ntnPrach.DuplexMode = prach.DuplexMode;
        ntnPrach.FrequencyRange = prach.FrequencyRange;
        ntnPrach.ConfigurationIndex = prach.ConfigurationIndex;
        ntnPrach.SubcarrierSpacing = prach.SubcarrierSpacing;
        ntnPrach.SequenceIndex = prach.SequenceIndex;
        ntnPrach.RestrictedSet = prach.RestrictedSet;
        ntnPrach.ZeroCorrelationZone = prach.ZeroCorrelationZone;
        ntnPrach.FrequencyStart = prach.FrequencyStart;
        ntnPrach.ActivePRACHSlot = prach.ActivePRACHSlot;
        ntnPrach.RBOffset = prach.RBOffset;
        ntnPrach.RBSetOffset = prach.RBSetOffset;
        ntnPrach.SubframesPerPRACHSlot = prach.SubframesPerPRACHSlot;
        ntnPrach.PreambleIndex = prach.PreambleIndex;
        ntnPrach.NPRACHSlot = prach.NPRACHSlot;
        ntnPrach.ActivePRACHSlot = prach.ActivePRACHSlot;
        ntnPrach.TimeIndex = timeOCCIdx;

        if strcmp(prach.FrequencyRange, 'FR1')
            ntnPrach.SubframesPerPRACHSlot = 1;
            ntnPrach.LRA = 139;
            ntnPrach.PRACHSlotsPerPeriod = lcm( ntnPrach.Tables.ConfigurationsFRiPairedSUL{prach.ConfigurationIndex+1,3} * 10, ...
                                            round(max([1 ntnPrach.SubframesPerPRACHSlot])) ) / ntnPrach.SubframesPerPRACHSlot;
            if ismember(prach.ConfigurationIndex,[0,1,2,3,4,5])
                ntnPrach.Format = 'B4';
                ntnPrach.PRACHDuration = 12;
                ntnPrach.SymbolLocation = 14;
                ntnPrach.NumTimeOccasions = 1;
            elseif ismember(prach.ConfigurationIndex,[6,7,8,9,10,11])
                ntnPrach.Format = 'c2';
                ntnPrach.PRACHDuration = 6;
                ntnPrach.SymbolLocation = 14;
                ntnPrach.NumTimeOccasions = 2;
            else
                error("Wrong NTN configIndex config!")
            end
        else
            ntnPrach.Format = prach.Format;
            ntnPrach.PRACHDuration = prach.PRACHDuration;
            ntnPrach.SymbolLocation = prach.SymbolLocation;
            ntnPrach.NumTimeOccasions = prach.NumTimeOccasions;
            ntnPrach.PRACHSlotsPerPeriod = prach.PRACHSlotsPerPeriod;
            ntnPrach.SubframesPerPRACHSlot = prach.SubframesPerPRACHSlot;
            ntnPrach.LRA = prach.LRA;
        end
    else
        ntnPrach = prach;
    end
return