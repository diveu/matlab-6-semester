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
        exampleNumber = get(handles.ExamplesListbox, 'Value');
        exampleNumberStr = num2str(exampleNumber);
        fileName = ['Examples/Example_' exampleNumberStr '.mat'];
        
        global solve inputTaskTableData conditionsTableData segBegin;
        global segEnd stepsCount stepSize accuracyExternal accuracyInternal solvingMethodForExternalTask solvingMethodForInternalTask timeOfT initialVectorTableData;
        global mainHandles;
        
        load(fileName, 'solve', 'stepsCount', 'inputTaskTableData', 'conditionsTableData', 'segBegin', 'segEnd', 'stepsCount', 'accuracyExternal', 'accuracyInternal', 'solvingMethodForExternalTask', 'solvingMethodForInternalTask','timeOfT', 'initialVectorTableData', 'buttons');
        
        set(mainHandles.InputTaskTable, 'Data', inputTaskTableData);
        set(mainHandles.ConditionsTable, 'Data', conditionsTableData);
        set(mainHandles.SegBegin, 'String', segBegin);
        set(mainHandles.SegEnd, 'String', segEnd);
        set(mainHandles.StepsCount, 'String', stepsCount);
        set(mainHandles.StepSize, 'String', stepSize);
        set(mainHandles.AccuracyExternal, 'String', accuracyExternal);
        set(mainHandles.AccuracyInternal, 'String', accuracyInternal);
        set(mainHandles.SolvingMethodForExternalTaskPopupmenu, 'Value', solvingMethodForExternalTask);
        set(mainHandles.SolvingMethodForInternalTaskPopupmenu, 'Value', solvingMethodForInternalTask);
        set(mainHandles.TimeOfT, 'String', timeOfT);
        set(mainHandles.InitialVectorTable, 'Data', initialVectorTableData);
        set(mainHandles.SolveTask, 'Enable', char(buttons(1, 1)));
        set(mainHandles.DeleteSolve, 'Enable', char(buttons(2, 1)));
        set(mainHandles.TaskResults, 'Enable', char(buttons(3, 1)));
        close;
%     catch
%         somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
%     end

function CloseExampleWindow_Callback(hObject, eventdata, handles)
    close;
