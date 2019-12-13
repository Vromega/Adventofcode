tic;
clc;
format long;
fileID1=fopen('jour9.txt','r');
formatSpec1='%f';
D = textscan(fileID1,formatSpec1,'Delimiter',',');
C=zeros(20000,'int64');
for i=1:size(D{1})
C(i)=D{1}(i);
end
i=1;
S=0;
inp=2;
code=C(1);
param(1)=0;param(2)=0;param(3)=0;
relative_base=0;
while code~=99
    opcode=mod(code,100);
    mode(1)=mod(floor(code/100),10);
    mode(2)=mod(floor(code/1000),10);
    mode(3)=mod(floor(code/10000),10);
    if opcode==1||opcode==2||opcode==7||opcode==8
        for u=1:2
            if(mode(u)==0)
                param(u)=C(C(i+u)+1);
            elseif(mode(u)==1)
                param(u)=C(i+u);
            else
                param(u)=C(C(i+u)+1+relative_base);
            end
        end
        if(mode(3)==0)
            param(3)=C(i+3);
            param(3);
        elseif(mode(3)==1)
            param(3)=i+2;
            param(3);
        else
            param(3)=C(i+3)+relative_base;
        end
    elseif opcode==5||opcode==6
        for u=1:2
            if(mode(u)==0)
                param(u)=C(C(i+u)+1);
            elseif(mode(u)==1)
                param(u)=C(i+u);
            else
                param(u)=C(C(i+u)+1+relative_base);
            end
        end
    elseif opcode==3||opcode==4||opcode==8||opcode==9
        if(mode(1)==0)
            param(1)=C(i+1);
        elseif(mode(1)==1)
            param(1)=i;
        else
            param(1)=C(i+1)+relative_base;
        end
    end
    
    if opcode==1
       C(param(3)+1)=param(1)+param(2);
       C(param(3)+1);
       i=i+4;
    end
    if opcode==2
       C(param(3)+1)=param(1)*param(2);
       i=i+4;
    end   
    if opcode==3
%        inp=input(['code']);
        C(param(1)+1)=inp;
        i=i+2;
    end    
    if opcode==4
        C(param(1)+1)
        i=i+2;
    end
    if opcode==5
        if param(1)~=0
            i=param(2)+1;
        else
            i=i+3;
        end
    end
    if opcode==6
        if param(1)==0
            i=param(2)+1;
        else
            i=i+3;
        end
    end
    if opcode==7
        if param(1)<param(2)
            C(param(3)+1)=1;
        else
            C(param(3)+1)=0;
        end
        i=i+4;
    end
    if opcode==8
        if param(1)==param(2)
            C(param(3)+1)=1;
        else
            C(param(3)+1)=0;
        end
        i=i+4;
    end
    if opcode==9
        relative_base=relative_base+C(param(1)+1);

        i=i+2;
    end
    code=C(i);
end
toc