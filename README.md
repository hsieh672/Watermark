# Watermark
With the idea of protecting the copyright of images, I designed a simple UIUX interface to add watermarks to images.
## Enter the host image and initial settings
When pushing the bottom of loading the image which need to add the watermark, the system would transform the image from RGB to gray image and showed on the user interface.  
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
The size of the watermark is the row_end * col_end
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
