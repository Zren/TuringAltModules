% Advanced Input - Keyboard and Mouse Events (Not Simple States)
%
%   Written by: Chris (Zren / Shade)
%      Version: 2.0

unit
module In
    % Import is neccessary when not used as a unit.
    %import Input, Mouse

    export Update, Initialize,
	DoubleClick, UpdateMouseLastUp, MouseUp, MouseDown, MousePressed, MouseMoved,
	DoubleType, UpdateCharsLastUp, KeyUp, KeyDown, KeyPressed, KeyFired,
	mouse, mouseLast,
	charsFiredCheck, charsLastFired,
	charsPressed, charsLast, charsLastUp,
	chars

    type MouseData :
	record
	    x, y, b, lastUp : int
	end record

    var mouse, mouseLast : MouseData
    var charsLastFired, charsLastUp : array char of int
    var charsEmpty, charsFiredCheck,
	charsPressed, charsLast : array char of boolean

    %%%
    % Shorcut functions
    %%%

    % In.chars -> In.charsPressed
    fcn chars () : array char of boolean
	result charsPressed
    end chars

    %%%
    % Initialize
    %%%
    proc Initialize ()
	Mouse.Where (mouse.x, mouse.y, mouse.b)

	% Setting at minint div 2 because:
	% Setting it at minint could cause underflow errors.
	% Setting at 0 will essentially make all it seem all
	%   events took place when the program started, which
	%   can create double click events on a single click
	%   close to the start of running.
	%   That behaviour will only happen if maxDelay is set as
	%   maxint div 2 or greater (which is fairly stupid).
	mouse.lastUp := minint div 2
	Input.KeyDown (charsPressed)
	for c : char
	    charsLastUp (c) := minint div 2
	    charsLastFired (c) := minint div 2
	end for

	for c : char
	    charsEmpty (c) := false
	end for
    end Initialize

    %%%
    % Current Mouse State Methods
    %%%

    proc UpdateMouseLastUp ()
	mouse.lastUp := Time.Elapsed
    end UpdateMouseLastUp

    fcn MouseUp () : boolean
	result mouse.b = 0 and mouseLast.b = 1
    end MouseUp

    fcn MouseDown () : boolean
	result mouse.b = 1 and mouseLast.b = 0
    end MouseDown

    fcn MousePressed () : boolean
	result mouse.b = 1 and mouseLast.b = 1
    end MousePressed

    fcn DoubleClick (maxDelay : int) : boolean
	result MouseUp () and Time.Elapsed - mouseLast.lastUp <= maxDelay
    end DoubleClick

    fcn MouseMoved () : boolean
	result mouse.x = mouseLast.x and mouse.y = mouseLast.y
    end MouseMoved

    %%%
    % Current Keyboard State Methods (Input.KeyDown)
    %%%

    proc UpdateCharsLastUp (s : char)
	charsLastUp (s) := Time.Elapsed
    end UpdateCharsLastUp

    fcn KeyUp (s : char) : boolean
	result ~charsPressed (s) and charsLast (s)
    end KeyUp

    fcn KeyDown (s : char) : boolean
	result charsPressed (s) and ~charsLast (s)
    end KeyDown

    % Checks if pressed by checking Input.KeyDown for this and last cycle.
    fcn KeyPressed (s : char) : boolean
	result charsPressed (s) and charsLast (s)
    end KeyPressed

    fcn DoubleType (s : char, maxDelay : int) : boolean
	result KeyUp (s) and Time.Elapsed - charsLastUp (s) <= maxDelay
    end DoubleType


    %%%
    % Current Keyboard Event Methods (Input.getchar)
    %%%

    % Checks if found in Input.getchar(char) this cycle.
    fcn KeyFired (s : char) : boolean
	result charsFiredCheck (s)
    end KeyFired

    proc UpdateCharsLastFired (s : char)
	charsLastFired (s) := Time.Elapsed
    end UpdateCharsLastFired


    %%%
    % Update State Methods
    %%%

    proc UpdateKeyboard ()
	% Save last state
	charsLast := charsPressed

	% Input Buffer (KeyDown Event)
	charsFiredCheck := charsEmpty
	loop
	    exit when not hasch
	    var c := getchar
	    charsFiredCheck (c) := true
	    UpdateCharsLastFired (c)
	end loop

	% Input State
	Input.KeyDown (charsPressed)
	for c : char
	    if KeyUp (c) then
		UpdateCharsLastUp (c)
	    end if
	end for
    end UpdateKeyboard

    proc UpdateMouse ()
	mouseLast := mouse
	Mouse.Where (mouse.x, mouse.y, mouse.b)

	if (MouseUp ()) then
	    UpdateMouseLastUp ()
	end if
    end UpdateMouse

    proc Update ()
	UpdateKeyboard ()
	UpdateMouse ()
    end Update
end In

