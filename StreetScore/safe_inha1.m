function varargout = safe_inha1(varargin)
% SAFE_INHA1 MATLAB code for safe_inha1.fig
%      SAFE_INHA1, by itself, creates a new SAFE_INHA1 or raises the existing
%      singleton*.
%
%      H = SAFE_INHA1 returns the handle to a new SAFE_INHA1 or the handle to
%      the existing singleton*.
%
%      SAFE_INHA1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAFE_INHA1.M with the given input arguments.
%
%      SAFE_INHA1('Property','Value',...) creates a new SAFE_INHA1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before safe_inha1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to safe_inha1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help safe_inha1

% Last Modified by GUIDE v2.5 04-Jun-2017 13:56:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @safe_inha1_OpeningFcn, ...
                   'gui_OutputFcn',  @safe_inha1_OutputFcn, ...
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
warning('off','all');
% End initialization code - DO NOT EDIT


% --- Executes just before safe_inha1 is made visible.
function safe_inha1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to safe_inha1 (see VARARGIN)

% Choose default command line output for safe_inha1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes safe_inha1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = safe_inha1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% load image 버튼
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load('RGBcolormaps.mat','mycmap');
% handles.color = mycmap;
% colormap(mycmap);
try
[file,path] = uigetfile('inha.bmp','Source image');
inputpath = strcat(path,file);
src = imread(inputpath);
[h,w,c] = size(src);
handles.src = src;
load('RGBcolormaps.mat','mycmap');
handles.cmap = mycmap;

if c == 1
    handles.src_r = src;
    handles.src_g = src;
    handles.src_b = src;
end
if c == 3
handles.src_r = src(:,:,1);
handles.src_g = src(:,:,2);
handles.src_b = src(:,:,3);
end

handles.h = h;
handles.w = w;
handles.c = c;
score_src = ones(h,w,c)*255;        % 필터
handles.score_src = score_src;

% axes(handles.axes1),imshow(imfuse(score_src,src,'blend'));
axes(handles.axes1), imshow(src);
guidata(hObject,handles);
catch
end
%% 엑셀 적용해 필터 만들기
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
R = 10;     % 반지름

[file,path] = uigetfile('./inha_final/inha_final1.xlsx','Source data');
inputpath = strcat(path,file);
z = xlsread(inputpath);

[file,path] = uigetfile('./inha_final/inha_final2.xlsx','Source data');
inputpath = strcat(path,file);
zz = xlsread(inputpath);

[file,path] = uigetfile('./inha_final/inha_final3.xlsx','Source data');
inputpath = strcat(path,file);
zzz = xlsread(inputpath);

data = size(z, 1);
data_y = z(:,1);        % 세로 -> h
data_x = z(:,2);        % 가로 -> w
data_safety = z(:,3);   % 안전도
handles.data_name = z(:,4);     % 파일이름
handles.data_d = zz(:,1);
handles.data_n = zz(:,2);
handles.data_s = zz(:,3);
handles.data_ss = zz(:,4);

handles.data_R = zzz(:,1);
handles.data_G = zzz(:,2);
handles.data_B = zzz(:,3);
cin = zzz(:,4);

handles.data = data;
handles.data_y = data_y;
handles.data_x = data_x;
handles.data_safety = data_safety;

%%
axes(handles.axes1),imshow(handles.src);
colormap(handles.cmap);
colorbar('ticks',[0,0.5,1],'ticklabels',{'danger','normal','safe',})

set(gcf,'WindowButtonDownFcn',{@axes1_ButtonDownFcn,handles});

guidata(hObject,handles);
catch
end

%% 안전도 표시 정적 텍스트
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


%% axes1 클릭시
% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
pos = get(gca, 'currentpoint'); % get mouse location on figure
y = round(pos(1,1));
x = round(pos(1,2));

in = 0;
yk = 0;
xk = 0;

for k = 1:handles.data
    if handles.data_y(k) < y+5 && handles.data_y(k) > y-5
        yk = k;
    end
    if  handles.data_x(k) < x+5 && handles.data_x(k) > x-5
        xk = k;
    end
    if yk == xk
        in = yk;
    end
end
catch
end
try
if handles.data_safety(in) == 0
    set(handles.edit1,'String','위험함');
elseif handles.data_safety(in) == 1
    set(handles.edit1,'String','보  통');
elseif handles.data_safety(in) == 2
    set(handles.edit1,'String','안전함');
end
da = '위험함 : ';
na = '보  통 : ';
sa = '안전함 : ';
if handles.data_d(in) > handles.data_n(in) && handles.data_d(in) > handles.data_s(in)           % danger
    if  handles.data_n(in) >  handles.data_s(in)
        set(handles.edit2,'String',sprintf('%s%.4f',da,handles.data_d(in)));
        set(handles.edit3,'String',sprintf('%s%.4f',na,handles.data_n(in)));
        set(handles.edit4,'String',sprintf('%s%.4f',sa,handles.data_s(in)));
    else
        set(handles.edit2,'String',sprintf('%s%.4f',da,handles.data_d(in)));
        set(handles.edit3,'String',sprintf('%s%.4f',sa,handles.data_s(in)));
        set(handles.edit4,'String',sprintf('%s%.4f',na,handles.data_n(in)));
    end
elseif handles.data_n(in) > handles.data_d(in) && handles.data_n(in) > handles.data_s(in)       % normal
    if  handles.data_d(in) >  handles.data_s(in)
        set(handles.edit2,'String',sprintf('%s%.4f',na,handles.data_n(in)));
        set(handles.edit3,'String',sprintf('%s%.4f',da,handles.data_d(in)));
        set(handles.edit4,'String',sprintf('%s%.4f',sa,handles.data_s(in)));
    else
        set(handles.edit2,'String',sprintf('%s%.4f',na,handles.data_n(in)));
        set(handles.edit3,'String',sprintf('%s%.4f',sa,handles.data_s(in)));
        set(handles.edit4,'String',sprintf('%s%.4f',da,handles.data_d(in)));
    end
elseif handles.data_s(in) > handles.data_d(in) && handles.data_s(in) > handles.data_n(in)       % safe
    if  handles.data_n(in) >  handles.data_d(in)
        set(handles.edit2,'String',sprintf('%s%.4f',sa,handles.data_s(in)));
        set(handles.edit3,'String',sprintf('%s%.4f',na,handles.data_n(in)));
        set(handles.edit4,'String',sprintf('%s%.4f',da,handles.data_d(in)));
    else
        set(handles.edit2,'String',sprintf('%s%.4f',sa,handles.data_s(in)));
        set(handles.edit3,'String',sprintf('%s%.4f',da,handles.data_d(in)));
        set(handles.edit4,'String',sprintf('%s%.4f',na,handles.data_n(in)));  
    end
end

out = imread(sprintf('%d.jpg',handles.data_name(in)));

axes(handles.axes2),imshow(out);

score = '/5';
set(handles.edit5,'String',sprintf('%.2f%s',handles.data_ss(in),score));  

catch
        msgbox('원하는 곳을 정확하게 눌러주세요');
        set(handles.edit1,'String','안 전 도');
        set(handles.edit2,'String','안 전 도');
        set(handles.edit3,'String','안 전 도');
        set(handles.edit4,'String','안 전 도');
        set(handles.edit5,'String','');
        cla(handles.axes2,'reset');
end

guidata(hObject,handles);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
