clear;clc;
traindata = importdata('traindata.txt');
K = int32(5);
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

for p = 1:7
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
        tR = tR + R;
        test_R = test_R + test_error(w, Z_test, testY);       
    end
    test_R = test_R / 5;
    tR = tR / 5;
    if(test_R<=minTesterror)
            minTesterror = test_R;
            minTR = tR;
            minP = p;
    end  
end

Z1 = Z1';
Z = [];

for i = 1:minP
    Z = [Z;Z1.^i];
    constant = ones(1,N);
    Z = [Z;constant];
end
[w_final, R_final] = solve_weight(Z,Y);
averageError = sqrt(R_final / double(N));
fprintf('minP:%-4dminTR:%-15.4fminTesterror:%-15.4faverageError:%-10.4f\n',minP,minTR,minTesterror,averageError);