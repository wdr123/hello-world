function [A b] = make_triangular(A,b)

[N,~] = size(A);
for i=1:N
    for j=i+1:N
        factor = -A(j,i)/A(i,i);
        A(j,:) = A(j,:) + factor*A(i,:);
        b(j)   = b(j)   + factor*b(i);
    end
end
