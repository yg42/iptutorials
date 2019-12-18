% reads volumes and computes reconstruction
volumes = {'volume_cornee.tif', 'volume_vickers.tif'};
nom     = {'cornee', 'vickers'};
methode = {'tenengrad', 'varianceTenengrad', 'variance', 'SML'};
fonction= {'tenengradSFF', 'varianceTenengradSFF', 'varianceSFF', 'modifiedLaplacianSFF'};
images = {'texture', 'altitude'};

for i =1:length(volumes)
    for f = 1:length(fonction)
        
    [Z, T] = feval(fonction{f}, volumes{i}, 7);
    
    % save images
    imwrite(uint8(255*T/max(T(:))), [images{1} '_' methode{f} '_' nom{i} '.png']);
    imwrite(uint8(255*double(Z)/max(double(Z(:)))), [images{2} '_' methode{f} '_' nom{i} '.png']);
    end
end