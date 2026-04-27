classdef SimuConf < handle
    properties
        nFrame{mustBeInteger}  = 1;
        nSlot{mustBeInteger}   = 1;
    end

    methods
        %{
        constructor
        @path_conf:     the config file path
        %}
        function self = SimuConf(path_conf)
        end
    end
end