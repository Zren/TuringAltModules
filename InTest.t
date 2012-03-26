import
    In in "Modules/In.tu"

% The run code
var fpsDelay : int
proc setFPS (n : int)
    fpsDelay := 1000 div n
end setFPS
setFPS (60)

proc charLine (s : string, f : function f2 (c : char) : boolean)
    put s ..
    for c : char
	if f (c) then
	    put c, "" ..
	end if
    end for
    put ""
end charLine

% Make sure to open your windows first!
var window := Window.Open ("graphics:640;480,nobuttonbar,offscreenonly")

% The initilization code requires a window to exist. Opening your own window
% afterwards will result in an extra window (the default run window).
In.Initialize ()

loop
    In.Update ()
    exit when In.KeyDown (KEY_ESC)

    cls
    put "ESC to Exit", skip
    put "Mouse: (", In.mouse.x, ",", In.mouse.y, ") ", In.mouse.b
    put "    Up: ", In.MouseUp ()
    put "    Pressed: ", In.MousePressed ()
    put "    Down: ", In.MouseDown ()
    put "    DoubleClick: ", In.DoubleClick (500)
    put "    Last Up: ", Time.Elapsed - In.mouseLast.lastUp

    put "Keyboard: "
    charLine ("    Fired: ", In.KeyFired)
    charLine ("    Down: ", In.KeyDown)
    charLine ("    Pressed: ", In.KeyPressed)
    charLine ("    Up: ", In.KeyUp)

    View.Update
    delay (fpsDelay)
end loop
Window.Close (window)
