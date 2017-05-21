function varargout = GUI_Example(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Example_OpeningFcn, ...
                       'gui_OutputFcn',  @Example_OutputFcn, ...
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

function Example_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);

function varargout = Example_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

function ExamplesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to GUI_ExamplesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns GUI_ExamplesListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from GUI_ExamplesListbox

function ExamplesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GUI_ExamplesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OpenGUI_Example.
function OpenExample_Callback(hObject, eventdata, handles)
% hObject    handle to OpenGUI_Example (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function CloseExampleWindow_Callback(hObject, eventdata, handles)
    close;