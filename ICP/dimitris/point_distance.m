function [D] = f1(q,q1) 
A1 = q;
A2 = q1;

R=eye;
t=0;

for i = 1 : length(A2) 
    CP(i,1)=A1(i,1)-A2(i,1);
    CP(i,2)=A1(i,2)-A2(i,2);
    CP(i,3)=A1(i,3)-A2(i,3);
    
    D(i)= sqrt(CP(i,1)^2 + CP(i,1)^2+ CP(i,1)^2) 
end


end