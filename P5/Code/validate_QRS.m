function [ S, P, VP, FN, FP ] = validate_QRS( qrsdet, qrsref, fs )

VP = 0; % Verdaderos Positivos
FN = 0; % Falsos negativos
FP = 0; % Falsos positivos
ts = 1/fs;
nmax = floor(50e-3/ts); % numero de muestras que se permite de desviacion (50ms)
tot_real = length(qrsref);
tot_det = length(qrsdet);

i = 1;
j = 1;
while ((i <= tot_det) && (j <= tot_real))
    if ((qrsdet(i) > (qrsref(j) - nmax)) && ((qrsdet(i) < (qrsref(j) + nmax))))
        VP = VP + 1;
        i = i+1;
        j = j+1;
    elseif (qrsdet(i) > (qrsref(j) + nmax)) % QRS no detectado (Falso negativo)
        FN = FN + 1;
        j = j+1;
    else % Falso positivo
        FP = FP + 1;  
        i = i+1;
    end
end
 
S = VP/tot_real*100; % Porcentaje de QRS correctamente detectadas
P = VP/tot_det*100; % Porcentaje de correspondencia

end

