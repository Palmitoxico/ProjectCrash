%
% evaluate.m
%
% This function get the array of found onsets and the ground-truth array 
% and returns the recall, the precision and the F-measure of the system. 
%
% y : array of found onsets 
% d : ground truth array
% R : number of correct results in d
% r : R / lenght(d)
% P : number of correct results in y
% p : P / lenght(y)
%

function [r, p, F] = evaluate(y, d) 

% tolerance
e = 0.2;

% order the arrays
y = sort(y);
d = sort(d);

% initialize the variables to the loop
R = 0;
P = 0;
j = 1;
i = 1;
ly = length(y);
ld = length(d);

while ( i <= ly ) && ( j <= ld )
   if ( norm(d(j) - y(i)) <= e )
       R = R + 1;
       P = P + 1;
       j = j + 1;
       i = i + 1;

   elseif ( norm(d(j) - y(i)) > e ) && ( d(j) < y(i) )
            j = j + 1;

   elseif ( norm(d(j) - y(i)) > e ) && ( d(j) > y(i) )  
            i = i + 1;
  
   end      
end

r = R/ld;
p = P/ly;
F = 2*p*r/(p+r);

end