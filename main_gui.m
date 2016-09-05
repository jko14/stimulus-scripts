function varargout = main_gui(varargin)
% MAIN_GUI MATLAB code for main_gui.fig
%      MAIN_GUI, by itself, creates a new MAIN_GUI or raises the existing
%      singleton*.
%
%      H = MAIN_GUI returns the handle to a new MAIN_GUI or the handle to
%      the existing singleton*.
%
%      MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI.M with the given input arguments.
%
%      MAIN_GUI('Property','Value',...) creates a new MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_gui

% Last Modified by GUIDE v2.5 21-Mar-2016 15:36:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @main_gui_OutputFcn, ...
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


% --- Executes just before main_gui is made visible.
function main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_gui (see VARARGIN)

% 'show_interval' must be placed first, but others may be reordered
% If reordered, the indices in the 'inputdlg' functions below should be
% changed as well
handles.short_names = {'show_interval', ...
                       'fff', ...
                       'fff_sto', ...
                       'rf', ...
                       'rf_sto', ...
                       'step_cont', ...
                       'moving_line', ...
                       'moving_edge', ...
                       'moving_sine', ...
                       'moving_square'};
handles.full_names = {'show_interval', ...
                      'stimulus_script_fff', ...
                      'stimulus_script_fff_sto', ...
                      'stimulus_script_rf', ...
                      'stimulus_script_rf_sto', ...
                      'stimulus_script_step_cont', ...
                      'stimulus_script_moving_line', ...
                      'stimulus_script_moving_edge', ...
                      'stimulus_script_moving_sine', ...
                      'stimulus_script_moving_square'};
handles.prompts = {{'dark interval (s)', 'bright interval (s)', 'repetitions', 'luminence', 'contrast'}, ...
                   {'duration (s)', 'time constant (s)', 'repetitions', 'luminence', 'contrast'}, ...
                   {'dark interval (s)', 'bright interval (s)', ...
                    'rf darker than rect (0/1)', ...
                    'width of a block (degrees)', 'horizontal step (degrees)', ...
                    'height of a block (degrees)', 'vertical step (degrees)', ...
                    'RFs shown in random order (0/1)', 'luminence', 'contrast'}, ...
                   {'duration (s)', 'view angle of a block (degrees)', 'time constant', 'luminence', 'contrast'}, ...
                   {'dark interval (s)', 'bright interval (s)', 'repetitions', 'luminence', 'array of contrast values'}, ...
                   {'width of the line (degrees)', 'moving direction of the line', ...
                    'moving speed of the line (degrees/s)', 'line darker than rect (0/1)', ...
                    'luminence', 'contrast'}, ...
                   {'moving direction of the edge', ...
                    'moving speed of the edge (degrees/s)', 'edge darker than rect (0/1)', ...
                    'luminence', 'contrast'}, ...
                   {'duration (s)', 'moving direction of the wave', ...
                    'period of the wave (degrees)', 'moving speed of the wave (degrees/s)', ...
                    'luminence', 'contrast'}, ...
                   {'duration (s)', 'moving direction of the wave', ...
                    'period of the wave (degrees)', 'moving speed of the wave (degrees/s)', ...
                    'luminence', 'contrast'}};
handles.inputdlgs = {@fff_inputdlg, @fff_sto_inputdlg, @rf_inputdlg, @rf_sto_inputdlg, @step_cont_inputdlg, ...
                     @moving_line_inputdlg, @moving_edge_inputdlg, @moving_sine_inputdlg, @moving_square_inputdlg};
handles.function_handles = cell(size(handles.full_names));
for i = 1:length(handles.full_names)
    handles.function_handles{i} = str2func(handles.full_names{i});
end

% Each stimulus will be stored as an entry in this struct array
handles.stimuli = struct('index', {}, 'parameters', {});

% Choose default command line output for main_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in stimulus_list.
function stimulus_list_Callback(hObject, eventdata, handles)
% hObject    handle to stimulus_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stimulus_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stimulus_list
cur = hObject.Value;
if isempty(cur)
    handles.description.String = '';
else
    index = handles.stimuli(cur).index;
    if index == 1 % show_interval
        handles.description.String = '';
    else
        parameters = handles.stimuli(cur).parameters';
        for i = 1: length(parameters)
            parameters{i} = mat2str(parameters{i});
        end
        prompts = handles.prompts{index - 1};
        handles.description.String = strcat(prompts, {': '}, parameters);
    end
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function stimulus_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulus_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function answer = fff_inputdlg(handles, default)
if ~exist('default', 'var')
    default = {1, 6, 2, 0.5, 1};
end
for i = 1: length(default)
    default{i} = mat2str(default{i});
end
answer = inputdlg(handles.prompts{1}, '', 1, default);
if ~isempty(answer)
    for i = 1: length(answer)
        answer{i} = str2num(answer{i});
        if ~isscalar(answer{i}) || i == 3 && answer{i} ~= floor(answer{i})
            msgbox(sprintf('No.%d parameter invalid.', i));
            answer = {};
            return;
        end
    end
end


function answer = fff_sto_inputdlg(handles, default)
if ~exist('default', 'var')
    default = {5, 0.01, 2, 0.5, 0.35};
end
for i = 1: length(default)
    default{i} = mat2str(default{i});
end
answer = inputdlg(handles.prompts{2}, '', 1, default);
if ~isempty(answer)
    for i = 1: length(answer)
        answer{i} = str2num(answer{i});
        if ~isscalar(answer{i}) || i == 3 && answer{i} ~= floor(answer{i})
            msgbox(sprintf('No.%d parameter invalid.', i));
            answer = {};
            return;
        end
    end
end


function answer = rf_inputdlg(handles, default)
if ~exist('default', 'var')
    default = {2, 0.5, 0, 0, 0, 10, 5, 0, 0.5, 0.5};
end
for i = 1: length(default)
    default{i} = mat2str(default{i});
end
answer = inputdlg(handles.prompts{3}, '', 1, default);
if ~isempty(answer)
    for i = 1: length(answer)
        answer{i} = str2num(answer{i});
        if i == 3 || i == 8
            answer{i} = logical(answer{i});
        end
        if ~isscalar(answer{i})
            msgbox(sprintf('No.%d parameter invalid.', i));
            answer = {};
            return;
        end
    end
end


function answer = rf_sto_inputdlg(handles, default)
if ~exist('default', 'var')
    default = {10, 10, 0.05, 0.5, 0.35};
end
for i = 1: length(default)
    default{i} = mat2str(default{i});
end
answer = inputdlg(handles.prompts{4}, '', 1, default);
if ~isempty(answer)
    for i = 1: length(answer)
        answer{i} = str2num(answer{i});
        if ~isscalar(answer{i})
            msgbox(sprintf('No.%d parameter invalid.', i));
            answer = {};
            return;
        end
    end
end


function answer = step_cont_inputdlg(handles, default)
if ~exist('default', 'var')
    default = {1, 1, 2, 0.5, 0.1:0.1:0.5};
end
for i = 1: length(default)
    default{i} = mat2str(default{i});
end
answer = inputdlg(handles.prompts{5}, '', 1, default);
if ~isempty(answer)
    for i = 1: length(answer)
        answer{i} = str2num(answer{i});
        if i == 5
            answer{i} = answer{i}(:)';
            if ~isrow(answer{i})
                msgbox(sprintf('No.%d parameter invalid.', i));
                answer = {};
                break;
            end
        elseif ~isscalar(answer{i}) || i == 3 && answer{i} ~= floor(answer{i})
            msgbox(sprintf('No.%d parameter invalid.', i));
            answer = {};
            return;
        end
    end
end


function answer = moving_line_inputdlg(handles, default)
if ~exist('default', 'var')
    default = {5, 30, 15, 0, 0.5, 0.5};
end
for i = 1: length(default)
    default{i} = mat2str(default{i});
end
answer = inputdlg(handles.prompts{6}, '', 1, default);
if ~isempty(answer)
    for i = 1: length(answer)
        answer{i} = str2num(answer{i});
        if i == 4
            answer{i} = logical(answer{i});
        end
        if ~isscalar(answer{i})
            msgbox(sprintf('No.%d parameter invalid.', i));
            answer = {};
            return;
        end
    end
end


function answer = moving_edge_inputdlg(handles, default)
if ~exist('default', 'var')
    default = {60, 15, 1, 0.5, 0.5};
end
for i = 1: length(default)
    default{i} = mat2str(default{i});
end
answer = inputdlg(handles.prompts{7}, '', 1, default);
if ~isempty(answer)
    for i = 1: length(answer)
        answer{i} = str2num(answer{i});
        if i == 3
            answer{i} = logical(answer{i});
        end
        if ~isscalar(answer{i})
            msgbox(sprintf('No.%d parameter invalid.', i));
            answer = {};
            return;
        end
    end
end


function answer = moving_sine_inputdlg(handles, default)
if ~exist('default', 'var')
    default = {5, 30, 10, 10, 0.5, 0.3};
end
for i = 1: length(default)
    default{i} = mat2str(default{i});
end
answer = inputdlg(handles.prompts{8}, '', 1, default);
if ~isempty(answer)
    for i = 1: length(answer)
        answer{i} = str2num(answer{i});
        if ~isscalar(answer{i})
            msgbox(sprintf('No.%d parameter invalid.', i));
            answer = {};
            return;
        end
    end
end


function answer = moving_square_inputdlg(handles, default)
if ~exist('default', 'var')
    default = {5, 30, 10, 10, 0.5, 0.3};
end
for i = 1: length(default)
    default{i} = mat2str(default{i});
end
answer = inputdlg(handles.prompts{9}, '', 1, default);
if ~isempty(answer)
    for i = 1: length(answer)
        answer{i} = str2num(answer{i});
        if ~isscalar(answer{i})
            msgbox(sprintf('No.%d parameter invalid.', i));
            answer = {};
            return;
        end
    end
end


function set_text_for_stimulus_list(hObject)
handles = guidata(hObject);
indices = [handles.stimuli.index];
handles.stimulus_list.String = handles.short_names(indices);
guidata(hObject, handles);


% --- Executes on button press in add_button.
function add_button_Callback(hObject, eventdata, handles)
% hObject    handle to add_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cur = handles.stimulus_list.Value;
if isempty(cur)
    cur = length(handles.stimuli);
end
has_new = false;
[selection, ok] = listdlg('PromptString', 'Select a stimulus:', 'SelectionMode', 'single', ...
    'ListString', handles.short_names);
if ok
    switch selection
        case 1 % show_interval
            has_new = true;
            new = struct('index', 1, 'parameters', {{}});
        otherwise
            answer = handles.inputdlgs{selection - 1}(handles);
            if ~isempty(answer)
                has_new = true;
                new = struct('index', selection, 'parameters', {answer});
            end
    end
    if has_new
        handles.stimuli = [handles.stimuli(1:cur); new; handles.stimuli(cur + 1:end)];
        handles.stimulus_list.Value = cur + 1;
        guidata(hObject, handles);
        set_text_for_stimulus_list(hObject);
        stimulus_list_Callback(handles.stimulus_list, eventdata, handles);
    end
end


% --- Executes on button press in delete_button.
function delete_button_Callback(hObject, eventdata, handles)
% hObject    handle to delete_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cur = handles.stimulus_list.Value;
% As long as the listbox shows, 'cur' is valid
if ~isempty(cur)
    handles.stimuli = [handles.stimuli(1:cur - 1); handles.stimuli(cur + 1:end)];
    n = length(handles.stimuli);
    if n == 0
        handles.stimulus_list.Value = [];
    else
        handles.stimulus_list.Value = min(cur, n);
    end
    guidata(hObject, handles);
    set_text_for_stimulus_list(hObject);
    stimulus_list_Callback(handles.stimulus_list, eventdata, handles);
end


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select Experiment File');
if FileName ~= 0
    try
        stimuli = load([PathName, FileName]);
        stimuli = stimuli.stimuli;
        n = length(stimuli);
        handles.stimuli = stimuli;
        if n == 0
            handles.stimulus_list.Value = [];
        else
            handles.stimulus_list.Value = 1;
        end
        guidata(hObject, handles);
        set_text_for_stimulus_list(hObject);
        stimulus_list_Callback(handles.stimulus_list, eventdata, handles);
    catch ME
        msgbox('Invalid experiment file.');
    end
end


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stimuli = handles.stimuli;
uisave('stimuli', ['exp_', datestr(now, 'yyyymmddHHMMSS'), '.mat']);


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName] = uiputfile(['data_', datestr(now, 'yyyymmddHHMMSS'), '.mat'], 'Save Experiment Data As');
if FileName ~= 0
    try
        Q = init;
        HideCursor;
        stimuli = handles.stimuli;
        for i = 1: length(stimuli)
            handles.function_handles{stimuli(i).index}(Q, stimuli(i).parameters{:});
        end
        sca;
        Q.save([PathName, FileName]);
    catch ME
        sca;
        rethrow(ME);
    end
end


% --- Executes on button press in up_button.
function up_button_Callback(hObject, eventdata, handles)
% hObject    handle to up_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cur = handles.stimulus_list.Value;
if ~isempty(cur) && cur >= 2
    handles.stimuli = [handles.stimuli(1:cur - 2); ...
                       handles.stimuli(cur); ...
                       handles.stimuli(cur - 1); ...
                       handles.stimuli(cur + 1:end)];
    handles.stimulus_list.Value = cur - 1;
    guidata(hObject, handles);
    set_text_for_stimulus_list(hObject);
end


% --- Executes on button press in down_button.
function down_button_Callback(hObject, eventdata, handles)
% hObject    handle to down_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cur = handles.stimulus_list.Value;
if ~isempty(cur) && cur < length(handles.stimuli)
    handles.stimuli = [handles.stimuli(1:cur - 1); ...
                       handles.stimuli(cur + 1); ...
                       handles.stimuli(cur); ...
                       handles.stimuli(cur + 2:end)];
    handles.stimulus_list.Value = cur + 1;
    guidata(hObject, handles);
    set_text_for_stimulus_list(hObject);
end


% --- Executes on button press in edit_button.
function edit_button_Callback(hObject, eventdata, handles)
% hObject    handle to edit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cur = handles.stimulus_list.Value;
if ~isempty(cur)
    index = handles.stimuli(cur).index;
    parameters = handles.stimuli(cur).parameters;
    switch index
        case 1 % show_interval
            return; % Nothing to edit
        otherwise
            answer = handles.inputdlgs{index - 1}(handles, parameters);
            if ~isempty(answer)
                handles.stimuli(cur).parameters = answer;
            end
    end
    guidata(hObject, handles);
    set_text_for_stimulus_list(hObject);
    stimulus_list_Callback(handles.stimulus_list, eventdata, handles);
end
