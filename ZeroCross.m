%-------------------------------------------------------------------------%
%  Electromyography (EMG) Feature Extraction source codes demo version    %
%                                                                         %
%  Programmer: Jingwei Too                                                %
%                                                                         %
%  E-Mail: jamesjames868@gmail.com                                        %
%-------------------------------------------------------------------------%

function ZC=ZeroCross(X,thres)
N=length(X); ZC=0;
for i=1:N-1
  if ((X(i) > 0 && X(i+1) < 0) || (X(i) < 0 && X(i+1) > 0)) ...
      && (abs(X(i)-X(i+1)) >= thres)
    ZC=ZC+1;
  end
end
end

% function [ZC_L,ZC_R]=jZC(X,thres)
% N=length(X); ZC_L=0;ZC_R=0;
% for i=1:N-1
%   if ((X(i) > 0 && X(i+1) < 0) || (X(i) < 0 && X(i+1) > 0)) ...
%       && (abs(X(i)-X(i+1)) >= thres)
%     ZC_L=ZC_L+1;
%     ZC_R=ZC_R+1;
%   end
% end
% end
