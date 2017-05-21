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
    set(handles.InitialVectorTable, 'Data', initInitialVectorTable, 'ColumnWidth', {35}, 'ColumnEditable', true);
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
        open('GUI_Example.fig');
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end

function Help_Callback(hObject, eventdata, handles)
    try
        open('GUI_Help.fig');
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end
        
function About_Callback(hObject, eventdata, handles)
    try
        open('GUI_About.fig');
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end

function Save_Callback(hObject, eventdata, handles)
    try
        set(hObject, 'Checked', 'on');
        [filename, pathname] = uiputfile('*.mat','Сохранить как...');
        if pathname == 0 
            return
        end
        saveDataName = fullfile(pathname, filename); 
        
        global solve inputTaskTableData conditionsTableData segBegin;
        global segEnd stepsCount accuracyExternal accuracyInternal solvingMethod timeOfT initialVectorTableData;
        buttons = {get(handles.SolveTask, 'Enable'); get(handles.DeleteSolve, 'Enable'); get(handles.TaskResults, 'Enable')};
        save(saveDataName, 'solve', 'inputTaskTableData', 'conditionsTableData', 'segBegin', 'segEnd', 'stepsCount', 'accuracyExternal', 'accuracyInternal', 'solvingMethod', 'timeOfT', 'initialVectorTableData', 'buttons');
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end

function Load_Callback(hObject, eventdata, handles)
    try
        set(handles.Save, 'Checked', 'on');
        [filename, pathname] = uigetfile('*.mat', 'Открыть файл');
        if pathname == 0 
            return
        end
        loadDataName = fullfile(pathname, filename);
        
        global solve inputTaskTableData conditionsTableData segBegin;
        global segEnd stepsCount accuracyExternal accuracyInternal solvingMethod timeOfT initialVectorTable;
        
        load(loadDataName, 'solve', 'inputTaskTableData', 'conditionsTableData', 'segBegin', 'segEnd', 'stepsCount', 'accuracyExternal', 'accuracyInternal', 'solvingMethod', 'timeOfT', 'initialVectorTableData', 'buttons');
        
        set(handles.InputTaskTable, 'Data', inputTaskTableData);
        set(handles.ConditionsTable, 'Data', conditionsTableData);
        set(handles.SegBegin, 'String', segBegin);
        set(handles.SegEnd, 'String', segEnd);
        set(handles.StepsCount, 'String', stepsCount);
        set(handles.AccuracyExternal, 'String', accuracyExternal);
        set(handles.AccuracyInternal, 'String', accuracyInternal);
        set(handles.SolvingMethodsPopupmenu, 'Value', solvingMethod);
        set(handles.TimeOfT, 'String', timeOfT);
        set(handles.InitialVectorTable, 'Data', initialVectorTableData);
        set(handles.SolveTask, 'Enable', char(buttons(1, 1)));
        set(handles.DeleteSolve, 'Enable', char(buttons(2, 1)));
        set(handles.TaskResults, 'Enable', char(buttons(3, 1)));
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end
    
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
                    global segEnd stepsCount accuracyExternal accuracyInternal solvingMethod timeOfT initialVectorTable;
                    
                    buttons = [handles.SolveTask, handles.DeleteSolve, handles.TaskResults];
                    save(saveDataName, 'solve', 'inputTaskTableData', 'conditionsTableData', 'segBegin', 'segEnd', 'stepsCount', 'accuracyExternal', 'accuracyInternal', 'solvingMethod', 'timeOfT', 'initialVectorTable', 'buttons');
                    close;
            end
        end
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end
    
%Callbacks of menu functions 


%Callbacks of task parametrs
    
function InputTaskTable_CellEditCallback(hObject, eventdata, handles)
    try
        global inputTaskTableData;
        global inputTaskTableCheck initialVectorTableCheck conditionsTableDataCheck;
        currentData = get(hObject, 'Data');
        countOfRows = size(currentData, 1);
        newData = zeros(0, 0);
        
        initialVectorTableCheck
        conditionsTableDataCheck
        inputTaskTableCheck
        
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
        
        if strcmp(inputTaskTableData(countOfRows, 2), '') && (countOfRows == 1)
            initialVectorTableCheck = false;
            conditionsTableDataCheck = false;
            inputTaskTableCheck = false;
        end
        
        currentData = get(hObject, 'Data');
        condData = get(handles.ConditionsTable, 'Data');
        initData = get(handles.InitialVectorTable, 'Data');
        if strcmp(currentData(end, 2), '') 
            if (size(currentData, 1) - 1) > size(condData, 1)
                condData = [condData; {''}];
                initData = [initData {''}];
                initialVectorTableCheck = false;
                conditionsTableDataCheck = false;
            end
            if (size(currentData, 1) - 1) < size(condData, 1)
                condData = condData(1:end-1, :);
                initData = initData(:, 1:end-1);
            end
        else
            if size(currentData, 1) > size(condData, 1)
                condData = [condData; {''}];
                initData = [initData {''}];
                initialVectorTableCheck = false;
                conditionsTableDataCheck = false;
            end
            if size(currentData, 1) < size(condData, 1)
                condData = condData(1:end-1, :);
                initData = initData(:, 1:end-1);
            end
        end
        set(handles.ConditionsTable, 'Data', condData);
        set(handles.InitialVectorTable, 'Data', initData);
        
        inputTaskTableData = get(hObject, 'Data');
        for i = 1:size(inputTaskTableData, 1)-1
          if strcmp(inputTaskTableData(i, 2), '')
              inputTaskTableCheck = false;
              break;
          else
              inputTaskTableCheck = true;
          end
        end
    
        if initialVectorTableCheck && inputTaskTableCheck && conditionsTableDataCheck
            set(handles.SolveTask, 'Enable', 'on');
        else
            set(handles.SolveTask, 'Enable', 'off');
        end

    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end
    
function ConditionsTable_CellEditCallback(hObject, eventdata, handles)
    global conditionsTableData;
    global inputTaskTableCheck initialVectorTableCheck conditionsTableDataCheck;
    conditionsTableData = get(hObject, 'Data');
    for i = 1:size(conditionsTableData, 1)
        if strcmp(conditionsTableData(i, 1), '')
            conditionsTableDataCheck = false;
            break;
        else
            conditionsTableDataCheck = true;
        end
    end
    
    if initialVectorTableCheck && inputTaskTableCheck && conditionsTableDataCheck
        set(handles.SolveTask, 'Enable', 'on');
    else
        set(handles.SolveTask, 'Enable', 'off');
    end

function SegBegin_Callback(hObject, eventdata, handles)
    try
        global segBegin;
        segBegin = str2double(get(hObject, 'String'));
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
        segEnd = str2double(get(hObject, 'String'));
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
        stepsCount = str2double(get(hObject, 'String'));
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
        accuracyExternal = str2double(get(hObject, 'String'));
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
        accuracyInternal = str2double(get(hObject, 'String'));
        if isnan(accuracyInternal)
            set(hObject, 'ForegroundColor', 'red');
            set(hObject, 'String', 'Error');
            accuracyInternal = 0;
        end
        uicontrol(handles.SolvingMethodsPopupmenu);
    catch
        set(hObject, 'ForegroundColor', 'red');
        set(hObject, 'String', 'Error');
    end

function SolvingMethodsPopupmenu_Callback(hObject, eventdata, handles)
    global solvingMethod solvingMethodName;
    solvingMethod = get(hObject, 'Value');
    solvingMethodName = get(hObject, 'String');
    solvingMethodName = solvingMethodName(solvingMethod);
    uicontrol(handles.TimeOfT);

function TimeOfT_Callback(hObject, eventdata, handles)
    try
        global timeOfT;
        timeOfT = str2double(get(hObject, 'String'));
        if isnan(timeOfT)
            set(hObject, 'ForegroundColor', 'red');
            set(hObject, 'String', 'Error');
            timeOfT = 0;
        end
        uicontrol(handles.InitialVectorTable);
    catch
        set(hObject, 'ForegroundColor', 'red');
        set(hObject, 'String', 'Error');
    end

function InitialVectorTable_CellEditCallback(hObject, eventdata, handles)
    global initialVectorTableData;
    global inputTaskTableCheck initialVectorTableCheck conditionsTableDataCheck;
    initialVectorTableData = get(hObject, 'Data');
    for i = 1:size(initialVectorTableData, 2)
        if strcmp(initialVectorTableData(1, i), '')
            initialVectorTableCheck = false;
            break;
        else
            initialVectorTableCheck = true;
        end
    end
    
    if initialVectorTableCheck && inputTaskTableCheck && conditionsTableDataCheck
        set(handles.SolveTask, 'Enable', 'on');
    else
        set(handles.SolveTask, 'Enable', 'off');
    end
    uicontrol(handles.SolveTask);

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
    
%KeyPressFcns of task parametrs    


%CreateFcns of task parametrs
function SegBegin_CreateFcn(hObject, eventdata, handles)
    global segBegin;
    segBegin = 0;
    
function SegEnd_CreateFcn(hObject, eventdata, handles)
    global segEnd;
    segEnd = 0;
    
function StepsCount_CreateFcn(hObject, eventdata, handles)
    global stepsCount;
    stepsCount = 0;

function AccuracyExternal_CreateFcn(hObject, eventdata, handles)
    global accuracyExternal;
    accuracyExternal = 0;

function AccuracyInternal_CreateFcn(hObject, eventdata, handles)
    global accuracyInternal;
    accuracyInternal = 0;

function SolvingMethodsPopupmenu_CreateFcn(hObject, eventdata, handles)
    global solvingMethod solvingMethodName;
    solvingMethod = 1;
    solvingMethodName = 'ode45';

function TimeOfT_CreateFcn(hObject, eventdata, handles)
    global timeOfT;
    timeOfT = 0;
    
%CreateFcns of task parametrs


%Callbacks of solve buttons

function SolveTask_Callback(hObject, eventdata, handles)
    %try
        set(handles.TaskResults, 'Enable', 'on');
        set(handles.DeleteSolve, 'Enable', 'on');
        
        global solve segBegin segEnd;
        
        p = [2; 0; -0.5; 0.5];
        ftx = get(handles.InputTaskTable, 'Data');
        ftx = ftx(1:end-1, 2);
        n = size(ftx, 1);
        
        dftx = BRAIN_findDftx(ftx);
        XMatrix = BRAIN_generateXMatrix(size(ftx, 1));
        initConditionForXMatrix = BRAIN_generateInitConditionForXMatrix(size(ftx, 1));
        initConditionsForInternalTask = [p; initConditionForXMatrix]';
        DX = dftx*XMatrix;
        
        strDX = zeros(0);
        tmpStrDX = zeros(0);
        
        for i = 1:n
            for j = 1:n
                a = char(DX(j, i));
                A = string(a);
                tmpStrDX = [tmpStrDX; A];
            end
            strDX = [strDX tmpStrDX];
            tmpStrDX = zeros(0);
        end
        
        strDX = reshape(strDX, [n*n, 1]);
        toFile = [ftx; strDX];
        BRAIN_writeSystemToFile(toFile);
        [T, X] = ode45(@systemTemp, [segBegin:0.1:segEnd], initConditionsForInternalTask);
        
        X = X(:, n+1:end);
        %X = reshape(X, [n, n])
        charFP = get(handles.ConditionsTable, 'Data');
        FP = BRAIN_makeFP(charFP, segBegin, segEnd);
        %FP0 = 
        BRAIN_findDFP(FP, X)
    %catch
        %somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    %end

function TaskResults_Callback(hObject, eventdata, handles)
    try
        open('GUI_Results.fig');
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end

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
