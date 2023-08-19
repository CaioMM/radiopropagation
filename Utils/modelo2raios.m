function Pr = modelo2raios(pt,f,gt,gr,ht,hr,d,p,M)
% Caio Cardoso
% 24/07/2023
% function to calculate the Received Power considering the two-ray
% ground-reflection model
% Input
% pt - transmitted power in dBm
% f  - signals frequency in Hz
% gt - transmitter antenna gain
% gr - receiver antenna gain
% ht - transmitter height
% hr - receiver height
% d  - distance between Tx and Rx
% p  - Select for which polarization the received power will be calculated:
%      vertical, horizontal or both:
%      {'v', 'h', 'b'}
% M  - Medium through which the signal propagates:
%      {'Solo Seco', 
%       'Solo Comum', 
%       'Solo Húmido',
%       'Água do Mar',
%       'Água Doce'}
% references: 
% Jordan E.C. and Balmain K.G. (1968) Electromagnetic Waves and Radiating
% Systems. Prentice Hall, New York
% Viswanathan M. (2020) Wireless Communication Systems in Matlab
% 
    polarizations = {'v', 'h','b'};
    isStringInsideCell = ismember(lower(p), lower(polarizations));
    if isStringInsideCell
        polarizationIndex = find(strcmpi(polarizations, p));
    else
        disp('Polarização Selecionada Inválida.');
    end     


    d1 = sqrt((ht-hr)^2+d.^2);  % Distance for LOS Wave
    d2 = sqrt((ht+hr)^2+d.^2);  % Distance for reflected Wave
    lambda = 3e8/f;             % Signals Wavelength
    phi = 2*pi*(d2-d1)/lambda;  % phase difference between LOS and reflected 
                                % wave
    [r_v, r_h] = reflectioncoefficient(ht,hr,d,f,M);
    pt = 10^(pt/10);  % Transmitted power in mW
    
    if polarizationIndex == 1
        holder = abs((lambda/(4*pi)*(sqrt(gt*gr)./d1 + r_v.*sqrt(gt*gr)./d2.*exp(1i*phi)))).^2;        
        Pr = pt * holder; % Received power in mW
        Pr = 10*log10(Pr);% Received power in dBm
    elseif polarizationIndex == 2
        holder = abs((lambda/(4*pi)*(sqrt(gt*gr)./d1 + r_h.*sqrt(gt*gr)./d2.*exp(1i*phi)))).^2;
        Pr = pt * holder; % Received power in mW
        Pr = 10*log10(Pr);% Received power in dBm
    else
        holder_v = abs((lambda/(4*pi)*(sqrt(gt*gr)./d1 + r_v.*sqrt(gt*gr)./d2.*exp(1i*phi)))).^2;
        holder_h = abs((lambda/(4*pi)*(sqrt(gt*gr)./d1 + r_h.*sqrt(gt*gr)./d2.*exp(1i*phi)))).^2;
        Prv = pt * holder_v; % Received power in mW
        Prv = 10*log10(Prv);% Received power in dBm
        Prh = pt * holder_h; % Received power in mW
        Prh = 10*log10(Prh);% Received power in dBm
        Pr = [Prv', Prh'];
    end    
end