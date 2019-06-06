clear all;
close all;
%% ������
c = 2.9979e+8; 
%% �״����
global mradar

                           %fc,      kr,       tr,     fr
mradar = radar(1256.98,5.300e+9,0.72135e+12,41.75e-6,10*32.317e+6);
B = mradar.kr*mradar.tr
T = 1/mradar.PRF
%% �������
h0 =50e3;
sightangle = 30;
squitangle = 20;
x0 = h0*tand(sightangle)
y0 = -h0/cosd(sightangle)*tand(squitangle)
r0 = sqrt((h0/cosd(sightangle))^2+y0^2)
D = 4;
antenasight = c/mradar.fc/D;
sightrange = 2*r0*tan(antenasight/2)
vm = 200;
rwcr = vm*sind(squitangle)
Bfd = 2*vm/D
fdc = 2*vm*sind(squitangle)*mradar.fc/c;
kd = 2*vm^2*cosd(squitangle)^2*mradar.fc/c/r0
crossRrs = vm*1/Bfd
acclong = sightrange/vm
fsfd = 1*Bfd
%% ���񳡾�
dx = 60;  %x���ؼ��10m
dy = 60;  %y���ؼ��10m
screen = [0 0 0 0 0
          0 0 0 0 0
          1 0 1 0 1 ;
          0 0 0 0 0;
          1 0 1 0 1;]
imwrite(1-screen,'screen.bmp','bmp');
figure;imshow(mat2gray(abs(screen)));title('���񳡾�');
%% �ز�����
t = 0:1/(mradar.fr):T;
[row,col] = size(screen);
centerx = (col+1)/2;
centery = (row+1)/2;
HRRPS = [];
tmf = -1.25*acclong/2:1/fsfd: 1.25*acclong/2;
for tm = tmf  %��ͬ�Ƕ�
st = s(t);
sr = zeros(size(t));
    for ii = 1:col
        for jj = 1:row
            x =  (ii-centerx)*dx;
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
    dr =1000;
    [~,indexlb] = min(abs((r0-dr)*2/c-t));
    [~,indexub] = min(abs((r0+dr)*2/c-t));
    indexrange = indexlb:indexub;
   % figure;plot(c*t(indexrange)/2,abs(result( indexrange)));xlabel('����/m');ylabel('HRRP����');%title([num2str(theta) '��ƥ���˲�������ȼ�HRRP']);
    HRRPS = [HRRPS;result( indexrange)];
    %figure;plot(angle(result));title([num2str(theta) '��ƥ���˲������λ']);
end
%% �����߶�У��
figure;imagesc(c*t(1:size(HRRPS,2))/2,tmf,abs(HRRPS));xlabel('����/m');ylabel('tm');
HRRPSout = rwc(HRRPS,tmf,rwcr);
figure;imagesc(c*t(1:size(HRRPSout,2))/2,1/fsfd*(1:size(HRRPSout,1))*vm,abs(HRRPSout));xlabel('����/m');ylabel('tm');
%% ��λ��ƥ���˲�
srftm = -1*acclong/2:1/fsfd: 1*acclong/2;
srf = exp(-2*pi*1j*0.5*kd*srftm.^2+2*pi*1j*fdc*srftm);
HRRPSZ = [zeros(floor(fsfd*acclong/2),size(HRRPSout,2));HRRPSout];
sarimage = matchfilter(HRRPSZ,srf,1);
 figure;plot(1/fsfd*(1:size(sarimage,1))*vm,abs(sarimage(:,432)))
 sarscreen = sarimage(1:size(HRRPS,1),:);
 figure;imagesc(c*t(1:size(HRRPSout,2))/2,tmf,abs(HRRPSout));xlabel('����/m');ylabel('tm');
figure;imagesc(c*t(1:size(HRRPS,2))/2,1/fsfd*(1:size(sarscreen,1))*vm,abs(sarscreen));xlabel('����/m');ylabel('��λ/m');

