
function []=func_Plot(T,Yout)
%Tip: If you are calling the HPA function in a for loop, you might want to
%comment this section out or use "close all" in the command line. (So it
%doesn't print out 21 figures)
 figure
         subplot(2,2,1)
         plot(T,Yout(:,1))
         xlabel('time(h)'), ylabel('CRH')
         subplot(2,2,2)
         plot(T,Yout(:,2))
         xlabel('time(h)'), ylabel('ACTH')
         subplot(2,2,3)
         plot(T,Yout(:,3))
         xlabel('time(h)'), ylabel('CORT(micrograms/dL)')
         subplot(2,2,4)
         plot(T,Yout(:,4))
         xlabel('time(h)'), ylabel('GR')
