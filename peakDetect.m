close all;
clear all;

X = xlsread('xl1.csv');

x = X(:,3);
figure(1),plot(x);
hold on;

se_length = 25;
y = imdilate(x,ones(se_length,1));  % Moving Window Maximum
figure(1),plot(y ,'r');
hold off;

a = x==y;
t = (1:length(x))';

figure,plot(1:length(x),x,'g',t(a),x(a),'r.'); 
hold on;

xa = x(a);  ta = t(a);
 
% Find the neck automatically by Otsu threshold
oneD_im = (xa - min(xa))/(max(xa) - min(xa));

% Finding neck of a histogram by Otsu algorithm
neck = graythresh(oneD_im); 
 
for i=1:length(xa),
     if oneD_im(i)<neck,
         plot(ta(i),xa(i),'g.');
     end
 end
 hold off;
 
 % Plotting the Histogram
 figure, hist(xa, 75), hold on;
