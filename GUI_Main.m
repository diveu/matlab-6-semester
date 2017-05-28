%Service

function varargout = GUI_Main(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Main_OpeningFcn, ...
                       'gui_OutputFcn',  @Main_OutputFcn, ...
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

function Main_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);
    
    global solve inputTaskTableCheck initialVectorTableCheck conditionsTableDataCheck;
    inputTaskTableCheck = false;
    initialVectorTableCheck = false;
    conditionsTableData = false;
    solve = zeros(0);
    
    initInputTaskTable = {'<html>x''<sub>1</sub></html>', ''};
    initConditionsTable = {};
    initInitialVectorTable = {};
    
    set(handles.InputTaskTable , 'Data', initInputTaskTable);
    set(handles.ConditionsTable , 'Data', initConditionsTable);
    set(handles.InitialVectorTable, 'Data', initInitialVectorTable, 'ColumnWidth', 'auto', 'ColumnEditable', true);
    set(handles.SolveTask, 'Enable', 'off');
    set(handles.DeleteSolve, 'Enable', 'off');
    set(handles.TaskResults, 'Enable', 'off');
    set(handles.Save, 'Checked', 'on');

function varargout = Main_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;
   
%Service     
    
    
%Callbacks of menu functions 

function MainTools_Callback(hObject, eventdata, handles)

function ExamplesLib_Callback(hObject, eventdata, handles)
    try
        global mainHandles;
        mainHandles = guihandles;
        run('GUI_Example.m');
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end

function Help_Callback(hObject, eventdata, handles)
    try
        run('GUI_Help.m');
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end
        
function About_Callback(hObject, eventdata, handles)
    try
        run('GUI_About.m');
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end

function Save_Callback(hObject, eventdata, handles)
    try
        i = 1;
        while true
            fn = ['New task' num2str(i) '.mat'];
            if exist(fn, 'file') 
                i = i + 1;
            else 
               [filename, pathname] = uiputfile(fn, 'Сохранить как...');
               if pathname == 0 
                   i = i - 1;
                   return
               end 
               break;
            end
        end
        set(hObject, 'Checked', 'on');
        saveDataName = fullfile(pathname, filename); 
        
        global solve inputTaskTableData conditionsTableData segBegin;
        global segEnd stepsCount stepSize accuracyExternal accuracyInternal solvingMethodForExternalTask solvingMethodForInternalTask timeOfT initialVectorTableData;
        buttons = {get(handles.SolveTask, 'Enable'); get(handles.DeleteSolve, 'Enable'); get(handles.TaskResults, 'Enable')};
        save(saveDataName, 'solve', 'stepsCount', 'inputTaskTableData', 'conditionsTableData', 'segBegin', 'segEnd', 'stepsCount', 'accuracyExternal', 'accuracyInternal', 'solvingMethodForExternalTask', 'solvingMethodForInternalTask','timeOfT', 'initialVectorTableData', 'buttons');
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end

function Load_Callback(hObject, eventdata, handles)
%     try
        set(handles.Save, 'Checked', 'on');
        [filename, pathname] = uigetfile('*.mat', 'Открыть файл');
        if pathname == 0 
            return
        end
        loadDataName = fullfile(pathname, filename);
        
        global solve inputTaskTableData conditionsTableData segBegin;
        global segEnd stepsCount stepSize accuracyExternal accuracyInternal solvingMethodForExternalTask solvingMethodForInternalTask timeOfT initialVectorTableData;
        
        load(loadDataName, 'solve', 'stepsCount', 'inputTaskTableData', 'conditionsTableData', 'segBegin', 'segEnd', 'stepsCount', 'accuracyExternal', 'accuracyInternal', 'solvingMethodForExternalTask', 'solvingMethodForInternalTask','timeOfT', 'initialVectorTableData', 'buttons');
        
        set(handles.InputTaskTable, 'Data', inputTaskTableData);
        set(handles.ConditionsTable, 'Data', conditionsTableData);
        set(handles.SegBegin, 'String', segBegin);
        set(handles.SegEnd, 'String', segEnd);
        set(handles.StepsCount, 'String', stepsCount);
        set(handles.StepSize, 'String', stepSize);
        set(handles.AccuracyExternal, 'String', accuracyExternal);
        set(handles.AccuracyInternal, 'String', accuracyInternal);
        set(handles.SolvingMethodForExternalTaskPopupmenu, 'Value', solvingMethodForExternalTask);
        set(handles.SolvingMethodForInternalTaskPopupmenu, 'Value', solvingMethodForInternalTask);
        set(handles.TimeOfT, 'String', timeOfT);
        set(handles.InitialVectorTable, 'Data', initialVectorTableData);
        set(handles.SolveTask, 'Enable', char(buttons(1, 1)));
        set(handles.DeleteSolve, 'Enable', char(buttons(2, 1)));
        set(handles.TaskResults, 'Enable', char(buttons(3, 1)));
%     catch
%         somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
%     end
    
function Exit_Callback(hObject, eventdata, handles)
    try
        isSaved = get(handles.Save, 'Checked');
        if strcmp(isSaved, 'on')
            close;
        else
            askToSave = questdlg('Задача не сохранена. Выйти?', 'Выход', 'Выйти', 'Сохранить и выйти', 'Отмена', 'Сохранить и выйти');
            switch askToSave
                case 'Выйти'
                    close;

                case 'Отмена'
                    set(handles.Save, 'Checked', 'off');

                case 'Сохранить и выйти'
                    set(handles.Save, 'Checked', 'on');
                    [filename, pathname] = uiputfile('*.mat','Сохранить как...');
                    if pathname == 0 
                        return
                    end
                    saveDataName = fullfile(pathname, filename); 
                    global solve inputTaskTableData conditionsTableData segBegin;
                    global segEnd stepsCount stepSize accuracyExternal accuracyInternal solvingMethodForExternalTask solvingMethodForInternalTask timeOfT initialVectorTableData;
                    buttons = {get(handles.SolveTask, 'Enable'); get(handles.DeleteSolve, 'Enable'); get(handles.TaskResults, 'Enable')};
                    save(saveDataName, 'solve', 'stepsCount', 'inputTaskTableData', 'conditionsTableData', 'segBegin', 'segEnd', 'stepsCount', 'accuracyExternal', 'accuracyInternal', 'solvingMethodForExternalTask', 'solvingMethodForInternalTask','timeOfT', 'initialVectorTableData', 'buttons');
                    close;
            end
        end
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end
    
%Callbacks of menu functions 


%Callbacks of task parametrs
    
function InputTaskTable_CellEditCallback(hObject, eventdata, handles)
%     try
        global inputTaskTableData;
        set(handles.Save, 'Checked', 'off');
        currentData = get(hObject, 'Data');
        countOfRows = size(currentData, 1);
        newData = zeros(0, 0);
      
        for i = 1:countOfRows
            if i ~= countOfRows
                if strcmp(currentData(i, 2), '')
                    for k = i+1:countOfRows
                        newRowName = ['<html>x''<sub>' num2str(k - 1) '</sub></html>'];
                        newRow = {newRowName, strjoin(currentData(k, 2))};
                        newData = [newData; newRow];
                    end
                    currentData = newData;
                    countOfRows = size(currentData, 1);
                    set(hObject, 'Data', currentData);
                    inputTaskTableData = currentData;
                    break;
                else
                    newRowName = ['<html>x''<sub>' num2str(i) '</sub></html>'];
                    newRow = {newRowName, strjoin(currentData(i, 2))};
                    newData = [newData; newRow];
                end
            else
                newRowName = ['<html>x''<sub>' num2str(i) '</sub></html>'];
                newRow = {newRowName, strjoin(currentData(i, 2))};
                newData = [newData; newRow];
                currentData = newData;
                countOfRows = size(currentData, 1);
                
                if strcmp(currentData(i, 2), '')
                    set(hObject, 'Data', currentData);
                    inputTaskTableData = currentData;
                else
                    newRowName = ['<html>x''<sub>' num2str((countOfRows + 1)) '</sub></html>'];
                    newRow = {newRowName, ''};
                    newData = [currentData; newRow];
                    set(hObject, 'Data', newData);
                    inputTaskTableData = newData;
                end
            end
        end
        
        currentData = get(hObject, 'Data');
        condData = get(handles.ConditionsTable, 'Data');
        initData = get(handles.InitialVectorTable, 'Data');
        
        if strcmp(currentData(end, 2), '') 
            if (size(currentData, 1) - 1) > size(condData, 1)
                condData = [condData; {''}];
                initData = [initData {''}];
            end
            if (size(currentData, 1) - 1) < size(condData, 1)
                condData = condData(1:end-1, :);
                initData = initData(:, 1:end-1);
            end
        else
            if size(currentData, 1) > size(condData, 1)
                condData = [condData; {''}];
                initData = [initData {''}];
            end
            if size(currentData, 1) < size(condData, 1)
                condData = condData(1:end-1, :);
                initData = initData(:, 1:end-1);
            end
        end
        
        set(handles.ConditionsTable, 'Data', condData);
        set(handles.InitialVectorTable, 'Data', initData);
        
        T1 = get(handles.ConditionsTable, 'Data');
        T2 = get(handles.InitialVectorTable, 'Data');
        T3 = get(hObject, 'Data');
        
        n = size(T3, 1)-1;
        
        for i = 1:n
            if strcmp(T1(n, 1), '') || strcmp(T2(1, n), '') || strcmp(T3(n, 2), '')
                set(handles.TaskResults, 'Enable', 'off');
                set(handles.SolveTask, 'Enable', 'off');
                set(handles.DeleteSolve, 'Enable', 'off');
                return
            end
        end
        set(handles.SolveTask, 'Enable', 'on');
        set(handles.TaskResults, 'Enable', 'off');
        set(handles.DeleteSolve, 'Enable', 'off');
%     catch
%         somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
%     end
    
function ConditionsTable_CellEditCallback(hObject, eventdata, handles)
    global conditionsTableData;
    conditionsTableData = get(hObject, 'Data');
    
    T1 = get(hObject, 'Data');
    T2 = get(handles.InitialVectorTable, 'Data');
    T3 = get(handles.InputTaskTable, 'Data');

    n = size(T3, 1)-1;

    for i = 1:n
        if strcmp(T1(n, 1), '') || strcmp(T2(1, n), '') || strcmp(T3(n, 2), '')
            set(handles.TaskResults, 'Enable', 'off');
            set(handles.SolveTask, 'Enable', 'off');
            set(handles.DeleteSolve, 'Enable', 'off');
            return
        end
    end
    set(handles.SolveTask, 'Enable', 'on');
    set(handles.TaskResults, 'Enable', 'off');
    set(handles.DeleteSolve, 'Enable', 'off');

function SegBegin_Callback(hObject, eventdata, handles)
    try
        global segBegin;
        segBegin = get(hObject, 'String');
        segBegin = sym(segBegin);
        segBegin = double(segBegin);
        if isnan(segBegin)
            set(hObject, 'ForegroundColor', 'red');
            set(hObject, 'String', 'Error');
            segBegin = 0;
        end
        uicontrol(handles.SegEnd);
    catch
        set(hObject, 'ForegroundColor', 'red');
        set(hObject, 'String', 'Error');
    end

function SegEnd_Callback(hObject, eventdata, handles)
    try
        global segEnd;
        segEnd = get(hObject, 'String');
        segEnd = sym(segEnd);
        segEnd = double(segEnd);
        if isnan(segEnd)
            set(hObject, 'ForegroundColor', 'red');
            set(hObject, 'String', 'Error');
            segEnd = 0;
        end
        uicontrol(handles.StepsCount);
    catch
        set(hObject, 'ForegroundColor', 'red');
        set(hObject, 'String', 'Error');
    end

function StepsCount_Callback(hObject, eventdata, handles)
    try
        global stepsCount;
        stepsCount = get(hObject, 'String');
        stepsCount = sym(stepsCount);
        stepsCount = double(stepsCount);
        if isnan(stepsCount)
            set(hObject, 'ForegroundColor', 'red');
            set(hObject, 'String', 'Error');
            stepsCount = 0;
        end
        uicontrol(handles.AccuracyExternal);
    catch
        set(hObject, 'ForegroundColor', 'red');
        set(hObject, 'String', 'Error');
    end

function AccuracyExternal_Callback(hObject, eventdata, handles)
    try
        global accuracyExternal;
        accuracyExternal = get(hObject, 'String');
        accuracyExternal = sym(accuracyExternal);
        accuracyExternal = double(accuracyExternal);
        if isnan(accuracyExternal)
            set(hObject, 'ForegroundColor', 'red');
            set(hObject, 'String', 'Error');
            accuracyExternal = 0;
        end
        uicontrol(handles.AccuracyInternal);
    catch
        set(hObject, 'ForegroundColor', 'red');
        set(hObject, 'String', 'Error');
    end

function AccuracyInternal_Callback(hObject, eventdata, handles)
    try
        global accuracyInternal;
        accuracyInternal = get(hObject, 'String');
        accuracyInternal = sym(accuracyInternal);
        accuracyInternal = double(accuracyInternal);
        if isnan(accuracyInternal)
            set(hObject, 'ForegroundColor', 'red');
            set(hObject, 'String', 'Error');
            accuracyInternal = 0;
        end
        uicontrol(handles.SolvingMethodForExternalTaskPopupmenu);
    catch
        set(hObject, 'ForegroundColor', 'red');
        set(hObject, 'String', 'Error');
    end

function SolvingMethodForExternalTaskPopupmenu_Callback(hObject, eventdata, handles)
    global solvingMethodForExternalTask solvingMethodNameForExternalTask;
    solvingMethodForExternalTask = get(hObject, 'Value');
    solvingMethodNameForExternalTask = get(hObject, 'String');
    solvingMethodNameForExternalTask = solvingMethodNameForExternalTask(solvingMethodForExternalTask);
    uicontrol(handles.SolvingMethodForInternalTaskPopupmenu);

function SolvingMethodForInternalTaskPopupmenu_Callback(hObject, eventdata, handles)
    global solvingMethodForInternalTask solvingMethodNameForInternalTask;
    solvingMethodForInternalTask = get(hObject, 'Value');
    solvingMethodNameForInternalTask = get(hObject, 'String');
    solvingMethodNameForInternalTask = solvingMethodNameForInternalTask(solvingMethodForInternalTask);
    uicontrol(handles.StepSize);
    
function StepSize_Callback(hObject, eventdata, handles)
    try
        global stepSize;
        stepSize = get(hObject, 'String');
        stepSize = sym(stepSize);
        stepSize = double(stepSize);
        if isnan(stepSize)
            set(hObject, 'ForegroundColor', 'red');
            set(hObject, 'String', 'Error');
            stepSize = 0;
        end
        uicontrol(handles.TimeOfT);
    catch
        set(hObject, 'ForegroundColor', 'red');
        set(hObject, 'String', 'Error');
    end    
    
function TimeOfT_Callback(hObject, eventdata, handles)
    try
        global timeOfT;
        timeOfT = get(hObject, 'String');
        timeOfT = sym(timeOfT);
        timeOfT = double(timeOfT);
        if isnan(timeOfT)
            set(hObject, 'ForegroundColor', 'red');
            set(hObject, 'String', 'Error');
            timeOfT = 0;
        end
    catch
        set(hObject, 'ForegroundColor', 'red');
        set(hObject, 'String', 'Error');
    end

function InitialVectorTable_CellEditCallback(hObject, eventdata, handles)
    global initialVectorTableData;
    initialVectorTableData = get(hObject, 'Data');
    initialVectorTableData = sym(initialVectorTableData);
    initialVectorTableData = double(initialVectorTableData);
    
    T1 = get(handles.ConditionsTable, 'Data');
    T2 = get(hObject, 'Data');
    T3 = get(handles.InputTaskTable, 'Data');

    n = size(T3, 1)-1;

    for i = 1:n
        if strcmp(T1(n, 1), '') || strcmp(T2(1, n), '') || strcmp(T3(n, 2), '')
            set(handles.TaskResults, 'Enable', 'off');
            set(handles.SolveTask, 'Enable', 'off');
            set(handles.DeleteSolve, 'Enable', 'off');
            return
        end
    end
    set(handles.SolveTask, 'Enable', 'on');
    set(handles.TaskResults, 'Enable', 'off');
    set(handles.DeleteSolve, 'Enable', 'off');

%Callbacks of task parametrs


%KeyPressFcns of task parametrs

function SegBegin_KeyPressFcn(hObject, eventdata, handles)
    if strcmp(get(hObject, 'String'), 'Error')
        set(hObject, 'ForegroundColor', 'black');
        set(hObject, 'String', eventdata.Character);
    end
    
function SegEnd_KeyPressFcn(hObject, eventdata, handles)
    if strcmp(get(hObject, 'String'), 'Error')
        set(hObject, 'ForegroundColor', 'black');
        set(hObject, 'String', eventdata.Character);
    end

function StepsCount_KeyPressFcn(hObject, eventdata, handles)
    if strcmp(get(hObject, 'String'), 'Error')
        set(hObject, 'ForegroundColor', 'black');
        set(hObject, 'String', eventdata.Character);
    end

function AccuracyExternal_KeyPressFcn(hObject, eventdata, handles)
    if strcmp(get(hObject, 'String'), 'Error')
        set(hObject, 'ForegroundColor', 'black');
        set(hObject, 'String', eventdata.Character);
    end

function AccuracyInternal_KeyPressFcn(hObject, eventdata, handles)
    if strcmp(get(hObject, 'String'), 'Error')
        set(hObject, 'ForegroundColor', 'black');
        set(hObject, 'String', eventdata.Character);
    end

function TimeOfT_KeyPressFcn(hObject, eventdata, handles)
    if strcmp(get(hObject, 'String'), 'Error')
        set(hObject, 'ForegroundColor', 'black');
        set(hObject, 'String', eventdata.Character);
    end
    
function StepSize_KeyPressFcn(hObject, eventdata, handles)
    if strcmp(get(hObject, 'String'), 'Error')
        set(hObject, 'ForegroundColor', 'black');
        set(hObject, 'String', eventdata.Character);
    end
    
%KeyPressFcns of task parametrs    


%CreateFcns of task parametrs
function SegBegin_CreateFcn(hObject, eventdata, handles)
    global segBegin;
    segBegin = 0;
    
function SegEnd_CreateFcn(hObject, eventdata, handles)
    global segEnd;
    segEnd = 1;
    
function StepsCount_CreateFcn(hObject, eventdata, handles)
    global stepsCount;
    stepsCount = 1;

function AccuracyExternal_CreateFcn(hObject, eventdata, handles)
    global accuracyExternal;
    accuracyExternal = 0.001;

function AccuracyInternal_CreateFcn(hObject, eventdata, handles)
    global accuracyInternal;
    accuracyInternal = 0;

function SolvingMethodForExternalTaskPopupmenu_CreateFcn(hObject, eventdata, handles)
    global solvingMethodForExternalTask solvingMethodForExternalTaskName;
    solvingMethodForExternalTask = 1;
    solvingMethodForExternalTaskName = 'ode45';
    
function SolvingMethodForInternalTaskPopupmenu_CreateFcn(hObject, eventdata, handles)
    global solvingMethodForInternalTask solvingMethodForInternalTaskName;
    solvingMethodForInternalTask = 1;
    solvingMethodForInternalTaskName = 'ode45';

function TimeOfT_CreateFcn(hObject, eventdata, handles)
    global timeOfT;
    timeOfT = 0;
    
function StepSize_CreateFcn(hObject, eventdata, handles)
    global stepSize;
    stepSize = 0.01;
%CreateFcns of task parametrs


%Callbacks of solve buttons

function SolveTask_Callback(hObject, eventdata, handles)
%     try
        set(handles.TaskResults, 'Enable', 'on');
        set(handles.DeleteSolve, 'Enable', 'on');
        
        global solve inputTaskTableData conditionsTableData segBegin;
        global segEnd stepsCount accuracyExternal accuracyInternal;
        global solvingMethodForInternalTask solvingMethodForExternalTask timeOfT initialVectorTableData;
        global stepSize; 
        
        
        solve = BRAIN_solve(inputTaskTableData, conditionsTableData, segBegin, segEnd, stepsCount, accuracyExternal, accuracyInternal, solvingMethodForInternalTask, stepSize, solvingMethodForExternalTask, timeOfT, initialVectorTableData);
%         
%     catch
%         somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
%     end

function TaskResults_Callback(hObject, eventdata, handles)
%     try
        run('GUI_Results.m');
%     catch
%         somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
%     end

function DeleteSolve_Callback(hObject, eventdata, handles)
    try
        set(hObject, 'Enable', 'off');
        set(handles.TaskResults, 'Enable', 'off');
        
        global solve;
        solve = zeros(0);
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end
    
%Callbacks of solve buttons
