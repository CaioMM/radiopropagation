function [r_v,r_h] = reflectioncoefficient(ht,hr,d,f,M)
% Caio Cardoso 
% 24/07/2023
% function to calculate the vertical and horizontal reflection coefficient
% Input:
% ht - transmitter height in meters
% hr - receiver height in meters
% d  - distance between Tx and Rx in meters
% f  - signals frequency in Hz
% p  - polarization vertical or horizontal:
%      {'v', 'h'}
% M  - Medium through which the signal propagates:
%      {'Solo Seco', 
%       'Solo Comum', 
%       'Solo Húmido',
%       'Água do Mar',
%       'Água Doce'};
%

    mediums = {'Solo Seco',                                                   ...
               'Solo Comum',                                                  ...
               'Solo Húmido',                                                 ...
               'Água do Mar',                                                 ...
               'Água Fresca',                                                 ...
               'Água Doce',                                                   ...
               'Água Rio Guamá'};

    isStringInsideCell = ismember(lower(M), lower(mediums));
    if isStringInsideCell
        index = find(strcmpi(mediums, M));   
    else
        disp('Meio selecionado Inválido.');
    end
    
    permissividade      = [4 15 25 81 81 81 80];
    condutividade_sigma = [1*(10^-3) 5*(10^-3) 2*(10^-2) ...
                           5*(10^0) 1*(10^-2) 0.22 0.05];

    er = permissividade(index);            % Permissividade do meio
    sigma = condutividade_sigma(index);    % Condutividade
    
    % Cálculo do ângulo de incidência  
    ponto_incidencia = (ht * d)/(hr + ht);
    angulo_incidencia = atan(ht./ponto_incidencia);
    
    cos2 = @(theta) cos(theta) .* cos(theta);
    
    % Cálculo do parâmetro X
    x = @(f) 18*(10^9)*sigma/f;
    
    % Cálculo do coeficiente de polarização Vertical
    coeff_v = @(psi,f) ((er - 1i.*x(f)) .* sin(psi) - sqrt(( (er - 1i.*x(f)) - cos2(psi))))./ ...
                       ((er - 1i.*x(f)) .* sin(psi) + sqrt(( (er - 1i.*x(f)) - cos2(psi))));

    % Cálculo do coeficiente de polarização Horizontal
    coeff_h = @(psi,f) (sin(psi) - sqrt(( (er - 1i*x(f)) - cos2(psi))))./ ...
                       (sin(psi) + sqrt(( (er - 1i*x(f)) - cos2(psi))));
                   
    r_v = coeff_v(angulo_incidencia,f);
    r_h = coeff_h(angulo_incidencia,f);
    
end