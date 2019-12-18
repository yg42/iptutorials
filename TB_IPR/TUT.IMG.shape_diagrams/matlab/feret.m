function [d,D] = feret(I)
% Feret diameter
% minimum: d (meso-diametre)
% maximum: D (exo-diametre)

% Algorithm:
% loop on all angles
% rotate the image and evaluate projection

% Initialisation des variables
d=max(size(I));
D=0;
% use an angle increment of 30 degrees, and evaluates min and max
for a=0:30:179
    I2 = imrotate(I, a);
    F=max(I2);
    mesure=sum(F>0);
    
    if (mesure<d)
        d=mesure;
    end
    if (mesure>D)
        D=mesure;
    end
end