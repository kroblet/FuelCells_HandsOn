
% Since Pressure and Temperature at A are at reference, mdot_A = mdot_corrected in grams/s
mdot_corrected = simlogCompressorMap.Compressor_G.mdot_A.series.values('g/s');

% Pressure Ratio
PR = simlogCompressorMap.Compressor_G.B.p.series.values ./ simlogCompressorMap.Compressor_G.A.p.series.values;

% The code below plots the compressor map using the same function as the
% simscape block available by right clicking on the block and selecting
% Fluid > Plot Compressor Map
handle = getSimulinkBlockHandle('CompressorMap/Compressor (G)');
fluids.internal.mask.plotCompressorMap(handle)
hold on
% Plot operating line of compressor transient
plot(mdot_corrected, PR,'g','DisplayName','Operating Line')