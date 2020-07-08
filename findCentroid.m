%findCentroid.m
I=imread('3.jpg'); 

I_gray=rgb2gray(I);
level=graythresh(I_gray);

[height,width]=size(I_gray);
I_bw=im2bw(I_gray,level);

for i=1:height %%循环中进行反色
for j=1:width
    if I_bw(i,j)==1
        I_bw(i,j)=0;
    else I_bw(i,j)=1;
    end
    
end
end

[L,num]=bwlabel(I_bw,8);
plot_x=zeros(1,num);%%用于记录质心位置的坐标
plot_y=zeros(1,num);

for k=1:num  %%num个区域依次统计质心位置
    sum_x=0;sum_y=0;area=0;
    for i=1:height
    for j=1:width
       if L(i,j)==k
        sum_x=sum_x+i;
        sum_y=sum_y+j;
        area=area+1;   
       end
    end
    end
    plot_x(k)=fix(sum_x/area);
    plot_y(k)=fix(sum_y/area);
end

figure(1);
imshow(I_bw);
for i=1:num
hold on
plot(plot_y(i) ,plot_x(i), '*');
end
