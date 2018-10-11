function [Output]=HPAwMRwbell(input1,input2,input3)    %HPA model
fprintf('HPA function\n');
global T Yout horm 
Tbegin=0;
Tend=500; %hrs
%For an accurate estimation pick any Tend>150, bc periodic solution, the ODE depends on the last values of the first ode function. 
%% First ODE call
    options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4 1e-4 1e-4 1e-4]);
    [T,Y] = ode45(@(t,y) fun(t,y,10,1.5),[Tbegin 150],[0.1 0.3 0.5 0.3,0.2],options);
    v0=Y(end,:);

%% Second ODE call
    options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4 1e-4 1e-4 1e-4],'Events',@events);
    [T,W,TE,YE,IE] = ode45(@(t,y) fun2(t,y,input1,input2),[Tbegin Tend],v0,options);
    Tout=T;
    Yout=W;
    TEout=TE;  
    YEout=YE;  
    IEout=IE;
horm = 3;
calc = input3;

if calc == 1
    % ----------------Average height----------------%
    [xdim ydim] = size(YE);
    if xdim>=5
         Amplitude = (abs(YE(4,horm)-YE(5,horm)))/2;
         if YE(4,horm)<YE(5,horm)
             Output = YE(4,horm)+Amplitude;
         elseif YE(4,horm)>YE(5,horm)
             Output = YE(5,horm)+Amplitude;
         else
             print('Weird');
             Output = 0;
         end
    elseif xdim>=4
        Amplitude = (abs(YE(4,horm)-YE(3,horm)))/2;
         if YE(3,horm)<YE(4,horm)
             Output = YE(3,horm)+Amplitude;
         elseif YE(3,horm)>YE(4,horm)
             Output = YE(4,horm)+Amplitude;
         else
             print('Weird');
             Output = 0;
         end
    elseif xdim>=3
         Amplitude = (abs(YE(2,horm)-YE(3,horm)))/2;
         if YE(2,horm)<YE(3,horm)
             Output = YE(2,horm)+Amplitude;
         elseif YE(2,horm)>YE(3,horm)
             Output = YE(3,horm)+Amplitude;
         else
             print('Weird');
             Output = 0;
         end
    elseif xdim>=2
        Amplitude = (abs(YE(2,horm)-YE(1,horm)))/2;
         if YE(1,horm)<YE(2,horm)
             Output = YE(1,horm)+Amplitude;
         elseif YE(1,horm)>YE(2,horm)
             Output = YE(2,horm)+Amplitude;
         else
             print('Weird');
             Output = 0;
         end
    else
        lenn = Tend/2;
        Output = (Yout(Tend-1)+Yout(Tend))/2;
    end
         
         
         
elseif calc == 2
%------------Calculating waveheight based off of one oscillation-------%
    [xdim ydim] = size(YE);
    if xdim > 3
        wave_Height = abs(YE(2,horm)-YE(3,horm));
        Output = wave_Height;
    elseif xdim >= 2
        wave_Height = abs(YE(1,horm)-YE(2,horm));
        Output = wave_Height;
    else
        wave_Height = 0;
        Output = wave_Height
    end
elseif calc == 3
    Len = length(TEout);
    if Len>25
            Len=25;
    end
    if mod(Len,2)==0 %checks if even
        Len = Len-1;
    end
    %-----Long term Frequency Calculation-----%
    if Len==25
        Period=TEout(25)-TEout(23);
        Oscillations=1;
    else 
        Oscillations=0;
        Period=1;
    end
    Frequency = Oscillations/Period;
    Output = Frequency;
% Calculating frequency as an average of 5 oscillations
% %     Len = length(TEout);
% %     YTol = .01;
% %     if Len>13
% %             Len=13;
% %     end
% %     if mod(Len,2)==0 %checks if even
% %         Len = Len-1;
% %     end
% %     if Len>3 
% %         i = Len;
% %         Period = TE(Len)-TE(3);
% %         Oscillations = (((Len-1)/2)-1);
% %         %tapering case
% %         YDiff = abs(YE(i,horm)-YE(i-1,horm));
% %         while (YDiff<YTol)
% %             if i==5
% %                 YDiff=abs(YE(i-1,horm)-YE(i-2,horm));
% %                 if (YDiff<YTol)
% %                     Oscillations = 0;
% %                 end
% %                 break;
% %             end
% %             i=i-2;
% %             Period = TE(i)-TE(3);
% %             Oscillations = Oscillations-1;
% %             YDiff=abs(YE(i,horm)-YE(i-1,horm));
% %         end
% %      elseif Len==3
% %             Period = TEout(3)-TEout(1);
% %             Oscillations = 1.0;
% %     else
% %         Oscillations = 0;
% %         Period = 1;
% %     end
% %     Frequency = Oscillations/Period;
% %     Output = Frequency;
else
    fprintf('choose another calc number');
end
function dy=fun2(t,y,input1,input2)
%--------------Calculating ki----------------%
% % if t<=input2*100
% %     ki = 1.5-(((1.5-input2)/input2)*(t/100.0));
% % elseif t<=(input2+1)*100
% %     ki = input2;
% % elseif t<=2*(input2+1)*100
% %     ki=input2+(t-(input2+1)*100)/1000.0;
% % else
% %     ki = 1.17;
% % end
if t<=100
    ki = 1.5-((1.5-input2)*(t/100));
else
    ki = 1.1;
end

% kstress=(1/sqrt(2*pi))*exp((-(t-5)^2)/2)+10; %N(5,1)
kstress=input1;
vs4=.907;    
vs3=3.25;
vs2=0.0509;
kb=0.0202;  
% kb = .0159775705;
km2=0.112;gtot=3.28;
n2=5.1;
kd1=0.00379;kd2=0.00916;kd3=0.356;
kp3=0.945;
km1=1.74;
vs5=.00535;
kp2=8.3;
km3=0.0768;
n1=5.43;
k1=0.645;
kd5=0.0854;


%------------------Membrane equation-------------%
%y(1)=CRH;y(2)=ACTH;y(3)=CORT;y(4)=GR;y(5)=MR,

    dy(1)=kstress*ki^n2/(ki^n2+y(4)^n2+y(5)^n2)-vs3*y(1)/(km1+y(1))-kd1*y(1);
    dy(2)=kp2*y(1)*ki^n2/(ki^n2+y(4)^n2)-vs4*y(2)/(km2+y(2))-kd2*y(2);
    dy(3)=kp3*y(2)-vs5*y(3)/(km3+y(3))-kd3*y(3);
    dy(4)=kb*y(3)*(gtot-y(4))+vs2*y(4)^n1/(k1^n1+y(4)^n1)-kd5*y(4);
    dy(5)=kb*y(3)*(gtot-y(5))+vs2*y(5)^n1/(k1^n1+y(5)^n1)-kd5*y(5);
    
dy=[dy(1);dy(2);dy(3);dy(4);dy(5)];

function dy=fun(t,y,input1,input2)

kstress=input1;
ki=input2;
vs4=.907;    
vs3=3.25;
vs2=0.0509;
kb=0.0202;  
% kb = .0159775705;
km2=0.112;gtot=3.28;
n2=5.1;
kd1=0.00379;kd2=0.00916;kd3=0.356;
kp3=0.945;
km1=1.74;
vs5=.00535;
kp2=8.3;
km3=0.0768;
n1=5.43;
k1=0.645;
kd5=0.0854;


%------------------Membrane equation-------------%
%y(1)=CRH;y(2)=ACTH;y(3)=CORT;y(4)=GR;y(5)=MR,

    dy(1)=kstress*ki^n2/(ki^n2+y(4)^n2+y(5)^n2)-vs3*y(1)/(km1+y(1))-kd1*y(1);
    dy(2)=kp2*y(1)*ki^n2/(ki^n2+y(4)^n2)-vs4*y(2)/(km2+y(2))-kd2*y(2);
    dy(3)=kp3*y(2)-vs5*y(3)/(km3+y(3))-kd3*y(3);
    dy(4)=kb*y(3)*(gtot-y(4))+vs2*y(4)^n1/(k1^n1+y(4)^n1)-kd5*y(4);
    dy(5)=kb*y(3)*(gtot-y(5))+vs2*y(5)^n1/(k1^n1+y(5)^n1)-kd5*y(5);
    
dy=[dy(1);dy(2);dy(3);dy(4);dy(5)];

function [value,isterminal,direction] = events(t,y)
global horm
vs4=.907;vs3=3.25;vs2=0.0509;
kb=0.0202;
% kb = .0159775705;
km2=0.112;gtot=3.28;
n2=5.1;n1=5.43;
kd1=0.00379;kd2=0.00916;kd3=0.356;
kp3=0.945;
km1=1.74;
vs5=.00535;
kp2=8.3;
km3=0.0768;
k1=0.645;
kd5=0.0854;

value = kp3*y(2)-vs5*y(3)/(km3+y(3))-kd3*y(3);
isterminal = 0;                    
direction = 0;

