classdef Prach < handle
    properties(Constant)
        DUPLEX_MODEs = ["FDD", "TDD"];
        FRs = ["FR1", "FR2"];
        CONFID_MAX_FR1_FDD = 255;
        CONFID_MAX_FR1_TDD = 262;
        CONFID_MAX_FR2_TDD = 255;
        RESTRICT_SETs = ["UnrestrictedSet", "RestrictedTypeA", "RestrictedTypeB"];
        NCS_MAX = 15;
    end


    properties
        config = NaN;
    end
        
    methods
        %{
        loade the prach configuration
        <input-FD>
        @freqRng:       frequency range, 'FR1' or 'FR2'
        @duplmod:       duplex mode, 'FDD' or 'TDD'
        @confId:        prach configuration index
        @scs:           scs(1.25, 5, 15, 30, 60, 120, 480, 960)
        @restrictSet:   restrict set, "UnrestrictedSet", "RestrictedTypeA", "RestrictedTypeB"
        @Ncs:           ZeroCorrelationZoneConfig (TS38211 Table 6.3.3.1-5 ~ Table 6.3.3.1-7)
        <input-TD>
        @k1:            the frequency offset as `k1` in
        %}
        function self = Prach(freqRng, duplmod, confId, scs, restrictSet, Ncs, ...
                              k1)
            %% input check
            freqRng = upper(char(freqRng));
            assert(ismember(freqRng, self.FRs), "Frequency range can only be 'FR1' or 'FR2'");
            duplmod = upper(char(duplmod));
            assert(ismember(duplmod, self.DUPLEX_MODEs), "Duplex mode can only be 'FDD' or 'TDD'");
            assert( ~strcmp(freqRng, 'FR2') || strcmp(duplmod, 'TDD'), "FR2 can only use TDD");                       % `TS38101-2 Table 5.2-1: NR operating bands in FR2` declares that FR2 only uses TDD 
            % confId
            assert(confId >=0, "confId must be greater than or equal to 0");
            assert(~strcmp(freqRng, "FR1") || ~strcmp(duplmod, 'FDD') || confId <= self.CONFID_MAX_FR1_FDD, "configID must be in [0, %d] for %s, %s", self.CONFID_MAX_FR1_FDD, freqRng, duplmod);
            assert(~strcmp(freqRng, "FR1") || ~strcmp(duplmod, "TDD") || confId <= self.CONFID_MAX_FR1_TDD, "configID must be in [0, %d] for %s, %s", self.CONFID_MAX_FR1_TDD, freqRng, duplmod);
            assert(~strcmp(freqRng, "FR1") || confId <= self.CONFID_MAX_FR1_TDD, "configID must be in [0, %d] for %s, %s", self.CONFID_MAX_FR1_TDD, freqRng, duplmod);
            % scs
            assert(ismember(scs, [1.25, 5, 15, 30, 60, 120, 480, 960]), "Subcarrier spacing can only be [1.25, 5, 15, 30, 60, 120, 480, 960]");
            % restrict set
            restrictSet = char(restrictSet);
            assert(ismember(restrictSet, self.RESTRICT_SETs), "restrictSet must be 'UnrestrictedSet', 'RestrictedTypeA', 'RestrictedTypeB'");
            % Ncs
            assert(Ncs >=0 && Ncs <= self.NCS_MAX, "Ncs must be [0, %d]", self.NCS_MAX);
            % k1

            % load the config
            self.config = nrPRACHConfig("FrequencyRange", freqRng, ...
                                        "DuplexMode", duplmod, ...
                                        "ConfigurationIndex", confId, ...
                                        "SubcarrierSpacing", scs, ...
                                        "RestrictedSet", restrictSet, ...
                                        "ZeroCorrelationZone", Ncs ...
                                        );
            self.config.SequenceIndex = 0;             % the preamble index (0~63), only given when actually generate PRACH
  
        end

        %{
        generate the waveform in the time domain
        @sfn:           system frame number
        @nslot:         slot number in the frame
        @preambleId:    the preamble id (0~63) to send
        %}
        function y = gen(sfn, nslot, preambleId)
            a= hNRPRACHWaveformGenerator(nrPRACHConfig);
        end
        
    end

end