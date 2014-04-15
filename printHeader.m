function printHeader(sceneInfo,scenario,randrun)


printMessage(2,' =====================================================================\n');
printMessage(2,'|                Discrete-Continuous Optimization                     |\n');
printMessage(2,'|                With Explicit Exclusion Handling                     |\n');
printMessage(2,'|                                                                     |\n');
printMessage(2,'|       Scenario: %10d           Random Run: %15d    |\n', ...
    scenario, randrun);

if all(isfield(sceneInfo,{'dataset','sequence'}))
printMessage(2,'|       Dataset: %11s           Sequence: %17s    |\n',sceneInfo.dataset,sceneInfo.sequence);
end

% :\nSCENARIO %i, LEXP %i, RAND %i: %i frames (%i:%i:%i)\n', ...
%     scenario,lexperiment,randrun,length(frameNums),frameNums(1),frameNums(2)-frameNums(1),frameNums(end));
printMessage(2,' =====================================================================\n\n');

end