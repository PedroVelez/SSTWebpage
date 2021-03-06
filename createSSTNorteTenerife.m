clc;clear all;close all

%Read options
configSSTWebpage

Files=dir(strcat(FileDataSST,'*'));
for i1=1:length(Files)
    DatatSST=matfile(strcat(Files(i1).folder,'/',Files(i1).name));
    TimeLast(i1)=nanmax(DatatSST.timetd);
end
iFileLast=find(TimeLast==max(TimeLast));

DataSST=matfile(strcat(Files(iFileLast).folder,'/',Files(iFileLast).name));

%% Inicio
fprintf('Interpolating data into North of Tenerife section: ')
data=load(EstNorteTenerife);
loneR=data(:,1)';
lateR=data(:,2)';
nestacion=data(:,3)';

lonSST=DataSST.lon;
latSST=DataSST.lat;
jdaySST=DataSST.timetd;

for iEstaciones=1:length(loneR)
    fprintf('%d, ',iEstaciones)
    ilon=Locate(lonSST,loneR(iEstaciones)+360);
    ilat=Locate(latSST,lateR(iEstaciones));
    [d,phaseangle]=sw_dist([latSST(ilat) lateR(iEstaciones)],[lonSST(ilon)-360 loneR(iEstaciones)]);
    dist(iEstaciones)=d;
    sstd(iEstaciones,:)=DataSST.ssttd(ilon,ilat,:);
end
fprintf(' \nSaving data\n')
save('./data/SSTNorteTenerife','sstd','jdaySST')
