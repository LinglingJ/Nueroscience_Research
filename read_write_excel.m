Write_XLS = 0; %Change this variable to 1 if you want to write to excel.
global T
global Yout
%     fprintf('Modes:');
%     fprintf('\n1 Average Height');
%     fprintf('\n2 Wave Height');
%     fprintf('\n3 Average Frequency');
%     fprintf('\n4 All of the above');
%     Input3 = input('\nSelect a number: ');
    Input3 = 3;
    Func_Name = ['HPAwMRwbell'];
    clear(Func_Name);
    edit(Func_Name);

   
if Write_XLS == 1
    %To use HPA function on excel data sheet
    filename = 'test.xlsx';
    Input1_Mat=xlsread(filename,'','A2:A14');
    Input2_Mat = xlsread(filename,'','B1:V1');
        len1 = length(Input1_Mat);
        len2 = length(Input2_Mat);
        Output_Mat= zeros(len1,len2);
        if Input3 == 4;
           Input3 = 1;
               for i = 1:len1 
                    Input1 = Input1_Mat(i);
                    for k = 1:len2
                        Input2 = Input2_Mat(k);
                        Output_Mat(i,k) = feval(Func_Name,Input1,Input2,Input3);
                    end
                end
                xlswrite(filename,Output_Mat,'B2:V14');
               Input3 = 2;
               for i = 1:len1 
                    Input1 = Input1_Mat(i);
                    for k = 1:len2
                        Input2 = Input2_Mat(k);
                        Output_Mat(i,k) = feval(Func_Name,Input1,Input2,Input3);
                    end
                end
                xlswrite(filename,Output_Mat,'B17:V29');
                Input3 = 3;
               for i = 1:len1 
                    Input1 = Input1_Mat(i);
                    for k = 1:len2
                        Input2 = Input2_Mat(k);
                        Output_Mat(i,k) = feval(Func_Name,Input1,Input2,Input3);
                    end
                end
                xlswrite(filename,Output_Mat,'B32:V44');
        else
            for i = 1:len1 
                Input1 = Input1_Mat(i);
                for k = 1:len2
                    Input2 = Input2_Mat(k);
                    Output_Mat(i,k) = feval(Func_Name,Input1,Input2,Input3);
                end
            end
            xlswrite(filename,Output_Mat,'B2:V14');
        end
        
else
    
%          Normal	PTSD	Depressed
% KI        1.51	1.17	1.6
% Kstress	10.1	17.5	13.7
Input1=40; 
Input2=1.1;
% Input1 = 17.5;
% Input2 = 1.17;
% Input1 = 13.7;
% Input2 = 1.6;
% Input1 = 40;
% Input2 = 1.6;

    feval(Func_Name,Input1,Input2,Input3)
     func_Plot(T,Yout)
end


    

