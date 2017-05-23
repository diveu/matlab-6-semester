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
         somethingWrong = errordlg('Произошла ошибка', 'Ошибка');
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
        plot(solve(:, x1+1), solve(:, x2+1));
    catch
         somethingWrong = errordlg('Произошла ошибка', 'Ошибка');
    end


function Xpopupmenu1_CreateFcn(hObject, eventdata, handles)
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
         somethingWrong = errordlg('Произошла ошибка', 'Ошибка');
    end


function Xpopupmenu2_Callback(hObject, eventdata, handles)
    try
        global solve;
        axes(handles.axes2);
        x2 = get(hObject, 'Value');
        x1 = get(handles.Xpopupmenu1, 'Value');
        cla(handles.axes2);
        plot(solve(:, x1+1), solve(:, x2+1));
    catch
         somethingWrong = errordlg('Произошла ошибка', 'Ошибка');
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
         somethingWrong = errordlg('Произошла ошибка', 'Ошибка');
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
    try
        global solve;
        tmpX = zeros(0);
        data = get(hObject, 'Data');
        axes(handles.axes1);
        if eventdata.Indices == [1 2]
            answ = cell2mat(data(1, 2));
            if answ
                data = {'Выбрать все/отменить все', true};
                for i = 1:size(solve, 2)-1
                    str = ['<html>x<sub>' num2str(i) '</sub></html>'];
                    data = [data; {str, true}];
                end
                set(hObject, 'Data', data);

                hold on;
                for i = 2:size(solve, 2)
                    plot(solve(:, 1), solve(:, i));
                end
            else 

                data = {'Выбрать все/отменить все', false};
                for i = 1:size(solve, 2)-1
                    str = ['<html>x<sub>' num2str(i) '</sub></html>'];
                    data = [data; {str, false}];
                end
                set(hObject, 'Data', data);
                cla(handles.axes1);
            end
        else
            data(1, :) = {'Выбрать все/отменить все', false};
            set(hObject, 'Data', data);
            for i = 2:size(solve, 2);
                answ = cell2mat(data(i, 2));
                if answ 
                    tmpX = [tmpX solve(:, i-1)];
                end
            end

            hold on;
            for i = 1:size(tmpX, 2)
                plot(solve(:, 1), tmpX(:, i));
            end
        end
    catch
         somethingWrong = errordlg('Произошла ошибка', 'Ошибка');
    end

function TXtable_CreateFcn(hObject, eventdata, handles)
    try
        global solve;
        data = {'Выбрать все/отменить все', false};
        for i = 1:size(solve, 2)-1
            str = ['<html>x<sub>' num2str(i) '</sub></html>'];
            data = [data; {str, false}];
        end
        set(hObject, 'Data', data);
    catch
         somethingWrong = errordlg('Произошла ошибка', 'Ошибка');
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
        plot(solve(:, x1+1), toPlot);
    catch
         somethingWrong = errordlg('Произошла ошибка', 'Ошибка');
    end
