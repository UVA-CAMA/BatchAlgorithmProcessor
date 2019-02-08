function varargout = BatchAlgorithmProcessor(varargin)
% BATCHALGORITHMPROCESSOR MATLAB code for BatchAlgorithmProcessor.fig
%      BATCHALGORITHMPROCESSOR, by itself, creates a new BATCHALGORITHMPROCESSOR or raises the existing
%      singleton*.
%
%      H = BATCHALGORITHMPROCESSOR returns the handle to a new BATCHALGORITHMPROCESSOR or the handle to
%      the existing singleton*.
%
%      BATCHALGORITHMPROCESSOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATCHALGORITHMPROCESSOR.M with the given input arguments.
%
%      BATCHALGORITHMPROCESSOR('Property','Value',...) creates a new BATCHALGORITHMPROCESSOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BatchAlgorithmProcessor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BatchAlgorithmProcessor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BatchAlgorithmProcessor

% Last Modified by GUIDE v2.5 01-Oct-2018 10:42:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BatchAlgorithmProcessor_OpeningFcn, ...
                   'gui_OutputFcn',  @BatchAlgorithmProcessor_OutputFcn, ...
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


% --- Executes just before BatchAlgorithmProcessor is made visible.
function BatchAlgorithmProcessor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BatchAlgorithmProcessor (see VARARGIN)

% Choose default command line output for BatchAlgorithmProcessor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BatchAlgorithmProcessor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BatchAlgorithmProcessor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in RunButton.
function RunButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if iscell(handles.filename) % handle the case where only one file is selected
    nfiles = length(handles.filename);
else
    nfiles = 1;
end
handles.allpathnames = handles.pathname;
handles.allfilenames = handles.filename;
if ~isdeployed
    addpath('X:\Amanda\NICUHDF5Viewer')
end
for f=1:nfiles
    if iscell(handles.allfilenames)  % handle the case where only one file is selected
        handles.filename = handles.allfilenames{f};
    else
        handles.filename = handles.allfilenames;
    end
    if iscell(handles.allpathnames)
        handles.pathname = handles.allpathnames{f};
    else
        handles.pathname = handles.allpathnames;
    end
    set(handles.PercentageCompleteTextBox,'string',['Loading file ' num2str(f) ' of ' num2str(nfiles)])
    waitfor(handles.PercentageCompleteTextBox,'string',['Loading file ' num2str(f) ' of ' num2str(nfiles)]);
%     handles = loaddata(hObject, eventdata, handles);
    set(handles.PercentageCompleteTextBox,'string',['Running file ' num2str(f) ' of ' num2str(nfiles)])
    waitfor(handles.PercentageCompleteTextBox,'string',['Running file ' num2str(f) ' of ' num2str(nfiles)]);
%     run_all_tagging_algs(fullfile(handles.pathname, handles.filename),handles.vdata,handles.vname,handles.vt,handles.wdata,handles.wname,handles.wt,handles.algorithmsselected);
    run_all_tagging_algs(fullfile(handles.pathname, handles.filename),[],[],[],[],[],[],handles.algorithmsselected);
end
set(handles.PercentageCompleteTextBox,'string',['Algorithms completed for ' num2str(nfiles) ' of ' num2str(nfiles) ' files.']);
handles.filename = handles.allfilenames;
handles.pathname = handles.allpathnames;


% --- Executes on selection change in SelectedFilesListbox.
function SelectedFilesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to SelectedFilesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SelectedFilesListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectedFilesListbox


% --- Executes during object creation, after setting all properties.
function SelectedFilesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectedFilesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ChooseDirectoryButton.
function ChooseDirectoryButton_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseDirectoryButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dirname = uigetdir();
files = dir([dirname '\**\*.hdf5']);
handles.filename = cell(length(files),1);
handles.pathname = cell(length(files),1);
for f=1:length(files)
    handles.filename{f} = files(f).name;
    handles.pathname{f} = files(f).folder;
end
if isequal(handles.filename,0)
   set(handles.SelectedFilesListbox,'string','No file selected');
else
   set(handles.SelectedFilesListbox,'string',fullfile(handles.pathname, handles.filename));
end
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in ChooseFilesButton.
function ChooseFilesButton_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseFilesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.filename, handles.pathname] = uigetfile({'*.hdf5'}, 'Select hdf5 file(s)','MultiSelect','on');
if isequal(handles.filename,0)
   set(handles.SelectedFilesListbox,'string','No file selected');
else
   set(handles.SelectedFilesListbox,'string',fullfile(handles.pathname, handles.filename));
end
% Update handles structure
guidata(hObject, handles);

% This is where the data is actually loaded in - the money code!!
function handles = loaddata(hObject, eventdata, handles)
    % Load data from HDF5 File
    corrupt = 0;
    try
        set(handles.PercentageCompleteTextBox,'string','Please wait. Loading Vital Signs...');
        waitfor(handles.PercentageCompleteTextBox,'string','Please wait. Loading Vital Signs...');
        [handles.vdata,handles.vname,handles.vt,~]=gethdf5vital(fullfile(handles.pathname, handles.filename));
        
        try
            handles.timezone = h5readatt(fullfile(handles.pathname, handles.filename),'/','Collection Timezone');
            handles.timezone = handles.timezone{1}; % switch cell array to string
        catch
            handles.timezone = '';
            set(handles.PercentageCompleteTextBox,'string','Time zone not specified. Using ET.');
        end
        handles.vdata = scaledata(hObject, eventdata, handles, handles.vname, handles.vdata);
    catch
        set(handles.PercentageCompleteTextBox,'string','Vitals could not load.');
        corrupt = 1;
    end
    try
        set(handles.PercentageCompleteTextBox,'string','Please wait. Loading Waveforms...');
        waitfor(handles.PercentageCompleteTextBox,'string','Please wait. Loading Waveforms...');
        [handles.wdata,handles.wname,handles.wt,~]=gethdf5wave(fullfile(handles.pathname, handles.filename));
        
        try
            handles.timezone = h5readatt(fullfile(handles.pathname, handles.filename),'/','Collection Timezone');
            handles.timezone = handles.timezone{1}; % switch cell array to string
        catch
            handles.timezone = '';
            set(handles.PercentageCompleteTextBox,'string','Time zone not specified. Using ET.');
        end
        handles.wdata = scaledata(hObject, eventdata, handles, handles.wname, handles.wdata);
    catch
        handles.wdata = [];
        handles.wname = [];
        handles.wt = [];
        set(handles.PercentageCompleteTextBox,'string','Waveforms could not load.');
        corrupt = 0;
    end


    if corrupt == 1
        set(handles.PercentageCompleteTextBox,'string','WARNING: File may be corrupt!!!');
    elseif corrupt == 2
        set(handles.PercentageCompleteTextBox,'string','URGENT: Delete old result file before continuing');
    else
        set(handles.PercentageCompleteTextBox,'string',[fullfile(handles.filename) ' Loaded. Processing Data.']);
    end
    % Update handles structure
    guidata(hObject, handles);


% --- Executes on selection change in SelectAlgorithmsListbox.
function SelectAlgorithmsListbox_Callback(hObject, eventdata, handles)
% hObject    handle to SelectAlgorithmsListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SelectAlgorithmsListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectAlgorithmsListbox
indicesselected = hObject.Value;
binaryselected = zeros(1,10);
binaryselected(indicesselected) = 1;
handles.algorithmsselected = binaryselected;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function SelectAlgorithmsListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectAlgorithmsListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.algnames = {...
        'QRS Detection: ECG I';...
        'QRS Detection: ECG II';...
        'QRS Detection: ECG III';...
        'CU Artifact';...
        'WUSTL Artifact';...
        'Brady Detection';...
        'Desat Detection';...
        'Apnea Detection with ECG Lead I';...
        'Apnea Detection with ECG Lead II';...
        'Apnea Detection with ECG Lead III';...
        'Apnea Detection with No ECG Lead';...
        'Periodic Breathing';...
        'Brady Detection Pete';...
        'Desat Detection Pete';...
        'Data Available: Pulse';...
        'Data Available: HR';...
        'Data Available: SPO2_pct';...
        'Data Available: Resp';...
        'Data Available: ECG I';...
        'Data Available: ECG II';...
        'Data Available: ECG III'};
set(hObject,'string',handles.algnames);
% Update handles structure
guidata(hObject, handles);

function data = scaledata(hObject, eventdata, handles, namesofinterest, data)
% hObject    handle to RemoveTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scalematrix = zeros(length(namesofinterest),1);
for n=1:length(namesofinterest)
    try
        scalematrix(n) = double(h5readatt(fullfile(handles.pathname, handles.filename),[namesofinterest{n} '/data'],'Scale'));
    catch
        scalematrix(n) = 0;
    end
    % For layout version 3, scale is simply a multiplicative factor for the original value. To get the real value, you divide by scale. For layout version 4.0, a real value of 1.2 is stored as 12 with a scale of 1, where scale is stored as the power of 10, so to convert from 12 back to 1.2, you need to divide by 10^scale. Later in this code, when we are actually plotting the data, we divide by scale
    try
        handles.layoutversion = h5readatt(fullfile(handles.pathname, handles.filename),'/','Layout Version');
    catch
        handles.layoutversion = "Doug's Layout";
    end
    if ischar(handles.layoutversion)
        majorversion = str2num(handles.layoutversion(1));
        if majorversion~=3
            scalematrix(n) = 10^scalematrix(n);
        end
    else
        if str2double(handles.layoutversion{1}(1)) ~= 3 
            scalematrix(n) = 10^scalematrix(n);
        end
    end
    data(:,n) = data(:,n)/scalematrix(n);
end
