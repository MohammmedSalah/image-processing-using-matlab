function varargout = projectGui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @projectGui_OpeningFcn, ...
                   'gui_OutputFcn',  @projectGui_OutputFcn, ...
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


% --- Executes just before projectGui is made visible.
function projectGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to projectGui (see VARARGIN)

% Choose default command line output for projectGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes projectGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = projectGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
global im 
[path , user_cance]=imgetfile();
if user_cance 
     msgbox(sprintf('Error'),'Error','Error');
     return 
end
im=imread(path);
im2=im;
axes(handles.axes1);
imshow(im);
 


% --- Executes on button press in average_method.
function average_method_Callback(hObject, eventdata, handles)
global im 

i=im;
for j=1:size(i,1)
    for k=1:size(i,2)
        GrayScale(j,k)=(i(j,k,1)+i(j,k,2)+i(j,k,3))/3;
    end
end  
axes(handles.axes2);
imshow(GrayScale);


% --- Executes on button press in lightness_method.
function lightness_method_Callback(hObject, eventdata, handles)
global im 

i=im;
for j=1:size(i,1)
    for k=1:size(i,2)
        Lightness(j,k)=(max([i(j,k,1),i(j,k,2),i(j,k,3)])+min([i(j,k,1),i(j,k,2),i(j,k,3)]))/2;
    end
end  
axes(handles.axes2);
imshow(Lightness);


% --- Executes on button press in weighted_Method.
function weighted_Method_Callback(hObject, eventdata, handles)
global im 

i=im;
for j=1:size(i,1)
    for k=1:size(i,2)
        Weighted(j,k)=((0.3*i(j,k,1))+(0.59*i(j,k,2))+(0.11*i(j,k,3)));
    end
end  
axes(handles.axes2);
imshow(Weighted);


% --- Executes on button press in thresholding.
function thresholding_Callback(hObject, eventdata, handles)
global im 

i=im;
for j=1:size(i,1)
    for k=1:size(i,2)
        Weighted(j,k)=((0.3*i(j,k,1))+(0.59*i(j,k,2))+(0.11*i(j,k,3)));
    end
end  

for j=1:size(Weighted,1)
    for k=1:size(Weighted,2)
        if(Weighted(j,k)>128)
            thresholding(j,k)=1;
        else
            thresholding(j,k)=0;
        end
    end
end      


axes(handles.axes2);
imshow(thresholding);


% --- Executes on button press in pixel_replication_zoom.
function pixel_replication_zoom_Callback(hObject, eventdata, handles)
global im 

i=im;
ColCounter=1;
RowCounter=1;
for j=1:size(im,1)
    for k=1:size(im,2)  
        R(RowCounter:RowCounter+1,ColCounter:ColCounter+1)=im(j,k,1);
        G(RowCounter:RowCounter+1,ColCounter:ColCounter+1)=im(j,k,2);
        B(RowCounter:RowCounter+1,ColCounter:ColCounter+1)=im(j,k,3);
        ColCounter=ColCounter+2;
    end
    RowCounter=RowCounter+2;
    ColCounter=1;
end
pixel_replication=cat(3,R,G,B);

axes(handles.axes2);
imshow(pixel_replication);


% --- Executes on button press in zero_order_zoom.
function zero_order_zoom_Callback(hObject, eventdata, handles)
global im;
a =im;
a = double(a)/255;
[r c] = size(a);
s = 2;
r2 = (r*s) -1;
c2 = (c*s)-1;
ng = zeros(r2 , c2,class(a));

for i =1:2:r2        
    for j=1:c2
        ii = ceil(i/s);
        jj = ceil(j/s);
        if( mod(i,2) == 1 && mod(j,2) ==1)       
            ng(i,j) =  a ( ii,jj);            
        else
            ng(i,j) = (a ( ii,jj) + a ( ii,jj+1)) /2;      
        end    
    end
end
for i =2:2:r2-1       
    for j=1:c2
      ng(i,j) = (ng(i-1,j)+ng(i+1,j))/2;   
    end
end

axes(handles.axes2);
imshow(ng);


function crop_image_Callback(hObject, eventdata, handles)
global im;
A=im;
x_TopLeft= str2num(get(handles.x_top_left, 'string'));
y_TopLeft= str2num(get(handles.y_top_left, 'string'));
x_BottomRight=str2num(get(handles.x_bottom_right, 'string'));
y_BottomRight=str2num(get(handles.y_bottom_right, 'string'));
M=x_BottomRight-x_TopLeft+1;
N=y_BottomRight-y_TopLeft+1; 
for i=1:M
    for j=1:N
        B(i, j, :)=A(x_TopLeft+i, y_TopLeft+j, :);
    end
end
axes(handles.axes2);
imshow(B);

function x_top_left_Callback(hObject, eventdata, handles)
% hObject    handle to x_top_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_top_left as text
%        str2double(get(hObject,'String')) returns contents of x_top_left as a double


% --- Executes during object creation, after setting all properties.
function x_top_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_top_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_bottom_right_Callback(hObject, eventdata, handles)
% hObject    handle to y_bottom_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_bottom_right as text
%        str2double(get(hObject,'String')) returns contents of y_bottom_right as a double


% --- Executes during object creation, after setting all properties.
function y_bottom_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_bottom_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_top_left_Callback(hObject, eventdata, handles)
% hObject    handle to y_top_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_top_left as text
%        str2double(get(hObject,'String')) returns contents of y_top_left as a double


% --- Executes during object creation, after setting all properties.
function y_top_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_top_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_bottom_right_Callback(hObject, eventdata, handles)
% hObject    handle to x_bottom_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_bottom_right as text
%        str2double(get(hObject,'String')) returns contents of x_bottom_right as a double


% --- Executes during object creation, after setting all properties.
function x_bottom_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_bottom_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in open_message.
function open_message_Callback(hObject, eventdata, handles)
open('message.txt');


% --- Executes on button press in retrive_message.
function retrive_message_Callback(hObject, eventdata, handles)
open('secret.txt');


% --- Executes on button press in data_hiding.
function data_hiding_Callback(hObject, eventdata, handles)
global im;
target=im;
fid = fopen('message.txt','r');
F = fread(fid);
s = char(F);
fclose(fid);

sz1=size(target);
size1=sz1(1)*sz1(2);
sz2=size(F);
size2=sz2(1);
 
if size2> size1
disp('Text File is too Large');
else
i=1;j=1;k=1;
while k<=size2
        a=F(k);
       
        o1=target(i,j,1);
        o2=target(i,j,2);
        o3=target(i,j,3);
 
        [r1,r2,r3]=hidetext(o1,o2,o3,a);
 
        target(i,j,1)=r1;
        target(i,j,2)=r2;
        target(i,j,3)=r3;
 
if(i<sz1(1))
                i=i+1;
else
                i=1;
                j=j+1;
end
            k=k+1;
end


        width=sz1(1);
txtsz=size2;
        n=size(target);
        target(n(1),n(2),1)=txtsz;% Text Size
        target(n(1),n(2),2)=width;% Image's Width
imwrite(target,'secret.bmp','bmp');

axes(handles.axes2);
imshow(target);
 
end
helpdlg('secret message hided succesfully in secret.jpg');


% --- Executes on button press in data_retrivale.
function data_retrivale_Callback(hObject, eventdata, handles)
[path , user_cance]=imgetfile();
im=imread(path);
axes(handles.axes1);
imshow(im);

target=im;
n=size(target);
txtsz=target(n(1),n(2),1);% Text Size
width=target(n(1),n(2),2);% Image's Width
 
i=1;j=1;k=1;
while k<=txtsz
 
        r1=target(i,j,1);
        r2=target(i,j,2);
        r3=target(i,j,3);
 
        R(k)=findtext(r1,r2,r3);
 
if(i<width)
             i=i+1;
else
            i=1;
            j=j+1;
end
            k=k+1;
end
 
set(handles.the_secret_message,'string', char(R));
fid = fopen('secret.txt','wb');
fwrite(fid,char(R),'char');
fclose(fid);
 
helpdlg('data Retrived succesfully in secret.txt');



function the_secret_message_Callback(hObject, eventdata, handles)
% hObject    handle to the_secret_message (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of the_secret_message as text
%        str2double(get(hObject,'String')) returns contents of the_secret_message as a double


% --- Executes during object creation, after setting all properties.
function the_secret_message_CreateFcn(hObject, eventdata, handles)
% hObject    handle to the_secret_message (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ktimes_Zomming.
function ktimes_Zomming_Callback(hObject, eventdata, handles)
global im;
a = im;
a = double(a)/255;
[r c] = size(a);
s = 3;                %s is k factor
r2 = ((r-1)*s) +1;     
c2 = ((c-1)*s)+1;
ng = zeros(r2 , c2,class(a));

for i =1:s:r2 
    for j=1:s:c2
        ii = ceil(i/s);
        jj = ceil(j/s);
        ng(i,j) =  a ( ii,jj);
    end
end
k=-1;
for i =1:s:r2 
    for j=1:c2-1
        ii = ceil(i/s);
        jj = ceil(j/s);
        if( mod(j,s) ~=1)
            ng(i,j) = ng(i,j-1) + k;
        else
            k = (ng(i,j+s) - ng(i,j))/s;
        end
    end
end
for j=1:c2
    for i =1:1:r2-1 
        ii = ceil(i/s);
        jj = ceil(j/s);
        if( mod(i,s) ~=1)
            ng(i,j) = ng(i-1,j) + k;
        else
            k = (ng(i+s,j) - ng(i,j) )/s;
        end
    end
end
axes(handles.axes2);
imshow(ng)


% --- Executes on button press in brightnessplus.
function brightnessplus_Callback(hObject, eventdata, handles)
axes(handles.axes2);
global im;
img=im+50;
imshow(img);


% --- Executes on button press in brightnessMinus.
function brightnessMinus_Callback(hObject, eventdata, handles)
global im
axes(handles.axes2);
img=im-50;
imshow(img);


% --- Executes on button press in contrastPlus.
function contrastPlus_Callback(hObject, eventdata, handles)
global im;
for i=1:size(im,1)
    for j=1:size(im,2)
        newimg(i,j,1)=im(i,j,1)*3;
        newimg(i,j,2)=im(i,j,2)*3;
        newimg(i,j,3)=im(i,j,3)*3;
    end
end
axes(handles.axes2);
imshow(newimg);


% --- Executes on button press in contrastMinus.
function contrastMinus_Callback(hObject, eventdata, handles)
global im;
newimg=0.5*im;
axes(handles.axes2);
imshow(newimg);


% --- Executes on button press in navigation.
function navigation_Callback(hObject, eventdata, handles)
global im
axes(handles.axes2);
img=255-im;
imshow(img);
