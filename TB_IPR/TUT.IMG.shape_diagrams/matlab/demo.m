% shape diagrams tutorial
close all
clear all
tic
hWaitBar = waitbar(0,'Diagrammes de formes');

name={'apple-' 'Bone-' 'camel-'};
color={'r' 'g' 'b'};
shape={'*' '+' 'o'};

format='.bmp';
indices=1:20;

% number of diagrams
N_diag=3;
x=zeros(N_diag, length(name)*length(indices));
y=zeros(N_diag, length(name)*length(indices));

xlabs={'\omega/d' '\omega/d' '2*r/d'};
ylabs={'2*r/d' '4A/(pi*d^2)' 'P/(pi*d)'};

% parameters for all images
for n=1:length(name)
    for i=indices
        I = imread([name{n} num2str(i) format]);
        [omega, d] = feret(I);
        [crofton, P] = perimetres(I);
        r = rayonInscrit(I);
        stats = regionprops(I>0, 'Area');
        ii = (n-1)*length(indices)+i;
        x(1,ii)=omega/d;
        x(2,ii)=omega/d;
        x(3,ii)=2*r/d;
        
        y(1,ii)=2*r/d;
        y(2,ii)=4*stats.Area/(pi*d^2);
        y(3,ii)=P/(pi*d); % valeurs superieures à 1, objets non convexes
        
        % progress bar
        waitbar(((n-1)*length(indices)+i)/(length(name)*length(indices)));
    end
end

close(hWaitBar);
toc

%% k-means: evaluates accuracy
X1=x(1,:);
X2=x(2,:);
X3=x(3,:);
Y1=y(1,:);
Y2=y(2,:);
Y3=y(3,:);
idx1 = kmeans([X1',Y1'],3);
idx2 = kmeans([X2',Y2'],3);
idx3 = kmeans([X3',Y3'],3);

% accuracy 
accuracy1 = (sum(idx1(1:20)==mode(idx1(1:20))) + sum(idx1(21:40)==mode(idx1(21:40))) + sum(idx1(41:60)==mode(idx1(41:60))))/60*100
accuracy2 = (sum(idx2(1:20)==mode(idx2(1:20))) + sum(idx2(21:40)==mode(idx2(21:40))) + sum(idx2(41:60)==mode(idx2(41:60))))/60*100
accuracy3 = (sum(idx3(1:20)==mode(idx3(1:20))) + sum(idx3(21:40)==mode(idx3(21:40))) + sum(idx3(41:60)==mode(idx3(41:60))))/60*100


% display 3 shape diagrams, with colors according to real class, and shape
% according to result of kmeans
id = {idx1; idx2; idx3};
for j=1:N_diag
    figure();
    hold on
    idx = id{j};
    for i=1:length(name)
        i1=length(indices)*(i-1)+1;
        i2=length(indices)*i;
        for k=i1:i2
            plot(x(j,k), y(j,k),[ color{i} shape{idx(k)}]); 
        end
        
    end

    %title(['Diagram ' num2str(j)]);
    xlabel(xlabs{j});
    ylabel(ylabs{j});
end
