# Watermark
With the idea of protecting the copyright of images, I designed a simple UIUX interface to add watermarks to images.
## Enter the host image and initial settings
```sh
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
```
