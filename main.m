function main
    mainWin = open('main.fig');
    handlesMain = guihandles(mainWin);
    initInputTable = {'<html>x''<sub>1</sub></html>', ''};
    set(handlesMain.InputTaskTable, 'Data', initInputTable);
    set(handlesMain.SolveTask, 'Enable', 'off');
    set(handlesMain.TasksResults, 'Enable', 'off');
    set(handlesMain.Save, 'Checked', 'on');
    
    set(handlesMain.MainTools, 'Callback', {@MainTools_Callback, handlesMain});
    set(handlesMain.Exit, 'Callback', {@Exit_Callback, handlesMain});
    set(handlesMain.InputTaskTable, 'CellEditCallback', {@InputTaskTable_CellEditCallback, handlesMain});
    set(handlesMain.About, 'Callback', {@About_Callback, handlesMain});
    set(handlesMain.TasksResults, 'Callback', {@TasksResults_Callback, handlesMain});
    set(handlesMain.SolveTask, 'Callback', {@SolveTask_Callback, handlesMain});
    set(handlesMain.Save, 'Callback', {@Save_Callback, handlesMain});
    set(handlesMain.Load, 'Callback', {@Load_Callback, handlesMain});
    set(handlesMain.ExamplesLib, 'Callback', {@ExamplesLib_Callback, handlesMain});
    set(handlesMain.Help, 'Callback', {@Help_Callback, handlesMain});
    
% function writeFtxToFile(system)
%     fileID = fopen('odeTemp.m', 'w'); 
%     fclose(fileID);
%     if fileID == -1 
%         error('File is not opened'); 
%     end
%     fileID = fopen('odeTemp.m', 'a'); 
%     fileHeader = 'function [ dx ] = ftx(t, x)\n';
%     fprintf(fileID, fileHeader);
    

function MainTools_Callback(hObject, eventdata, handles)

function ExamplesLib_Callback(hObject, eventdata, handles)
    try
        exampleWin = open('Example.fig');
        handlesExample = guihandles(exampleWin);
        set(handlesExample.CloseExample, 'Callback', {@CloseExample_Callback, handlesExample});
        set(handlesExample.OpenExample, 'Callback', {@OpenExample_Callback, handlesExample});
        set(handlesExample.ExamplesListbox, 'Callback', {@ExamplesListbox_Callback, handlesExample});
        set(handlesExample.ExamplesListbox, 'CreateFcn', {@ExamplesListbox_CreateFcn, handlesExample});
    catch
        somethingWrong = errordlg('??????-???? ?????????? ???? ?????? :(', '????????????????');
    end

    
% --- Executes on selection change in ExamplesListbox.
function ExamplesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to ExamplesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ExamplesListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ExamplesListbox


% --- Executes during object creation, after setting all properties.
function ExamplesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExamplesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


% --- Executes on button press in OpenExample.
function OpenExample_Callback(hObject, eventdata, handles)
% hObject    handle to OpenExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function CloseExample_Callback(hObject, eventdata, handles)
    delete(handles.ExampleFigure);

function Help_Callback(hObject, eventdata, handles)
    try
        helpWin = open('Help.fig');
        handlesHelp = guihandles(helpWin);
        set(handlesHelp.CloseHelp, 'Callback', {@CloseHelp_Callback, handlesHelp});
    catch
        somethingWrong = errordlg('??????-???? ?????????? ???? ?????? :(', '????????????????');
    end
    
 function CloseHelp_Callback(hObject, eventdata, handles)
        delete(handles.HelpFigure);

        
function About_Callback(hObject, eventdata, handles)
    try
        aboutWin = open('About.fig');
        handlesAbout = guihandles(aboutWin);
        set(handlesAbout.CloseAbout, 'Callback', {@CloseAbout_Callback, handlesAbout});
    catch
        somethingWrong = errordlg('??????-???? ?????????? ???? ?????? :(', '????????????????');
    end


    
function CloseAbout_Callback(hObject, eventdata, handles)
    delete(handles.AboutFigure);
    

function Save_Callback(hObject, eventdata, handles)
    try
        set(hObject, 'Checked', 'on');
        [filename, pathname] = uiputfile('*.mat','?????????????????? ??????...');
        if pathname == 0 
            return
        end
        saveDataName = fullfile(pathname, filename); 
        if strcmp(get(handles.TasksResults, 'Enable'), 'on')
            toSaveTask = handles.InputTaskTable.Data;
            isSolveButtonEnable = get(handles.SolveTask, 'Enable');
            %Save solving
            save(saveDataName, 'toSaveTask', 'isSolveButtonEnable');
        else
            toSaveTask = handles.InputTaskTable.Data;
            isSolveButtonEnable = get(handles.SolveTask, 'Enable');
            save(saveDataName, 'toSaveTask', 'isSolveButtonEnable');
        end
    catch
        somethingWrong = errordlg('??????-???? ?????????? ???? ?????? :(', '????????????????');
    end


function Load_Callback(hObject, eventdata, handles)
    try
        set(handles.Save, 'Checked', 'on');
        [filename, pathname] = uigetfile('*.mat', '?????????????? ????????');
        if pathname == 0 
            return
        end
        loadDataName = fullfile(pathname, filename);
        if strcmp(get(handles.TasksResults, 'Enable'), 'on')
            %load solving
            load(loadDataName, 'toSaveTask', 'isSolveButtonEnable');
            set(handles.InputTaskTable, 'Data', toSaveTask);
            set(handles.SolveTask, 'Enable', isSolveButtonEnable);
        else
            load(loadDataName, 'toSaveTask', 'isSolveButtonEnable');
            set(handles.InputTaskTable, 'Data', toSaveTask);
            set(handles.SolveTask, 'Enable', isSolveButtonEnable);
        end
    catch
        somethingWrong = errordlg('??????-???? ?????????? ???? ?????? :(', '????????????????');
    end
    

function Exit_Callback(hObject, eventdata, handles)
    try
        isSaved = get(handles.Save, 'Checked');
        if strcmp(isSaved, 'on')
            close;
        else
            askToSave = questdlg('???????????? ???? ??????????????????. ???????????', '??????????', '??????????', '?????????????????? ?? ??????????', '????????????', '?????????????????? ?? ??????????');
            switch askToSave
                case '??????????'
                    close;

                case '????????????'
                    set(handles.Save, 'Checked', 'off');

                case '?????????????????? ?? ??????????'
                    set(handles.Save, 'Checked', 'on');
                    [filename, pathname] = uiputfile('*.mat','?????????????????? ??????...');
                    if pathname == 0 
                        return
                    end
                    saveDataName = fullfile(pathname, filename); 
                    toSaveTask = handles.InputTaskTable.Data;
                    isSolveButtonEnable = get(handles.SolveTask, 'Enable');
                    save(saveDataName, 'toSaveTask', 'isSolveButtonEnable');
                    close;
            end
        end
    catch
        somethingWrong = errordlg('??????-???? ?????????? ???? ?????? :(', '????????????????');
    end
    
function InputTaskTable_CellEditCallback(hObject, eventdata, handles)
    try
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
                else
                    newRowName = ['<html>x''<sub>' num2str((countOfRows + 1)) '</sub></html>'];
                    newRow = {newRowName, ''};
                    newData = [currentData; newRow];
                    set(hObject, 'Data', newData);
                end
            end
        end
        
        if strcmp(currentData(countOfRows, 2), '') && (countOfRows == 1)
            set(handles.SolveTask, 'Enable', 'off');
        else
            set(handles.SolveTask, 'Enable', 'on');
        end
    catch
        somethingWrong = errordlg('??????-???? ?????????? ???? ?????? :(', '????????????????');
    end
    



function TasksResults_Callback(hObject, eventdata, handles)
    




function SolveTask_Callback(hObject, eventdata, handles)
    %try
        currentData = get(handles.InputTaskTable, 'Data');
        countOfRows = size(currentData, 1);
        set(handles.TasksResults, 'Enable', 'on');
        
        ftx = get(handles.InputTaskTable, 'Data');
        ftx = ftx(1:end-1, 2);
        
        writeFtxToFile(ftx);
        dftx = findDftx(ftx)
        XMatrix = generateXMatrix(size(ftx, 1));
        initConditionForXMatrix = generateInitConditionForXMatrix(size(ftx, 1));
        DX = dftx*XMatrix;
        %p = [2, 0, -0.5, 0.5];
        [T, X] = ode45(@ftxTemp, [0, 7], [2, 0, -0.5, 0.5]);
%     catch
%         somethingWrong = errordlg('??????-???? ?????????? ???? ?????? :(', '????????????????');
%     end


% 
% function AccuracyExternal_Callback(hObject, eventdata, handles)
% 
% 
% 
% 
% function AccuracyInternal_Callback(hObject, eventdata, handles)
