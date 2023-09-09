# Watermark
To protect the copyright of images, I designed a simple UIUX interface to add watermarks to images.
## Enter the host image and initial settings
When pushing the bottom of the "source image," the image that needs to add the watermark would be loaded, and the system would transform the image from RGB to gray image and show it on the user interface.  
```sh
function pushbutton1_Callback(hObject, eventdata, handles)
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
## Enter the watermark image and initial settings
The image will be loaded when the "add watermark" is pushed.  
```sh
function pushbutton2_Callback(hObject, eventdata, handles)
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
```
## Create a watermark of the original image
The size of the watermark is the row_end * col_end.
```sh
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
```
## Hide the watermark in the host image and save it as a new image
```sh
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
```
## Read the image with the watermark on it and remove the watermark
When pushing the button of "check the watermark," the watermark will be removed
```sh
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
        bin=dec2binwilli,j),8);
        get_wm(i,j)=str2double(bin(str2double(bp)));
    end
end
axes(handles.axes4);
imshow(get_wm);
score=corr2(imresize(get_wm,[256 256]),imresize(water_mark,[256 256]));
set(handles.edit3,'String',num2str(score));
msgbox('Get Watermark Completed');
```
