function Z = expansion(X, choice)

if strcmp(choice,'basis')==1
% basis expansion
[~, n] = size(X)
affine = ones(1,n);
Z = [X;affine];
elseif strcmp(choice,'qua') == 1
% quadratic expansion
[~, n] = size(X)
sec = ones(1,n);
third = X.^2;
Z = [X;sec;third];
elseif strcmp(choice,'nonlinear') == 1
    first = sin(2*X);
    sec = log(X);
    third = sqrt(X);
    Z = [first;sec;third];
end
end

