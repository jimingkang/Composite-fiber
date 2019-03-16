x =input('输入材料宽度： ')  ;
y =input('输入材料长度： ')  ;
z =input('输入材料高度： ')  ;
s =input('输入网格的边长(边长需要被长宽高整除)：  ') ;
r =input('输入纤维半径：') ;
P100 = input('输入纤维所占材料的百分比：（%）');

if(mod(x,s)~=0||mod(y,s)~=0||mod(z,s)~=0)
    disp('数据错误，边长需要被长宽高整除。')
    
else
    disp('网格边长数据正确。')
end

if(2*r>x||2*r>y)
    disp('数据错误，纤维直径需小于材料的长宽。')
   
else
    disp('纤维半径数据正确。')
end

if(P100>=100)
    disp('数据错误，纤维体积超过材料本身。')
    
else
    disp('纤维体积比正确。')
end

fid=fopen('Job-1.inp','wt');

n=1;
fprintf(fid, '*Part\n*Node\n');



for a = x:-s:0
   for b = y:-s:0
       for c = z:-s:0
            fprintf(fid,'%g, %g, %g, %g\n',n, a, b, c);
            X(n)=a;  %所有点的x坐标
            Y(n)=b; %所有点的y坐标
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
            XXX(n)=j1;%所有方块的j1点编号
            fprintf (fid,'%g, %g, %g, %g, %g, %g, %g, %g, %g\n',n,j1,j3,j4,j2,j5,j7,j8,j6);
            
            n=n+1;
           
        end
    end
end

fprintf(fid, '*End Part');



fprintf(fid,'*Set-1\n***************\n');

NumCylinder=floor(x*y*P100/(100*r*r*pi));

%Numbers = floor(r/s);%中心半列最多几块
%Number2Dia = r/s/sqrt(5);%两个方块对角线的个数
%NumberDia = floor(r/s/sqrt(2));%斜对角线的个数

nx=x/s; ny=y/s; nz=z/s; %每行列总共各几块
%locY=round(ny/2);locX=round(nx/2);
AREA=nx*ny;

for NUM=0:1:(nz-1)
    Loc=locY+(locX-1)*ny+NUM*nx*ny;%圆的中心
    CX=X(Loc);CY=Y(Loc);
    Area=nx*ny+NUM*nx*ny;
    Start=1+NUM*nx*ny;

    for Num=Start:1:Area
        Data=XXX(Num);
        Dis = sqart((X(Data)-CX)^2+(Y(Data)-CY)^2);

        if Dis<=r
            fprintf(fid, '%g,' ,Data);%输入圆上的元素
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
                %开始生成圆
                suibian=suibian+1;N=N+1;
           end
       end
    end
    
    
end