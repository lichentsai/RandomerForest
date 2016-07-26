close all
clear
clc

rng(1);

fpath = mfilename('fullpath');
rerfPath = fpath(1:strfind(fpath,'RandomerForest')-1);

n = 100;
ns = [10 20 50];
ih = 20;
iw = ih;

X_image = zeros(ih,iw,n);
Y = zeros(n,1);

%Class 0
X_image(:,1:iw/2,1:n/2) = rand(ih,iw/2,n/2)<1/3;
X_image(:,iw/2+1:end,1:n/2) = rand(ih,iw/2,n/2)>1/3;

%Class 1
X_image(:,1:iw/2,n/2+1:end) = rand(ih,iw/2,n/2)>1/3;
X_image(:,iw/2+1:end,n/2+1:end) = rand(ih,iw/2,n/2)<1/3;
Y(n/2+1:end) = 1;

NewOrdering = randperm(n);
X_image = X_image(:,:,NewOrdering);
Y = Y(NewOrdering);
Labels = unique(Y);

ntrials = 10;

for k = 1:length(ns)
        nTrain = ns(k);
    
    for trial = 1:ntrials

        Idx = [];
        for l = 1:length(Labels)
            Idx = [Idx randsample(find(Y==Labels(l)),round(nTrain/length(Labels)))'];
        end
        TrainIdx{k}(trial,:) = Idx(randperm(length(Idx)));
    end
end

save([rerfPath 'RandomerForest/Data/image_simulation_data.mat'],'ns','ntrials',...
    'TrainIdx','X_image','Y')