% Using reduced or full integration
function [gp,w] = ReducedFull(flag)
%Full or reduced integration
intchoice = flag;
if intchoice == 1
    gp = [0, 0];
    w = 4;
else
    gp = [-sqrt(1/3) -sqrt(1/3)
      sqrt(1/3) -sqrt(1/3)
      sqrt(1/3) sqrt(1/3)
      -sqrt(1/3) sqrt(1/3)];
    w = 1;
end

end