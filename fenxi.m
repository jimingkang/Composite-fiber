x =input('������Ͽ�ȣ� ')  ;
y =input('������ϳ��ȣ� ')  ;
z =input('������ϸ߶ȣ� ')  ;
s =input('��������ı߳�(�߳���Ҫ�����������)��  ') ;
r =input('������ά�뾶��') ;
P100 = input('������ά��ռ���ϵİٷֱȣ���%��');

if(mod(x,s)~=0||mod(y,s)~=0||mod(z,s)~=0)
    disp('���ݴ��󣬱߳���Ҫ�������������')
    
else
    disp('����߳�������ȷ��')
end

if(2*r>x||2*r>y)
    disp('���ݴ�����άֱ����С�ڲ��ϵĳ���')
   
else
    disp('��ά�뾶������ȷ��')
end

if(P100>=100)
    disp('���ݴ�����ά����������ϱ���')
    
else
    disp('��ά�������ȷ��')
end

fid=fopen('Job-1.inp','wt');

n=1;
fprintf(fid, '*Part\n*Node\n');



for a = x:-s:0
   for b = y:-s:0
       for c = z:-s:0
            fprintf(fid,'%g, %g, %g, %g\n',n, a, b, c);
            X(n)=a;  %���е��x����
            Y(n)=b; %���е��y����
           n=n+1;
       end
   end
end

fprintf(fid, '*Element, type=C3D8R\n');

m=x*y*z/s/s/s;
e=z/s+1;
w=y/s+1;
q=x/s+1;

area=e*w;
constantE=e;
n=1;

for e = 1:1:(z/s)
    for q = 1:1:(x/s)
        for  w = 1:1:(y/s)
            
%           id = w+(q-1)*(y/s)+(e-1)*(y/s)*(x/s);
            j5 = n + (q-1) + (e-1) * ((y/s)+(x/s)+1);
            j7 = j5 + constantE;
            j8 = j7+1;
            j6 = j5+1;
            j1 = j5 +area;
            j3 = j1 + constantE;
            j4 = j3+1;
            j2 = j1+1;
            XXX(n)=j1;%���з����j1����
            fprintf (fid,'%g, %g, %g, %g, %g, %g, %g, %g, %g\n',n,j1,j3,j4,j2,j5,j7,j8,j6);
            
            n=n+1;
           
        end
    end
end

fprintf(fid, '*End Part');



fprintf(fid,'*Set-1\n***************\n');

NumCylinder=floor(x*y*P100/(100*r*r*pi));

%Numbers = floor(r/s);%���İ�����༸��
%Number2Dia = r/s/sqrt(5);%��������Խ��ߵĸ���
%NumberDia = floor(r/s/sqrt(2));%б�Խ��ߵĸ���

nx=x/s; ny=y/s; nz=z/s; %ÿ�����ܹ�������
%locY=round(ny/2);locX=round(nx/2);
AREA=nx*ny;

for NUM=0:1:(nz-1)
    Loc=locY+(locX-1)*ny+NUM*nx*ny;%Բ������
    CX=X(Loc);CY=Y(Loc);
    Area=nx*ny+NUM*nx*ny;
    Start=1+NUM*nx*ny;

    for Num=Start:1:Area
        Data=XXX(Num);
        Dis = sqart((X(Data)-CX)^2+(Y(Data)-CY)^2);

        if Dis<=r
            fprintf(fid, '%g,' ,Data);%����Բ�ϵ�Ԫ��
        end    

    end
end




suibian=0;N=1;RandLocX(0)=-1000;RandLocY(0)=-1000;
while suibian<NumCylinder
    
    RandLoc = floor(1 + (AREA-1).*rand([1,1])); 
    RandLocX(N)=X(RandLoc);RandLocY(N)=Y(RandLoc);    
    
    if(RandLocX(N)<(r+s)||RandLocY(N)<(r+s)||(x-RandLocX(N))<(r+s)||(y-RandLocY(N))<(r+s))
        suibian=suibian;
    else
        cX=RandLocX(N);cY=RandLocY(N);
       for panduan=0:1:N
           
           if((cX-RandLocX(N))<(2*r)||(cY-RandLocY(N))<(2*r))
                suibian=suibian;
           else
                %��ʼ����Բ
                suibian=suibian+1;N=N+1;
           end
       end
    end
    
    
end