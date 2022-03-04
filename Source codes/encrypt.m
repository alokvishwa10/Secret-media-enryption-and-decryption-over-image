function varargout = encrypt(varargin)
% ENCRYPT MATLAB code for encrypt.fig
%      ENCRYPT, by itself, creates a new ENCRYPT or raises the existing
%      singleton*.
%
%      H = ENCRYPT returns the handle to a new ENCRYPT or the handle to
%      the existing singleton*.
%
%      ENCRYPT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENCRYPT.M with the given input arguments.
%
%      ENCRYPT('Property','Value',...) creates a new ENCRYPT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before encrypt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to encrypt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help encrypt

% Last Modified by GUIDE v2.5 18-Feb-2021 23:47:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @encrypt_OpeningFcn, ...
                   'gui_OutputFcn',  @encrypt_OutputFcn, ...
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


% --- Executes just before encrypt is made visible.
function encrypt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to encrypt (see VARARGIN)

% Choose default command line output for encrypt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes encrypt wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = encrypt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in encrypt.
function encrypt_Callback(hObject, eventdata, handles)
% hObject    handle to encrypt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Convert image to greyscale 
clc;
in=handles.in;
in=rgb2gray(in); 
  
% Resize the image to required size 
in=imresize(in, [512 512]); 
  
% Message to be embedded 
message=get(handles.textbox,'string');
p=length(message);
% Length of the message where each character is 8 bits 
len = length(message) * 8; 
  
% Get all the ASCII values of the characters of the message 
ascii_value = uint8(message); 
  
% Convert the decimal values to binary 
bin_message = transpose(dec2bin(ascii_value, 8)); 
  
% Get all the binary digits in separate row 
bin_message = bin_message(:); 
  
% Length of the binary message 
N = length(bin_message); 
  
% Converting the char array to numeric array 
bin_num_message=str2num(bin_message); 
  
% Initialize output as input 
out = in; 
  
% Get height and width for traversing through the image 
height = size(in, 1); 
width = size(in, 2); 
  
% Counter for number of embedded bits 
embed_counter = 1; 
  
% Traverse through the image 
for i = 1 : height 
    for j = 1 : width 
          
        % If more bits are remaining to embed 
        if(embed_counter <= len) 
              
            % Finding the Least Significant Bit of the current pixel 
            LSB = mod(double(in(i, j)), 2); 
              
            % Find whether the bit is same or needs to change 
            temp = double(xor(LSB, bin_num_message(embed_counter))); 
              
            % Updating the output to input + temp 
            out(i, j) = in(i, j)+temp; 
              
            % Increment the embed counter 
            embed_counter = embed_counter+1; 
        end
          
    end
end
  
% Write both the input and output images to local storage 
% Mention the path to a folder here. 
out(512,512)=p;
filename = 'output_img.xlsx'; 
xlswrite(filename, out); 
imwrite(in, 'originalImage.png'); 
imwrite(out, 'stegoImage.png');
axes(handles.encryptedimage);
imshow(out);
disp('Encryption done')
handles.out=out;
guidata(hObject,handles);



function textbox_Callback(hObject, eventdata, handles)
% hObject    handle to textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox as text
%        str2double(get(hObject,'String')) returns contents of textbox as a double



% --- Executes during object creation, after setting all properties.
function textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chooseimage.
function chooseimage_Callback(hObject, eventdata, handles)
% hObject    handle to chooseimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.*', 'Pick an image');
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    filename=strcat(pathname,filename);
    in=imread(filename);
    axes(handles.coverimage);
    imshow(in);
    handles.in=in;
    guidata(hObject,handles);
end


% --- Executes on button press in decrypt.
function decrypt_Callback(hObject, eventdata, handles)
% hObject    handle to decrypt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc; 
  
% Getting the input image   
filename = 'output_img.xlsx'; 
input_image = xlsread(filename); 
  
% Get height and width for traversing through the image 
height = size(input_image, 1); 
width = size(input_image, 2); 
  
% Number of characters of the hidden text 
chars = input_image(512,512); 
  
% Number of bits in the message 
message_length = chars * 8; 
  
% counter to keep track of number of bits extracted 
counter = 1; 
  
% Traverse through the image 
for i = 1 : height 
    for j = 1 : width 
          
        % If more bits remain to be extracted 
        if (counter <= message_length) 
              
            % Store the LSB of the pixel in extracted_bits 
            extracted_bits(counter, 1) = mod(double(input_image(i, j)), 2); 
              
            % Increment the counter 
            counter = counter + 1; 
        end
    end
end
  
% Powers of 2 to get the ASCII value from binary 
binValues = [ 128 64 32 16 8 4 2 1 ]; 
  
% Get all the bits in 8 columned table 
% Each row is the bits of the character  
% in the hidden text 
binMatrix = reshape(extracted_bits, 8,(message_length/8)); 
  
% Convert the extracted bits to characters 
% by multiplying with powers of 2 
textString = char(binValues*binMatrix);  
  
% Print the hidden text 
disp(textString); 
set(handles.edit2,'string',textString);


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
