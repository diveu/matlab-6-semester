function varargout = GUI_Results(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @GUI_Results_OpeningFcn, ...
                       'gui_OutputFcn',  @GUI_Results_OutputFcn, ...
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

function GUI_Results_OpeningFcn(hObject, eventdata, handles, varargin)
    try
        handles.output = hObject;
        guidata(hObject, handles);
        global solve;
        columnsHeaders = ['t'];
        for i = 1:size(solve, 2)-1
           str = ['<html>x<sub>' num2str(i) '</sub></html>'];
           str = string(str);
           columnsHeaders = [columnsHeaders str];
        end
        columnsHeaders = num2cell(columnsHeaders);
        set(handles.DataTable, 'ColumnName', columnsHeaders);
        set(handles.DataTable, 'Data', solve);
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end

function varargout = GUI_Results_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

function Xpopupmenu1_Callback(hObject, eventdata, handles)
    try
        global solve;
        axes(handles.axes2);
        x1 = get(hObject, 'Value');
        x2 = get(handles.Xpopupmenu2, 'Value');
        cla(handles.axes2);
        plot(solve(:, x1), solve(:, x2+1));
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end


function Xpopupmenu1_CreateFcn(hObject, eventdata, handles)
    try
        global solve;
        columnsHeaders = [string('t')];
        for i = 1:size(solve, 2)-1
           str = ['<html>x<sub>' num2str(i) '</sub></html>'];
           str = string(str);
           columnsHeaders = [columnsHeaders str];
        end
        columnsHeaders = num2cell(columnsHeaders);
        set(hObject, 'String', columnsHeaders);
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end


function Xpopupmenu2_Callback(hObject, eventdata, handles)
    try
        global solve;
        axes(handles.axes2);
        x2 = get(hObject, 'Value');
        x1 = get(handles.Xpopupmenu1, 'Value');
        cla(handles.axes2);
        plot(solve(:, x1), solve(:, x2+1));
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end


function Xpopupmenu2_CreateFcn(hObject, eventdata, handles)
    try
        global solve;
        columnsHeaders = zeros(0);
        for i = 1:size(solve, 2)-1
           str = ['<html>x<sub>' num2str(i) '</sub></html>'];
           str = string(str);
           columnsHeaders = [columnsHeaders str];
        end
        columnsHeaders = num2cell(columnsHeaders);
        set(hObject, 'String', columnsHeaders);
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end



function OwnPlot_Callback(hObject, eventdata, handles)
    set(handles.Xpopupmenu2, 'Enable', 'off');

function OwnPlot_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function OwnPlot_KeyPressFcn(hObject, eventdata, handles)
    set(handles.Xpopupmenu2, 'Enable', 'off');
    if strcmp(get(hObject, 'String'), 'Задайте свою функцию и вы увидите ее на графике (это бесплатно)')
        set(hObject, 'FontSize', 14);
        set(hObject, 'String', '');
    end
    
   
function TXtable_CellEditCallback(hObject, eventdata, handles)
%     try
        global solve;
        tmpX = zeros(0);
        tableData = get(hObject, 'Data');
        data = zeros(0);
        axes(handles.axes1);
        condition1 = (eventdata.Indices(1) == 1) && (eventdata.Indices(2) == 2);
        condition2 = (eventdata.Indices(1) == 1) && (eventdata.Indices(2) == 3);
        condition3 = (eventdata.Indices(1) == 1) && (eventdata.Indices(2) == 4);
        if condition1 || condition2 || condition3
            answ = cell2mat(tableData(1, 4));
            if answ
                data = {'Все', char(tableData(1, 2)), char(tableData(1, 3)), true};
                for i = 1:size(solve, 2)-1
                    str = ['<html>x<sub>' num2str(i) '</sub></html>'];
                    data = [data; {str, char(tableData(i+1, 2)), char(tableData(i+1, 3)), true}];
                end
                set(hObject, 'Data', data);

                hold on;
                cla(handles.axes1);
                if strcmp(char(data(1, 2)), 'Какой-нибудь')
                    for i = 2:size(solve, 2)
                        plot(solve(:, 1), solve(:, i), char(data(1, 3)));
                    end
                else
                    lineStyle = char(data(1, 3));
                    lineColor = char(data(1, 2));
                    for i = 2:size(solve, 2)
                        plot(solve(:, 1), solve(:, i), 'Color', lineColor, 'LineStyle', lineStyle);
                    end
                end
            else 

                data = {'Все', char(tableData(1, 2)), char(tableData(1, 3)), false};
                for i = 1:size(solve, 2)-1
                    str = ['<html>x<sub>' num2str(i) '</sub></html>'];
                    data = [data; {str, char(tableData(i+1, 2)), char(tableData(i+1, 3)), false}];
                end
                set(hObject, 'Data', data);
                cla(handles.axes1);
            end
        else
            tableData(1, :) = {'Все', char(tableData(1, 2)), char(tableData(1, 3)), true};
            hold on;
            cla(handles.axes1);
            for i = 2:size(solve, 2)
                answ = cell2mat(tableData(i, 4));
                if answ 
                    if strcmp(char(tableData(i, 2)), 'Какой-нибудь')
                        plot(solve(:, 1), solve(:, i), char(tableData(i, 3)));
                    else
                        lineStyle = char(tableData(i, 3));
                        lineColor = char(tableData(i, 2));
                        plot(solve(:, 1), solve(:, i), 'LineStyle', lineStyle, 'Color', lineColor);
                    end
                    
                else
                    tableData(1, :) = {'Все', char(tableData(1, 2)), char(tableData(1, 3)), false};
                end
            end
            set(hObject, 'Data', tableData);
        end
%     catch
%         somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
%     end

function TXtable_CreateFcn(hObject, eventdata, handles)
    try
        global solve;
        data = {'Все', 'Какой-нибудь', '-', false};
        for i = 1:size(solve, 2)-1
            str = ['<html>x<sub>' num2str(i) '</sub></html>'];
            data = [data; {str, 'Какой-нибудь', '-', false}];
        end
        set(hObject, 'Data', data);
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end


function draw_Callback(hObject, eventdata, handles)
    try
        if strcmp(get(handles.OwnPlot, 'String'), 'Задайте свою функцию и вы увидите ее на графике (это бесплатно)')
            return;
        end
        global solve;
        set(handles.Xpopupmenu2, 'Enable', 'on');
        userFun = get(handles.OwnPlot, 'String');
        userFun = sym(userFun);

        symArray = sym('x%d', [1 size(solve, 2)-1]);
        syms(symArray);

        symArray = num2cell(symArray);

        toPlot = zeros(0);

        for i = 1:size(solve, 1)
            toPlot = [toPlot subs(userFun, symArray, solve(i, 2:end))];
        end

        x1 = get(handles.Xpopupmenu1, 'Value');
        axes(handles.axes2);
        cla(handles.axes2);
        grid on;
        plot(solve(:, x1), toPlot);
    catch
        somethingWrong = errordlg('Что-то пошло не так :(', 'Ошибочка');
    end

function Exit_Callback(hObject, eventdata, handles)
    close;


function listbox1_Callback(hObject, eventdata, handles)
    functionalNumber = get(hObject, 'Value');
    if functionalNumber == 1
        run('GUI_Functional1.m');
    elseif functionalNumber == 2
       run('GUI_Functional2.m');
    end
