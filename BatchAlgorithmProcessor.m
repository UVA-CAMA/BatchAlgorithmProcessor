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
    set(handles.PercentageCompleteTextBox,'string',['Running file ' num2str(f) ' of ' num2str(nfiles)])
    waitfor(handles.PercentageCompleteTextBox,'string',['Running file ' num2str(f) ' of ' num2str(nfiles)]);
    run_all_tagging_algs(fullfile(handles.pathname, handles.filename),[],handles.algorithmsselected);
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


% --- Executes on selection change in SelectAlgorithmsListbox.
function SelectAlgorithmsListbox_Callback(hObject, eventdata, handles)
% hObject    handle to SelectAlgorithmsListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SelectAlgorithmsListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectAlgorithmsListbox
indicesselected = hObject.Value;
binaryselected = zeros(1,28);
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
if ~isdeployed
    addpath('X:\Amanda\NICUHDF5Viewer')
end
[masteralgmask,algmask_current] = algmask;
handles.algnames = masteralgmask(algmask_current,:);
% handles.algnames = {...
%         'QRS Detection: ECG I',1;...
%         'QRS Detection: ECG II',1;...
%         'QRS Detection: ECG III',1;...
%         'CU Artifact',1;...
%         'WUSTL Artifact',1;...
%         'Brady Detection',1;...
%         'Desat Detection',1;...
%         'Apnea Detection with ECG Lead I',1;...
%         'Apnea Detection with ECG Lead II',1;...
%         'Apnea Detection with ECG Lead III',1;...
%         'Apnea Detection with No ECG Lead',1;...
%         'Apnea Detection',1;...
%         'Periodic Breathing with ECG Lead I',1;...
%         'Periodic Breathing with ECG Lead II',1;...
%         'Periodic Breathing with ECG Lead III',1;...
%         'Periodic Breathing with No ECG Lead',1;...
%         'Periodic Breathing',1;...
%         'Brady Detection Pete',1;...
%         'Desat Detection Pete',1;...
%         'Brady Desat',1;...
%         'Brady Desat Pete',1;...
%         'ABD Pete No ECG',2;...
%         'ABD Pete',1;...
%         'Save HR in Results',1;...
%         'Data Available: Pulse',1;...
%         'Data Available: HR',1;...
%         'Data Available: SPO2_pct',1;...
%         'Data Available: Resp',1;...
%         'Data Available: ECG I',1;...
%         'Data Available: ECG II',1;...
%         'Data Available: ECG III',1};
    
set(hObject,'string',handles.algnames(:,1));
% Update handles structure
guidata(hObject, handles);
