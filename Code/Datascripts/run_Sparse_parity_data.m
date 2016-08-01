close all
clear
clc

fpath = mfilename('fullpath');
rerfPath = fpath(1:strfind(fpath,'RandomerForest')-1);

rng(1);

ntrain = 1000;
ntest = 10000;
dims = [2 5 10 15 25 50 100];
ndims = length(dims);
ntrials = 10;
Class = [0;1];
Xtrain = cell(1,ndims);
Ytrain = cell(1,ndims);
Xtest = cell(1,ndims);
Ytest = cell(1,ndims);

for i = 1:ndims
    d = dims(i);
    fprintf('d = %d\n',d)
    dgood = min(3,d);
    x = zeros(ntrain,d,ntrials);
    y = cell(ntrain,ntrials);
    Sigma = 1/32*ones(1,d);
    for trial = 1:ntrials
        Mu = sparse(ntrain,d);
        for jj = 1:ntrain
            Mu(jj,:) = binornd(1,0.5,1,d);
            x(jj,:,trial) = mvnrnd(Mu(jj,:),Sigma);
        end
        nones = sum(Mu(:,1:dgood),2);
        y(:,trial) = cellstr(num2str(mod(nones,2)));
    end
    Xtrain{i} = x;
    Ytrain{i} = y;
    
    Xtest{i} = zeros(ntest,d);
    Mu = sparse(ntest,d);
    for jj = 1:ntest
        Mu(jj,:) = binornd(1,0.5,1,d);
        Xtest{i}(jj,:) = mvnrnd(Mu(jj,:),Sigma);
    end
    nones = sum(Mu(:,1:dgood),2);
    Ytest{i} = cellstr(num2str(mod(nones,2)));
end

save([rerfPath 'RandomerForest/Data/Sparse_parity_data.mat'],'Xtrain','Ytrain',...
    'Xtest','Ytest','ntrain','ntest','dims','ntrials')