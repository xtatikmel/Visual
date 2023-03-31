clc
close all
clear all
%% Comando xlsread
[USD,Rublo,Bitcoin] = xlsread('');
% filas de Interes
USD = []; rublo = []; BTC = [];
subplot(3,1,1)
hold on;
plot(Dolar(USD,:))
plot(Dolar(rublo,:))
plot(Dolar(BTC,:))
grid on;
title('diferencia entre el dolar, el rublo y el BTC. ')
xlabel('Dolar');
hold off;
legend({'Dolar','Rublo','BTC'})
%%
meanUSD = mean(Dolar(USD,:))
meanrublo = mean(Dolar(rublo,:))
meanBTC = mean(Dolar(BTC,:))
ValoresAjustados = [[Dolar(USD,:) - meanUSD;Dolar(rublo,:) - meanrublo] - meanUSD;Dolar(BTC,:) - meanBTC]];
subplot(3,1,2)
hold on;
plot(ValoresAjustados(1,:)) % Dolar
plot(ValoresAjustados(2,:)) % Rublo
plot(ValoresAjustados(3,:)) % BTC
grid on;
title('Inflación Actual en las principales monedas. ')
xlabel('Rublo');
hold off;
legend({'USD','rublo','Mínimos Relativos','Máximos Relarivos','Cruces x Cero'})
%%
subplot(3,1,3)
hold on;
plot(ValoresAjustados(1,:)) % Dolar
plot(ValoresAjustados(2,:)) % Rublo
plot(ValoresAjustados(3,:)) % BTC
grid on;
title('Tendecias del BTC en base a el dolar y el rublo ')
xlabel('BTC');
%%
for J = 1 : 2 
   
    maxRelativos = [];minRelativos = [];
    for(I = 1: size(ValoresAjustados,2)-2)
        if(ValoresAjustados(J,I) < ValoresAjustados(J,I+1) && ValoresAjustados(J,I+2) < ValoresAjustados(J,I+1))
            maxRelativos = [maxRelativos I+1];
        end
        
        if(ValoresAjustados(J,I) > ValoresAjustados(J,I+1) && ValoresAjustados(J,I+2) > ValoresAjustados(J,I+1))
            minRelativos = [minRelativos I+1];
        end
    end    
    plot(minRelativos,ValoresAjustados(J,minRelativos),'ob')
    plot(maxRelativos,ValoresAjustados(J,maxRelativos),'*k')
    
    CrucesCero = [];
    for(I = 1: size(ValoresAjustados,2)-1)
        if((ValoresAjustados(J,I)*ValoresAjustados(J,I+1))<0)
            if(abs(ValoresAjustados(J,I)) < abs(ValoresAjustados(J,I+1)))
                CrucesCero = [CrucesCero I];
            else
                CrucesCero = [CrucesCero I+1];
            end
        end
    end
    plot(CrucesCero,ValoresAjustados(J,CrucesCero),'dr')
end
hold off;
legend({'USD','rublo','BTC','Mínimos Relativos','Máximos Relarivos','Cruces x Cero'})
%%
CoeficientesUSD = polyfit(0:1:length(Dolar(USD,:))-1,Dolar(USD,:),2)
CoeficientesRublo = polyfit(0:1:length(Dolar(rublo,:))-1,Dolar(rublo,:),2)
CoeficientesBTC = polyfit(0:1:length(Dolar(BTC,:))-1,Dolar(BTC,:),2)
%%
poly2str(CoeficientesUSD,'x')
x = 0:1:length(Dolar(USD,:))+1;
USDAJUSTADO = polyval(CoeficientesUSD,x)
subplot(3,1,1);
hold on;
plot(x,USDAJUSTADO);
hold off;
poly2str(Coeficientesrublo,'x')
x = 0:1:length(Dolar(rublo,:))+1;
rubloAJUSTADO = polyval(Coeficientesrublo,x)
subplot(3,1,1);
hold on;
plot(x,USDAJUSTADO);
hold off;
poly2str(CoeficientesBTC,'x')
x = 0:1:length(Dolar(BTC,:))+1;
BTCAJUSTADO = polyval(CoeficientesBTC,x)
subplot(3,1,1);
hold on;
plot(x,USDAJUSTADO);
hold off;
%%
return
xlswrite('DB.xlsx',{'Hola a todos'},'Hoja2','B4')[Dolar,Rublo,Bitcoin] = xlsread('');