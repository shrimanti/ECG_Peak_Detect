
close all;
clear all;

fname = 'S2xl.csv';
X = xlsread(fname);
x = X(1001:end,3);
% checking for nan values
nanind = isnan(x);
if sum(nanind)>0,
    x(nanind)=0;
end

sig = 1;
g = fspecial('Gaussian',[2*round(3*sig)+1 1],sig);
x = conv(x,g,'same');

y = X(1001:end,7);
% checking for nan values
nanind = isnan(y);
if sum(nanind)>0,
    y(nanind)=0;
end

sig = 15;
g = fspecial('Gaussian',[2*round(3*sig)+1 1],sig);
y = imfilter(y,g,'same','replicate','conv');

figure(1),plot(x+80,'b');
hold on; plot(y,'g'); hold off;

hf_se_length = 15;
ym = imdilate(y,ones(2*hf_se_length+1,1)); % moving window maximum
z = zeros(size(y));
z(y==ym) = y(y==ym);

N = length(x);
ptt1 = zeros(size(x));
hl_window = 1000;
maxptt = 1000;

tic;
for i=hl_window+1:N-hl_window,
    xw = x(i-hl_window:i+hl_window);
    xw = xw - mean(xw);
    
    zw = z(i-hl_window:i+hl_window);
    
    % compute correlation by fft
    
    Fx = fft(xw(end:-1:1));   %  Reverse the order of the elements
    Fz = fft(zw);
    cor = real(ifft(Fx.*Fz));
    %figure,plot(cor);
    
    [maxv,maxi] = max(cor(1:maxptt));
    ptt1(i) = maxi(1);
end
toc;
% figure(2),plot(ptt,'g.');
% return;

hf_se_length = 1000;
pttFiltered = medfilt2(ptt1,[2*hf_se_length+1 1])/1000;
figure(2),hold on, plot(pttFiltered,'r');hold off;
ylabel('secs'); 

load([fname(1:end-3) 'mat']);
figure(2),hold on;
plot(ptt_tindex,ptt,'b.');

%disp(max(ptt)); disp(min(ptt)); disp(mean(ptt));

acc = [];
for i=1:length(ptt_tindex),
    if pttFiltered(ptt_tindex(i))>0,
        acc = [acc; 100*abs(pttFiltered(ptt_tindex(i))-ptt(i))/ptt(i)];
    end
end
figure(3),errorbar(mean(acc),std(acc),'r*'),grid on;
disp(mean(acc)); disp(std(acc));



