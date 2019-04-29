clear all;
close all;
%% ������
c = 2.9979e+8; 
%% �״����
global mradar;
                           %fc,      kr,       tr,     fr
mradar = radar(1256.98,5.300e+9,0.72135e+12,41.75e-6,0.1*32.317e+6);
B = mradar.kr*mradar.tr
T = 1/mradar.PRF
%% �������
r0 =50e3;
%% ���񳡾�
dx = 10;  %x���ؼ��10m
dy = 10;  %y���ؼ��10m
screen = [1 0 0 0 0
          0 0 0 0 0
          0 0 0 0 0 ;
          0 0 0 0 0;
          0 0 0 0 0;]
imwrite(screen,'screen.bmp','bmp');
figure;imshow(mat2gray(abs(screen)));title('���񳡾�');

%% �ز�����
t = 0:1/(mradar.fr):T;
[row,col] = size(screen);
centerx = (col+1)/2;
centery = (row+1)/2;
HRRPS = [];
for theta = 0:90:360  %��ͬ�Ƕ�
st = s(t);
sr = zeros(size(t));
    for ii = 1:col
        for jj = 1:row
            x = -(ii-centerx)*dx;
            y = -(jj-centery)*dy;
            x = x*cosd(theta)-y*sind(theta);
            y = y*cosd(theta)+x*sind(theta);
            d = sqrt(x^2+(r0+y)^2);
            sr = sr + screen(jj,ii)*s(t-2*d/c);
        end
    end
    if theta==0
    figure;plot(t,real(st),t,real(sr),'r');title('����������ź�');
    end
%% ȥ��Ƶ
    sc = exp(-1i*2*pi*(mradar.fc*t));
    st = st.*sc;
    sr = sr.*sc;
    if theta==0
    figure;plot(t,real(st),t,real(sr),'r');title('ȥ��Ƶ����ͽ����ź�');
    end
%% ƥ���˲�
    result = matchfilter(sr,st,0);
    result = result*pi/max(abs(result));
    dr =100;
    [~,indexlb] = min(abs((r0-dr)*2/c-t));
    [~,indexub] = min(abs((r0+dr)*2/c-t));
    indexrange = indexlb:indexub;
    figure;plot(c*t(indexrange)/2,abs(result( indexrange)));xlabel('����/m');ylabel('HRRP����');title([num2str(theta) '��ƥ���˲�������ȼ�HRRP']);
    HRRPS = [HRRPS;abs(result( indexrange))];
    %figure;plot(angle(result));title([num2str(theta) '��ƥ���˲������λ']);
end
figure;imagesc(c*t(indexrange)/2,0:2:360,HRRPS);xlabel('����/m');ylabel('theta');
% for theta = 0:90:360  %��ͬ�Ƕ�
%     figure;plot(c*t(indexrange)/2,HRRPS(theta/2+1,:));title([num2str(theta) '��HRRP']);
% end