function varargout = GUI_Functional1(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @GUI_Functional1_OpeningFcn, ...
                       'gui_OutputFcn',  @GUI_Functional1_OutputFcn, ...
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

function GUI_Functional1_OpeningFcn(hObject, eventdata, handles, varargin)
    guidata(hObject, handles);

function varargout = GUI_Functional1_OutputFcn(hObject, eventdata, handles) 
    %varargout{1} = handles.output;


function findResult_Callback(hObject, eventdata, handles)
    try
        global solve;
        position = get(handles.position, 'String');
        position = sym(position);
        position = double(position);

        t = solve(:, 1);
        X = zeros(0);
        symArray1 = sym('x%d', [1 size(solve, 2)-1]);
        syms(symArray1);
        symArray1 = num2cell(symArray1);

        func = get(handles.func, 'String');
        func = sym(func);

        for i = 1:size(solve, 2)-1
            x = solve(:, i+1);
            X = [X interp1(t, x, position)];
        end

        func = subs(func, symArray1, X);
        func = double(func);
        func = char(string(func));
        set(handles.result, 'String', func);
    catch
    end
    
    

function close_Callback(hObject, eventdata, handles)
    close;


function func_Callback(hObject, eventdata, handles)
    uicontrol(handles.findResult);



function position_Callback(hObject, eventdata, handles)
    uicontrol(handles.func);

function position_CreateFcn(hObject, eventdata, handles)
    global solve;
    set(hObject, 'String', solve(1, 1));

function text4_CreateFcn(hObject, eventdata, handles)
    global solve;
    text = ['t∈[' num2str(solve(1, 1)) ', ' num2str(solve(end, 1)) ']'];
    set(hObject, 'String', text);
    
    
    
    
