clear;
traindata = importdata('traindata.txt');
K = int32(10);
[N,~] = size(traindata);
N = int32(N);
fold = idivide(N,K,'floor');
X = traindata(:,1:8);
Y = traindata(:,9);
X1 = sqrt(X(:,1:4));
X2 = sqrt(X(:,6:8));
X3 = X(:,5);
Z1= cat(2,X1,X3,X2);
minTesterror = +Inf;
testError = [];

for p = 1:8
    tR = 0;
    test_R = 0;
    for k = 1:K
        Z = [];
        Z_test = [];
        testZ1 = Z1(fold*(k-1)+1:fold*k,:)';
        trainZ1 = [Z1(1:fold*(k-1),:);Z1(fold*k+1:N,:)]';
        testY = Y(fold*(k-1)+1:fold*k);
        trainY = Y([1:fold*(k-1),fold*k+1:N]);
        [N1, M1] = size(trainZ1);
        [N2, M2] = size(testZ1);
        for i = 1:p
            Z = [Z;trainZ1.^i];
        end
        for i = 1:p
            Z_test = [Z_test;testZ1.^i];
        end
        constant1 = ones(1,M1);
        constant2 = ones(1,M2);
        Z = [Z;constant1];
        Z_test = [Z_test;constant2];
        [w, R] = solve_weight(Z,trainY);
        tR = tR + R/M1;
        test_R = test_R + test_error(w, Z_test, testY)/M2;       
    end
    test_R = test_R / 10;
    tR = tR / 10;
    if(test_R<=minTesterror)
            minTesterror = test_R;
            minTR = tR;
            minP = p;
    end
    testError = [testError, tR];
end

% p = [1,2,3,4,5,6,7,8,9,10];
% plotdata(p,testError);
Z1 = Z1';
Z = [];

for i = 1:minP
    Z = [Z;Z1.^i];
end
constant = ones(1,N);
Z = [Z;constant];
[w_final, R_final] = solve_weight(Z,Y);
averageError = R_final / double(N);
fprintf('minP:%-4dminTR:%-15.4fminTesterror:%-15.4faverageError:%-10.4f\n',minP,minTR,minTesterror,averageError);