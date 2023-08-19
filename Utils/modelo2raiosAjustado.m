function Pr = modelo2raiosAjustado(Pro,do,f,ht,hr,d,p,M)
% Caio Cardoso
% 24/07/2023
% function to calculate the Received Power considering the two-ray
% ground-reflection model adjusted to measured data
% Input
% Pro - received power in dBm
% do  - distance where the first received signal was collected
% f   - signals frequency in Hz
% ht - transmitter height
% hr - receiver height
% d  - distance between Tx and Rx
% p  - Select for which polarization the received power will be calculated:
%      vertical, horizontal or both:
%      {'v', 'h','b'}
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
    Z = 50;                     % Impedância de Entrada do Sistema
    
    Eo = sqrt(10^(Pro/10) * Z * (10^-3));     % V    
    
    [r_v, r_h] = reflectioncoefficient(ht,hr,d,f,M);

    if polarizationIndex == 1
        E = (Eo * do) * ( ((1./d1) .* exp(-1i*(2*pi/lambda).*d1)) + ((r_v./d2) .* exp(-1i*(2*pi/lambda).*d2)));
        Pr = 20*log10(abs(E)) - 10*log10(50) + 30;
    elseif polarizationIndex == 2
        E = (Eo * do) * ( ((1./d1) .* exp(-1i*(2*pi/lambda).*d1)) + ((r_h./d2) .* exp(-1i*(2*pi/lambda).*d2)));
        Pr = 20*log10(abs(E)) - 10*log10(50) + 30;
    else
        Ev = (Eo * do) * ( ((1./d1) .* exp(-1i*(2*pi/lambda).*d1)) + ((r_v./d2) .* exp(-1i*(2*pi/lambda).*d2)));
        Eh = (Eo * do) * ( ((1./d1) .* exp(-1i*(2*pi/lambda).*d1)) + ((r_h./d2) .* exp(-1i*(2*pi/lambda).*d2)));
        Prv = 20*log10(abs(Ev)) - 10*log10(50) + 30;
        Prh = 20*log10(abs(Eh)) - 10*log10(50) + 30;
        Pr = [Prv', Prh'];
    end
end