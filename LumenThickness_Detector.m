function varargout = LumenThickness_Detector(varargin)
% LUMENTHICKNESS_DETECTOR MATLAB code for LumenThickness_Detector.fig
%      LUMENTHICKNESS_DETECTOR, by itself, creates a new LUMENTHICKNESS_DETECTOR or raises the existing
%      singleton*.
%
%      H = LUMENTHICKNESS_DETECTOR returns the handle to a new LUMENTHICKNESS_DETECTOR or the handle to
%      the existing singleton*.
%
%      LUMENTHICKNESS_DETECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LUMENTHICKNESS_DETECTOR.M with the given input arguments.
%
%      LUMENTHICKNESS_DETECTOR('Property','Value',...) creates a new LUMENTHICKNESS_DETECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LumenThickness_Detector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LumenThickness_Detector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LumenThickness_Detector

% Last Modified by GUIDE v2.5 08-Feb-2018 15:37:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LumenThickness_Detector_OpeningFcn, ...
                   'gui_OutputFcn',  @LumenThickness_Detector_OutputFcn, ...
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


% --- Executes just before LumenThickness_Detector is made visible.
function LumenThickness_Detector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LumenThickness_Detector (see VARARGIN)

% Choose default command line output for LumenThickness_Detector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LumenThickness_Detector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LumenThickness_Detector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.indir = uigetdir('', 'Pick a directory that contains your Images');
handles.indir=[handles.indir '\'];

set(findobj(handles.edit1),'String',handles.indir);

mkdir([handles.indir 'OP\']);
handles.opdir=[handles.indir 'OP\'];
D=dir([handles.indir '*.czi']);

if ~isempty(D)
set(findobj(handles.text2),'String',['Nr.of Images found = ' num2str(numel(D))]);
else
    set(findobj(handles.text2),'String',['No Images are found in above folder']);
end

handles.D=D;

guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.ResizeFactor=str2num(contents{get(hObject,'Value')});
guidata(hObject, handles);



% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
contents = cellstr(get(hObject,'String'));
handles.ResizeFactor=str2num(contents{get(hObject,'Value')});
guidata(hObject, handles);
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.ThresholdFactor=str2num(contents{get(hObject,'Value')});
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
contents = cellstr(get(hObject,'String'));
handles.ThresholdFactor=str2num(contents{get(hObject,'Value')});
guidata(hObject, handles);
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ExperimentName=get(hObject,'String');
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.ExperimentName=get(hObject,'String');
guidata(hObject, handles);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.figure1, 'pointer', 'watch')
drawnow;

TotalResT=[];
set(findobj(handles.text7),'String',['']);


for i=1:numel(handles.D)
    
try
NameOfCZI=handles.D(i).name;    

ResT=Process_SihamVolumes_CovexHull(NameOfCZI,handles.indir, handles.opdir, handles.ResizeFactor, handles.ThresholdFactor, handles.ExperimentName);

TotalResT=[TotalResT;ResT];

set(findobj(handles.text7),'String',['Processing ' NameOfCZI ' ' num2str(i) ' of ' num2str(numel(handles.D))]);

catch
    continue;
end

end

writetable(TotalResT,[handles.opdir 'TrailNo_' handles.ExperimentName '.xlsx']);

set(findobj(handles.text7),'String',['Processing done!']);

set(handles.figure1, 'pointer', 'arrow');
