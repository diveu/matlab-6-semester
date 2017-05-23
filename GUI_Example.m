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

function ExamplesListbox_CreateFcn(hObject, eventdata, handles)

function OpenExample_Callback(hObject, eventdata, handles)
%     try
        exampleNumber = get(handles.ExamplesListbox, 'Value')
        exampleNumberStr = num2str(exampleNumber)
        fileName = ['Examples/Example_' exampleNumberStr '.mat']
        
        global solve inputTaskTableData conditionsTableData segBegin;
        global segEnd stepsCount accuracyExternal accuracyInternal solvingMethod timeOfT initialVectorTable;
        global mainHandles;
        
        load(fileName, 'solve', 'inputTaskTableData', 'conditionsTableData', 'segBegin', 'segEnd', 'stepsCount', 'accuracyExternal', 'accuracyInternal', 'solvingMethod', 'timeOfT', 'initialVectorTableData', 'buttons');
        
        set(mainHandles.Save, 'Checked', 'on');
        set(mainHandles.InputTaskTable, 'Data', inputTaskTableData);
        set(mainHandles.ConditionsTable, 'Data', conditionsTableData);
        set(mainHandles.SegBegin, 'String', segBegin);
        set(mainHandles.SegEnd, 'String', segEnd);
        set(mainHandles.StepsCount, 'String', stepsCount);
        set(mainHandles.AccuracyExternal, 'String', accuracyExternal);
        set(mainHandles.AccuracyInternal, 'String', accuracyInternal);
        set(mainHandles.SolvingMethodsPopupmenu, 'Value', solvingMethod);
        set(mainHandles.TimeOfT, 'String', timeOfT);
        set(mainHandles.InitialVectorTable, 'Data', initialVectorTableData);
        set(mainHandles.SolveTask, 'Enable', 'on');
        set(mainHandles.DeleteSolve, 'Enable', 'on');
        set(mainHandles.TaskResults, 'Enable', 'on');
        close;
%     catch
%          somethingWrong = errordlg('Произошла ошибка', 'Ошибка');
%     end

function CloseExampleWindow_Callback(hObject, eventdata, handles)
    global closeExamplesWindowViaCloseButton;
    closeExamplesWindowViaCloseButton = true;
    close;
