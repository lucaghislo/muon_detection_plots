function [vpp,sig,mv,bound]=histfitlandau(val,passo,inizio,fine)

% function to compute and display a Landau Distribution
% for INFO visit www.cern.ch/meroli
% special thanks to Daniele

%%% input
% val -->        acquired data
% passo -->      bin size
% inizio -->     start point for the fit
% fine   -->     last point for the fit

%%%output
% vpp -->        most probable value for the Landau Distribution
% sig -->        sigma for the Landau Distribution
% mv -->         mean value for the Landau Distribution
% bound  -->     bounds for vpp and sig

%% Example
% x(1:1000)=randn(1,1000);
% x(1001:2000)=randn(1,1000).*4+2;
% [vpp,sig,mv,bound]=histfitlandau(x,0.3,-3,15);

% This script changes all interpreters from tex to latex. 
list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end

clf;
if(nargin==1)
    [y1,x1]=hist(val);
    passo=(max(x1)-min(x1))/calcnbins(val);
end;
if nargin>3
    [y,x]=hist_(val,passo,min(val),fine);
else
    [y,x]=hist_(val,passo);
end;
x=x+passo/2;
if nargin>2;
    inz=find(x<inizio);
    if isempty(inz)
        inz=1;
    end;
    y(1:inz(end))=0;
end;

colors = distinguishable_colors(4, 'w');

a0=max(y);
mpv0=min(x(find(y==a0)));
sigma0=std(val);
ftype=fittype('a*landau(x,mpv,sigma,0)');
fitres=fit(x,y,ftype,'StartPoint',[a0 mpv0 sigma0]);
bound=confint(fitres);
xfit=x(1):(passo/10):x(end);
yfit=fitres(xfit);
line(xfit,yfit,'LineWidth',2,'LineStyle','-','Color', [colors(2, 1), colors(2, 2), colors(2, 3)]);
picco=max(yfit);
mpv=xfit(find(yfit==picco));
mpv=mpv(end);
mv=mean(val);
errMPV=mean(abs(bound(:,2)-mpv));
errSig=mean(abs(bound(:,3)-fitres.sigma));
%line([mpv mpv],[0 picco],'LineWidth',2,'LineStyle','--','Color','r');
%text(mpv,0,[' \leftarrow' num2str(mpv)],'rotation',-90,'FontSize',12');
testo={['MPV: ', num2str(mpv), '\newline', num2str(errMPV), ];['$\sigma$ = ', num2str(fitres.sigma),'\pm', num2str(errSig),];['Entries: ' num2str(length(val))]};
testo={['MPV: ', num2str(round(mpv, 2)), ' keV'];['$\sigma$ = ', num2str(round(fitres.sigma, 2)), ' keV'];['Entries: ' num2str(length(val))]};
annotation('textbox',[.73 .805 .1 .1],'FitHeightToText','on','String',testo,'Fontsize',12);
if nargout
    vpp=mpv;
    sig=fitres.sigma;
    mv=mean(val);
    bound=confint(fitres);
    bound(:,1)=[];
end;
end






