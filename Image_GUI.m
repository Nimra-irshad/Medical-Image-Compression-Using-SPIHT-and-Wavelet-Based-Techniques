function varargout = Image_GUI(varargin)
% IMAGE_GUI MATLAB code for Image_GUI.fig
%      IMAGE_GUI, by itself, creates a new IMAGE_GUI or raises the existing
%      singleton*.
%
%      H = IMAGE_GUI returns the handle to a new IMAGE_GUI or the handle to
%      the existing singleton*.
%
%      IMAGE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_GUI.M with the given input arguments.
%
%      IMAGE_GUI('Property','Value',...) creates a new IMAGE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Image_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Image_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Image_GUI

% Last Modified by GUIDE v2.5 03-Nov-2016 12:11:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Image_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Image_GUI_OutputFcn, ...
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


% --- Executes just before Image_GUI is made visible.
function Image_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Image_GUI (see VARARGIN)

% Choose default command line output for Image_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Image_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Image_GUI_OutputFcn(hObject, eventdata, handles) 
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
global fileName path
[fileName, path] = uigetfile({'*.jpg';'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.gif'}, 'File Selector');


% --- Executes on selection change in popupChoice.
function popupChoice_Callback(hObject, eventdata, handles)
% hObject    handle to popupChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupChoice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupChoice
global popupChoice
contents = cellstr(get(hObject, 'String'));
popupChoice = contents(get(hObject, 'Value'));

% --- Executes during object creation, after setting all properties.
function popupChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in popupWavelet.
function popupWavelet_Callback(hObject, eventdata, handles)
% hObject    handle to popupWavelet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupWavelet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupWavelet
global popupWavelet
contents_wave = cellstr(get(hObject, 'String'));
popupWavelet = contents_wave(get(hObject, 'Value'));

% --- Executes during object creation, after setting all properties.
function popupWavelet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupWavelet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compression.
function compression_Callback(hObject, eventdata, handles)
% hObject    handle to compression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fileName path image MSE PSNR CR RG wavelet popupWavelet popupChoice

a2 = imread(strcat(path,fileName));
[m, n, dim] = size(a2);
if dim == 3;
    aa = rgb2gray(a2);
else if dim == 1;
        aa = a2;
    end
end
image = imresize(aa, [512, 512]);
gray_image = im2double(image);
axes(handles.axes1);
imhist(gray_image);
title('Histogram');

ts1 = tic
if (strcmp(popupChoice, 'Please Choose:'))
    RG = [];
    axes(handles.axes2);
    imshow(RG);
    title('No Segmentation Applied');
else if (strcmp(popupChoice, 'Region Growing'))
        x = 198; 
        y = 359; 
        reg_maxdist = 0.2;
        J = regiongrowing(gray_image,x,y,reg_maxdist);
        RG = gray_image+J;
        axes(handles.axes2);
        imshow(RG);
        title('Region Growing Segmentation');
    end
end
t1 = toc(ts1)
assignin('base','RG',RG);


ts2 = tic
if (strcmp(popupWavelet, 'Please Choose:'))
    wavelet = [];
    axes(handles.axes3);
    imshow(wavelet);
    title('No Output');
else if (strcmp(popupWavelet, '5/3 Wavelet Lifting'))
        n1level = 1;
        Y = wavelift(RG, n1level, 'spl53'); % Wavelet Compression Technique - lifting 5/3 wavelet
        wavelet = Y;
        axes(handles.axes3);
        imshow(wavelet);
        title('5/3 Wavelet Lifting');
    else if (strcmp(popupWavelet, '9/7 Wavelet Lifting')) 
            nlevel = 1;
            YY = wavelift(RG, nlevel); % Wavelet Compression Technique - lifting 9/7 wavelet
            wavelet = YY;
            axes(handles.axes3);
            imshow(wavelet);
            title('9/7 Wavelet Lifting');
        end
    end
end
t2 = toc(ts2)
assignin('base','wavelet',wavelet);

ts3 = tic
Orig_I = double(image);
rate = 1;
OrigSize = size(Orig_I, 1);
max_bits = floor(rate * OrigSize^2);
OutSize = OrigSize;
image_spiht = zeros(size(Orig_I));
[nRow, nColumn] = size(Orig_I);


% ('-----------   Wavelet Decomposition   ------------\n');
n = size(Orig_I,1);
n_log = log2(n); 
level = n_log;

% wavelet decomposition level can be defined by users manually.
type = 'bior4.4';
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(type);
[I_W, S] = func_DWT(Orig_I, level, Lo_D, Hi_D);

% ('-----------   Encoding   ----------------\n');
img_enc = func_SPIHT_Enc(I_W, max_bits, nRow*nColumn, level);   

% ('-----------   Decoding   ----------------\n');
img_dec = func_SPIHT_Dec(img_enc);

% ('-----------   Wavelet Reconstruction   ----------------\n')
img_spiht = func_InvDWT(img_dec, S, Lo_R, Hi_R, level);


S_name = fileName(1:end-4);
outfilename = strcat(S_name,'-','reconstruct.jpg');
imwrite(img_spiht, gray(256), outfilename, 'jpg');
t3 = toc(ts3)
% t_total = t1 + t2 + t3;
compression = outfilename;

axes(handles.axes4);
imshow(outfilename);
title('Reconstructed Image');

% ('-----------  MSE and PSNR Analysis  --------------\n')
Q = 255;
MSE = immse(img_spiht, Orig_I);
PSNR = (10*log10((Q^2)/MSE));


% ('-----------  Compression Ratio  --------------\n')
bitbudget = 1000000;
[encoded, bits] = cSPIHT(double(wavelet), 1, bitbudget);
[r c]=size(image);
input_size=r*c*8;
CR = input_size/bits;

assignin('base','compression',compression);
set(handles.mse, 'String', MSE);
set(handles.psnr, 'String', PSNR);
set(handles.cr, 'String', CR);
set(handles.timer1, 'String', t1);
set(handles.timer2, 'String', t3);


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MSE PSNR CR
PSNR = 0;
MSE = 0;
CR = 0;
CR = num2str(CR);
PSNR = num2str(PSNR);
t1 = 0;
t3 = 0;
MSE = num2str(MSE);
set(handles.mse, 'String', MSE);
set(handles.psnr, 'String', PSNR);
set(handles.cr, 'String', CR);
set(handles.timer1, 'String', t1);
set(handles.timer2, 'String', t3);

a=ones(256,256);
axes(handles.axes1);
imshow(a);
axes(handles.axes2);
imshow(a);
axes(handles.axes3);
imshow(a);
axes(handles.axes4);
imshow(a);


