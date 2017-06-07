function varargout = GUI_Functional2(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @GUI_Functional2_OpeningFcn, ...
                       'gui_OutputFcn',  @GUI_Functional2_OutputFcn, ...
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

function GUI_Functional2_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);

function varargout = GUI_Functional2_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;



function to_Callback(hObject, eventdata, handles)
    uicontrol(handles.func);

function to_CreateFcn(hObject, eventdata, handles)
    global solve;
    text = num2str(solve(end, 1));
    set(hObject, 'String', text);

function from_Callback(hObject, eventdata, handles)
    uicontrol(handles.to);

function from_CreateFcn(hObject, eventdata, handles)
    global solve;
    text = num2str(solve(1, 1));
    set(hObject, 'String', text);

function func_Callback(hObject, eventdata, handles)
    uicontrol(handles.equal);

function equal_Callback(hObject, eventdata, handles)
    try
        global solve;
        
        from = get(handles.from, 'String');
        from = sym(from);
        from = double(from);

        to = get(handles.to, 'String');
        to = sym(to);
        to = double(to);
        
        result = 0;
        
        symArray1 = sym('x%d', [1 size(solve, 2)-1]);
        symArray1 = [sym('t') symArray1];
        syms(symArray1);
        symArray1 = num2cell(symArray1);

        func = get(handles.func, 'String');
        func = sym(func);
        
        t = solve(:, 1);
        x = solve(:, 1:end);
        
        interval = 0.1;
        
        for i=from:interval:to-interval
            x0 = zeros(0);
            x1 = zeros(0);
            
            for j=1:size(solve, 2)
               x0 = [x0 interp1(t, x(:, j), i)];
            end
            
            for j=1:size(solve, 2)
               x1 = [x1 interp1(t, x(:, j), i+interval)];
            end
            
            Fx0 = double(subs(func, symArray1, x0));
            Fx1 = double(subs(func, symArray1, x1));
            
            result = result + (1/2*(Fx0 + Fx1)*interval);
        end
        set(handles.result, 'String', result);
    catch
    end

function close_Callback(hObject, eventdata, handles)
    close;
