clear;
traindata = importdata('traindata.txt');
Test = importdata('testinputs.txt');
X = traindata(:,1:8);
Y = traindata(:,9);
Z = CreaterootFeatures(X,5);
Z_final = CreaterootFeatures(Test,5);
n = length(Y);
c = cvpartition(n,'HoldOut',0.3);
idxTrain = training(c,1);
idxTest = ~idxTrain;
XTrain = Z(idxTrain,:);
yTrain = Y(idxTrain);
XTest = Z(idxTest,:);

yTest = Y(idxTest);
testNum = size(yTest,1);
[B,FitInfo] = lasso(XTrain,yTrain);
idxLambdaMinMSE = 1;
coef = B(:,idxLambdaMinMSE);
coef0 = FitInfo.Intercept(idxLambdaMinMSE);
k = find(coef);
Z_new = XTest(:,k);
Z_final = Z_final(:,k);
w = coef(k);
test_error = sum((yTest-Z_new*w-coef0).^2)/testNum;
fid=fopen('lasso_predicted.txt','w+');
fprintf(fid,'%3d \r\n',Z_final*w+coef0);
fclose(fid);