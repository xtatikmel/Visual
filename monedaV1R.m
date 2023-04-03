function varargout = monedaV1R(varargin)
% MONEDAV1R MATLAB code for monedaV1R.fig
%      MONEDAV1R, by itself, creates a new MONEDAV1R or raises the existing
%      singleton*.
%
%      H = MONEDAV1R returns the handle to a new MONEDAV1R or the handle to
%      the existing singleton*.
%
%      MONEDAV1R('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MONEDAV1R.M with the given input arguments.
%
%      MONEDAV1R('Property','Value',...) creates a new MONEDAV1R or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before monedaV1R_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to monedaV1R_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools Importar.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help monedaV1R

% Last Modified by GUIDE v2.5 02-Apr-2023 20:53:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @monedaV1R_OpeningFcn, ...
                   'gui_OutputFcn',  @monedaV1R_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before monedaV1R is made visible.
function monedaV1R_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to monedaV1R (see VARARGIN)

% Choose default command line output for monedaV1R
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes monedaV1R wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = monedaV1R_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Exportación~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

% --------------------------------------------------------------------
function menu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Exportar_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ExportarExcel_Callback(hObject, eventdata, handles)

%Exportar los datos de la tabla a Excel.
[nombre, direccion] = uiputfile({'*.xlsx', 'Archivo de Excel'}, ...
                                'Guardar como'); %Crear un nombre de archivo
Encabezado = get(handles.uitable1, 'ColumnName')'; %Exportar encabezados si hay.
Tabla = get(handles.uitable1, 'Data');
xlswrite([direccion, nombre], [Encabezado ; Tabla]);

% --------------------------------------------------------------------
function ExportarTexto_Callback(hObject, eventdata, handles)

%Exportar los datos de la tabla a un archivo .txt o .csv
[nombre, direccion, seleccion] = uiputfile({'*.txt', 'Archivo de texto' ; ...
                                 '*.csv', 'Archivo CSV'}, ...
                                'Guardar como');
Encabezado = get(handles.uitable1, 'ColumnName'); %Exportar encabezados si hay.
Encabezado{8} = 'Order_num'; %ESTO SOLO ES NECESARIO PARA MI CASO EN PARTICULAR

%Convertir los datos de la tabla en un arreglo de tipo tabla
T = array2table(get(handles.uitable1, 'Data'), 'VariableNames', Encabezado);

%Dependiendo de si elegimos guardar como .txt (1) o .csv (2), se añade un
%delimitador de columnas específico.
if seleccion == 1
    writetable(T, [direccion, nombre], 'Delimiter', '\t');
elseif seleccion == 2
    writetable(T, [direccion, nombre], 'Delimiter', ',');
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Importación~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

% --------------------------------------------------------------------
function Importar_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ImportarExcel_Callback(hObject, eventdata, handles)

%Importar una hoja de cálculo de Excel
[nombre, direccion] = uigetfile({'*.xlsx', 'Archivo de Excel'}, ...
                                'Escoge un archivo'); %Obtener nombre y dirección del archivo a importar
[M, string, full] = xlsread([direccion, nombre]);
NombresCol = full(1,:); %Separar el encabezado del arreglo y guardarlo como un arreglo nuevo.
full(1,:) = []; %Borrar el encabezado de los datos del arreglo.
NumeracionFilas = 1:size(full, 1); 
set(handles.uitable1, 'Data', full, 'ColumnName', NombresCol, ...
    'ColumnEditable', logical(1:size(full,2)), 'RowName', NumeracionFilas);
guidata(hObject, handles);


% --------------------------------------------------------------------
function ImportarTexto_Callback(hObject, eventdata, handles)

%Importar un archivo de texto o .csv
[nombre, direccion] = uigetfile({'*.txt', 'Archivo de texto' ; ...
                                 '*.csv', 'Archivo CSV'}, ...
                                'Escoge un archivo'); %Obtener nombre y dirección del archivo a importar
if isequal(nombre,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(direccion,nombre)]);
end
M = table2cell(readtable([direccion, nombre], 'ReadVariableNames', false));
NombresCol = M(1,:); %Separar el encabezado del arreglo y guardarlo como un arreglo nuevo.
M(1,:) = []; %Borrar el encabezado de los datos del arreglo.
NumeracionFilas = 1:size(M, 1);
set(handles.uitable1, 'Data', M, 'ColumnName', NombresCol, ...
    'ColumnEditable', logical(1:size(M,2)), 'RowName', NumeracionFilas);
guidata(hObject, handles);
%~~~~~~~~~~~~~~~~~~~~~~~Cambiar formato de columnas~~~~~~~~~~~~~~~~~~~~~~~%

% --------------------------------------------------------------------
function Editar_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function FormatoNumerico_Callback(hObject, eventdata, handles)

%Abrir mensaje de usuario para ingresar número de columna a editar
T = get(handles.uitable1, 'Data');
texto = {['Ingresa el número de columna en' newline 'la cual cambiar el formato']};
titulo = 'Cambiar formato';
numlines = 1;
default = {'2'};
respuesta = inputdlg(texto,titulo,numlines,default);
col = str2num(respuesta{1});

%Convertir el arreglo de celdas en numérico
for i = 1:size(T,1)
iter = T{i,col};
editado(i,1) = num2cell(str2num(iter));
end

%Sobreescribir la tabla
T(:,col) = editado;
set(handles.uitable1, 'Data', T);
guidata(hObject, handles);

% --------------------------------------------------------------------
function FormatoString_Callback(hObject, eventdata, handles)

%Abrir mensaje de usuario para ingresar número de columna a editar
global T;
T = get(handles.uitable1, 'Data');
texto = {['Ingresa el número de columna en' newline 'la cual cambiar el formato']};
titulo = 'Cambiar formato';
numlines = 1;
default = {'2'};
respuesta = inputdlg(texto,titulo,numlines,default);
col = str2num(respuesta{1});

%Convertir el arreglo a texto
editado = cellstr(num2str(cell2mat(T(:,col))));
T(:,col) = editado;
set(handles.uitable1, 'Data', T);
guidata(hObject, handles);

%%
% --- Executes on button press in opnedb.
function opnedb_Callback(hObject, eventdata, handles)
% hObject    handle to opnedb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nombre, direccion] = uigetfile({ '*.xlsx', 'Archivo de Excel';...
                                  '*.txt', 'Archivo de texto' ; ...
                                 '*.csv', 'Archivo CSV'}, ...
                                'Escoge un archivo'); %Obtener nombre y dirección del archivo a importar

global M string full;
ruta = fullfile(direccion,nombre)
[M, string, full] = xlsread([direccion, nombre]); 

% opts = detectImportOptions(ruta)
% Dato = readtable(ruta,opts)
% Dato.Properties
NombresCol = full(1,:); %Separar el encabezado del arreglo y guardarlo como un arreglo nuevo.
full(1,:) = []; %Borrar el encabezado de los datos del arreglo.
NumeracionFilas = 1:size(full, 1); 
set(handles.uitable1, 'Data', full, 'ColumnName', NombresCol, ...
    'ColumnEditable', logical(1:size(full,2)), 'RowName', NumeracionFilas);

handles.valorfile = ruta;

set(handles.file, 'String', num2str(handles.valorfile));

guidata(hObject, handles);

% --- Executes when entered data in editable cell(s) in uitable1.

% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


%~~~~~~~~~~~~~~~~~~~~~~~~~~~Hoja de cálculo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)

%Obtener el índice de la columna donde está la celda editada
Indices = eventdata.Indices;

%Si se actualiza la columna 6 o 7, se vuelven a calcular las sumatorias.
if Indices(2) == 6 || Indices(2) == 7
    Calcular_Callback(handles.Calcular, [], handles)
end

% --- Executes on button press in Calcular. 
function Calcular_Callback(hObject, eventdata, handles)
%%% APlicamos calculos 
T = get(handles.uitable1, 'Data');
handles.valorpromedio = mean(cell2mat(T(:,2)));
handles.valormx = max(cell2mat(T(:,2)));
handles.valormn = min(cell2mat(T(:,2)));
handles.valorrango = range(cell2mat(T(:,2)));
handles.valormediari = mean(cell2mat(T(:,2)));
handles.valormediageo = geomean(cell2mat(T(:,2)));
handles.valormediaarm = harmmean(cell2mat(T(:,2)));
handles.valorlamedian = median(cell2mat(T(:,2)));
handles.valormod = mode(cell2mat(T(:,2)));
handles.valordesvestan = std(cell2mat(T(:,2)));
handles.valordesvmed = mean(cell2mat(T(:,2)));
handles.valoresperanz = mean(cell2mat(T(:,2)));
handles.valorvarianz = var(cell2mat(T(:,2)));
handles.valorcovarianz = cov(cell2mat(T(:,2)));
handles.valorkurtos = kurtosis(cell2mat(T(:,2)));
handles.valoraper = handles.valormx/handles.valormn;
handles.valorcoefivar = handles.valordesvestan/handles.valordesvmed;
handles.valorpearson = (handles.valordesvestan/handles.valormediaarm)*100;


%%% Imprimimos resulatado
set(handles.promedio, 'String', num2str(handles.valorpromedio));
set(handles.mx, 'String', num2str(handles.valormx));
set(handles.mn, 'String', num2str(handles.valormn));
set(handles.rango, 'String', num2str(handles.valorrango));
set(handles.mediari, 'String', num2str(handles.valormediari));
set(handles.mediageo, 'String', num2str(handles.valormediageo));
set(handles.mediaarm, 'String', num2str(handles.valormediaarm));
set(handles.lamedian, 'String', num2str(handles.valorlamedian));
set(handles.mod, 'String', num2str(handles.valormod));
set(handles.desvestan, 'String', num2str(handles.valordesvestan));
set(handles.desvmed, 'String', num2str(handles.valordesvmed));
set(handles.esperanz, 'String', num2str(handles.valoresperanz));
set(handles.varianz, 'String', num2str(handles.valorvarianz));
set(handles.covarianz, 'String', num2str(handles.valorcovarianz));
set(handles.kurtos, 'String', num2str(handles.valorkurtos));
set(handles.aper, 'String', num2str(handles.valoraper));
set(handles.coefivar, 'String', num2str(handles.valorcoefivar));
set(handles.pearson, 'String', num2str(handles.valorpearson));

    guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function promedio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function mx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function mn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1



% --- Executes during object creation, after setting all properties.
function y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in grafica.
function grafica_Callback(hObject, eventdata, handles)
% hObject    handle to grafica (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global T M string full CrucesZero y_normalized;

    fecha = datetime(string(2:end,1),'InputFormat','dd/MM/yyyy');
%%% Grafica de datos originales con sus valores maximos y minimos
subplot(handles.axes1)
hold on
plot(fecha,M,'g');
 Indexmx = find(M ==handles.valormx)
 plot(fecha(Indexmx),M(Indexmx),'cd');
 Indexmn = find(M ==handles.valormn)
 plot(fecha(Indexmn),M(Indexmn),'cd');
hold off
    datetick('x','yyyy');
    xlabel('Tiempo (Dias)');
    ylabel('Tasa de Cambio(Pesos)');
    title('Variación');
    legend('Dolar','Max','Min');
set(handles.axes1,'Box','on');


% --- Executes on button press in normal.

% --- Executes on button press in mxmn.
function mxmn_Callback(hObject, eventdata, handles)

global T M string full CrucesZero y_normalized  ;

    fecha = datetime(string(2:end,1),'InputFormat','dd/MM/yyyy');
%%% Grafica de datos originales con sus valores maximos y minimos
R3=get(hObject,'Value'); %Obtenemos el valor booleano de checkbox1
g=get(handles.axes1,'GridColor');

if R3==1
%      hObject.mxmn = plot(fecha(Indemx),M(Indemx),'cd',fecha(Indemn),M(Indemn),'cd',fecha,M,'g');

% subplot(handles.axes1)
hold on
plot(fecha,M,'g');
Indexmx = find(M ==handles.valormx)
hObject.mxmn0 = plot(fecha(Indexmx),M(Indexmx),'cd');
Indexmn = find(M ==handles.valormn)
hObject.mxmn1 = plot(fecha(Indexmn),M(Indexmn),'cd');
% hold off
    datetick('x','yyyy');
    xlabel('Tiempo (Dias)');
    ylabel('Tasa de Cambio(Pesos)');
    
    title('Variación');
    legend('Max','Min');
set(handles.axes1,'Box','on');

else
% 
subplot(handles.axes1)
hold off
plot(fecha,M,'g');
Indexmx = find(M ==handles.valormx)
hObject.Indexmx0 = plot(fecha(Indexmx),M(Indexmx),'cd');

Indexmn = find(M ==handles.valormn)
hObject.Indexmx1 = plot(fecha(Indexmn),M(Indexmn),'cd');
hold off
%  hObject.mxmn = plot(fecha(Indemx),M(Indemx),'cd',fecha(Indemn),M(Indemn),'cd',fecha,M,'g');
hold off
    datetick('x','yyyy');
    xlabel('Tiempo (Dias)');
    ylabel('Tasa de Cambio (Pesos)');
    
    title('Variación');
%     legend('Dolar','Max','Min');
set(handles.axes1,'Box','on');

end    

function normal_Callback(hObject, eventdata, handles)
% hObject    handle to normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Lugar de Raíces (Cruces x Cero), Máximos Relativos y Mínimos Relativos
%%% Utilizar la instrucción "find" o el "Teorema de Boltzman" 
% () ∗ () < 0,  ,  
%    ó para buscar los ceros del grupo de datos. 
global T M string full CrucesZero y_normalized;
   
    fecha = datetime(string(2:end,1),'InputFormat','dd/MM/yyyy');
axisy = M;
promedio = mean(M);
    axisx = datetime(string(2:end,1),'InputFormat','dd/MM/yyyy');
        y_normalized = axisy - promedio;
%%% Teniendo en cuenta que el cruce por cero se puede obtener interpolando 
% linealmente los dos valores o eligiendo el más cercano al cero
% Identificar los máximos relativos con coordenadas 
% (, ()) () < () < (),  , ,     ó
% Identificar los mínimos relativos con coordenadas 
% (, ())() > () > (),  , ,      ó
YMax = [];YMin = [];
for (I = 1: length(y_normalized)-2)
    % Máximos Relativos
    if(y_normalized(I) < y_normalized(I+1) && y_normalized(I+1) > y_normalized(I+2))
        YMax = [YMax I+1];
    end
    % Mínimos Relativos
    if(y_normalized(I) > y_normalized(I+1) && y_normalized(I+1) < y_normalized(I+2))
        YMin = [YMin I+1];
    end
end
[~,MaxAbsolute] = max(y_normalized);
[~,MinAbsolute] = min(y_normalized);
CrucesZero = [];
for (I = 1:length(y_normalized)-1)
    if(y_normalized(I)*y_normalized(I+1) < 0)
        if(abs(y_normalized(I)) < abs(y_normalized(I+1)))
            CrucesZero = [CrucesZero I];
        else
            CrucesZero = [CrucesZero I+1];
        end
    end

end
% Hint: place code in OpeningFcn to populate axes2

%%% Grafica de datos originales con sus valores maximos y minimos
subplot(handles.axes1)
hold on
%plot(fecha,y_normalized,'b',fecha,data,'g');  
plot(fecha,y_normalized,'b'); 
% plot(fecha(CrucesZero),y_normalized(CrucesZero),'cd');
hold off
datetick('x','yyyy');    
      title('Variación del dolar Vs. Variacion del Dolar Normalizado');
    legend('DolarNormalizado','Dolar');
set(handles.axes1,'Box','on');


% --- Executes during object creation, after setting all properties.
function rango_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rango (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function mediari_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mediari (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function mediageo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mediageo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function mediaarm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mediaarm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function lamedian_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lamedian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function mod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function desvestan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desvestan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function desvmed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desvmed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function esperanz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to esperanz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function varianz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varianz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function covarianz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to covarianz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function kurtos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kurtos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function aper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function coefivar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to coefivar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in crucecero.
function crucecero_Callback(hObject, eventdata, handles)
global T M string full CrucesZero y_normalized;

    fecha = datetime(string(2:end,1),'InputFormat','dd/MM/yyyy');
axisy = M;
promedio = mean(M);
    axisx = datetime(string(2:end,1),'InputFormat','dd/MM/yyyy');
        y_normalized = axisy - promedio;
R1=get(hObject,'Value'); %Obtenemos el valor booleano de checkbox1
g=get(handles.axes1,'GridColor');
if R1==1 % SI el valor es 1 o encendido
%   subplot(handles.axes1)
    hold on  

  hObject.cruce = plot(fecha(CrucesZero),y_normalized(CrucesZero),'bx');
%     set(handles.axes1,'GridColor',g);
else
    hold off
  hObject.cruce = plot(fecha(CrucesZero),y_normalized(CrucesZero),fecha,y_normalized,'b');


%     hold off
%      hold on

 %   delete(handles.cruce);

%       hold off
 %set(handles.axes1,'Box','off');
end
%guidata(handles.axes1,handles);
% hObject    handle to crucecero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crucecero


% --- Executes on button press in grid.
function grid_Callback(hObject, eventdata, handles)
% hObject    handle to grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of grid


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

R2=get(hObject,'Value'); %Obtenemos el valor booleano de checkbox2
if R2==1 %Si el valor booleano de checkbox2 es verdadero, encendido o 1...
    set(handles.axes1,'XGrid','on') %Encendemos la cuadrícula del eje X de axes1
    set(handles.axes1,'YGrid','on') %Encendemos la cuadrícula del eje Y de axes1
else %Si no, o sea falso, apagado o 0...
    set(handles.axes1,'XGrid','off') %Encendemos la cuadrícula del eje X de axes1
    set(handles.axes1,'YGrid','off') %Encendemos la cuadrícula del eje Y de axes1
end
guidata(handles.axes1,handles); %Almacenamos todos los cambios ocurridos en axes1


% --- Executes during object creation, after setting all properties.
function file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% hObject    handle to mxmn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mxmn


% --- Executes on button press in max.
function max_Callback(hObject, eventdata, handles)
% hObject    handle to max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global T M string full 
handles.valormx = max(cell2mat(T(:,2)));
% Hint: get(hObject,'Value') returns toggle state of max
R4=get(hObject,'Value'); %Obtenemos el valor booleano de checkbox2
g=get(handles.axes1,'GridColor');
if R4==1 %Si el valor booleano de checkbox2 es verdadero, encendido o 1...
    set(handles.axes1,yline(handles.valormx,'r','--')) %Encendemos la cuadrícula del eje X de axes1
else %Si no, o sea falso, apagado o 0...
%     set(handles.axes1,'XGrid','off') %Encendemos la cuadrícula del eje X de axes1
%     set(handles.axes1,'YGrid','off') %Encendemos la cuadrícula del eje Y de axes1
end
guidata(handles.axes1,handles); %Almacenamos todos los cambios ocurridos en axes1


% --- Executes on button press in min.
function min_Callback(hObject, eventdata, handles)
% hObject    handle to min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global T M string full 
handles.valormn = min(cell2mat(T(:,2)));
% Hint: get(hObject,'Value') returns toggle state of min
R5=get(hObject,'Value'); %Obtenemos el valor booleano de checkbox2
if R5==1 %Si el valor booleano de checkbox2 es verdadero, encendido o 1...
    set(handles.axes1,yline(handles.valormn,'r','--')) %Encendemos la cuadrícula del eje X de axes1
else %Si no, o sea falso, apagado o 0...
%     set(handles.axes1,'YGrid','off') %Encendemos la cuadrícula del eje Y de axes1
end
guidata(handles.axes1,handles); %Almacenamos todos los cambios ocurridos en axes1
