% Caio Cardoso
% 19/08/2023
% Exemplo de utilização da função modelo2raiosAjustado e modelo2raios,
% neste exemplo a função modelo2raiosAjustado ajusta o modelo de dois raios
% considerando a equação de Friis.
% Caso queira ajustar o modelo a um conjunto de dados medidos, basta
% substituir os valores obtidos pela equação de Friis pelos valores
% medidos.

clc, clear, close all
addpath Utils
ht = 10;             %height of tx antenna (m)
hr = 5;              %height of rx antenna (m)
f  =915e6;           %Transmission Frequency (Hz)
c  = 3e8;            %Light Speed (m/s)
lambda = c/f;        %Wavelength (m)
d  =1:1000;          %distance between tx-rx (m)
pt_dBm = 3;          %Transmission Power (dBm)
pt =10^((pt_dBm)/10);%Transmission Power (W)
Gt = 1;              %tx gain
Gr = 1;              %rx gain
p  ='b';             %polarization {'v':'vertical','h':'horizontal','b':'both}
M  ='Solo Seco';     %Medium through which the signal propagates:
                     %      {'Solo Seco', 
                     %       'Solo Comum', 
                     %       'Solo Húmido',
                     %       'Água do Mar',
                     %       'Água Doce'}

Pr_friis = pt * Gt * Gr * (lambda./(4*pi*d)).^2;    %Friis Equation
Pr_friis_dBm = 10*log10(Pr_friis);                  %Received Power (dBm)

Pro = Pr_friis_dBm(1); %Received power at distance do
do  = d(1);            %Distance where the first received power (Pro) was 
                       %collected

Pr2_a = modelo2raiosAjustado(Pro,do,f,ht,hr,d,p,M);
Pr2 = modelo2raios(pt,f,Gt,Gr,ht,hr,d,p,M);

switch p
    case 'v'
        figure(1)
        plot(d,Pr_friis_dBm,'o-b');
        hold on
        plot(d,Pr2,'x-k');
        plot(d,Pr2_a,'x-r');
        box on
        grid on
        xlabel('Distance (m)')
        ylabel('Received Power (dBm)')
        legend('Free Space','2 Ray model - V polarization','2 Ray Adjusted - V polarization')
    case 'h'
        figure(1)
        plot(d,Pr_friis_dBm,'o-b');
        hold on
        plot(d,Pr2,'x-k');
        plot(d,Pr2_a,'x-r');
        box on
        grid on
        xlabel('Distance (m)')
        ylabel('Received Power (dBm)')
        legend('Free Space','2 Ray model - H polarization','2 Ray Adjusted - H polarization')
    case 'b'
        figure(1)
        subplot(1,2,1)
        plot(d,Pr_friis_dBm,'o-b');
        hold on
        plot(d,Pr2(:,1),'x-r');
        plot(d,Pr2_a(:,2),'x-k');
        box on
        grid on
        xlabel('Distance (m)')
        ylabel('Received Power (dBm)')
        legend('Free Space','2 Ray model - V polarization','2 Ray Adjusted - V polarization')
        subplot(1,2,2)
        plot(d,Pr_friis_dBm,'o-b');
        hold on
        plot(d,Pr2(:,2),'x-r');
        plot(d,Pr2_a(:,2),'x-k');
        box on
        grid on
        xlabel('Distance (m)')
        ylabel('Received Power (dBm)')
        legend('Free Space','2 Ray model - H polarization','2 Ray Adjusted - H polarization')
end