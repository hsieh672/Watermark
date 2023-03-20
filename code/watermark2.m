
function varargout = watermark2(varargin)
% WATERMARK2 MATLAB code for watermark2.fig
%      WATERMARK2, by itself, creates a new WATERMARK2 or raises the existing
%      singleton*.
%
%      H = WATERMARK2 returns the handle to a new WATERMARK2 or the handle to
%      the existing singleton*.
%
%      WATERMARK2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATERMARK2.M with the given input arguments.
%
%      WATERMARK2('Property','Value',...) creates a new WATERMARK2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before watermark2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to watermark2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help watermark2

% Last Modified by GUIDE v2.5 30-Apr-2021 11:55:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @watermark2_OpeningFcn, ...
                   'gui_OutputFcn',  @watermark2_OutputFcn, ...
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


% --- Executes just before watermark2 is made visible.
function watermark2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to watermark2 (see VARARGIN)

% Choose default command line output for watermark2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes watermark2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = watermark2_OutputFcn(hObject, eventdata, handles) 
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
global img bp row_img col_img
[filename,pathname]=uigetfile('*.png;*.jpg;*.tif');
img = imread([pathname filename]);
axes(handles.axes1);
img=rgb2gray(img);
imshow(img);
row_img=length(img(1,:,:));
col_img=length(img(:,1,:));
bp=get(handles.edit2,'String');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img bp row_img col_img water_mark sz
[filename,pathname]=uigetfile('*.png;*.jpg;*.tif');

water_mark = imread([pathname filename]);
water_mark = im2bw(water_mark);

axes(handles.axes2);
imshow(water_mark);

sz=str2double(get(handles.edit5,'String'));
row_sz=row_img/sz;
col_sz=col_img/sz;
water_mark=imresize(water_mark,[row_sz col_sz]);
row_start=1;
col_start=1;
row_end=row_sz;
col_end=col_sz;
col=1;
row=1;

for i=1:row_end
    for m=1:col_end
        for j=row_start:row_sz
            for k=col_start:col_sz
                water_mark_2(j,k)=water_mark(row,col);
                col=col+1;
            end
            col=1;
            row=row+1;
        end
        row=1;
        col_start=col_start + col_sz;
        col_sz=col_sz + col_sz;
    end
    row_start=row_start + row_sz;
    row_sz=row_sz + row_sz;
end


bp=get(handles.edit2,'String');

for i=1:row_img
    for j=1:col_img
        a=dec2bin(img(i,j),8); %取8個bit
        a(str2double(bp))=num2str(water_mark_2(i,j));
        new_water_mark(i,j)=bin2dec(a); %轉回dec
    end
end
    axes(handles.axes3);
    imshow(uint8(new_water_mark));
    Qv=get(handles.edit1,'String');
    imwrite(uint8(new_water_mark),'wm_img.jpg','jpg','Quality',str2double(Qv));
    
    msgbox('Watermark embedding Completed');

 


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img bp water_mark

iwm = imread('wm_img.jpg');

row_wm=length(img(1,:));
col_wm=length(img(:,1));
iwm = imresize(iwm,[row_wm col_wm]);

bp=get(handles.edit2,'String');
for i=1:row_wm
    for j=1:col_wm
        bin=dec2bin(iwm(i,j),8);
        get_wm(i,j)=str2double(bin(str2double(bp)));
    end
end
axes(handles.axes4);
imshow(get_wm);
score=corr2(imresize(get_wm,[256 256]),imresize(water_mark,[256 256]));
set(handles.edit3,'String',num2str(score));
msgbox('Get Watermark Completed');




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
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
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
