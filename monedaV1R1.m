function varargout = monedaV1R1(varargin)
% MONEDAV1R1 MATLAB code for monedaV1R1.fig
%      MONEDAV1R1, by itself, creates a new MONEDAV1R1 or raises the existing
%      singleton*.
%
%      H = MONEDAV1R1 returns the handle to a new MONEDAV1R1 or the handle to
%      the existing singleton*.
%
%      MONEDAV1R1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MONEDAV1R1.M with the given input arguments.
%
%      MONEDAV1R1('Property','Value',...) creates a new MONEDAV1R1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before monedaV1R1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to monedaV1R1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools Importar.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help monedaV1R1

% Last Modified by GUIDE v2.5 28-Mar-2023 03:24:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @monedaV1R1_OpeningFcn, ...
                   'gui_OutputFcn',  @monedaV1R1_OutputFcn, ...
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


% --- Executes just before monedaV1R1 is made visible.
function monedaV1R1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to monedaV1R1 (see VARARGIN)

% Choose default command line output for monedaV1R1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes monedaV1R1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = monedaV1R1_OutputFcn(hObject, eventdata, handles) 
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

[M, string, full] = xlsread([direccion, nombre]);  
NombresCol = full(1,:); %Separar el encabezado del arreglo y guardarlo como un arreglo nuevo.
full(1,:) = []; %Borrar el encabezado de los datos del arreglo.
NumeracionFilas = 1:size(full, 1); 
set(handles.uitable1, 'Data', full, 'ColumnName', NombresCol, ...
    'ColumnEditable', logical(1:size(full,2)), 'RowName', NumeracionFilas);
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

T = get(handles.uitable1, 'Data');
handles.valorpromedio = mean(cell2mat(T(:,2)));
handles.valormx = max(cell2mat(T(:,2)));
handles.valormn = min(cell2mat(T(:,2)));
set(handles.promedio, 'String', num2str(handles.valorpromedio));
set(handles.mx, 'String', num2str(handles.valormx));
set(handles.mn, 'String', num2str(handles.valormn));
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
T = get(handles.uitable1, 'Data');
   [data,header] =  xlsread("DB Datos.xlsx");
    fecha = datetime(header(2:end,1),'InputFormat','dd/MM/yyyy');
%%% Grafica de datos originales con sus valores maximos y minimos
plot(fecha,data,'g');
%handles.valorx = values(:,1);
%handles.valory = values(:,2);
%plot(fecha,full,'g');
%plot((cell2mat(T(:,1))),(cell2mat(T(:,2))),'g');
    datetick('x','yyyy');
    xlabel('Tiempo (Dias)');
    ylabel('Tasa de Cambio del Dolar (Pesos)');
 %   yline(mn,'b','--');
%    yline(mx,'r','--');
    title('Variación del dolar desde 2012');
   % legend('Dolar','Max','Min');
    grid on;
set(handles.axes1,'Box','on');



% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in normal.
function normal_Callback(hObject, eventdata, handles)
% hObject    handle to normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Lugar de Raíces (Cruces x Cero), Máximos Relativos y Mínimos Relativos
%%% Utilizar la instrucción "find" o el "Teorema de Boltzman" 
% () ∗ () < 0,  ,  
%    ó para buscar los ceros del grupo de datos. 
T = get(handles.uitable1, 'Data');
   [data,header] =  xlsread("DB Datos.xlsx");
    fecha = datetime(header(2:end,1),'InputFormat','dd/MM/yyyy');
axisy = data;
promedio = mean(data);
    axisx = datetime(header(2:end,1),'InputFormat','dd/MM/yyyy');
        y_normalized = axisy - promedio;
%%% Teniendo en cuenta que el cruce por cero se puede obtener interpolando 
% linealmente los dos valores o eligiendo el más cercano al cero
% Identificar los máximos relativos con coordenadas 
% (, ()) () < () < (),  , ,      ó
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
plot(fecha,y_normalized,'b',fecha,data,'g');  
    datetick('x','yyyy');    
      title('Variación del dolar Vs. Variacion del Dolar Normalizado');
    legend('DolarNormalizado','Dolar');
    grid on;
    grid on;
set(handles.axes1,'Box','on');
