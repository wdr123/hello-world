traindata = importdata('traindata.txt');
K = int32(5);
[N,~] = size(traindata);
N = int32(N);
fold = idivide(N,K,'floor');
adj = [1,2,3,4,5,8];
X = traindata(:,1:8);
Y = traindata(:,9);
X1 = sqrt(X(:,1:4));
X2 = sqrt(X(:,6:8));
X3 = X(:,5);
Z1= cat(2,X1,X3,X2);
Z = zeros(N,15);
Z_test = zeros(N,15);
minTesterror = +Inf;

for count = 0:63
    order = bitget(count,6:-1:1) + 1;
    test_R = 0;
    tR = 0;
    for k = 1:K
        testZ1 = Z1(fold*(k-1)+1:fold*k,:);
        trainZ1 = Z1([1:fold*(k-1),fold*k+1:N],:);
        testY = Y(fold*(k-1)+1:fold*k);
        trainY = Y([1:fold*(k-1),fold*k+1:N]);
        [N1, ~] = size(trainZ1);
        [N2, ~] = size(testZ1);
        for i = 1:N1
            s = 1;
            for j = 1:6
                if order(j) == 1
                    Z(i,s) = trainZ1(i,adj(j));
                    if i <= N2
                        Z_test(i,s) = testZ1(i,adj(j));
                    end
                    s = s + 1;
                else
                    Z(i,s) = trainZ1(i,adj(j));
                    Z(i,s+1) = trainZ1(i,adj(j))^2;
                    if i <= N2
                        Z_test(i,s) = testZ1(i,adj(j));
                        Z_test(i,s+1) = testZ1(i,adj(j))^2;
                    end
                    s = s + 2;
                end
            end
            Z(i,s) = trainZ1(i,6);
            Z(i,s+1) = trainZ1(i,7);
            Z(i,s+2) = 1;
            if i <= N2
                Z_test(i,s) = testZ1(i,6);
                Z_test(i,s+1) = testZ1(i,7);
                Z_test(i,s+2) = 1;
            end
            s = s + 3;
        end
        Z = Z(1:N1,1:s-1)';
        Z_test = Z_test(1:N2,1:s-1)';
        [w, R] = solve_weight(Z,trainY);
        tR = tR + R;
        test_R = test_R + test_error(w, Z_test, testY);       
    end
    test_R = test_R / 5;
    tR = tR / 5;
    if(test_R<=minTesterror)
            minTesterror = test_R;
            minOrder = order;
            minTR = tR;
    end  
end

for i = 1:N
    s = 1;
    for j = 1:6
        if minOrder(j) == 1
                    Z(i,s) = Z1(i,adj(j));
                    s = s + 1;
        else
            Z(i,s) = Z1(i,adj(j));
            Z(i,s+1) = Z1(i,adj(j))^2;                   
            s = s + 2;
        end
    end
    Z(i,s) = Z1(i,6);
    Z(i,s+1) = Z1(i,7);
    Z(i,s+2) = 1;
    s = s+3;
end
Z = Z(1:N,1:s-1)';
[minW, train_R] = solve_weight(Z,Y);
test_R = minTesterror;