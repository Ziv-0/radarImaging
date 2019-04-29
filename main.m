clear all;
close all;
%% ������
c = 2.9979e+8; 
%% �״����
global mradar;
                           %fc,      kr,       tr,     fr
mradar = radar(1256.98,5.300e+9,0.72135e+12,41.75e-6,2*32.317e+6);
B = mradar.kr*mradar.tr
T = 1/mradar.PRF
%% �������
h0 =50e3;
y0 = 0;
sightangle = 30;
x0 = h0*tand(sightangle)
r0 = sqrt((h0/cosd(sightangle))^2+y0^2)

D = 4;
antenasight = c/mradar.fc/D;
sightrange = 2*r0*tan(antenasight/2)
vm = 200;
Bfd = 2*vm/D
kd = 2*vm^2*mradar.fc/c/r0
crossRrs = vm*1/Bfd
acclong = sightrange/vm
%% ���񳡾�
dx = 30;  %x���ؼ��10m
dy = 30;  %y���ؼ��10m
screen = [1 0 0 0 0
          0 0 0 0 0
          1 0 1 0 0 ;
          0 0 0 0 0;
          0 0 0 0 1;]
imwrite(screen,'screen.bmp','bmp');
figure;imshow(mat2gray(abs(screen)));title('���񳡾�');
%% �ز�����
t = 0:1/(mradar.fr):T;
[row,col] = size(screen);
centerx = (col+1)/2;
centery = (row+1)/2;
HRRPS = [];
tmf = -1.25*acclong/2:1/3/Bfd: 1.25*acclong/2;
for tm = tmf  %��ͬ�Ƕ�
st = s(t);
sr = zeros(size(t));
    for ii = 1:col
        for jj = 1:row
            x = -(ii-centerx)*dx;
            y = -(jj-centery)*dy;
            x = x + x0;
           deltpy = vm*tm;
            y = y - y0-deltpy;
            if deltpy>0.5*sightrange
                continue;
            end
            if deltpy<-0.5*sightrange
                continue;
            end
            d = sqrt(x^2+y^2+h0^2);
            sr = sr + screen(jj,ii)*s(t-2*d/c);
        end
    end
%% ȥ��Ƶ
    sc = exp(-1i*2*pi*(mradar.fc*t));
    st = st.*sc;
    sr = sr.*sc;
%% ƥ���˲�
    result = matchfilter(sr,st,0);
    dr =100;
    [~,indexlb] = min(abs((r0-dr)*2/c-t));
    [~,indexub] = min(abs((r0+dr)*2/c-t));
    indexrange = indexlb:indexub;
   % figure;plot(c*t(indexrange)/2,abs(result( indexrange)));xlabel('����/m');ylabel('HRRP����');%title([num2str(theta) '��ƥ���˲�������ȼ�HRRP']);
    HRRPS = [HRRPS;result( indexrange)];
    %figure;plot(angle(result));title([num2str(theta) '��ƥ���˲������λ']);
end
figure;imagesc(c*t(indexrange)/2,tmf,abs(HRRPS));xlabel('����/m');ylabel('tm');
% for theta = 0:90:360  %��ͬ�Ƕ�
%     figure;plot(c*t(indexrange)/2,HRRPS(theta/2+1,:));title([num2str(theta) '��HRRP']);
% end
srftm = -1*acclong/2:1/3/Bfd: 1*acclong/2;
srf = exp(-2*pi*1j*0.5*kd*srftm.^2);
HRRPSZ = [zeros(floor(3*Bfd*acclong/2),size(HRRPS,2));HRRPS];
sarimage = matchfilter(HRRPSZ,srf,1);
 figure;plot(1/3/Bfd*(1:size(sarimage,1))*vm,abs(sarimage(:,323)))
 sarscreen = sarimage(1:size(HRRPS,1),:);
figure;imagesc(c*t(1:size(HRRPS,2))/2,1/3/Bfd*(1:size(sarscreen,1))*vm,abs(sarscreen));
































%Range Compress
% t = (1-M/2):1:M/2;
% srf = exp(-1j*pi*mradar.kr*t.^2);
% data_azi = tm_compress(data,srf.');
% figure;
% imagesc(abs(data_azi));
% figure;
% imshow(mat2gray(abs(data_azi)));
% %---------------azimuth compression
% n=1:1:N;
% tm=(-N/2+n)./mradar.PRF;
% ka=2*vr^2/wavelen/(mplatform.R0+(1024+970-1)*delta);
% % ref2=exp(-1j*pi*ka*tm.^2);
% % REF2=conj(fftshift(fft(ref2,N)).*hamming(N).');   %��ʱ��ƥ�亯��FFTƥ���˲����ս������
% % azimuth=iftx(ftx(range).*(REF2.'*ones(1,M)));
% fa=-PRF/2+PRF*(n-1)/N;
% ref2=exp(-1j*pi*fa.^2./ka).*hamming(N).';
% azimuth=ifft(fft(data_azi).*(ref2.'*ones(1,M)));       %ֱ��д��Ƶ����ʽ�����ȷ
% figure;
% imagesc(abs(azimuth));
% figure;
% imshow(mat2gray(abs(azimuth)));
% 
% % azimuth=ifft(fft(range).*(REF2.'*ones(1,M)));
% % ka=2*vr^2/wavelen/(R0+(1024+970-1)*delta);
% % srf_tm=exp(-1j*pi*ka*tm.^2);
% % REF2=conj(fftshift(fft(ref2,N)).*hamming(N).');   %��ʱ��ƥ�亯��FFTƥ���˲����ս������
% % azimuth=iftx(ftx(range).*(REF2.'*ones(1,M)));
% 
% 
% % ref2=exp(-1j*pi*fa.^2./ka);
% % srf_azi = 
% % tm_compress(data_azi,srf_azi);

