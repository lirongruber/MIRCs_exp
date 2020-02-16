function G = myFourierKernel(U,V)
% Sigmoid kernel function with slope gamma and intercept c
% if size(U,1)>1 || size(V,1)>1
%     1;
% end
q=0.25;
for i=1:size(U,1)
    G(i) = (1-q^2)./ (2*(1-2*q*cos(norm(U(i,:)-V,Inf)))+q^2);
end
end
