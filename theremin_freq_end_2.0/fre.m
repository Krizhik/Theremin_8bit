clear;
x=1:1:250;
y=(-5580.*exp(-(x)*0.015)./4+850)/4.8;
for i=1:1:39
   y(i)= 20;
end

for i=200:1:250
   y(i)= 80*2;
end
y=fix(y);
plot(x,y);
grid on;
ylabel('?????????? ????? ?? ?????? ??????');
xlabel('???????? ???????? ???????');