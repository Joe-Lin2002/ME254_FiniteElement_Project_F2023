% Using reduced or full integration
function [GP,w] = ReducedFull()
%Full or reduced integration
intchoice = input('Enter 1 for reduced integration, 2 for full integration: ');
if intchoice == 1
    GP = 0;
    w = 4;
else
    GP = [-sqrt(1/3) -sqrt(1/3)
      sqrt(1/3) -sqrt(1/3)
      sqrt(1/3) sqrt(1/3)
      -sqrt(1/3) sqrt(1/3)];
    w = 1;
end

end