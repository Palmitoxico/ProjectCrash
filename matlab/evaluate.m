%
% evaluate.m
%
% This function get the array of found onsets and the ground-truth array 
% and returns the recall, the precision and the F-measure of the system. 
%
% y : array of found onsets 
% d : ground truth array
% h : number of correct results
% r : h / lenght(d)
% p : h / lenght(y)
%

function [r, p, F] = evaluate(y, d) 

% tolerance in ms
e = 20;

% order the arrays
y = sort(y);
d = sort(d);

% initialize the variables to the loop
h = 0;
j = 1;
i = 1;
ly = length(y);
ld = length(d);

while ( i <= ly ) && ( j <= ld ) 
   if ( abs(d(j) - y(i)) <= e ) % if its a hit
       h = h + 1;
       j = j + 1;
       i = i + 1;

   elseif ( abs(d(j) - y(i)) > e ) && ( d(j) < y(i) ) % if its a mistake in d
            j = j + 1;

   elseif ( abs(d(j) - y(i)) > e ) && ( d(j) > y(i) ) % if its a mistake in y
            i = i + 1;
  
   end      
end

r = h/ld;
p = h/ly;
F = 2*p*r/(p+r);

end
